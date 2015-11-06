# References:
# https://github.com/wearefractal/product-boilerplate/blob/master/gulpfile.coffee
# https://webpack.github.io/docs/usage-with-gulp.html

rimraf = require 'rimraf'
webpack = require 'webpack'
wpConfig = require '../webpack.config'

module.exports = (gulp, app) ->
  {log, rel, getType} = app.util

  # create a task that will re-run when its source changes
  autotask = (name, source, task) ->
    gulp.task name, ->
      task gulp.src(rel source)
    gulp.watch source, gulp.parallel(name)

  displayError = (err) ->
    delete err.stream
    log.red err
    #log.red err.stack

  gulp.task 'clean', (next) ->
    rimraf rel('public'), next

  autotask 'html', 'client/*.html', (src) ->
    src.pipe(gulp.dest rel 'public')

  autotask 'js', 'client/js/**.js', (src) ->
    src.pipe(gulp.dest rel 'public/js')

  autotask 'media', 'client/media/**', (src) ->
    src.pipe(gulp.dest rel 'public/media')

  gulp.task 'webpack', (done) ->
    webpack wpConfig, done

  gulp.task 'build', gulp.parallel 'html', 'js', 'media', 'webpack'
