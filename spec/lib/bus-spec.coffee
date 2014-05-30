EventEmitter = require('events').EventEmitter

describe 'bus.io', ->

  Given ->
    @Sio = class Sio extends EventEmitter
      constructor: ->
        if not (@ instanceof Sio)
          return new Sio
      listen: ->

  Given ->
    @Bus = requireSubject 'lib/bus', {
      'socket.io': @Sio
    }

  Given -> @bus = @Bus()

  describe '#', ->
    
    Then -> expect(@bus instanceof @Bus).toBe true

  describe '#listen', ->

    context 'with port', ->

      Given -> @port = 3000
      Given -> spyOn(@bus.io,['listen'])
      When -> @bus.listen @port
      Then -> expect(@bus.io.listen).toHaveBeenCalled()

    context 'socket.io instance', ->

      Given -> @io = @Sio()
      Given -> spyOn(@io,['listen'])
      When -> @bus.listen @io
      Then -> expect(@bus.io).toEqual @io

  describe '#message', ->

    Given ->
      @params =
        actor: 'me'
        action: 'say'
        content: 'hello'
        target: 'you'
        creatd: new Date
    When -> @message = @bus.message @params
    Then -> expect(@message.data()).toBe @params
    And -> expect(@message.listeners('built').length).toBe 1
    And -> expect(@message.listeners('built')[0]).toEqual @bus.onBuiltMessage