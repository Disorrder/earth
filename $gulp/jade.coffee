cfg = require './config'

_ = require 'lodash'
gulp = require 'gulp'
jade = require 'gulp-jade'
build = require './lib/build'

getDefault = ->
    defaultLocals =
        styles: build.getStyles()
        scripts: build.getScripts()
        version: cfg.version

compile = (locals = {}) ->
    locals = _.extend getDefault(), locals
    console.log locals

    getSources '**/*.jade'
        .pipe jade
            pretty: true
            locals: locals
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
