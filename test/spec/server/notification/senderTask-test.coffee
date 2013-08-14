describe 'senderTask', ->
  helpers = require '../../testHelpers'
  rewire = require('rewire')
  WeatherQuery = require '../../../../server/models/weatherQuery'
  User = require '../../../../server/models/user'
  q = require 'q'
  notificationTask = rewire '../../../../server/notification/senderTask'
  userService = require '../../../../server/services/userService'

  now = new Date(2013, 6, 30, 10)

  weatherService = require '../../../../server/services/weatherService'

  db = require('../../../../server/db/db')()
  helpers.mockHttpGet('test/spec/server/testData/ForecastFromHelsinkiAndTurku.xml')

  dropDbAndUpdateForecasts = ->
    db.drop().then ->
      weatherService.updateForecasts()

  notificationTask.__set__('now', -> now)


  it 'should send notification', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 15, 0,3, "Helsinki")
    user = new User(1, new Date(), [weatherQuery])

    dropDbAndUpdateForecasts()
    .then ->
      userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .then (sentNotifications) ->
      sentNotifications.should.equal 1

  it 'should not find any notifications to send', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 35, 0,23, "Helsinki")
    user = new User(1, now, [weatherQuery])
    dropDbAndUpdateForecasts()
    .then ->
      userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .then (sentNotifications) ->
      sentNotifications.should.equal 0

  it 'should not find any notifications when invalid locationName', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 15, 0,3, "Timbuktu")
    user = new User(1, new Date(), [weatherQuery])
    dropDbAndUpdateForecasts()
    .then ->
      userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .fail (error) ->
        error.should.exist






