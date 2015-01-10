gulp         = require 'gulp'
cssimport    = require 'gulp-cssimport'
autoprefixer = require 'gulp-autoprefixer'
minifyCss    = require 'gulp-minify-css'
csslint      = require 'gulp-csslint'
notify       = require 'gulp-notify'
replace      = require 'gulp-replace'

$ =
  src:    './src/css/style.css'
  dist:   './public/css/'
  target: './src/css/**/*.css'
  # these're not in CSS spec
  exceptions: [
    'min-device-pixel-ratio'
    'appearance'
    'font-smoothing'
  ]
  cssrules:
    'adjoining-classes': false
    'box-model': false
    'compatible-vendor-prefixes': false
    'empty-rules': false
    'fallback-colors': false
    'ids': false
    'import': false
    'qualified-headings': false
    'unique-headings': false
    'vendor-prefix': false

gulp.task 'css', ->
  re = new RegExp "\-webkit\-(?!(#{$.exceptions.join '|'}))"

  gulp.src $.src
  .pipe cssimport()
  .pipe replace re, ''
  .pipe autoprefixer 'last 2 versions'
  .pipe minifyCss keepSpecialComments: 0
  .pipe gulp.dest $.dist

gulp.task 'css-lint', ->
  gulp.src $.target
  .pipe csslint $.cssrules
  .pipe csslint.reporter()
  .pipe notify (file) -> "#{file.relative} (#{file.csslint.results.length} errors)" unless file.csslint.success
