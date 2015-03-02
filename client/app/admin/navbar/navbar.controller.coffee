'use strict'

angular.module 'shutterBugApp'
.controller 'AdminNavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [{
    title: 'Dashboard'
    link: '/admin/dashboard'
    accessProperties: ['canViewDashboard']
  }, {
    title: 'Users'
    link: '/admin/users'
    accessProperties: ['canViewUsers']
  }]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser
  $scope.getCurrentEntity = Auth.getCurrentEntity
  $scope.setCurrentAccess = Auth.setCurrentAccess
  $scope.hasAccess = Auth.hasAccess

  $scope.logout = ->
    Auth.logout()
    $location.path '/admin/login'

  $scope.isActive = (route) ->
    !!~ $location.path().indexOf route
