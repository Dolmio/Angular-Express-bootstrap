describe 'userService', ->
  require '../../testHelpers'
  userService = require '../../../../server/services/userService'
  User =  require '../../../../server/models/user'
  WeatherQuery = require '../../../../server/models/weatherQuery'
  q = require 'q'

  db = require('../../../../server/db/db')()

  it 'should find only users with notification time between arguments', ->
    startTime = new Date(10)
    endTime = new Date(20)
    db.drop().then ->
      user1 = userService.addUser(new User(1, startTime, []))
      user2 = userService.addUser(new User(2, new Date(9), []))
      user3 = userService.addUser(new User(3, new Date(21), []))
      q.all(user1, user2, user3)
    .then ->
      userService.getUsersWhoWantNotificationsAtTimeframe(startTime, endTime)
    .then (usersToNotify) ->
      usersToNotify.should.have.length 1


  it 'should add and get user', ->
    db.drop().then ->
      userService.addUser(new User(10))
    .then ->
        userService.getUser(10)
    .then (user) ->
      user._id.should.eql 10

  it 'should update user', ->
    user = new User(1)
    newNotificationTime = new Date(10)
    db.drop().then ->
      userService.addUser(user)
    .then ->
        user.notificationTime = newNotificationTime
        userService.updateUser(user)
    .then ->
        userService.getUser(1)
    .then (updatedUser) ->
        updatedUser.notificationTime.should.eql newNotificationTime

  it 'should reject updating user with invalid query', ->
    query = new WeatherQuery('any', 'temperature', 'greaterThan', 10, 4, 23, "Helsinki")
    user = new User(1, new Date(), [query])
    db.drop().then ->
      userService.addUser(user)
    .then ->
      user.queries[0].operator = "invalid"
      userService.updateUser(user)
    .fail (error) ->
        error.message.should.contain "invalid"




