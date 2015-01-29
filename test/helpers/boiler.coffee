process.env.NODE_ENV = 'test'
_ = require 'lodash'

# cache app and re-use
app = require '../../server/server'
app.start()

apiTestSetup = ->
  # require the app
  before (done) ->
    @timeout 4000

    @app = app
    @log = @app.util.log
    @app.wait(done)

  # import helper utils
  before ->
    _.merge @, @app.util, require('./util')
    @api = @getApiClient(@app)

  # TODO: if using a relational DB, you should auto-migrate here
  before (done) ->
    @app.Factory.clearAll(done)

  # clear DB
  afterEach (done) ->
    @app.Factory.clearAll(done)

e2eTestSetup = ->

  # load webdriver for e2e testing
  before ->
    @timeout 10000
    @wd = require './webdriver-setup'

    # TODO: put this in a separate file, everything else in boiler should be general
    # TODO: check for 'body' instead of 'Hello'
    @wd.getRoot = (done) =>
      @wd.get(@app.settings.url)
      @wd.waitFor.linkText('Hello').then ->
        done() # disregard promise result

  after (done) ->
    @timeout 10000
    @wd?.close().then(done)

boiler = global.boiler = (name, tests) ->
  describe name, ->
    apiTestSetup()
    tests()

e2eboiler = global.e2eboiler = (name, tests) ->
  describe name, ->
    apiTestSetup()
    e2eTestSetup()
    tests()

module.exports = {boiler, e2eboiler}
