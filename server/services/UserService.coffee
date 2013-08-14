appConfig = require "./../../app-config.json"
db = require('../db/db')()
q = require 'q'
userCollection  = "users"
User = require '../models/user'
module.exports =

  getUser : (id) ->
    db.findOne(userCollection, {'_id' : id})

  getUsersWhoWantNotificationsAtTimeframe : (startTime, endTime) ->
    db.find(userCollection, { '$and' :
            [{'notificationTime' : {'$lte' : startTime}, 'notificationTime' : {'$gte' : endTime}}]})

  addUser : (user) ->
    db.insert(userCollection, user)

  updateUser : (user) ->
    validatedUser = new User(user._id, user.notificationTime, user.queries)
    db.update(userCollection, {'_id' : validatedUser._id}, validatedUser)





