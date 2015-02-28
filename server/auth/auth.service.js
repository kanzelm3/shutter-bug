'use strict';

var _ = require('lodash'),
    mongoose = require('mongoose'),
    passport = require('passport'),
    config = require('../config/environment'),
    jwt = require('jsonwebtoken'),
    expressJwt = require('express-jwt'),
    compose = require('composable-middleware'),
    User = require('../api/user/user.model'),
    validateJwt = expressJwt({ secret: config.secrets.session });

/**
 * Attaches the user object to the request if authenticated
 * Otherwise returns 403
 */
function isAuthenticated() {
  return compose()
    // Validate jwt
    .use(function(req, res, next) {
      // allow access_token to be passed through query parameter as well
      if(req.query && req.query.hasOwnProperty('access_token')) {
        req.headers.authorization = 'Bearer ' + req.query.access_token;
      }
      validateJwt(req, res, next);
    })
    // Attach user to request
    .use(function(req, res, next) {
      User.findById(req.user._id).deepPopulate(['accessDefinitions.entity', 'accessDefinitions.accessLevel']).exec(function (err, user) {
        if (err) return next(err);
        if (!user) return res.send(401);

        req.user = user;
        return next();
      });
    });
}

/**
 * Checks if the user role meets the minimum requirements of the route
 */
function hasRole(roleRequired) {
  if (!roleRequired) throw new Error('Required role needs to be set');

  return compose()
    .use(isAuthenticated())
    .use(function meetsRequirements(req, res, next) {
      if (req.hasAccess) {
        return next();
      }
      if (config.userRoles.indexOf(req.user.role) >= config.userRoles.indexOf(roleRequired)) {
        return next();
      }
      else {
        res.send(403);
      }
    });
}

/**
 * Checks if the user has access to entity
 */
function hasAccess(accessLevel) {
  if (!accessLevel) throw new Error('Required access level needs to be set');

  return compose()
    .use(isAuthenticated())
    .use(function meetsAccessRequirements(req, res, next) {
      var entityId = req.query.entityId;
      if (entityId) {
        var accessDefinition = _.find(req.user.accessDefinitions, function(_accessDefinition) {
          return String(_accessDefinition.entity._id) === entityId;
        });
        if (accessDefinition && accessDefinition.accessLevel.name === accessLevel) {
          req.hasAccess = true;
          req.entityId = entityId;
          return next();
        }
      } else {
        return next();
      }
    });
}

/**
 * Returns a jwt token signed by the app secret
 */
function signToken(id) {
  return jwt.sign({ _id: id }, config.secrets.session, { expiresInMinutes: 60*5 });
}

/**
 * Set token cookie directly for oAuth strategies
 */
function setTokenCookie(req, res) {
  if (!req.user) return res.json(404, { message: 'Something went wrong, please try again.'});
  var token = signToken(req.user._id, req.user.role);
  res.cookie('token', JSON.stringify(token));
  res.redirect('/');
}

exports.isAuthenticated = isAuthenticated;
exports.hasRole = hasRole;
exports.hasAccess = hasAccess;
exports.signToken = signToken;
exports.setTokenCookie = setTokenCookie;
