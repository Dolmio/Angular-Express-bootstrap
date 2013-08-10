appConfig = require "./../../app-config.json"
_ = require "lodash"

class WeatherQuery

  constructor: (@groupMatcher, @feature, @operator, @valueToCompare, @startTime, @endTime) ->
    @validateQuery()

  validateQuery : ->
    if not _.contains appConfig.groupMatchers, @groupMatcher
      throw new Error("Invalid argument error:  #{@groupMatcher} should be valid groupMatcher")
    if not _.contains appConfig.measuredFeatures, @feature
      throw new Error("Invalid argument error:  #{@feature} should be measured")
    if not _.contains appConfig.supportedQueryOperators, @operator
      throw new Error("Invalid argument error:  #{@operator} should be in supportedQueryOperators")
    if not _.isNumber @valueToCompare
      throw new Error("Invalid argument error:  #{@valueToCompare} should be a number")
    @validateAndThrowIfNeeded(@startTime)
    @validateAndThrowIfNeeded(@endTime)

  validateAndThrowIfNeeded : (hour) ->
    if (not _.isNumber hour) and ( hour < 0 or hour > 23)
      throw new Error("Invalid argument error:  #{hour} should be a number in range of 0-23")



module.exports =
  buildQuery : (locationName, queryName) ->
    if not _.contains _.keys(storedQueries), queryName
      throw new Error("Invalid argument error:  #{queryName} should be in stored queries")
    _.extend storedQueries[queryName], {locationName: locationName}

  buildRawQuery : (groupMatcher, feature, operator, valueToCompare, startTime, endTime) ->
    new WeatherQuery(groupMatcher, feature, operator, valueToCompare, startTime, endTime)


storedQueries =
  rainyInTheMorning : new WeatherQuery("any", "humidity", "greaterThan", 80, 7,9)




