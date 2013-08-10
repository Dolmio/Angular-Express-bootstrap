appConfig = require "./../../app-config.json"
db = require('../db/db')()
q = require 'q'
userCollection  = "users"
module.exports =

  getUser : (id) ->
    db.findOne(userCollection, {'_id' : id})

  getUsersWhoWantNotificationsAtTimeframe : (startTime, endTime) ->
    db.find(userCollection, { '$and' :
            [{'notificationTime' : {'$gte' : startTime}, 'notificationTime' : {'$lte' : endTime}}]})

  addUser : (user) ->
    db.insert(userCollection, user)




