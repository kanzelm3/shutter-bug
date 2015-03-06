'use strict'

angular.module 'shutterBugApp'
.controller 'LoginCtrl', ($scope, $stateParams, Auth, $location, $window) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        path = $stateParams.url or '/admin/dashboard'
        $location.path path
        $location.search('url', null)

      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
