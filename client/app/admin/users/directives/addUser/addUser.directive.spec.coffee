'use strict'

describe 'Directive: addUser', ->

  # load the directive's module and view
  beforeEach module 'shutterBugApp'
  beforeEach module 'app/admin/users/directives/addUser/addUser.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<add-user></add-user>'
    element = $compile(element) scope
    scope.$apply()
    expect(element.text()).toBe 'this is the addUser directive'

