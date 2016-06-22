cfg = require './config'

path = require 'path'
gulp = require 'gulp'
stylus = require 'gulp-stylus'
nib = require 'nib'

glob = '**/*.styl'
compile = ->
    getSources glob
        .pipe stylus {use: nib(), import: ['nib']} #? use and import?
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
module.exports.watch = path.join cfg.path.app, glob
