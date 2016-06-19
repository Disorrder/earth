cfg = require '../config'
path = require 'path'
gulp = require 'gulp'
ignore = require 'gulp-ignore'

global.getSources = (glob) ->
    glob = path.join cfg.path.app, glob
    gulp.src glob, {base: cfg.path.app}
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*" # excludes files
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*/**/*" # and folders
        .pipe ignore.exclude cfg.ignore

global.errorHndl = (e) ->
    E = new util.PluginError 'compile', e, {showStack: true}
    # E = new Error e
    # util.log "\n--- [#{type} error] ---\n".red, E.toString(), "\n------------".red
