describe 'weatherQueryBuilder', ->
  require '../../testHelpers'
  builder = require '../../../../server/services/weatherQueryBuilder'

  it 'should build valid weather query', ->
    query = builder.buildQuery('Helsinki', 'rainyInTheMorning')
    query.locationName.should.equal('Helsinki')
    query.feature.should.exist
    query.operator.should.exist
    query.valueToCompare.should.exist
    query.startTime.should.exist
    query.endTime.should.exist
    query.groupMatcher.should.exist
