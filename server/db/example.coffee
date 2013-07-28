
appConfig = require("../../app-config.json")
weatherService = require '../services/weatherService'
module.exports = (req, res) ->
  console.log "starting"
  weatherService.updateForecasts().then((result)->
    res.send 'Forecasts Updated'
    console.log("FINISHED")
  ).done()


