cfg = require './$gulp/config'

require './$gulp/lib/global'
_ = require 'lodash'
gulp = require 'gulp'
cache = require 'gulp-memory-cache'
bowerCompiler = require './$gulp/bower'
jadeCompiler = require './$gulp/jade'
# todo: add scripts and styles, think about own cache with getByGlob OR any like gulp.src cache.get().getFileNames
gulp.task 'bower', bowerCompiler
# gulp.task 'scripts', series ['bower']
gulp.task 'jade', jadeCompiler

gulp.task 'test', (cb) =>
    console.log _.values cache.get('tmpl').cache
    console.log '\n----------------\n'
    console.log _.values cache.get('bower').cache
    cb()

gulp.task 'default', gulp.series ['bower', 'jade', 'test']
