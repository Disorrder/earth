cfg = require './config'

_ = require 'lodash'
gulp = require 'gulp'
jade = require 'gulp-jade'

compile = (locals = {}) ->
    getSources '**/*.jade'
        .pipe jade
            pretty: true
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
