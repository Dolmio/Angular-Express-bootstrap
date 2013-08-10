weatherService = require "./weatherService"
moment = require 'moment'

resolve = (query, fromForecasts) ->

  matchedForecasts = fromForecasts.forecasts.filter (forecast) ->
    featureFilter(forecast[query.feature], query.operator, query.valueToCompare) and
    timeFilter(query.startTime, query.endTime, forecast.timestamp)

  switch(query.groupMatcher)
    when 'any' then matchedForecasts.length > 0
    when 'all' then matchedForecasts.length is Math.abs(query.endTime - query.startTime)

featureFilter = (featureValue, operator, valueToCompare) ->
  switch(operator)
    when 'greaterThan' then featureValue > valueToCompare
    when 'lessThan' then featureValue < valueToCompare
    when 'equals' then featureValue is valueToCompare
    else throw TypeError "Operator: #{operator} should be valid operator"

timeFilter = (startTimeHour, endTimeHour, forecastTime) ->
  justNow = now()
  forecastTime = moment.utc(forecastTime)
  if forecastTime.diff(justNow, 'hours') >= 24 then false
  else if endTimeHour < startTimeHour
    forecastTime.hours() >= startTimeHour or forecastTime.hours() < endTimeHour
  else
    forecastTime.hours() >= startTimeHour and forecastTime.hours() < endTimeHour

now = ->
  moment().utc()

module.exports =
  isPredicted : (weatherQuery) ->
    weatherService.getForecastsFor(weatherQuery.locationName)
    .then (forecastsForLocation) ->
        resolve(weatherQuery, forecastsForLocation)


