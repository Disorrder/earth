cfg = require './$gulp/config'

require './$gulp/lib/global'
_ = require 'lodash'
fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
cache = require 'gulp-memory-cache'
bowerCompiler = require './$gulp/bower'
typescriptCompiler = require './$gulp/typescript'
jadeCompiler = require './$gulp/jade'

gulp.task 'clean', (cb) =>
    fs.ensureDirSync cfg.path.build
    fs.readdirSync(cfg.path.build).map (file) ->
        fs.removeSync path.join cfg.path.build, file
    cb()
# todo: add scripts and styles, think about own cache with getByGlob OR any like gulp.src cache.get().getFileNames
gulp.task 'bower', bowerCompiler
gulp.task 'typescript', typescriptCompiler
gulp.task 'jade', jadeCompiler

gulp.task 'test', (cb) =>
    # console.log _.values cache.get('tmpl').cache
    # console.log '\n----------------\n'
    # console.log _.values cache.get('bower').cache
    cb()

gulp.task 'build', gulp.series ['bower', 'typescript', 'jade', 'test']
gulp.task 'default', gulp.series ['clean', 'build']
