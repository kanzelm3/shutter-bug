'use strict'

angular.module 'shutterBugApp'
.controller 'NavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [
    title: 'Home'
    link: '/'
  ]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser
  getCurrentAccessLevel = Auth.getCurrentAccessLevel

  $scope.hasAccess = (level) ->
    getCurrentAccessLevel() && getCurrentAccessLevel().name == level

  $scope.logout = ->
    Auth.logout()
    $location.path '/admin/login'

  $scope.isActive = (route) ->
    if route == '/' then route is $location.path() else !!~ $location.path().indexOf route
