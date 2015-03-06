'use strict'

describe 'Controller: TakePhotosCtrl', ->

  # load the controller's module
  beforeEach module 'shutterBugApp'
  TakePhotosCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TakePhotosCtrl = $controller 'TakePhotosCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
