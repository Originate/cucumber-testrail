PARAMS = ['project_id', 'suite_id', 'section_id', 'testrun_id', 'testplan_id']
FILTERS = ['section_id', 'suite_id']
REQUESTS =
  addPlanEntry: 'add_plan_entry/{{testplan_id}}'
  getCases: 'get_cases/{{project_id}}&suite_id={{suite_id}}&section_id={{section_id}}'
  addResults: 'add_results_for_cases/{{testrun_id}}'

RequestManager = require './request_manager'

class TestRailApi

  constructor: (@config = {}, @opts = {}, @suite_config = {}, @metrics = []) ->
    @request_manager = new RequestManager @opts


  addResults: (testrun_id) ->
    url = @_generateUrl 'addResults', {testrun_id}
    yield @request_manager.send 'post', url: url, body: results: @metrics
    testrun_url = "#{@config.testrail_url}/runs/view/#{testrun_id}"
    console.log "Successfully added the following results for project symbol #{@suite_config.project_symbol} to TestRail. Visit #{testrun_url} to access."


  fetchCases: ->
    resp = yield @request_manager.send 'get', url: @_generateUrl 'getCases'
    resp.map ({id}) -> id


  generateTestRun: (case_ids) ->
    url = @_generateUrl 'addPlanEntry'
    body =
      suite_id: @suite_config.suite_id
      name: "CircleCI Automated Test Run #{@opts.runid} - #{(new Date()).toLocaleDateString()}"
      include_all: false
      case_ids: case_ids
    resp = yield @request_manager.send 'post', {url, body}
    resp.runs[resp.runs.length - 1].id


  _generateUrl: (type, opts={}) ->
    action = REQUESTS[type] or ''
    PARAMS.forEach (key) =>
      action = action.replace("{{#{key}}}", @suite_config[key]) if @suite_config[key] isnt undefined and opts[key] is undefined
      action = action.replace("&#{key}={{#{key}}}", '') unless @suite_config[key] isnt undefined and FILTERS.indexOf(key) isnt -1
      action = action.replace("{{#{key}}}", opts[key]) unless opts[key] is undefined
    "#{@config.testrail_url}/api/v2/#{action}"


module.exports = TestRailApi
