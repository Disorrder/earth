cfg = require './config'

gulp = require 'gulp'
typescript = require 'gulp-typescript'

compile = ->
    getSources '**/*.ts'
        .pipe typescript
            target: 'es5'
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
