'use strict'

angular.module 'shutterBugApp'
.controller 'DashboardCtrl', ($http, $scope, $timeout, socket) ->
  cachedEvents = undefined

  $scope.events = []

  $http.get('/api/events').success (events) ->
    cachedEvents = events
    getLatestEvents()
    events = _.filter events, (event) ->
      return ((new Date(event.scheduledTime.start)) - Date.now()) < 60000
    $scope.events = events

  getLatestEvents = ->
    $timeout ->
      console.log 'Latest events retrieved', Date.now(), cachedEvents
      $scope.events = _.filter cachedEvents, (event) ->
        return ((new Date(event.scheduledTime.start)) - Date.now()) < 60000
      getLatestEvents()
    , 5000
