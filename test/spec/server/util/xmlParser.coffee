describe 'xmlParser', ->
  require '../../testHelpers'
  parser = require('../../../../server/util/xmlParser')

  it 'should parse XML string to JSON object', ->
    xmlString = '<?xml version="1.0" encoding="UTF-8"?><root><child>1</child><child>2</child></root>'
    parser.parseXMLStringToJson(xmlString)
    .then((json) ->
        json.root.child[1].should.equal('2')
    )


