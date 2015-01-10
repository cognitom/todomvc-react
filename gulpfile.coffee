gulp        = require 'gulp'
runSequence = require 'run-sequence'
requireDir  = require 'require-dir'
dir         = requireDir './task'
del         = require 'del'
browserSync = require 'browser-sync'
reload      = browserSync.reload

$ =
  src:  './src/'
  dist: './public/'

gulp.task 'default', (cb) ->
  runSequence 'clean', 'build', cb

gulp.task 'clean', (cb) -> del [$.dist], -> cb()

gulp.task 'build', (cb) ->
  runSequence [
    'html'
    'browserify'
    'css'
  ], cb

gulp.task 'watch', ->
  browserSync.init
    notify: false
    server: baseDir: $.dist
  o = debounceDelay: 3000
  gulp.watch ["#{$.src}css/**/*"], o, ['css']
  gulp.watch ["#{$.src}coffee/**/*"], o, ['browserify']
  gulp.watch ["#{$.src}html/**/*"], o, ['html']
  gulp.watch [
    "#{$.dist}*.html"
    "#{$.dist}js/**/*.js"
    "#{$.dist}css/**/*.css"
  ], o, reload
