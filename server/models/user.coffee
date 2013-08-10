class User
  constructor : (@notificationTime, @queries) ->
    @queries = @queries || []

module.exports = User