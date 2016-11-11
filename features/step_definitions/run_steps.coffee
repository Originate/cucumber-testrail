expect = require 'expect.js'
express = require 'express'

module.exports = ->
  @Given /^a TestRail API at localhost:(\d+)$/, (port) ->
    port = parseInt port
    app = express()

    app.use (req, res, next) ->
      next()

    api_router = express.Router()

    api_router.get '/get_cases/:params', (req, res) ->
      res.json [ {id: 1}, {id: 2}]
    api_router.post '/add_plan_entry/:params', (req, res) ->
      res.json runs: [id: 5]
    api_router.post '/add_results_for_cases/:params', (req, res) ->
      res.json []

    app.use '/api/v2', api_router

    app.listen port


  @When /^I run the script "cucumber-testrail ([^"]*)"$/, (script) ->
    out = yield @execute_script "bin/cucumber-testrail #{script}"
    @resp = out


  @Then /^my output contains the following text:$/, (output) ->
    expect(@resp).to.contain(output.trim())

  # TODO: remove once done with generating sample json
  #@When /^I have ([^"]*)$/, (stuff) ->
  #  return true

  #@When /^I can ([^"]*)$/, (stuff) ->
  #  return true
