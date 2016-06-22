cfg = require './config'

path = require 'path'
gulp = require 'gulp'
typescript = require 'gulp-typescript'

glob = '**/*.ts'
compile = ->
    getSources glob
        .pipe typescript
            target: 'es5'
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
module.exports.watch = path.join cfg.path.app, glob
