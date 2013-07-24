describe 'weatherService', ->
  weatherService = require('../../../../server/services/weatherService')
  chai = require('chai')
  chai.should()
  require("mocha-as-promised")()

  it 'should return 200 for basic request', ->
    weatherService.getWeatherData().then(
      (result) -> result.le
    )

