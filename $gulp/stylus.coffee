cfg = require './config'

gulp = require 'gulp'
stylus = require 'gulp-stylus'
nib = require 'nib'

compile = ->
    getSources '**/*.styl'
        .pipe stylus {use: nib(), import: ['nib']} #? use and import?
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
