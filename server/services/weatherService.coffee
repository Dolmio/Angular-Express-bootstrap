appConfig = require "./../../app-config.json"
http = require '../util/httpPromise'
xmlParser = require '../util/xmlParser'
db = require '../db/db'
fs = require 'fs'
forecastCollection  = "forecasts"
module.exports =
  updateForecasts: ->
    storedQuery = "fmi::forecast::hirlam::surface::obsstations::timevaluepair"
    features = "temperature,WeatherSymbol3,humidity"
    options =
      hostname : "data.fmi.fi"
      path : "/fmi-apikey/a3a7cb9b-6c34-4b57-83cb-d666c0aaee45/wfs?request=getFeature&storedquery_id=#{storedQuery}&parameters=#{features}"

    http.get(options).then((xmlResult) ->
      dataParser = require './weatherDataParser'
      dataParser.parseXmlToForecasts(xmlResult)
      .then (forecasts)->
          db.insert forecastCollection, forecasts
    )



