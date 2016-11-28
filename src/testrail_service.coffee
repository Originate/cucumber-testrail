co = require 'co'

TestRailApi = require './testrail_api'

class TestRailService

  constructor: (@symbol, @config, @opts, @testrail_metrics) ->
    @suite_config = @config.suites.filter ({project_symbol}) => project_symbol is @symbol
    @needs_update = unless @testrail_metrics[@symbol].length then false else true
    @api = new TestRailApi @config, @opts, @suite_config[0], @testrail_metrics[@symbol]


  sendTestResults: co.wrap ->
    unless @suite_config.length
      throw new Error "symbol #{@symbol} found in cucumber results is not represented in cucumber_testrail.yml"
    return console.log "No test results to report for suite with symbol #{@symbol}. Skipping this update." unless @needs_update
    case_ids = yield @api.fetchCases()
    testrun_id = yield @api.generateTestRun case_ids
    yield @api.addResults testrun_id


module.exports = TestRailService
