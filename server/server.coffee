process.env.NODE_ENV or= 'development'

_ = require 'lodash'
loopback = require "loopback"
boot = require "loopback-boot"
serveStatic = require "serve-static"
app = module.exports = loopback()
app.util = _.merge require("../common/util"), require("./util")

# Set up the /favicon.ico
app.use loopback.favicon()

# request pre-processing middleware
app.use loopback.compress()

config = require './config'
# boot scripts mount components like REST API
boot app, config
{rel, log} = app.util

# -- Mount static files here--
# All static middleware should be registered at the end, as all requests
# passing the static middleware are hitting the file system
path = require("path")
app.use serveStatic(path.resolve(__dirname, "../public"))

# Requests that get this far won't be handled
# by any middleware. Convert them into a 404 error
# that will be handled later down the chain.
app.use loopback.urlNotFound()

# The ultimate error handler.
app.use loopback.errorHandler()

# Facilities to detect whether we have connected to the network
app.started = false
app.on 'started', ->
  app.started = true

app.wait = (done) ->
  if app.started
    return done()

  else
    app.once 'started', done

app.start = (done) ->
  done or= ->

  env = process.env.NODE_ENV

  # start the web server
  app.listen ->
    app.emit "started"
    console.log "#{env} server listening at: %s", app.get("url")
    done()
