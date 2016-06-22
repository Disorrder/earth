cfg = require './$gulp/config'

require './$gulp/lib/global'
_ = require 'lodash'
fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
bower = require './$gulp/bower'
ts = require './$gulp/typescript'
stylus = require './$gulp/stylus'
jade = require './$gulp/jade'
browserSync = require './$gulp/browser-sync'

gulp.task 'clean', (cb) =>
    fs.ensureDirSync cfg.path.build
    fs.readdirSync(cfg.path.build).map (file) ->
        fs.removeSync path.join cfg.path.build, file
    cb()

gulp.task 'bower', bower
gulp.task 'typescript', ts
gulp.task 'stylus', stylus
gulp.task 'jade', jade

gulp.task 'server', (cb) ->
    cb()



gulp.task 'build', gulp.parallel 'bower', 'typescript', 'stylus', 'jade'
gulp.task 'default', gulp.series 'clean', 'build', 'server'
