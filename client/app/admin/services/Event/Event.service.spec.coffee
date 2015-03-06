'use strict'

describe 'Service: event', ->

  # load the service's module
  beforeEach module 'shutterBugApp'

  # instantiate service
  event = undefined
  beforeEach inject (_event_) ->
    event = _event_

  it 'should do something', ->
    expect(!!event).toBe true