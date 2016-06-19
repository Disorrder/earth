_ = require 'lodash'
minimatch = require 'minimatch'
glob = require 'glob'
cache = require 'gulp-memory-cache'

class Filter
    @getAll: =>
        files = []
        _.each cache.get(), (v, k) =>
            files = files.concat _.values v.cache
        files

    @getByGlob: (pattern) =>
        @getAll().filter (file) =>
            minimatch file.relative, pattern, {matchBase: true}

    @getScripts: =>
        @getByGlob '*.js'

    @getStyles: =>
        @getByGlob '*.css'

    @getTemplates: =>
        @getByGlob '*.html'

module.exports = Filter
