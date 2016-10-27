fs = require 'mz/fs'

TESTRAIL_STATUSES = FAILED: 5, PASSED: 1

class CucumberResultReader

  constructor: ({symbols}, @file) ->
    @symbols = symbols or {}


  parse: () ->
    file = fs.readFileSync @file
    results = file.toString()
    testRailMetrics = {}
    @symbols.forEach (item) -> testRailMetrics[item] = []
    JSON.parse(results).forEach (result) =>
      result.elements?.forEach ({tags=[], type, steps}) =>
        testrail_ids = @_testRailTags tags
        return unless testrail_ids.length and type is 'scenario'
        testrail_ids.forEach ({name}) =>
          {symbol, case_id} = @_parseName name
          {comment, status_id} = @_examineScenario steps
          testRailMetrics[symbol].push {case_id, status_id, comment}
    testRailMetrics


  _examineScenario: (steps) ->
    status_id = TESTRAIL_STATUSES.PASSED
    totalPassed = 0
    steps.forEach (step) ->
      switch step.result.status
        when 'passed' then totalPassed += 1
        when 'failed' then return status_id: TESTRAIL_STATUSES.FAILED, comment: step.result.error_message
        else throw new Error "unknown step result status: #{step.result.status}"
    status_id: TESTRAIL_STATUSES.PASSED, comment: 'Passed on CircleCI!'


  _parseName: (name) ->
    [_, symbol, case_id] = name.split '-'
    throw new Error "symbol #{symbol} found in cucumber results is not configured in cucumber_testrail.yml" if @symbols.indexOf(symbol) is -1
    throw new Error "case_id #{case_id} found in cucumber results has an invalid format. id should be numeric" unless parseInt case_id
    {symbol, case_id}


  _testRailTags: (tags) ->
    tags.filter ({name}) -> name.indexOf('TestRail') isnt -1

module.exports = CucumberResultReader
