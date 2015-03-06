'use strict'

describe 'Controller: EventDashboardCtrl', ->

  # load the controller's module
  beforeEach module 'shutterBugApp'
  DashboardCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DashboardCtrl = $controller 'EventDashboardCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
