_ = require "lodash"
appConfig = require "./../../app-config.json"

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

module.exports = WeatherQuery