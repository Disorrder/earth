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
assets = require './$gulp/assets'

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
    # TODO: hide glob into compileFn as an option
    gulp.watch path.join(cfg.path.bower, 'bower.json'), gulp.series 'bower'
    gulp.watch path.join(cfg.path.app, '**/*.ts'), gulp.series 'typescript'
    gulp.watch path.join(cfg.path.app, '**/*.styl'), gulp.series 'stylus'
    gulp.watch path.join(cfg.path.app, '**/*.jade'), gulp.series 'jade'
    gulp.watch path.join(cfg.path.app, 'assets/**/*.*'), gulp.series 'assets'

gulp.task 'server', ->
    browserSync = require './$gulp/browser-sync'
    browserSync.watch path.join cfg.path.build, '**/*.*'
        .on 'change', browserSync.reload

gulp.task 'build', gulp.parallel 'bower', 'typescript', 'stylus', 'jade', 'assets'
gulp.task 'default', gulp.series 'clean', 'build', gulp.parallel('server', 'watch')
