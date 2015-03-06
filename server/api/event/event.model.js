'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var SessionSchema = new Schema({
  assets: [{
    type: Schema.ObjectId,
    ref: 'Asset'
  }],
  time: {
    start: Date,
    end: Date
  }
});

var EventSchema = new Schema({
  name: {
    type: String,
    required: 'Please provide an event name',
    trim: true
  },
  location: {
    name: {
      type: String,
      required: 'Please provide an event location name',
      trim: true
    },
    line1: String,
    line2: String,
    city: String,
    state: String,
    zip: String
  },
  scheduledTime: {
    start: Date,
    end: Date
  },
  actualTime: {
    start: Date,
    end: Date
  },
  setupTime: {
    start: Date,
    end: Date
  },
  cost: Number,
  deposit: Number,
  sessions: [SessionSchema],
  assets: [{
    type: Schema.ObjectId,
    ref: 'Asset'
  }],
  settings: Schema.Types.Mixed
});

module.exports = mongoose.model('Event', EventSchema);
