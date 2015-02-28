'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'users',
    url: '/users'
    parent: 'admin'
    views:
      '':
        templateUrl: 'app/admin/users/users.html'
        controller: 'UsersCtrl'
