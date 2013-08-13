describe 'weatherService', ->
  helpers = require '../../testHelpers'
  db = require('../../../../server/db/db')()
  weatherService = require '../../../../server/services/weatherService'

  helpers.mockHttpGet('test/spec/server/testData/ForecastFromHelsinkiAndTurku.xml')
  dropDbAndUpdateForecasts = ->
    db.drop().then ->
      weatherService.updateForecasts()

  it 'should update weather forecasts', ->
    @timeout(5000)
    dropDbAndUpdateForecasts()
    .then  ->
      weatherService.getForecasts()
    .then (forecasts) ->
      forecasts.should.have.length 2
      helsinkiForecast = forecasts[0]
      turkuForecast = forecasts[1]
      helsinkiForecast.locationName.should.equal "Helsinki"
      turkuForecast.locationName.should.equal "Turku"

  it 'should throw error if no forecasts present', ->
    weatherService.getForecasts()
    .fail (error) ->
        error.should.exist

  it 'should get weather forecasts for location', ->
      dropDbAndUpdateForecasts()
      .then  ->
        weatherService.getForecastsFor('Helsinki')
      .then (forecastsForLocation) ->
        forecastsForLocation.locationName.should.equal "Helsinki"
        forecastsForLocation.loc.should.exist
        forecastsForLocation.forecasts.should.have.length 36

  it 'should throw error if no forecasts found for location', ->
    dropDbAndUpdateForecasts()
    .then ->
      weatherService.getForecastsFor("Tokyo")
        .fail (error) ->
          error.message.should.eql "No forecasts found for Tokyo"



