userService = require '../services/userService'
weatherQueryService = require '../services/weatherQueryService'
async = require '../util/asyncCollectionUtil'
oneMinute = 60000
taskInterval = oneMinute

now = ->
  new Date()

senderTask = ->
  justNow = now()
  timeOfPreviousTask = new Date(justNow.getTime() - taskInterval)
  userService.getUsersWhoWantNotificationsAtTimeframe(timeOfPreviousTask, justNow)
  .then (users) ->
      console.log users
      getUsersWithOnlyTasksThatNeedNotifying(users)
  .then (users) ->
      countAndSendNotifications(users)

getUsersWithOnlyTasksThatNeedNotifying = (users) ->
  async.map users, (user) ->
    user.queriesToNotify = async.filter user.queries, (query) ->
      weatherQueryService.isPredicted(query)
    user

countAndSendNotifications = (users) ->
  notifyPromises = users.map (user) ->
    notify(user)

  async.reduce notifyPromises, (cumulator, currentValue) ->
    cumulator + currentValue
  ,0

notify = (user) ->
  user.queriesToNotify
  .then (queries) ->
    console.log "Sending #{queries.length} notifications to user #{user._id}"
    queries.forEach (query) ->
      console.log "sending"
    queries.length

module.exports =
  start : ->
    setInterval(senderTask, taskInterval)

  doTask : ->
    senderTask()