'use strict'

angular.module 'shutterBugApp'
.controller 'UsersCtrl', ($scope, $timeout, $stateParams, $http, Auth, User) ->

  $scope.getAccess = Auth.getCurrentAccess
  $scope.getEntity = Auth.getCurrentEntity

  $scope.setAccessLevel = (level) ->
    $scope.selectedAccessLevel = level

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

  $scope.addNewUser = ->
    $scope.addingNewUser = true

  $scope.saveNewUser = (user) ->
    console.log 'User:', user
    _user = new User(user)
    _user.$save ->
      $scope.addingNewUser = false
      $scope.status = _user;
      $timeout ->
        $scope.status = undefined
        $scope.users = User.query({entityId: Auth.getCurrentEntity()._id})
      , 4000

  $scope.$watch Auth.getCurrentEntity, (newVal) ->
    if (newVal)
      $scope.users = User.query({entityId: newVal._id})
      $scope.selectedAccessLevel = newVal.accessLevels[0]

  $scope.getAccessLevel = (user) ->
    return Auth.getUserAccess(user).accessLevel.name
