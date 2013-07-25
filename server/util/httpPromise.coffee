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
  get : get