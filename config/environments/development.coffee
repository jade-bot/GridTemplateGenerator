express = require 'express'

module.exports = (compound) ->
  app = compound.app
  app.configure 'development', ->
    app.use express.static app.root + '/assets/tmp', maxAge: 86400000
    app.use express.errorHandler dumpExceptions: true, showStack: true