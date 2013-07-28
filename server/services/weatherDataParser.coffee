xmlToJsonParser = require '../util/xmlParser'
_ = require 'lodash'

module.exports =
  parseXmlToForecasts : (xmlString) ->
    xmlToJsonParser.parseXMLStringToJson(xmlString)
      .then( (json) ->
        console.info "JSON PARSED FROM XML"
        collectRelevantDataFromJson(json)
      (error) ->
        console.error "Something went wrong when parsing xmlString to JSON", error.stack
      )
      .then((rawMeasurementsFromCategories) ->
        forecastsGrouped = groupForecastsByMeasurementLocation(rawMeasurementsFromCategories)
        forecastsForEveryPlace = _.map forecastsGrouped,  buildForecastsFromRawMeasurements
        console.info "FORECASTS BUILT"
        forecastsForEveryPlace
      (error) ->
        console.error "Something went wrong when building forecasts from XML", error.stack
      )

measuredCategoryIds =
  temperature : 'temperature'
  weatherSymbol : 'WeatherSymbol3'
  humidity : 'humidity'

collectRelevantDataFromJson = (json) ->
  _.map json['wfs:FeatureCollection']['wfs:member'], (estimateCategory) ->
    estimateCategoryDetails = estimateCategory['omso:PointTimeSeriesObservation'][0]
    location = parseLocation(estimateCategoryDetails)
    measurementsOfCategory = estimateCategoryDetails['om:result'][0]['wml2:MeasurementTimeseries'][0]
    measurements =  measurementsOfCategory['wml2:point']
    categoryId = measurementsOfCategory['gml:id']

    parseMeasurement = (rawMeasurement) ->
      measurement = rawMeasurement['wml2:MeasurementTVP'][0]
      {
        categoryKey : categoryId
        measurementValue : Number (measurement['wml2:value'][0])
        measurementTime : measurement['wml2:time'][0]
        location: location
      }

    _.map measurements, parseMeasurement

parseLocation = (categoryJson) ->
  locationNode = categoryJson['om:featureOfInterest'][0]['sams:SF_SpatialSamplingFeature'][0]['sams:shape'][0]\
    ['gml:MultiPoint'][0]['gml:pointMembers'][0]['gml:Point']
  locationName = locationNode[0]['gml:name'][0]
  positionString = locationNode[0]['gml:pos'][0]
  posSplit = positionString.split(" ")
  {
    name: locationName
    loc :
      lat : Number(posSplit[0])
      lng :  Number(posSplit[1])
  }

buildForecastsFromRawMeasurements = (rawMeasurementsFromCategories)->
  zippedMeasurements = _.zip(rawMeasurementsFromCategories...)
  forecasts = _.map zippedMeasurements, buildForecast
  location = forecasts[0].location
  {
    forecasts : forecasts
    locationName : location.name
    loc : location.loc
  }

groupForecastsByMeasurementLocation = (forecasts) ->
  _.reduce forecasts , grouper, []

grouper = (result, forecast) ->
  if _.isEmpty result
    result.push([forecast])
  else if (result[result.length - 1].length % _.keys(measuredCategoryIds).length) is 0
    result.push([forecast])
  else
    result[result.length - 1].push forecast
  result


buildForecast = (rawForecast) ->
  timestamp : rawForecast[0].measurementTime
  location : rawForecast[0].location
  temperature : getMeasurementValueFor(measuredCategoryIds.temperature, rawForecast)
  weatherSymbol : getMeasurementValueFor(measuredCategoryIds.weatherSymbol, rawForecast)
  humidity : getMeasurementValueFor(measuredCategoryIds.humidity, rawForecast)

getMeasurementValueFor = (categoryId, rawForecast) ->
  forecast = _.find rawForecast, (measurement) ->
    measurement.categoryKey.indexOf(categoryId) isnt -1
  forecast.measurementValue
