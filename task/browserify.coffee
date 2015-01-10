gulp       = require 'gulp'
browserify = require 'browserify'
coffeeify  = require 'coffee-reactify'
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
streamify  = require 'gulp-streamify'
uglify     = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
path       = require 'path'

$ =
  src:  './src/coffee/app.coffee'
  dist: './public/js/'

gulp.task 'browserify', ->
  browserify
    entries: [$.src]
    extensions: ['.coffee', '.cjsx']
  .transform coffeeify
  .bundle()
  .pipe source "#{path.basename $.src, '.coffee'}.js"
  .pipe buffer()
  .pipe sourcemaps.init loadMaps: true
  #.pipe streamify uglify mangle: false# without mangling for AngularJS
  .pipe sourcemaps.write './'
  .pipe gulp.dest $.dist
