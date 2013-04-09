module.exports = (compound) ->

  express = require 'express'
  app = compound.app

  app.configure ->

    # Allow loading lib/ directory.
    app.use '/lib', express.static app.root + '/lib'

    app.use express.bodyParser()
    app.use express.cookieParser 'secret'
    app.use express.session secret: 'secret'
    app.use express.methodOverride()
    app.use app.router