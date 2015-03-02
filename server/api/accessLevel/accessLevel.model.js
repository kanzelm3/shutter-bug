'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AccessLevelSchema = new Schema({
  name: {
    type: String,
    default: '',
    required: 'Access level name is required',
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

AccessLevelSchema.pre('validate', function(next) {
  var self = this;
  if (this.name && this.entity) {
    console.log('Test: ', this.name, this.entity);
    this.constructor.findOne({name: this.name, entity: { _id: this.entity }}, function(err, accessLevel) {
      if (err) throw err;
      if (accessLevel) {
        console.log('Found level: ', accessLevel);
        self.invalidate('name', 'Access level already exists, please choose a different name');
        return next();
      } else {
        return next();
      }
    });
  } else {
    return next();
  }
});

module.exports = mongoose.model('AccessLevel', AccessLevelSchema);
