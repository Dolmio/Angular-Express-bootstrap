parseXMLStringToJson = (string) ->
  q = require 'q'
  parseXml = require('xml2js').parseString
  q.nfcall(parseXml, string, {trim : true, attrkey: '@', mergeAttrs: true})

module.exports =
  parseXMLStringToJson  : parseXMLStringToJson