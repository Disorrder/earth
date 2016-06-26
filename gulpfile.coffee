cfg = require './$gulp/config'

require './$gulp/lib/global'
_       = require 'lodash'
fs      = require 'fs-extra'
path    = require 'path'
gulp    = require 'gulp'
bower   = require './$gulp/bower'
ts      = require './$gulp/typescript'
stylus  = require './$gulp/stylus'
jade    = require './$gulp/jade'
assets  = require './$gulp/assets'

gulp.task 'clean', (cb) =>
    fs.ensureDirSync cfg.path.build
    fs.readdirSync(cfg.path.build).map (file) ->
        fs.removeSync path.join cfg.path.build, file
    cb()

gulp.task 'bower', bower
gulp.task 'typescript', ts
gulp.task 'stylus', stylus
gulp.task 'jade', jade
gulp.task 'assets', assets

gulp.task 'watch', ->
    gulp.watch bower.watch,  gulp.series 'bower'
    gulp.watch ts.watch,     gulp.series 'typescript'
    gulp.watch stylus.watch, gulp.series 'stylus'
    gulp.watch jade.watch,   gulp.series 'jade'
    gulp.watch assets.watch, gulp.series 'assets'

gulp.task 'server', ->
    browserSync = require './$gulp/browser-sync'
    browserSync.watch path.join cfg.path.build, '**/*.*'
        .on 'change', browserSync.reload

gulp.task 'serveprod', ->
    connect = require 'gulp-connect'
    connect.server
        root: cfg.path.build
        port: process.env.PORT || cfg.webserver.port
        livereload: false

gulp.task 'build', gulp.parallel 'bower', 'typescript', 'stylus', 'jade', 'assets'
gulp.task 'default', gulp.series 'clean', 'build', gulp.parallel('server', 'watch')
gulp.task 'heroku', gulp.series 'build', 'serveprod'
