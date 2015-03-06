/**
 * Populate DB with sample data on server start
 * to disable, edit config/environment/index.js, and set `seedDB: false`
 */

'use strict';

var _ = require('lodash'),
    AccessLevel = require('../api/accessLevel/accessLevel.model'),
    Entity = require('../api/entity/entity.model'),
    User = require('../api/user/user.model'),
    Event = require('../api/event/event.model');

AccessLevel.find({}).remove(function() {
  AccessLevel.create({
      name: 'Admin',
      access: {
        canViewDashboard: true,
        canViewUsers: true,
        addCustomers: true,
        editCustomers: true,
        deleteCustomers: true,
        addEvents: true,
        editEvents: true,
        deleteEvents: true,
        addBooths: true,
        editBooths: true,
        deleteBooths: true,
        addUsers: true,
        editUsers: true,
        deleteUsers: true
      }
    }, {
      name: 'Employee',
      access: {
        canViewDashboard: true,
        canViewUsers: false,
        addCustomers: false,
        editCustomers: true,
        deleteCustomers: false,
        addEvents: false,
        editEvents: true,
        deleteEvents: false,
        addBooths: false,
        editBooths: true,
        deleteBooths: false,
        addUsers: false,
        editUsers: false,
        deleteUsers: false
      }
    }, function() {
      console.log('finished populating access levels');

      AccessLevel.find({entity: {$exists: false}}, function(err, accessLevels) {
        console.log('AccessLevels', accessLevels);

        Entity.find({}).remove(function() {
          Entity.create({
              type: 'client',
              name: 'Best Booths',
              email: 'bestbooths@gmail.com',
              accessLevels: accessLevels,
              address: {
                line1: '514 Strawberry Walk',
                city: 'Loganville',
                state: 'GA',
                zip: '30052'
              },
              phone: '4047357545'
            },{
              type: 'client',
              name: 'Great Booths',
              email: 'greatbooths@gmail.com',
              accessLevels: accessLevels,
              address: {
                line1: '2484 Linstone Ct',
                city: 'Grayson',
                state: 'GA',
                zip: '30017'
              },
              phone: '7709829142'
            }, function() {
              console.log('finished populating entities');
              Entity.findOne({name: 'Best Booths'}).populate('accessLevels').exec(function(err, entity) {
                var adminAccess = _.find(entity.accessLevels, function(_accessLevel) {
                  return _accessLevel.name === 'Admin';
                });
                var employeeAccess = _.find(entity.accessLevels, function(_accessLevel) {
                  return _accessLevel.name === 'Employee';
                });

                Entity.findOne({name: 'Great Booths'}).populate('accessLevels').exec(function(err, entity2) {
                  var adminAccess2 = _.find(entity2.accessLevels, function(_accessLevel) {
                    return _accessLevel.name === 'Admin';
                  });
                  var employeeAccess2 = _.find(entity2.accessLevels, function(_accessLevel) {
                    return _accessLevel.name === 'Employee';
                  });

                  User.find({}).remove(function() {
                    User.create({
                        provider: 'local',
                        firstName: 'Justin',
                        lastName: 'Robinson',
                        email: 'jprobinson91@gmail.com',
                        password: 'banetek14',
                        accessDefinitions: [{
                          entity: entity,
                          accessLevel: employeeAccess
                        }]
                      },{
                        provider: 'local',
                        firstName: 'Whitney',
                        lastName: 'Kanzelmeyer',
                        email: 'daviswh3@gmail.com',
                        password: 'ilovejoel',
                        accessDefinitions: [{
                          entity: entity,
                          accessLevel: adminAccess
                        },{
                          entity: entity2,
                          accessLevel: adminAccess2
                        }]
                      },{
                        provider: 'local',
                        firstName: 'Joel',
                        lastName: 'Kanzelmeyer',
                        role: 'admin',
                        email: 'kanzelm3@gmail.com',
                        password: 'whit111307',
                        accessDefinitions: []
                      }, function() {
                        console.log('finished populating users');
                        Event.find({}).remove(function() {
                          Event.create({
                            name: 'Kanzelmeyer Wedding',
                            location: {
                              name: 'Vines Mansion',
                              line1: '3500 Oak Grove Rd SW',
                              city: 'Loganville',
                              state: 'GA',
                              zip: '30052'
                            },
                            scheduledTime: {
                              start: Date.now() + 60000,
                              end: Date.now() + 120000
                            },
                            setupTime: {
                              start: Date.now(),
                              end: Date.now() + 60000
                            },
                            cost: 499.00,
                            deposit: 250.00,
                            sessions: [],
                            assets: [],
                            settings: {
                              sessionLimit: {
                                timer: {
                                  active: false,
                                  length: 60000
                                },
                                pictures: {
                                  active: false,
                                  number: 6
                                }
                              }
                            }
                          },{
                            name: 'Robinson Wedding',
                            location: {
                              name: 'Chateau Elan',
                              line1: '100 Rue Charlemagne Dr',
                              city: 'Braselton',
                              state: 'GA',
                              zip: '30517'
                            },
                            scheduledTime: {
                              start: Date.now() + 600000,
                              end: Date.now() + 1200000
                            },
                            setupTime: {
                              start: Date.now() + 540000,
                              end: Date.now() + 600000
                            },
                            cost: 499.00,
                            deposit: 250.00,
                            sessions: [],
                            assets: [],
                            settings: {
                              sessionLimit: {
                                timer: {
                                  active: false,
                                  length: 60000
                                },
                                pictures: {
                                  active: false,
                                  number: 6
                                }
                              }
                            }
                          }, function() {
                            console.log('finished populating events');
                          });
                        });
                      }
                    );
                  });
                });
              });
            }
          );
        });
      });
    }
  );
});
