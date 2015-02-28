'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var deepPopulate = require('mongoose-deep-populate');
var crypto = require('crypto');
var authTypes = ['github', 'twitter', 'facebook', 'google'];

/**
 * Access Definition Schema
 */
var AccessDefinitionSchema = new Schema({
  entity: {
    type: Schema.ObjectId,
    ref: 'Entity'
  },
  accessLevel: {
    type: Schema.ObjectId,
    ref: 'AccessLevel'
  }
});

var UserSchema = new Schema({
  firstName: String,
  lastName: String,
  email: { type: String, lowercase: true },
  role: {
    type: String,
    default: 'user'
  },
  accessDefinitions: [AccessDefinitionSchema],
  updated: {
    type: Date
  },
  created: {
    type: Date,
    default: Date.now
  },
  hashedPassword: String,
  provider: String,
  salt: String,
  facebook: {},
  twitter: {},
  google: {},
  github: {}
});

/**
 * Virtuals
 */
UserSchema
  .virtual('password')
  .set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    this.hashedPassword = this.encryptPassword(password);
  })
  .get(function() {
    return this._password;
  });

// Get full name
UserSchema
  .virtual('name')
  .get(function() {
    return this.firstName + ' ' + this.lastName;
  });

// Public profile information
UserSchema
  .virtual('profile')
  .get(function() {
    return {
      'name': this.firstName + ' ' + this.lastName,
      'role': this.role,
      'accessDefinitions': this.accessDefinitions
    };
  });

// Non-sensitive info we'll be putting in the token
UserSchema
  .virtual('token')
  .get(function() {
    return {
      '_id': this._id,
      'role': this.role
    };
  });

UserSchema.set('toJSON', { getters: true, virtuals: true });

/**
 * Validations
 */

// Validate empty email
UserSchema
  .path('email')
  .validate(function(email) {
    if (authTypes.indexOf(this.provider) !== -1) return true;
    return email.length;
  }, 'Email cannot be blank');

// Validate empty password
UserSchema
  .path('hashedPassword')
  .validate(function(hashedPassword) {
    if (authTypes.indexOf(this.provider) !== -1) return true;
    return hashedPassword.length;
  }, 'Password cannot be blank');

// Validate email is not taken
UserSchema
  .path('email')
  .validate(function(value, respond) {
    var self = this;
    this.constructor.findOne({email: value}, function(err, user) {
      if(err) throw err;
      if(user) {
        if(self.id === user.id) return respond(true);
        return respond(false);
      }
      respond(true);
    });
}, 'The specified email address is already in use.');

var validatePresenceOf = function(value) {
  return value && value.length;
};

/**
 * Pre-save hook
 */
UserSchema
  .pre('save', function(next) {
    if (!this.isNew) return next();

    if (!validatePresenceOf(this.hashedPassword) && authTypes.indexOf(this.provider) === -1)
      next(new Error('Invalid password'));
    else
      next();
  });

/**
 * Methods
 */
UserSchema.methods = {
  /**
   * Authenticate - check if the passwords are the same
   *
   * @param {String} plainText
   * @return {Boolean}
   * @api public
   */
  authenticate: function(plainText) {
    return this.encryptPassword(plainText) === this.hashedPassword;
  },

  /**
   * Make salt
   *
   * @return {String}
   * @api public
   */
  makeSalt: function() {
    return crypto.randomBytes(16).toString('base64');
  },

  /**
   * Encrypt password
   *
   * @param {String} password
   * @return {String}
   * @api public
   */
  encryptPassword: function(password) {
    if (!password || !this.salt) return '';
    var salt = new Buffer(this.salt, 'base64');
    return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
  }
};

/**
 * Add ability to deep populate
 */
UserSchema.plugin(deepPopulate, {
  whitelist: ['accessDefinitions.entity.accessLevels', 'accessDefinitions.accessLevel']
});

module.exports = mongoose.model('User', UserSchema);
