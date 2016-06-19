cfg         = require '../gulpconfig.json' # think about detect work directory
_           = require 'lodash'
# path        = require 'path'

defaultCfg = {
    "path": {
        "bower": "./",
        "app": "./app/",
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
    "usemin": true, # not implemented
    "hashLength": 6, # may be rename
    "webpack": false,
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
    "bowerOverrides": {},
    "version": "0.0.0"
}

module.exports = cfg = _.extend {}, defaultCfg, cfg
