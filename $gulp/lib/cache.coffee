_ = require 'lodash'

groups = {}

class Cache {
    cache = []

    getFiles: =>
        cache

    addFiles: (files) =>
        files.forEach (file) => @addFile file

    addFile: (file) =>
        short = {relative: file.relative}
        cached = _.find cache, short
        if not cached then cache.push file
        i = cache.indexOf cached
        cache[i] = file
}
