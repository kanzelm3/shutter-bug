'use strict'

angular.module 'shutterBugApp'
.factory 'AccessLevel', ($resource) ->
  $resource '/api/accessLevels/:id',
    id: '@_id'
  ,
    update:
      method: 'PUT'
