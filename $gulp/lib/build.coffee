cfg = require '../config'
glob = require 'glob'

class Build # another type of cache. PS: mb rename to Cache?
    @getByGlob: (mask) =>
        glob.sync mask, {cwd: cfg.path.build}

    @getScripts: =>
        @getByGlob '**/*.js'

    @getStyles: =>
        @getByGlob '**/*.css'

    @getTemplates: =>
        @getByGlob '**/*.html'

module.exports = Build
