
_           = require 'lodash'
glob        = require 'glob'
fs          = require 'fs-extra'
argv        = require('optimist').argv
colors      = require 'colors'
chokidar    = require 'chokidar'
gulp        = require 'gulp'
concat      = require 'gulp-concat'
filter      = require 'gulp-filter'
ignore      = require 'gulp-ignore'
tasks       = require 'gulp-tasks-mng'
util        = require 'gulp-util'
wrap        = require 'gulp-wrap'
hash        = require 'gulp-hash'
git         = require 'gulp-git'
webserver   = require 'gulp-webserver'
eventStream = require 'event-stream'
merge       = require 'merge-stream'
templateCache = require 'gulp-angular-templatecache'
# compilers
jade        = require 'gulp-jade'
stylus      = require 'gulp-stylus'
nib         = require 'nib'
babel       = require 'gulp-babel'
eslint      = require 'gulp-eslint'


# Defaults

# Libs
class Build # another type of cache. PS: mb rename to Cache?
    @getByGlob: (Glob) -> # "glob" is name of lib, so "Glob" is argument.
        console.log glob.sync Glob, {cwd: cfg.path.build}
        glob.sync Glob, {cwd: cfg.path.build}

    @getScripts: =>
        @getByGlob '**/*.js'

    @getStyles: =>
        @getByGlob '**/*.css'

    @getTemplates: =>
        @getByGlob '**/*.html'

# Tasks
getSources = (glob) ->
    glob = path.join cfg.path.app, glob
    gulp.src glob, {base: cfg.path.app}
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*" # excludes files
        .pipe ignore.exclude "**/#{cfg.excludePrefix}*/**/*" # and folders
        .pipe ignore.exclude cfg.ignore

errorHndl = (e) ->
    E = new util.PluginError 'compile', e, {showStack: true}
    # E = new Error e
    # util.log "\n--- [#{type} error] ---\n".red, E.toString(), "\n------------".red

tasks.add 'clean', ->
        fs.ensureDirSync cfg.path.build
        fs.readdirSync(cfg.path.build).map (file) ->
            fs.removeSync path.join cfg.path.build, file

tasks.add 'Git.rev', (cb) -> # TODO: pref use git and run before building
    cfg.version = {}

    getTime = (ts) ->
        d = new Date(ts)
        date = d.toLocaleDateString()
        time = d.toTimeString().split(' ')[0]
        "#{date} #{time}"

    git.revParse {args:'--short HEAD'}, (err, hash) ->
        if err # not a git repo
            cfg.version.ts = Date.now()
            cfg.version.time = getTime cfg.version.ts
            # hashFiles {files: [cfg.path.app]}, (err, hash) ->
            #    cfg.version.rev = hash.substr(-cfg.hashLength)
            cb()

        else
            cfg.version.rev = hash
            git.exec {args: 'log -1 --pretty=format:%ct'}, (err, stdout) ->
                cfg.version.ts = stdout
                cfg.version.time = getTime cfg.version.ts
                cb()

tasks.add 'Bower', ->
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

    files = fetchMain {path: cfg.path.bower, overrides: cfg.bowerOverrides}
    gulp.src files, {base: cfg.path.bower}
        .pipe gulp.dest cfg.path.build

tasks.add 'Babel', ->
    getSources '**/*{.js,.es6}'
        .pipe babel()
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

tasks.add 'Stylus', ->
    getSources '**/*.styl'
        .pipe stylus {use: nib(), import: ['nib']} #? use and import?
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

tasks.add 'Jade', ->
    getSources '**/*.jade'
        .pipe jade
            pretty: true,
            locals:
                buildmode: cfg.buildmode
                files: Build
                version: cfg.version
        .on 'error', errorHndl
        .pipe gulp.dest cfg.path.build

# command lines
tasks.add 'default', ['clean', 'compile']
tasks.add 'compile', ['Git.rev', 'Bower', 'Babel', 'Stylus', 'Jade']
# -- sync exec --
compileDeps = tasks.get('compile').dependencies
_.each compileDeps, (dep, k) ->
    nextDep = compileDeps[k+1]
    if !nextDep then return
    tasks.get dep
        .includeTo nextDep
# ----
