cfg = require './config'

gulp = require 'gulp'

compile = ->
    getSources 'assets/**/*.*'
        .pipe gulp.dest cfg.path.build

module.exports = compile
