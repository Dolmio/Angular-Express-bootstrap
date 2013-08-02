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
      collection.insert(data))
    .fail((error) ->
        console.error "Insert failed: ",  error
    )

  drop : ->
    db.invoke('dropDatabase').then -> console.log "DROPPED Database"

  findLatest : (collection) ->
    db.invoke('collection', collection)
    .then (collection) ->
        collection.find({},{}, {sort: {'_id' :  -1}})
    .invoke('nextObject')







