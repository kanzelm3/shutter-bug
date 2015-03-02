'use strict'

describe 'Service: AccessLevel', ->

  # load the service's module
  beforeEach module 'shutterBugApp'

  # instantiate service
  AccessLevel = undefined
  beforeEach inject (_AccessLevel_) ->
    AccessLevel = _AccessLevel_

  it 'should do something', ->
    expect(!!AccessLevel).toBe true