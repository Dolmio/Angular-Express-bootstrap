describe 'userService', ->
  require '../../testHelpers'
  userService = require '../../../../server/services/userService'
  User =  require '../../../../server/models/user'
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


