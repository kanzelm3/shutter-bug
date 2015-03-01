'use strict'

angular.module 'shutterBugApp'
.directive 'addUser', ->
  templateUrl: 'app/admin/users/directives/addUser/addUser.html'
  restrict: 'E'
  scope:
    currentAccess: '='
    saveMethod: '&'
  link: (scope) ->
    scope.save = ->
      accessDefinition =
        entity: scope.currentAccess().entity._id
        accessLevel: scope.selectedAccessLevel._id
      scope.user.accessDefinitions = [accessDefinition]
      scope.user.requiresSetup = true
      scope.saveMethod({user:scope.user})

    scope.setAccessLevel = (level) ->
      scope.selectedAccessLevel = level

    scope.selectedAccessLevel = scope.currentAccess().entity.accessLevels[0]
