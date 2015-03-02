'use strict'

angular.module 'shutterBugApp'
.directive 'editUser', (Auth) ->
  templateUrl: 'app/admin/users/directives/editUser/editUser.html'
  restrict: 'E'
  scope:
    user: '='
    currentAccess: '='
    saveMethod: '&'
  link: (scope) ->
    scope.save = ->
      definition = _.find scope.user.accessDefinitions, (def) ->
        return def.entity._id == scope.currentAccess().entity._id
      index = scope.user.accessDefinitions.indexOf definition
      if index != -1
        definition.accessLevel = scope.selectedAccessLevel
        scope.saveMethod(scope.user)

    scope.setAccessLevel = (level) ->
      scope.selectedAccessLevel = level

    scope.selectedAccessLevel = Auth.getUserAccess(scope.user).accessLevel
