cfg = require './config'

_ = require 'lodash'
fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
filter = require 'gulp-filter'
concat = require 'gulp-concat'
wrap = require 'gulp-wrap'
hash = require 'gulp-hash'
git = require 'gulp-git'

fetchMain = (cfg) ->
    `var ignore` # conflict with lib name
    bowerFile = fs.readJsonSync path.join cfg.path, 'bower.json'
    deps = _.assign bowerFile.dependencies, bowerFile.devDependencies
    main = []
    ignore = []
    for lib, v of deps
        libBower = fs.readJsonSync path.join cfg.path, 'bower_components', lib, '.bower.json'
        libBowerCfg = cfg.overrides[lib]
        _main = if libBower.main then [].concat libBower.main else [] #ensure array

        if libBowerCfg
            if libBowerCfg.main
                _main = [].concat libBowerCfg.main #ensure array
            else
                _main = _main.concat libBowerCfg.add if libBowerCfg.add
                _ignore = libBowerCfg.ignore
                if _ignore then ignore.concat _ignore.map (file) -> path.join cfg.path, 'bower_components', lib, file

        main = main.concat _main.map (file) -> path.join cfg.path, 'bower_components', lib, file

    main = main.filter (file) ->
        if !fs.existsSync(file) then util.log "[Bower] File is not exist!".red, file
        if file in ignore then return false
        true

compile = ->
    files = fetchMain {path: cfg.path.bower, overrides: cfg.bowerOverrides}
    jsFilter = filter "**/*.js", {restore: true}
    gulp.src files, {base: cfg.path.bower}
        .pipe jsFilter
        .pipe wrap "/* --- <%= file.relative %> --- */\n<%= contents %>"
        .pipe concat path.join 'bower_components', 'libs.js'
        .pipe hash {hashLength: 6}
        .pipe jsFilter.restore
        .pipe gulp.dest cfg.path.build

module.exports = compile
