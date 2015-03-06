'use strict'

describe 'Directive: imageOnLoad', ->

  # load the directive's module
  beforeEach module 'shutterBugApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<image-on-load></image-on-load>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the imageOnLoad directive'
