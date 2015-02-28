/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var AccessLevel = require('./accessLevel.model');

exports.register = function(socket) {
  AccessLevel.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  AccessLevel.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('accessLevel:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('accessLevel:remove', doc);
}