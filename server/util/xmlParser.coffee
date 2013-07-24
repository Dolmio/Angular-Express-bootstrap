parseXMLStringToJson = (string) ->
  q = require 'q'
  parseXml = require('xml2js').parseString
  q.nfcall(parseXml, string)

module.exports =
  parseXMLStringToJson  : parseXMLStringToJson