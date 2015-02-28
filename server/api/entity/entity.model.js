'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var EntitySchema = new Schema({
  type: {
    type: String,
    default: '',
    required: 'Please provide a type',
    trim: true
  },
  name: {
    type: String,
    default: '',
    required: 'Please fill Entity name',
    trim: true
  },
  created: {
    type: Date,
    default: Date.now
  },
  parent: {
    type: Schema.ObjectId,
    ref: 'Entity'
  },
  children: [{
    type: Schema.ObjectId,
    ref: 'Entity'
  }],
  accessLevels: [{
    type: Schema.ObjectId,
    ref: 'AccessLevel'
  }],
  email: String,
  address: Schema.Types.Mixed,
  phone: String
});

module.exports = mongoose.model('Entity', EntitySchema);
