Helper = require 'hubot-test-helper'
assert = require 'power-assert'

describe '5rolli', ->
  room = null

  beforeEach ->
    helper = new Helper('../src/scripts/5rolli.coffee')
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  it 'help', ->
    helps = room.robot.helpCommands()
    assert.deepEqual helps, [
      'hubot 5rolli <URL> - List Summary of project'
      'hubot 5rolli info [project] <URL> - List Detail of project'
    ]
