appConfig = require "./../../app-config.json"
http = require '../util/httpPromise'

module.exports =
  getWeatherData : ->
    options =
      host : "data.fmi.fi"
      path : "/fmi-apikey/a3a7cb9b-6c34-4b57-83cb-d666c0aaee45/wfs?request=getCapabilities"
      method : 'GET'
    http.get options


