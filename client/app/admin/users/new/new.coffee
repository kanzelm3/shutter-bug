'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'users.new',
    url: '/new/:token'
    views:
      '@admin':
        templateUrl: 'app/admin/users/new/new.html'
        controller: 'NewCtrl'
