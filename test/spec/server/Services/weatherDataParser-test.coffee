describe 'weatherDataParser', ->
  require '../../testHelpers'
  fs = require 'fs'
  parser = require '../../../../server/services/weatherDataParser'
  xmlToParse =  fs.readFileSync('test/spec/server/testData/ForecastOfCitiesInFinland.xml', 'utf-8').toString()

  it 'should parse Forecast objects from data', ->
    parser.parseXmlToForecasts(xmlToParse)
    .then (forecasts) ->
        forecasts.should.be.a('array')

        forecastForPlace = forecasts[0]
        forecastForPlace.locationName.should.exist
        forecastForPlace.loc.should.exist
        location = forecastForPlace.loc
        location.lat.should.exist
        location.lng.should.exist

        forecastForPlace.forecasts.should.be.a('array')
        forecastForPlace.forecasts.should.have.length 36

        forecastForTimeStamp = forecastForPlace.forecasts[0]
        forecastForTimeStamp.timestamp.should.exist
        forecastForTimeStamp.temperature.should.exist
        forecastForTimeStamp.humidity.should.exist
        forecastForTimeStamp.weatherSymbol.should.exist



