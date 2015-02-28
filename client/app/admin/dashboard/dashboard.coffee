'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'dashboard',
    url: '/dashboard'
    parent: 'admin'
    templateUrl: 'app/admin/dashboard/dashboard.html'
    controller: 'DashboardCtrl'
