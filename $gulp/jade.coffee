cfg = require './config'

gulp = require 'gulp'
jade = require 'gulp-jade'
cache = require 'gulp-memory-cache'
cacheFilter = require './lib/cacheFilter'

compile = (params) ->
    getSources '**/*.jade'
        .pipe jade
            pretty: true
            locals:
                # buildmode: cfg.buildmode
                scripts: cacheFilter.getScripts()
                styles: cache.get('styles')?.getFilePaths()
                version: cfg.version
        .on 'error', errorHndl
        .pipe cache 'tmpl'
        .pipe gulp.dest cfg.path.build

module.exports = compile
