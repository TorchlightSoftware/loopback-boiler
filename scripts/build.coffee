_ = require 'lodash'
{inspect} = require 'util'
Walker = require 'walker'

{join, resolve, extname, relative, basename} = require "path"
fs = require 'fs-extra'
rimraf = require 'rimraf'

browserify = require "browserify"
watchify = require "watchify"
coffeeify = require "coffeeify"

boot = require "loopback-boot"
source = require 'vinyl-source-stream'

module.exports = (gulp, app) ->
  {log, rel, getType} = app.util

  displayError = (err) ->
    delete err.stream
    log.red err
    #log.red err.stack

  #oldEmit = gulp.emit
  #gulp.emit = (args...) ->
    #log.gray 'Emitting:', args...
    #oldEmit.call gulp, args...

  gulp.task 'build', ['static-files', 'browserify'], ->

  gulp.task 'clean', (next) ->
    rimraf rel('public'), next

  gulp.task 'mkpublic', ['clean'], (next) ->
    fs.mkdir rel('public'), next

# TODO: concat this to index.html in development mode
#<script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1"></' + 'script>')</script>
  gulp.task 'html', ->
    gulp.src(rel('client/*.html'))
      .pipe(gulp.dest(rel 'public'))

  gulp.task 'css', ->
    gulp.src(rel('client/**/*.css'))
      .pipe(gulp.dest(rel 'public'))

  gulp.task 'fonts', ->
    gulp.src(rel('node_modules/bootstrap-sass/assets/fonts/bootstrap/*'))
      .pipe(gulp.dest(rel 'public/fonts/bootstrap'))

  gulp.task 'sass', ->
    sass = require 'gulp-ruby-sass'
    gulp.src(rel('client/style/*.sass'))
      .pipe(sass {
        loadPath: [
          rel('client/styles')
          rel('node_modules/bootstrap-sass/assets/stylesheets')
          rel('bower_components/susy/sass')
        ]
      })
      .on('error', displayError)
      .pipe(gulp.dest(rel 'public/style'))

  gulp.task 'js', ->
    gulp.src(rel('client/js/**.js'))
      .pipe(gulp.dest(rel 'public/js'))

  gulp.task 'media', ->
    gulp.src(rel('client/media/**'))
      .pipe(gulp.dest(rel 'public/media'))

  gulp.task 'static-files', ['mkpublic'], ->
    gulp.run ['html', 'css', 'media', 'js', 'sass', 'fonts']
    gulp.watch rel('client/*.html'), ['html']
    gulp.watch rel('client/**/*.css'), ['css']
    gulp.watch rel('client/js/**.js'), ['js']
    gulp.watch rel('client/media/**'), ['media']
    gulp.watch rel('client/style/*.sass'), ['sass']
    gulp.watch rel('node_modules/bootstrap-sass/assets/fonts/bootstrap/*'), ['fonts']
    return null

  gulp.task 'browserify', ['mkpublic'], ->

    b = browserify
      basedir: rel('client')
      extensions: ['.coffee']
      debug: true
      cache: {}
      packageCache: {}

    b = watchify(b)

    b.require "./lbclient", {expose: "lbclient"}

    # walk the views directory and require all views
    viewPath = rel 'client/views'
    loadView = (view, stat) ->
      return unless extname(view) is '.coffee'
      short = relative viewPath + '/..', view
      expose = short.slice(0, -7) # remove .coffee
      b.require view, {expose}
      #log.yellow {view, expose}

    Walker(viewPath)
      .on('file', loadView)
      .on 'end', ->

        # continue with build
        boot.compileToBrowserify {
          appRootDir: rel('client')
          #env: app.env
        }, b

        createBundle = ->
          log.gray 'creating bundle...'

          pipeline = b.bundle()
            .on('error', (err) ->
              displayError(err)
              @end()
            )
            .pipe(source('lbclient.js'))
            .pipe(gulp.dest(rel 'public/js/'))

          pipeline.once 'end', -> log.gray 'bundle complete!'

          return pipeline

        b.on 'update', createBundle

        return createBundle()
