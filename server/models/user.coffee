WeatherQuery = require './weatherQuery'

class User
  constructor : (@_id, @notificationTime, queries = []) ->
    @queries = queries.map (q) ->
      new WeatherQuery q.groupMatcher, q.feature, q.operator, q.valueToCompare, q.startTime, q.endTime, q.locationName

module.exports = User