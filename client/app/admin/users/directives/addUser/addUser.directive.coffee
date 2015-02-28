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
      scope.saveMethod(scope.user)

    scope.setAccessLevel = (level) ->
      scope.selectedAccessLevel = level

    scope.selectedAccessLevel = scope.currentAccess().entity.accessLevels[0].name
