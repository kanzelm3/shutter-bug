'use strict'

describe 'Directive: showOnParentHover', ->

  # load the directive's module
  beforeEach module 'shutterBugApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<a href="">Parent <i show-on-parent-hover></i></a>'
    element = $compile(element) scope
    expect(element.find('[show-on-parent-hover]').hasClass 'ng-hide').toBeTruthy()
    element.trigger 'mouseenter'
    expect(element.find('[show-on-parent-hover]').hasClass 'ng-hide').toBeFalsy()
