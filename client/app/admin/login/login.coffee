'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin.login',
    url: '/login'
    views:
      '':
        templateUrl: 'app/admin/login/login.html'
        controller: 'LoginCtrl'
