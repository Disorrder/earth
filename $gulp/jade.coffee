cfg = require './config'

_ = require 'lodash'
path = require 'path'
gulp = require 'gulp'
jade = require 'gulp-jade'

glob = '**/*.jade'
compile = (locals = {}) ->
    getSources glob
        .pipe jade
            pretty: true
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
module.exports.watch = path.join cfg.path.app, glob
