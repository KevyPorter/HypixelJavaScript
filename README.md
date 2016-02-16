hypixel.js
=========

JavaScript wrapper for the Hypixel API

[![NPM](https://nodei.co/npm/hypixel.js.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/hypixel.js/)

Usage
---
To install it use
``` bash
$ npm install hypixel.js
```

To use it in coffeescript
``` coffeescript
hypixel = require 'hypixel.js'
API_KEY = 'YOUR_API_KEY'

hypixel(API_KEY).then (api) ->
  # This makes sure the api_key is valid
  # The api uses promises instead of callbacks
  api.users.getByName('TheKomputerKing')

.then (user) ->
  console.log user
  # Do things with user...
.catch (err) ->
  console.log err.stack
  # The request failed.. for some reason
```


Hypixel object
---
You get an hypixel object by calling the function returned by this module.
You need to add a .then(...) with a function, because the API checks for a valid API key first.

``` coffeescript
hypixel = require 'hypixel.js'
API_KEY = 'YOUR_API_KEY'
hypixel(API_KEY).then (api) ->
  # Use api...
```

## Available methods
They are all pretty much the same:
Get info about a 'thing' by UUID or name.
They all use promises, so you need to chain them, eg:

``` coffeescript
api.users.getByName('notch').then (user) ->
  # Everything went well, here you can use `user`
.catch (err) ->
  # Something went wrong; err contains the error.
```

* .users.getByUUID(UUID)
* .users.getByName(name)
* .sessions.getByName(UUID)
* .friends.getByName(name)
* .guilds.getByMember(memberName)
* .guilds.getByName(guildName)
* .guilds.getByID(id)
