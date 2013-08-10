describe 'weatherQueryService', ->
  require '../../testHelpers'
  rewire = require('rewire')
  builder = require '../../../../server/services/weatherQueryBuilder'
  fs = require 'fs'
  q = require 'q'
  moment = require 'moment'

  weatherQueryService = rewire '../../../../server/services/weatherQueryService'

  weatherQueryService.__set__('weatherService ',
    getForecastsFor : (location) ->
      q.fcall( -> JSON.parse fs.readFileSync('test/spec/server/testData/helsinkiForecast.json', 'utf-8'))
  )
  weatherQueryService.__set__('now', ->
   #month is 0-indexed!
   moment.utc([2013, 7, 1, 6, 0, 0, 0])
  )

  it 'should get an answer for stored weatherQuery', ->

    rainyInTheMorning = builder.buildQuery('Helsinki', 'rainyInTheMorning')

    weatherQueryService.isPredicted(rainyInTheMorning)
    .then (result) ->
        result.should.equal true


  it 'should not be dry at the morning', ->
    query = builder.buildRawQuery("any", "humidity", "lessThan", 70, 7,9)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal false

  it 'should not pay attention to forecast more than 23 hours ahead', ->
    query = builder.buildRawQuery("any", "humidity", "lessThan", 10, 6,7)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal false

  it 'should pay attention to forecast 23 hours ahead', ->
    query = builder.buildRawQuery("any", "humidity", "lessThan", 10, 5,6)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal true

  it 'should not pay attention to forecasts before startTime', ->
    query = builder.buildRawQuery("any", "humidity", "greaterThan", 80, 8,9)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal false

  it 'should not pay attention to forecasts after endTime (endhour is excluded)', ->
    query = builder.buildRawQuery("any", "humidity", "greaterThan", 90, 6,10)
    weatherQueryService.isPredicted(query)
      .then (result) ->
        result.should.equal false

  it 'should be possible to assign end hour greater smaller than start hour', ->
    query = builder.buildRawQuery("any", "temperature", "greaterThan", 20, 23,1)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal true

  it "should be possible to use 'all' as a query matcher", ->
    query = builder.buildRawQuery("all", "humidity", "greaterThan", 65, 6,11)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal true

  it "should notice if 'all' query parameter not matched", ->
    query = builder.buildRawQuery("all", "humidity", "greaterThan", 65, 6,5)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal false

  it "should be possible to use equals as operator in the query", ->
    query = builder.buildRawQuery("any", "weatherSymbol", "equals", 31, 6,5)
    weatherQueryService.isPredicted(query)
    .then (result) ->
      result.should.equal true

  it "should not be able to find any matching weatherSymbols", ->
    query = builder.buildRawQuery("any", "weatherSymbol", "equals", 0, 6,5)
    weatherQueryService.isPredicted(query)
      .then (result) ->
        result.should.equal false









