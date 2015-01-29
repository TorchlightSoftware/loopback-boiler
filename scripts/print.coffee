_ = require 'lodash'

module.exports = (gulp, app) ->
  {getModelSummary, log} = app.util

  gulp.task 'print-models', ->
    log.yellow 'Printing models:'

    models = {}
    for n, p of app.models
      models[n] = getModelSummary(p)

    log.gray models
