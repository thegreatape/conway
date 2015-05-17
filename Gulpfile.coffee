# assets
# ├── Gulpfile.coffee
# ├── Gulpfile.js
# ├── package.json
# ├── node_modules/  (auto generated)
# ├── cs/
# └── sass/
#
# Setup:
# $ cd my_app/assets
# $ npm install -g gulp
# $ npm install
# $ gulp watch

gulp       = require 'gulp'
sass       = require 'gulp-ruby-sass'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
gulpif     = require 'gulp-if'

gulp.task 'watch', ->
  gulp.watch 'web/static/sass/**/*.sass', ['css']
  gulp.watch 'web/static/cs/**/*.coffee', ['coffee']

gulp.task 'css', ->
  gulp.src 'web/static/sass/app.sass'
    .pipe sass()
    .pipe gulp.dest 'priv/static/css'

gulp.task 'coffee', ->
  gulp.src ['web/static/vendor/**/*.js', 'web/static/vendor/**/*.coffee', 'web/static/cs/**/*.coffee']
    .pipe gulpif(/[.]coffee$/, coffee())
    .pipe concat('app.js')
    .pipe gulp.dest 'priv/static/js'

gulp.task 'default', ['css', 'coffee']
