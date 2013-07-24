appConfig = require "./../../app-config.json"
http = require "http"
q = require 'q'
get  = (options) ->
  deferred = q.defer()
  data = ""

  req = http.request options, (response) ->
    response.setEncoding('utf8');
    response.on 'data', (chunk) ->
      data += chunk
    response.on 'end',  ->
      deferred.resolve data

  req.on "error", (e) ->
    deferred.reject e

  req.end()
  deferred.promise

module.exports =
  getWeatherData : ->
    options =
      host : "data.fmi.fi"
      path : "/fmi-apikey/a3a7cb9b-6c34-4b57-83cb-d666c0aaee45/wfs?request=getCapabilities"
      method : 'GET'
    get options


