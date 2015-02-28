'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AccessLevelSchema = new Schema({
  name: {
    type: String,
    default: '',
    required: 'Please fill Access level name',
    trim: true
  },
  access: Schema.Types.Mixed,
  created: {
    type: Date,
    default: Date.now
  },
  entity: {
    type: Schema.ObjectId,
    ref: 'Entity'
  }
});

module.exports = mongoose.model('AccessLevel', AccessLevelSchema);
