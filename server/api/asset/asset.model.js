'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AssetSchema = new Schema({
  type: {
    type: String,
    required: 'Please provide a type',
    trim: true
  },
  url: {
    type: String,
    trim: true
  },
  created: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Asset', AssetSchema);
