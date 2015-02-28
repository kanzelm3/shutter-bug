'use strict'

describe 'Controller: AdminNavbarCtrl', ->

  # load the controller's module
  beforeEach module 'shutterBugApp'
  NavbarCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NavbarCtrl = $controller 'AdminNavbarCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
