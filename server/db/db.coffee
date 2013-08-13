appConfig = require("../../app-config.json")
db = null

initDb = (dbName) ->
  dbName = appConfig.database.name if not dbName
  console.log "initialising db #{dbName}"
  QMongoDB = require('q-mongodb')
  db = QMongoDB.db(dbName)

module.exports = (dbName) ->

  if not db
    initDb(dbName)

  insert : (collection, data) ->
    db.invoke('collection', collection)
    .then( (collection) ->
      console.log "starting insert"
      collection.insert(data, {w : 1}))
    .fail((error) ->
        console.error "Insert failed: ",  error
    )

  drop : ->
    db.invoke('dropDatabase')

  findLatest : (collection, projection) ->
    projection = projection || {}
    db.invoke('collection', collection)
    .then (collection) ->
        collection.find({},projection, {sort: {'_id' :  -1}})
    .invoke('nextObject')

  find : (collection, query) ->
    query = query || {}
    db.invoke('collection', collection)
    .then (collection) ->
      collection.find(query)
    .invoke('toArray')

  findOne : (collection, query) ->
    query = query || {}
    db.invoke('collection', collection)
    .then (collection) ->
      collection.findOne(query)
    .invoke('nextObject')








