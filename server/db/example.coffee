"use strict"
appConfig = require("../../app-config.json")
db = require("../db").db(appConfig.database.name)

# Example route - returns all items in database collection
module.exports = (req, res) ->
  console.log "Accessing database " + db.databaseName
  db.collection appConfig.database.collection, (err, collection) ->
    if err
      console.log "Error accessing collection"
      console.log err
      return err
    
    # Find all items and return them
    collection.find().toArray (err, items) ->
      if err
        console.log "Error finding items in collection"
        console.log err
        return err
      res.send items