'use strict'

angular.module 'shutterBugApp'
.factory 'Entity', ($resource) ->
  $resource '/api/entities/:id',
    id: '@_id'
  ,
    update:
      method: 'PUT'
