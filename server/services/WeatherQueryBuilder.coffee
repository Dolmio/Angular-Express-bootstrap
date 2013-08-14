appConfig = require "./../../app-config.json"
WeatherQuery = require "../models/weatherQuery"
_ = require "lodash"
module.exports =
  buildQuery : (locationName, queryName) ->
    if not _.contains _.keys(storedQueries), queryName
      throw new Error("Invalid argument error:  #{queryName} should be in stored queries")
    _.extend storedQueries[queryName], {locationName: locationName}

storedQueries =
  rainyInTheMorning : new WeatherQuery("any", "humidity", "greaterThan", 80, 7,9, "")




