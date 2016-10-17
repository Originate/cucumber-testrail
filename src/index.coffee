_ = require 'lodash'
co = require 'co'
fs = require 'mz/fs'
minimist = require 'minimist'
request = require 'request'
yaml = require 'yamljs'

REQUESTS =
  addPlanEntry: 'add_plan_entry/{{testplan_id}}'
  getCases: 'get_cases/{{project_id}}&suite_id={{suite_id}}&section_id={{section_id}}'
  addResults: 'add_results_for_cases/{{testrun_id}}'

consoleWrite = (msg) ->
  # coffeelint: disable=no_debugger
  console.log msg
  # coffeelint: enable=no_debugger


class CucumberTestRail

  constructor: ->
    alias =
      u: 'username'
      p: 'password'
      c: 'config'
      r: 'result'
      i: 'runid'
    unknown = (opt) ->
      throw new Error "unrecognized option #{opt} passed in command line"

    @opts = minimist process.argv[2..], {alias, unknown} or {}

    # holds information from cucumber_testrail.yml
    @config = []

    # contains testrail scenarios from cucumber in testrail format
    @testRailResults = []


  run: ->
    try
      @config = yield @_readConfig()
      @testRailMetrics = yield @_readMetrics()
      Object.keys(@testRailMetrics).forEach co.wrap (symbol) =>
        return if @config.symbols.indexOf(symbol) is -1
        return if @testRailMetrics[symbol].length is 0
        # TODO: figure out why this line can't be moved to top of loop
        # when moved to top, loop moves to next iteration and makes requests with next symbol
        @suiteConfig = @config.suites.filter ({project_symbol}) -> project_symbol is symbol
        return if @suiteConfig.length is 0
        @case_ids = yield @_fetchCases()
        @testrun_id = yield @_generateTestRun()
        yield @_addResults symbol
    catch e
      return consoleWrite "Error running cucumber_testrail: #{e}"
      #TODO: do yields need dedicated try/catch? yield errors aren't catching here


  _addResults: (symbol) ->
    url = @_generateUrl 'addResults', testrun_id: @testrun_id, @config.testRailUrl
    body = results: @testRailMetrics[symbol]
    try
      resp = yield @_apiRequest 'post', {url, body}
    catch e
      return consoleWrite "Error adding test results: #{e}"

    consoleWrite 'Successfully Added Results to TestRail!'
    consoleWrite "Visit #{@config.testRailUrl}/runs/view/#{@testrun_id} to view your results"


  _apiRequest: (type, {url, body}) ->
    opts = @_generateOpts url: url, username: @opts.username, password: @opts.password, body: body
    req = request.get
    req = request.post if type is 'post'
    new Promise (resolve, reject) ->
      req opts, (err, resp) ->
        return reject new Error err if err
        response = JSON.parse resp.body
        if response.error
          return reject new Error response.error
        resolve JSON.parse resp.body


  _examineScenario: (steps) ->
    testRailStatuses =
      failed: 5
      passed: 1
    status_id = testRailStatuses.passed
    totalPassed = 0
    comments = 'Passed on Circle!'
    steps.forEach (step) ->
      totalPassed += 1 if step.result.status is 'passed'
      comments = step.result.error_message if step.result.status is 'failed'
    status_id = testRailStatuses.failed unless totalPassed is steps.length
    {status_id, comments}


  _fetchCases: ->
    url = @_generateUrl 'getCases', @suiteConfig[0], @config.testRailUrl
    try
      resp = yield @_apiRequest 'get', {url}
      return resp.map ({id}) -> id
    catch e
      return consoleWrite "Error fetching cases: #{e}"


  _generateOpts: ({url, body, username, password}) ->
    url: url
    headers:
      'Content-Type': 'application/json'
    body: JSON.stringify body
    auth: {username, password}


  _generateUrl: (type, suiteConfig={}, url) ->
    params = ['project_id', 'suite_id', 'section_id', 'testrun_id', 'testplan_id']
    filters = ['section_id', 'suite_id']

    action = REQUESTS[type] or ''
    params.forEach (key) ->
      action = action.replace("{{#{key}}}", suiteConfig[key]) if suiteConfig[key] isnt ''
      action = action.replace("&#{key}={{#{key}}}", '') unless suiteConfig[key] isnt '' and filters.indexOf(key) isnt -1
    "#{url}/api/v2/#{action}"


  _generateTestRun: ->
    url = @_generateUrl 'addPlanEntry', @suiteConfig[0], @config.testRailUrl
    body =
      suite_id: @suiteConfig[0].suite_id
      name: "CircleCI Automated Test Run #{@opts.runid} - #{(new Date()).toLocaleDateString()}"
      include_all: false
      case_ids: @case_ids
    try
      resp = yield @_apiRequest 'post', {url, body}
      @testrun_id = resp.runs[resp.runs.length - 1].id
    catch e
      #TODO: remove once resolve error catching in run method
      console.log e
      throw e


  _parseMetrics: (results, {symbols}) ->
    testRailMetrics = {}
    symbols.forEach (item) -> testRailMetrics[item] = []
    JSON.parse(results).forEach (result) =>
      return unless result.elements
      result.elements.forEach ({tags=[], type, steps}) =>
        isTestRailId = tags.filter ({name}) -> name.indexOf('TestRail') isnt -1
        return unless isTestRailId.length and type is 'scenario'
        isTestRailId.forEach ({name}) =>
          [_, symbol, case_id] = name.split '-'
          return unless symbols.indexOf(symbol) isnt -1
          {comments, status_id} = @_examineScenario steps
          testRailMetrics[symbol].push {case_id, status_id, comments}
    testRailMetrics


  _readConfig: ->
    try
      config = yaml.parse yield @_readFile @opts.config
      config.suites = config.suites.map ({suite}) -> suite
      @_validateConfig config
      config.symbols = config.suites.map ({project_symbol}) -> project_symbol
      config
    catch e
      throw e


  _readFile: (file) ->
    fs.readFile file
      .then (data) ->
        data.toString()


  _readMetrics: ->
    @_parseMetrics yield(@_readFile @opts.result), @config


  _validateConfig: (config) ->
    requiredConfigFields = ['project_id', 'project_symbol', 'testplan_id']
    throw new Error "cucumber_testrail.yml is missing suites" unless config.suites.length
    config.suites.forEach (config, index) ->
      params = Object.keys config
      missingFields = _.compact requiredConfigFields.map (field) ->
        field unless field in params
      return unless missingFields.length
      throw new Error "cucumber_testrail.yml file is missing the following required fields for suite #{index + 1}: #{missingFields}"


co ->
  try
    (new CucumberTestRail()).run()
  catch e
    return consoleWrite "Error processing request: #{e}"
