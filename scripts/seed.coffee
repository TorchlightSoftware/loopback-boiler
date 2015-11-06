_ = require 'lodash'
async = require 'async'

module.exports = (gulp, app) ->
  {Factory, util, dataSources: {mssql}} = app
  {objMapAsync, log, getType} = util

  initial_data = util.require 'common/fixtures/initial_data'

  # drop and recreate all tables
  gulp.task 'migrate', (done) ->
    mssql.automigrate(done)

  gulp.task 'import', (done) ->
    importCollection = (coll, next, model_name) ->
      createRecord = (data, nextRecord) ->
        #log.yellow 'creating:', {model_name, data}
        Factory.create(model_name, data, nextRecord)

      async.map coll, createRecord, next

    objMapAsync initial_data, importCollection, (err, results) ->
      log.white(results) unless err?
      done(err)
      process.exit()

  gulp.task 'seed', gulp.series 'migrate', 'import'
