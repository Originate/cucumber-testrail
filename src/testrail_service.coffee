co = require 'co'

TestRailApi = require './testrail_api'

class TestRailService

  constructor: (@config, @suite_config, @opts, @testrail_metrics) ->
    @api = new TestRailApi @config, @opts, @suite_config, (@testrail_metrics[@suite_config.project_symbol] or [])


  sendTestResults: co.wrap ->
    case_ids = yield @api.fetchCases()
    testrun_id = yield @api.generateTestRun case_ids
    yield @api.addResults testrun_id


module.exports = TestRailService
