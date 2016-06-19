cfg = require './config'

gulp = require 'gulp'
jade = require 'gulp-jade'
build = require './lib/build'

compile = (params) ->
    console.log build.getScripts()
    getSources '**/*.jade'
        .pipe jade
            pretty: true
            locals:
                scripts: build.getScripts()
                styles: build.getStyles()
                version: cfg.version
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

module.exports = compile
