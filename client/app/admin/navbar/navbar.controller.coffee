'use strict'

angular.module 'shutterBugApp'
.controller 'AdminNavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [{
    title: 'Dashboard'
    link: '/admin/dashboard'
  }, {
    title: 'Users'
    link: '/admin/users'
  }]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser
  $scope.getCurrentEntity = Auth.getCurrentEntity

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    !!~ $location.path().indexOf route
