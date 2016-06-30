cfg         = require '../gulpconfig.json' # think about detect work directory
_           = require 'lodash'

defaultCfg = {
    "path": {
        "bower": "./",
        "app": "./src/",
        "build": "./.build/"
    },
    "filters": { # legacy
        "scripts": "**/*.js",
        "styles": "**/*.styl",
        "templates": "**/*.jade",
        # "index": "index.jade",
        "assets": "assets/**/*",
        "images": "**/*.{png,svg,gif,jpg,jpeg,ico}",
        "fonts": "**/*.{eot,svg,ttf,woff,woff2}"
    },
    "excludePrefix": "__",
    "notify": true,
    "usemin": true, # not implemented
    "hashLength": 6, # may be rename
    "webpack": false, # not implemented
    "webserver": {
        "https": false,
        "hostname": "localhost",
        "host": "0.0.0.0",
        "port": 1000,
        "open": true,
        "livereload": true
    },
    "ignore": [
        "**/mixins/**/*.{jade,styl}"
    ],
    "bowerOverrides": {
        "lodash": {
            "main": "lodash.js"
        },
        "q": {
            "main": "q.js"
        }
    },
    "version": "0.0.0"
}

config = _.extend({}, defaultCfg, cfg) if !config

module.exports = config
