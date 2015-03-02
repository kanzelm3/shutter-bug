'use strict'

describe 'Service: Entity', ->

  # load the service's module
  beforeEach module 'shutterBugApp'

  # instantiate service
  Entity = undefined
  beforeEach inject (_Entity_) ->
    Entity = _Entity_

  it 'should do something', ->
    expect(!!Entity).toBe true