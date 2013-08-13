q = require 'q'
async = require 'async'
module.exports =
  filter : (collection, filterFunc) ->
    filterPromises = collection.map filterFunc
    q.all(filterPromises)
    .then (truthValues) ->
      collection.filter (value, index) ->
        truthValues[index]

  map : (collection, callback) ->
    promises = collection.map callback
    q.all(promises)

  reduce : (collectionOfPromises, reducer, initialValue) ->
    q.all(collectionOfPromises)
    .then (resolvedValues) ->
      if initialValue? then resolvedValues.reduce reducer, initialValue
      else resolvedValues.reduce reducer




