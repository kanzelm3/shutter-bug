'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'takePhotos',
    parent: 'event',
    url: '/take-photos'
    templateUrl: 'app/event/takePhotos/takePhotos.html'
    controller: 'TakePhotosCtrl'
