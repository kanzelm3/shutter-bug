'use strict'

angular.module 'shutterBugApp'
.controller 'NewCtrl', ($scope, $location, Auth) ->
  $scope.user = {}
  $scope.errors = {}
  $scope.register = (form) ->
    $scope.submitted = true

    if form.$valid
      # Account created, redirect to home
      Auth.completeUserSetup $scope.user

      .then ->
        $location.path '/admin/dashboard'

      .catch (err) ->
        err = err.data
        $scope.errors = {}
        if err
          # Update validity of form fields that match the mongoose errors
          angular.forEach err.errors, (error, field) ->
            form[field].$setValidity 'mongoose', false
            $scope.errors[field] = error.message
