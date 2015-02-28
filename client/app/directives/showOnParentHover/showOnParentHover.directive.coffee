'use strict'

angular.module 'shutterBugApp'
.directive 'showOnParentHover', ->
  restrict: 'A'
  link: (scope, element) ->
    element.addClass 'ng-hide'

    element.parent().bind 'mouseenter', ->
      if element.hasClass 'ng-hide'
        element.removeClass 'ng-hide'
    element.parent().bind 'mouseleave', ->
      if !element.hasClass 'ng-hide'
        element.addClass 'ng-hide'
