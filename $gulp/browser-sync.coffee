cfg = require './config'

browserSync = require('browser-sync').create()

browserSync.init
    startPath: '/'
    server: cfg.path.build
    browser: 'default'
    open: 'external'
    host: cfg.webserver.host
    port: cfg.webserver.port

module.exports = browserSync
