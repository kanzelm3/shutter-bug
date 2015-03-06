'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'event',
    url: '/event/:eventId'
    abstract: true
    authenticate: true
    views:
      '@':
        templateUrl: 'app/event/event.html'
        controller: 'EventCtrl'
      'navbar@event':
        templateUrl: 'app/event/navbar/navbar.html'
        controller: 'EventNavbarCtrl'
