module.exports = (gulp, app) ->
  {log, rel, getType} = app.util

  gulp.task 'livereload', ->

    log.yellow 'livereload watching:', rel('public')
    require('livereload').createServer().watch rel('public')
