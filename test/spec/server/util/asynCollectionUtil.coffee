describe 'asyncCollectionUtil', ->
  require '../../testHelpers'
  async = require('../../../../server/util/asyncCollectionUtil')
  q = require 'q'

  it 'should filter asynchronosly with normal filter function', ->
    filter = (number) ->
      number % 2 is 0

    async.filter([0,1,2,3,4], filter)
    .then (filtered) ->
      filtered.should.eql([0, 2, 4])

  it 'should filter asynchronosly with filter function which returns promise', ->
    filter = (number) ->
      q.fcall(-> number % 2 is 0)

    async.filter([0,1,2,3,4], filter)
      .then (filtered) ->
        filtered.should.eql [0, 2, 4]


  it 'should map asynchronously', ->
    square = (value) ->
      q.fcall(-> value * value)

    async.map([0,1,2,3,4], square)
    .then (result) ->
        result.should.eql [0,1,4,9,16]

  it 'should reduce asynchronously', ->
    val1 = q.fcall(-> 1)
    val2 = q.fcall(-> 2)

    async.reduce([val1, val2], (cumulator, current) -> cumulator + current)
    .then (result) ->
        result.should.eql 3

