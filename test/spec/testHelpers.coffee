chai = require('chai')
chai.should()
require("mocha-as-promised")()
require('../../server/db/db')('test_db')
q = require 'q'
http = require '../../server/util/httpPromise'
fs = require 'fs'
module.exports =
  mockHttpGet : (mockDataPath) ->
    mockWeatherData = fs.readFileSync(mockDataPath, 'utf-8').toString()
    http.get = ->
      q.fcall( -> mockWeatherData)
