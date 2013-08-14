_ = require "lodash"
appConfig = require "./../../app-config.json"

class WeatherQuery

  constructor: (@groupMatcher, @feature, @operator, @valueToCompare, @startTime, @endTime, @locationName) ->
    @validateQuery()

  validateQuery : ->
    if not _.contains appConfig.groupMatchers, @groupMatcher
      throw new Error("Invalid argument error:  #{@groupMatcher} should be valid groupMatcher" + @getOtherArgumentsText())
    if not _.contains appConfig.measuredFeatures, @feature
      throw new Error("Invalid argument error:  #{@feature} should be measured" + @getOtherArgumentsText())
    if not _.contains appConfig.supportedQueryOperators, @operator
      throw new Error("Invalid argument error:  #{@operator} should be in supportedQueryOperators" + @getOtherArgumentsText())
    if not _.isNumber @valueToCompare
      throw new Error("Invalid argument error:  #{@valueToCompare} should be a number" + @getOtherArgumentsText())
    if not _.isString @locationName
      throw new Error("Invalid argument error:  #{@locationName} should be a string" + @getOtherArgumentsText())
    @validateAndThrowIfNeeded(@startTime)
    @validateAndThrowIfNeeded(@endTime)

  getOtherArgumentsText : ->
    "\nOther Arguments:
    groupMatcher: #{@groupMatcher}
    feature: #{@feature}
    operator: #{@operator}
    valueToCompare: #{@valueToCompare}
    startTime: #{@startTime}
    endTime: #{@endTime}
    locationName: #{@locationName}"

  validateAndThrowIfNeeded : (hour) ->
    if (not _.isNumber hour) and ( hour < 0 or hour > 23)
      throw new Error("Invalid argument error:  #{hour} should be a number in range of 0-23")

module.exports = WeatherQuery