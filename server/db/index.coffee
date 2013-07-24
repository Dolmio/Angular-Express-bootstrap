"use strict"

# jshint camelcase: false 

# Dependencies
mongo = require("mongodb")
appConfig = require("../../app-config.json")
createDummyCollection = undefined

# Create mongo server
server = new mongo.Server(appConfig.database.host, appConfig.database.port,
  auto_reconnect: true
)
client = module.exports = new mongo.MongoClient(server)

# Open a client to mongo
client.open (err, client) ->
  if err
    console.log "Database connection error\nis mongod running?"
    console.log err
    return
  console.log "Database connection to " + client.db(appConfig.database.name).databaseName
  
  # Always create a new collection
  db = client.db(appConfig.database.name)
  db.createCollection appConfig.database.collection, (err, collection) ->
    if err
      console.log "Error creating collection"
      console.log err
      return err
    
    # If collection is empty then create some dummy data
    collection.find({}).toArray (err, items) ->
      if err
        console.log "Error accessing collection"
        console.log err
        return err
      createDummyCollection collection  if items.length <= 0




# Create dummy data for the collection
createDummyCollection = (collection) ->
  console.log "Creating collection..."
  dummy = [
    name: "Albert"
    address: "21 Jump St"
    phone: "123 456 789"
  ,
    name: "Bert"
    address: "15 Sesame St"
    phone: "987 654 321"
  ,
    name: "Cecil"
    address: "7 Rue de la Vio"
    phone: "0101 98 98"
  ]
  collection.insert dummy, (err, res) ->
    if err
      console.log "Error inserting collection data"
      console.log err
      return err
    console.log "Collection populated"
