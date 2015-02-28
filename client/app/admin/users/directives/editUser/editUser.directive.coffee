'use strict'

angular.module 'shutterBugApp'
.directive 'editUser', (Auth) ->
  templateUrl: 'app/admin/users/directives/editUser/editUser.html'
  restrict: 'E'
  scope:
    user: '='
    currentAccess: '='
    saveMethod: '&'
  link: (scope, element, attrs) ->
    scope.save = ->
      scope.saveMethod(scope.user)

    scope.selectedAccessLevel = Auth.getUserAccess(scope.user).accessLevel.name
