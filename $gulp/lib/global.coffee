cfg = require '../config'
path = require 'path'
gulp = require 'gulp'
util = require 'gulp-util'
ignore = require 'gulp-ignore'
notify = require 'gulp-notify'

global.getSources = (glob) ->
    glob = path.join cfg.path.app, glob
    gulp.src glob, {base: cfg.path.app}
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*" # excludes files
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*/**/*" # and folders
        .pipe ignore.exclude cfg.ignore

global.errorHndl = (e) ->
    # E = new util.PluginError 'compile', e, {showStack: true}
    notify.onError({
        onLast: true
    })(e)
