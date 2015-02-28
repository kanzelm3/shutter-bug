'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin',
    url: '/admin'
    abstract: true
    authenticate: true
    views:
      '@':
        templateUrl: 'app/admin/admin.html'
        controller: 'AdminCtrl'
      'navbar@admin':
        templateUrl: 'app/admin/navbar/navbar.html'
        controller: 'AdminNavbarCtrl'
