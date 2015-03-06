'use strict';

var _ = require('lodash');
var Asset = require('./asset.model');
var gphoto2 = require('gphoto2');
var GPhoto = new gphoto2.GPhoto2();
var fs = require('fs');
// Required to do gzip
// var zlib = require('zlib');
var AWS = require('aws-sdk');

var camera = undefined;
var camera_settings = undefined;

GPhoto.list(function (list) {
  if (list.length === 0) return;
  camera = list[0];
  console.log('Found', camera.model);

  // get configuration tree
  camera.getConfig(function (er, settings) {
    console.log('Image settings: ', settings.main.children.imgsettings.children.imagesize.choices);
    camera_settings = settings;
    camera.setConfigValue('imagesize', '2992x2000', function(err) {
      console.log('couldnt set config: ', err);
    });
  });
});

// Get list of assets
exports.index = function(req, res) {
  Asset.find(function (err, assets) {
    if(err) { return handleError(res, err); }
    return res.json(200, assets);
  });
};

// Get a single asset
exports.show = function(req, res) {
  Asset.findById(req.params.id, function (err, asset) {
    if(err) { return handleError(res, err); }
    if(!asset) { return res.send(404); }
    return res.json(asset);
  });
};

// Creates a new asset in the DB.
exports.create = function(req, res) {
  if (req.asset) {
    var asset = {
      type: req.asset.type
    };
    Asset.create(asset, function(err, asset) {
      if(err) { return handleError(res, err); }
      var s3obj = new AWS.S3({
        params: {
          Bucket: 'shutterbug-bucket',
          Key: asset._id + '.jpg',
          ContentType: 'image/jpg',
          ACL: 'public-read'
        }
      });
      s3obj.upload({Body: req.asset.file})
        .on('httpUploadProgress', function(evt) {
          console.log(evt);
        })
        .send(function(err, data) {
          console.log(err, data);
          if (data && data.Location) {
            asset.url = data.Location;
            asset.save(function(err, asset) {
              if(err) { return handleError(res, err); }
              return res.send(200, asset);
            });
          }
        });
    });
  } else {
    res.send(500, 'Image not found');
  }
};

// Updates an existing asset in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Asset.findById(req.params.id, function (err, asset) {
    if (err) { return handleError(res, err); }
    if(!asset) { return res.send(404); }
    var updated = _.merge(asset, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, asset);
    });
  });
};

// Deletes a asset from the DB.
exports.destroy = function(req, res) {
  Asset.findById(req.params.id, function (err, asset) {
    if(err) { return handleError(res, err); }
    if(!asset) { return res.send(404); }
    asset.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

exports.capturePhoto = function(req, res, next) {
  if (camera) {
    // Take picture with camera object obtained from list()
    camera.takePicture({download: true}, function (er, data) {
      //fs.writeFileSync('picture.jpg', data);
      console.log(er);
      if (er !== -1) {
        req.asset = {
          type: 'photo',
          file: data
        };
        next();
      } else {
        console.log('Couldn\'t take photo');
        res.send(500, 'OUT OF FOCUS')
      }
    });
  } else {
    var photo = fs.createReadStream('client/assets/images/DSC_0731.jpg');
    console.log('Image gzip:', photo);
    req.asset = {
      type: 'photo',
      file: photo
    };
    next();
  }
};

function handleError(res, err) {
  return res.send(500, err);
}
