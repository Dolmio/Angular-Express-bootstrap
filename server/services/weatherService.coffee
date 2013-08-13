appConfig = require "./../../app-config.json"
http = require '../util/httpPromise'
xmlParser = require '../util/xmlParser'
db = require('../db/db')()
fs = require 'fs'
q = require 'q'
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
          db.insert forecastCollection, {forecastCollection : forecasts, createdAt: new Date()}
    )

  getForecasts: ->
    db.findLatest(forecastCollection)
      .then (forecastSnpashot) ->
        deferred = q.defer()
        if not forecastSnpashot then deferred.reject new Error('No forecasts found')
        else
          deferred.resolve forecastSnpashot.forecastCollection
        deferred.promise


  getForecastsFor: (locationName) ->
    db.findLatest(forecastCollection, {"forecastCollection" : {"$elemMatch" : {"locationName" : locationName}}})
      .then (forecastSnpashot) ->
        deferred = q.defer()
        if not forecastSnpashot or not forecastSnpashot.forecastCollection then deferred.reject new Error("No forecasts found for #{locationName}")
        else
          deferred.resolve forecastSnpashot.forecastCollection[0]
        deferred.promise
