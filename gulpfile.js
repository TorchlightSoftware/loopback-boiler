require('coffee-script/register');

var gulp = require('gulp')
  , app = require('./server/server')
  , fs = require('fs')
  , scripts = fs.readdirSync('./scripts')
  , path = require('path');

app.util.log.yellow('Gulp - ' + process.env.NODE_ENV);

// this doesn't work at all
gulp.on('err', function(e) {
  app.util.log.red(e.err.stack);
});

scripts.forEach(function(script){
  if (path.extname(script) === '.coffee') {

    // require each script and pass it gulp and app params
    require('./scripts/'+script)(gulp, app);
  }
});
