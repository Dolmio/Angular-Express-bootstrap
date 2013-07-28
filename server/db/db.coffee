appConfig = require("../../app-config.json")
QMongoDB = require('q-mongodb');
db = QMongoDB.db(appConfig.database.name)

module.exports =

  insert : (collection, data) ->
    db.invoke('collection', collection)
    .then( (collection) ->
      console.log "starting insert"
      collection.insert(data))
    .fail((error) ->
        console.error "Insert failed: ",  error
    )




