class User
  constructor : (@_id, @notificationTime, @queries) ->
    @queries = @queries || []

module.exports = User