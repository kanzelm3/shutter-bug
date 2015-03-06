'use strict'

angular.module 'shutterBugApp'
.directive 'imageOnLoad', ($timeout) ->
  restrict: 'A'
  scope:
    loaded: '=imageOnLoad'
  link: (scope, element) ->
    scope.loaded = false
    element.bind 'load', ->
      $timeout ->
        scope.loaded = true
