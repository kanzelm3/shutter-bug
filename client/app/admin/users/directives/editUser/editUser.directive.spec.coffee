'use strict'

describe 'Directive: editUser', ->

  # load the directive's module and view
  beforeEach module 'shutterBugApp'
  beforeEach module 'app/admin/users/directives/editUser/editUser.html'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should be defined', inject ($compile) ->
    element = angular.element '<edit-user></edit-user>'
    element = $compile(element) scope
    scope.$apply()
    expect(element).toBeDefined()

