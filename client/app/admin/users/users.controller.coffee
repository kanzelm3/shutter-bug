'use strict'

angular.module 'shutterBugApp'
.controller 'UsersCtrl', ($scope, $timeout, $stateParams, $http, Auth, User, users) ->

  $scope.users = users
  $scope.getAccess = Auth.getCurrentAccess

  $scope.delete = (user) ->
    User.remove id: user._id
    _.remove $scope.users, user

  $scope.edit = (user) ->
    $scope.users.forEach (_user) ->
      _user.isEditing = false
    user.isEditing = true

  $scope.save = (user) ->
    console.log 'User:', user
    $timeout ->
      user.isEditing = false

  $scope.getAccessLevel = (user) ->
    return Auth.getUserAccess(user).accessLevel.name
