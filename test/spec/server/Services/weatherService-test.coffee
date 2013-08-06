describe 'weatherService', ->
  require '../../testHelpers'
  q = require 'q'

  fs = require 'fs'
  mockWeatherData =  fs.readFileSync('test/spec/server/testData/ForecastFromHelsinkiAndTurku.xml', 'utf-8').toString()
  db = require('../../../../server/db/db')()
  beforeEach( ->

    db.drop()
    @weatherService = require '../../../../server/services/weatherService'
    #mock httpRequest
    @http = require '../../../../server/util/httpPromise'
    @http.get = ->
      q.fcall( -> mockWeatherData)
  )


  it 'should update weather forecasts', ->
    @timeout(5000)
    weatherService = @weatherService
    weatherService.updateForecasts()
    .then  ->
      weatherService.getForecasts()
    .then (forecasts) ->
      forecasts.should.have.length 2
      helsinkiForecast = forecasts[0]
      turkuForecast = forecasts[1]
      helsinkiForecast.locationName.should.equal "Helsinki"
      turkuForecast.locationName.should.equal "Turku"

  it 'should throw error if no forecasts present', ->
    @weatherService.getForecasts()
    .fail (error) ->
        error.should.exist

  it 'should get weather forecasts for location', ->
    weatherService = @weatherService
    weatherService.updateForecasts()
      .then  ->
        weatherService.getForecastsFor('Helsinki')
      .then (forecastsForLocation) ->
        forecastsForLocation.locationName.should.equal "Helsinki"
        forecastsForLocation.loc.should.exist
        forecastsForLocation.forecasts.should.have.length 36

  it 'should throw error if no forecasts found for location', ->
    @weatherService.getForecastsFor("Tokyo")
      .fail (error) ->
        error.should.exist


