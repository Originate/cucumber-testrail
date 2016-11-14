express = require 'express'

module.exports = ->
  @Before ->
    @server = undefined
    @app = express()
    @app.use (req, res, next) ->
      next()
    api_router = express.Router()
    api_router.get '/get_cases/:params', (req, res) ->
      res.json [ {id: 1}, {id: 2}]
    api_router.post '/add_plan_entry/:params', (req, res) ->
      res.json runs: [id: 5]
    api_router.post '/add_results_for_cases/:params', (req, res) ->
      res.json []
    @app.use '/api/v2', api_router


  @After ->
    @server.close()
