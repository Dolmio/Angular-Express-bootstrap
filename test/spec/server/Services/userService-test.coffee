describe 'userService', ->
  require '../../testHelpers'
  userService = require '../../../../server/services/userService'
  User =  require '../../../../server/models/user'
  q = require 'q'

  it 'should find users who want notifications at given time', ->
    notificationTime = new Date(1)
    console.log notificationTime
    user1 = userService.addUser(new User(notificationTime, []))
    user2 = userService.addUser(new User(new Date(10), []))
    q.all(user1, user2)
    .then ->
        userService.getUsersWhoWantNotificationsAtTimeframe(notificationTime, new Date(3))
    .then (usersToNotify) ->
        usersToNotify.should.have.length 1

