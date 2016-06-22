cfg = require './config'

path = require 'path'
gulp = require 'gulp'

glob = 'assets/**/*'
compile = ->
    getSources glob
        .pipe gulp.dest cfg.path.build

module.exports = compile
module.exports.watch = path.join cfg.path.app, glob
