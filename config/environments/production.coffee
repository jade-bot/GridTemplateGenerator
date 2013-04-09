express = require 'express'

module.exports = (compound) ->
  app = compound.app
  app.configure 'production', ->
    app.use express.static app.root + '/assets/dist', maxAge: 86400000
    app.use express.errorHandler()