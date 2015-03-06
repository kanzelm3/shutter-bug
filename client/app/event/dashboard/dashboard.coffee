'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'event.dashboard',
    url: '/dashboard'
    parent: 'event'
    templateUrl: 'app/event/dashboard/dashboard.html'
    controller: 'EventDashboardCtrl'
