'use strict';

var _ = require('lodash');
var User = require('./user.model');
var passport = require('passport');
var config = require('../../config/environment');
var jwt = require('jsonwebtoken');
var nodemailer = require('nodemailer');
var async = require('async');
var crypto = require('crypto');
var auth = require('../../auth/auth.service');

var validationError = function(res, err) {
  return res.json(422, err);
};

/**
 * Get list of users
 * restriction: 'admin'
 */
exports.index = function(req, res) {
  var query = {};
  if (req.entityId) {
    query = { accessDefinitions: { $elemMatch: { entity: req.entityId } } };
  }
  User.find(query, '-salt -hashedPassword').deepPopulate(['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel']).exec(function (err, users) {
    if(err) return res.send(500, err);
    res.json(200, users);
  });
};

/**
 * Creates a new user
 */
exports.create = function (req, res, next) {
  if (req.body.requiresSetup) return next();
  var newUser = new User(req.body);
  newUser.provider = 'local';
  newUser.role = 'user';
  newUser.save(function(err, user) {
    if (err) return validationError(res, err);
    var token = jwt.sign({_id: user._id }, config.secrets.session, { expiresInMinutes: 60*5 });
    res.json({ token: token });
  });
};

/**
 * Create user requires setup email
 */
exports.createSetupEmail = function (req, res, next) {
  console.log('createSetupEmail error 1', req.body.requiresSetup);
  if (!req.body.requiresSetup) return validationError(res);
  async.waterfall([
    // Generate random token
    function(done) {
      crypto.randomBytes(20, function(err, buffer) {
        var token = buffer.toString('hex');
        done(err, token);
      });
    },
    // Add tokens to new user and save
    function(token, done) {
      var user = new User(req.body);
      // Add missing user fields
      user.provider = 'local';
      user.role = 'user';
      user.requiresSetup = req.body.requiresSetup;
      console.log('New user: ', user);

      user.createUserToken = token;
      user.createUserExpires = Date.now() + 3600000; // 1 hour

      user.save(function(err, user) {
        done(err, token, user);
      });
    },
    function(token, user, done) {
      user.deepPopulate(['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel'], function(err, user) {
        res.render('templates/create-user-email', {
          appName: config.app.title,
          entityName: user.accessDefinitions[0].entity.name,
          url: 'http://' + req.headers.host + '/api/users/new/' + token
        }, function(err, emailHTML) {
          done(err, emailHTML, user);
        });
      });
    },
    // If valid email, send reset email using service
    function(emailHTML, user, done) {
      var smtpTransport = nodemailer.createTransport(config.mailer.options);
      var mailOptions = {
        to: user.email,
        from: config.mailer.from,
        subject: 'Account Setup',
        html: emailHTML
      };
      smtpTransport.sendMail(mailOptions, function(err) {
        if (!err) {
          res.send({
            message: 'An email has been sent to ' + user.email + ' with account setup instructions.'
          });
        }

        done(err);
      });
    }
  ], function(err) {
    if (err) return next(err);
  });
};

/**
 * Validate create user token
 */
exports.validateCreateToken = function(req, res) {
  User.findOne({
    createUserToken: req.params.token,
    createUserExpires: {
      $gt: Date.now()
    }
  }, function(err, user) {
    if (!user) {
      return res.redirect('/admin/users/new/invalid');
    }

    res.redirect('/admin/users/new/' + req.params.token);
  });
};

/**
 * New user POST from email token
 */
exports.completeUserSetup = function(req, res, next) {
  // Init Variables
  var credentials = req.body;

  async.waterfall([

    function(done) {
      User.findOne({
        createUserToken: req.params.token,
        createUserExpires: {
          $gt: Date.now()
        }
      }, function(err, user) {
        if (!err && user) {
          user = _.extend(user, credentials);
          user.createUserToken = undefined;
          user.createUserExpires = undefined;

          user.save(function(err, user) {
            if (err) {
              return validationError(res, err);
            } else {

              var token = auth.signToken(user._id, user.role);
              console.log('token: ', token);
              res.json({token: token});

              done(err, user);
            }
          });
        } else {
          return res.status(400).send({
            message: 'Password reset token is invalid or has expired.'
          });
        }
      });
    },
    function(user, done) {
      res.render('templates/create-user-confirm-email', {
        name: user.name,
        appName: config.app.title
      }, function(err, emailHTML) {
        done(err, emailHTML, user);
      });
    },
    // If valid email, send reset email using service
    function(emailHTML, user, done) {
      var smtpTransport = nodemailer.createTransport(config.mailer.options);
      var mailOptions = {
        to: user.email,
        from: config.mailer.from,
        subject: 'Your account has been created',
        html: emailHTML
      };

      smtpTransport.sendMail(mailOptions, function(err) {
        done(err, 'done');
      });
    }
  ], function(err) {
    if (err) return next(err);
  });
};

/**
 * Get a single user
 */
exports.show = function (req, res, next) {
  var userId = req.params.id;

  User.findById(userId, function (err, user) {
    if (err) return next(err);
    if (!user) return res.send(401);
    res.json(user.profile);
  });
};

/**
 * Deletes a user
 * restriction: 'admin'
 */
exports.destroy = function(req, res) {
  User.findByIdAndRemove(req.params.id, function(err, user) {
    if(err) return res.send(500, err);
    return res.send(204);
  });
};

/**
 * Update a user
 */
exports.update = function(req, res, next) {
  console.log('User to save: ', req.body);
  var userId = req.body._id;
  User.findById(userId).deepPopulate(['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel']).exec(function(err, user) {
    var newUser = _.extend(user, req.body);
    newUser.accessDefinitions = newUser.accessDefinitions.map(function(accessDefinition) {
      return {
        entity: accessDefinition.entity._id,
        accessLevel: accessDefinition.accessLevel._id
      }
    });
    console.log('New user:', newUser);
    newUser.save(function(err, _user) {
      if (err) return validationError(res, err);
      _user.deepPopulate(['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel'], function(err, _user) {
        if (err) return validationError(res, err);
        res.json(_user);
      });
    })
  });
};

/**
 * Change a users password
 */
exports.changePassword = function(req, res, next) {
  var userId = req.user._id;
  var oldPass = String(req.body.oldPassword);
  var newPass = String(req.body.newPassword);

  User.findById(userId, function (err, user) {
    if(user.authenticate(oldPass)) {
      user.password = newPass;
      user.save(function(err) {
        if (err) return validationError(res, err);
        res.send(200);
      });
    } else {
      res.send(403);
    }
  });
};

/**
 * Get my info
 */
exports.me = function(req, res, next) {
  var userId = req.user._id;
  User.findOne({
    _id: userId
  }, '-salt -hashedPassword').deepPopulate(['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel']).exec(function(err, user) { // don't ever give out the password or salt
    if (err) return next(err);
    if (!user) return res.json(401);
    res.json(user);
  });
};

/**
 * Authentication callback
 */
exports.authCallback = function(req, res, next) {
  res.redirect('/');
};
