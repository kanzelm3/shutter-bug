'use strict'

describe 'Service: menu', ->

  # load the service's module
  beforeEach module 'shutterBugApp'

  # instantiate service
  menu = undefined
  beforeEach inject (_menu_) ->
    menu = _menu_

  it 'should do something', ->
    expect(!!menu).toBe true