gulp    = require 'gulp'
changed = require 'gulp-changed'
replace = require 'gulp-replace'

$ =
  src:  './src/html/*.html'
  dist: './public/'

gulp.task 'html', ->
  gulp.src $.src
  .pipe changed $.dist
  .pipe replace '../css/', 'css/'
  .pipe replace "../.#{$.dist}", ''
  .pipe gulp.dest $.dist
