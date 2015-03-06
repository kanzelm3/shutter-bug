'use strict'

angular.module 'shutterBugApp'
.factory 'Event', ($resource) ->
  $resource '/api/events/:id',
    id: '@_id'
  ,
    update:
      method: 'PUT'
