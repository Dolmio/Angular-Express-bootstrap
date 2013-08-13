describe 'senderTask', ->
  require '../../testHelpers'
  rewire = require('rewire')
  WeatherQuery = require '../../../../server/models/weatherQuery'
  User = require '../../../../server/models/user'
  q = require 'q'
  notificationTask = rewire '../../../../server/notification/senderTask'
  userService = require '../../../../server/services/userService'

  fs = require 'fs'
  mockWeatherData =  fs.readFileSync('test/spec/server/testData/ForecastFromHelsinkiAndTurku.xml', 'utf-8').toString()
  now = new Date(2013, 6, 30, 10)

  weatherService = require '../../../../server/services/weatherService'
  #mock httpRequest
  http = require '../../../../server/util/httpPromise'
  http.get = ->
    q.fcall( -> mockWeatherData)

  db = require('../../../../server/db/db')()
  beforeEach ->
    db.drop()
    notificationTask.__set__('now', -> now)
    weatherService.updateForecasts()


  it 'should send notification', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 15, 0,3)
    weatherQuery.locationName = "Helsinki"
    user = new User(new Date(), [weatherQuery])
    userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .then (sentNotifications) ->
      sentNotifications.should.equal 1

  it 'should not find any notifications to send', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 35, 0,23)
    weatherQuery.locationName = "Helsinki"
    user = new User(now, [weatherQuery])
    userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .then (sentNotifications) ->
      sentNotifications.should.equal 0

  it 'should not find any notifications when invalid locationName', ->
    weatherQuery = new WeatherQuery("any", "temperature", "greaterThan", 15, 0,3)
    weatherQuery.locationName = "Timbuktu"
    user = new User(new Date(), [weatherQuery])
    userService.addUser(user)
    .then ->
      notificationTask.doTask()
    .fail (error) ->
        error.should.exist






