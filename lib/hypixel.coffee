request = require 'request'
qs = require 'querystring'
Promise = require 'bluebird'

cache = require './cache'

module.exports = (key, db) ->
  hp = new Hypixel(key, db)
  hp.request('key').then (result) ->
    if not result.success
      throw new Error 'Invalid Hypixel API key!'
    hp

class Hypixel
  constructor: (@key, @db) ->
    @base = 'https://api.hypixel.net'
    @cache = cache @db

  request: (endpoint, params={}) ->
    # If searching for a player or a guild, try the cache first

    @cache.get endpoint, params, =>
      # If it failed for some reason (not found or an error)
      new Promise (yell, cry) =>
        params.key = @key
        url = "#{@base}/#{endpoint}?#{qs.stringify params}"
        request url, (err, res, body) ->
          if err?
            return cry err
          try
            yell JSON.parse body
          catch e
            cry new Error 'Error while decoding json response: ' + body


  # Players
  getPlayerByUUID: (uuid) ->
    @request 'player', uuid: uuid

  getPlayerByName: (username) ->
    @request 'player', name: username

  # Sessions
  getSessionByPlayer: (username) ->
    @request 'session', player: username

  # Guilds
  getGuildByID: (id) ->
    @request 'guild', id: id

  getGuildByName: (name) ->
    @request('findGuild', byName: name).then (result) =>
      @getByID result.guild

  getGuildByPlayer: (username) ->
    @request('findGuild', byPlayer: username).then (result) =>
      @getByID result.guild
