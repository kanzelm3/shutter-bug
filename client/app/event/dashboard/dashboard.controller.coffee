'use strict'

angular.module 'shutterBugApp'
.controller 'EventDashboardCtrl', ($scope, $stateParams, Event) ->

  event = Event.get({id: $stateParams.eventId})
  event.$promise.then ->
    $scope.eventLoaded = true
  $scope.event = event

  $scope.startEvent = ->
    event.actualTime =
      start: Date.now()
    event.$update (_event) ->
      console.log 'Event saved', _event
