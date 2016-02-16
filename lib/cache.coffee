Promise = require 'bluebird'

module.exports = (db) ->
  new MongoCache db

class MongoCache
  cacheCollections: ['player', 'guild']

  constructor: (@db) ->
    if @db?
      for name in @cacheCollections
        @db[name].ensureIndex { createdAt: 1 }, { expireAfterSeconds: 3600 }

  get: (collection, params, fn) ->
    if not @db?
      return Promise.resolve fn()

    if @cacheCollections.indexOf(collection) is -1
      return Promise.resolve fn()

    new Promise (yell, cry) =>
      @db.collection(collection).findOne (err, doc) =>
        if err?
          return cry err

        if not doc?
          fn().then (doc) =>
            yell doc
            doc.createdAt = new Date
            @db.collection(collection).save(doc)
          return

        doc.fromCache = true
        yell doc
