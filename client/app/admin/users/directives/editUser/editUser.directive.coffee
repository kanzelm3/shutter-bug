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
      scope.saveMethod(scope.user)

    scope.setAccessLevel = (level) ->
      scope.selectedAccessLevel = level

    scope.selectedAccessLevel = Auth.getUserAccess(scope.user).accessLevel.name
