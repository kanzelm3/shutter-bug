'use strict'

angular.module 'shutterBugApp'
.controller 'AdminNavbarCtrl', ($scope, $location, Auth, Menu) ->
  $scope.menu = Menu.getMenu 'admin'

  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser
  $scope.getCurrentEntity = Auth.getCurrentEntity
  $scope.getCurrentAccess = Auth.getCurrentAccess
  $scope.setCurrentAccess = Auth.setCurrentAccess
  $scope.hasAccess = Auth.hasAccess

  $scope.logout = ->
    Auth.logout()
    $location.path '/admin/login'

  $scope.isActive = (route) ->
    !!~ $location.path().indexOf route
