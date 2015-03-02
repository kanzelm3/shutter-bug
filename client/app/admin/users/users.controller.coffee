'use strict'

angular.module 'shutterBugApp'
.controller 'UsersCtrl', ($scope, $timeout, $stateParams, $http, Auth, User, AccessLevel, Entity) ->

  $scope.newAccessLevel = {}
  $scope.availableAccessProperties = [
    'addBooths'
    'addCustomers'
    'addEvents'
    'addUsers'
    'canViewDashboard'
    'canViewUsers'
    'deleteBooths'
    'deleteCustomers'
    'deleteEvents'
    'deleteUsers'
    'editBooths'
    'editCustomers'
    'editEvents'
    'editUsers'
  ]

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
    user.$save ->
      $timeout ->
        user.isEditing = false

  $scope.addNewUser = ->
    $scope.addingNewUser = true

  $scope.saveNewUser = (user) ->
    _user = new User(user)
    _user.$save  ->
      $scope.newUserErrors = []
      $scope.addingNewUser = false
      $scope.status = _user
      $timeout ->
        $scope.status = undefined
        $scope.users = User.query({entityId: Auth.getCurrentEntity()._id})
      , 4000
    , (err) ->
      $scope.newUserErrors = []
      _.forEach err.data.errors, (error) ->
        $scope.newUserErrors.push error

  $scope.cancelAddNewUser = ->
    $scope.newUserErrors = []
    $timeout ->
      $scope.addingNewUser = false

  $scope.addNewAccessLevel = ->
    $scope.addingNewAccessLevel = true

  $scope.saveNewAccessLevel = ->
    $scope.accessLevelErrors = []
    $scope.newAccessLevel.entity = $scope.getEntity()
    $scope.availableAccessProperties.forEach (accessProp) ->
      $scope.newAccessLevel.access = $scope.newAccessLevel.access or {}
      if !$scope.newAccessLevel.access[accessProp]
        $scope.newAccessLevel.access[accessProp] = false
    _accessLevel = new AccessLevel($scope.newAccessLevel)
    _accessLevel.$save ->
      _entity = Entity.get({id: $scope.getEntity()._id})
      _entity.$promise.then ->
        _entity.accessLevels.push(_accessLevel._id)
        _entity.$update ->
          $scope.addingNewAccessLevel = false
          $scope.newAccessLevel = {}
          $scope.getEntity().accessLevels.push _accessLevel
          $scope.setAccessLevel _accessLevel
          $scope.accessLevelStatus = _accessLevel
          $timeout ->
            $scope.accessLevelStatus = undefined
          , 4000
    , (err) ->
      _.forEach err.data.errors, (error) ->
        $scope.accessLevelErrors.push error

  $scope.cancelAddNewAccessLevel = ->
    $scope.accessLevelErrors = []
    $scope.addingNewAccessLevel = false

  $scope.$watch Auth.getCurrentEntity, (newVal) ->
    if (newVal)
      $scope.users = User.query({entityId: newVal._id})
      $scope.selectedAccessLevel = newVal.accessLevels[0]

  $scope.getAccessLevel = (user) ->
    return Auth.getUserAccess(user).accessLevel && Auth.getUserAccess(user).accessLevel.name
