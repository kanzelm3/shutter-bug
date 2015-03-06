'use strict'

angular.module 'shutterBugApp'
.controller 'EventNavbarCtrl', ($scope, $location, Auth, Menu) ->
  $scope.menu = Menu.getMenu 'event'

  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn

  $scope.endEvent = ->
    $location.path '/admin/dashboard'

  $scope.isActive = (route) ->
    !!~ $location.path().indexOf route
