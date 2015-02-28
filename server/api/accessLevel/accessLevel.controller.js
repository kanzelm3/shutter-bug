'use strict';

var _ = require('lodash');
var AccessLevel = require('./accessLevel.model');

// Get list of accessLevels
exports.index = function(req, res) {
  AccessLevel.find(function (err, accessLevels) {
    if(err) { return handleError(res, err); }
    return res.json(200, accessLevels);
  });
};

// Get a single accessLevel
exports.show = function(req, res) {
  AccessLevel.findById(req.params.id, function (err, accessLevel) {
    if(err) { return handleError(res, err); }
    if(!accessLevel) { return res.send(404); }
    return res.json(accessLevel);
  });
};

// Creates a new accessLevel in the DB.
exports.create = function(req, res) {
  AccessLevel.create(req.body, function(err, accessLevel) {
    if(err) { return handleError(res, err); }
    return res.json(201, accessLevel);
  });
};

// Updates an existing accessLevel in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  AccessLevel.findById(req.params.id, function (err, accessLevel) {
    if (err) { return handleError(res, err); }
    if(!accessLevel) { return res.send(404); }
    var updated = _.merge(accessLevel, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, accessLevel);
    });
  });
};

// Deletes a accessLevel from the DB.
exports.destroy = function(req, res) {
  AccessLevel.findById(req.params.id, function (err, accessLevel) {
    if(err) { return handleError(res, err); }
    if(!accessLevel) { return res.send(404); }
    accessLevel.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}