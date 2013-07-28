describe 'weatherService', ->
  require '../../testHelpers'
  weatherService = require('../../../../server/services/weatherService')

  '''
  it 'should return 200 for basic request', ->
    weatherService.getWeatherData().then(
      (result) -> console.log result
    )
  '''
