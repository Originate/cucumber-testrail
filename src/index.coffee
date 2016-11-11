co = require 'co'
_ = require 'lodash'
minimist = require 'minimist'

REQUIRED_SCRIPT_OPTIONS = ['username', 'password', 'result', 'config']

ConfigReader = require './config_reader'
CucumberResultReader = require './cucumber_result_reader'
TestRailService = require './testrail_service'

runService = co.wrap (symbol, config, opts, testrail_metrics) =>
  suite_config = _projectSuites config.suites, symbol
  return unless _needsUpdate symbol, suite_config, testrail_metrics
  yield (new TestRailService config, opts, suite_config[0], testrail_metrics[symbol]).run()


_needsUpdate = (symbol, suite_config, testrail_metrics) ->
  if suite_config.length is 0
    throw new Error "symbol #{symbol} found in cucumber results is not represented in cucumber_testrail.yml"
  return false if testrail_metrics[symbol].length is 0
  true


_projectSuites = (suites, symbol) ->
  suite_config = suites.filter ({project_symbol}) -> project_symbol is symbol


co ->
  try
    alias = u: 'username', p: 'password', c: 'config', r: 'result', i: 'runid'
    unknown = (opt) -> throw new Error "unrecognized option #{opt} passed in command line"
    opts = minimist process.argv[2..], {alias, unknown}
    params = Object.keys opts
    missingOptions = _.compact REQUIRED_SCRIPT_OPTIONS.map (field) ->
      field unless field in params
    throw new Error "script is missing these required options: #{missingOptions}" if missingOptions.length
    # holds information from cucumber_testrail.yml
    config = []
    # contains testrail scenarios from cucumber in testrail format
    testrail_metrics = []
    config_reader = new ConfigReader opts.config
    config = config_reader.parse()
    cucumber_reader = new CucumberResultReader config, opts.result
    testrail_metrics = yield cucumber_reader.parse()
    yield Promise.all Object.keys(testrail_metrics).map (symbol) => runService symbol, config, opts, testrail_metrics
  catch e
    console.log "Error processing request: #{e}"
