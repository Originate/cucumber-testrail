co = require 'co'


ConfigReader = require './config_reader'
CucumberResultReader = require './cucumber_result_reader'
OptionsReader = require './options_reader'
TestRailService = require './testrail_service'

co ->
  try
    # holds options passed in by CLI
    opts = {}
    # holds information from cucumber_testrail.yml
    config = []
    # contains testrail scenarios from cucumber in testrail format
    testrail_metrics = []
    options_reader = new OptionsReader()
    opts = options_reader.parse()
    config_reader = new ConfigReader opts.config
    config = config_reader.parse()
    if opts.write
      suite_config = config.suites.filter ({project_symbol}) => project_symbol is opts.write
      throw new Error "project symbol #{opts.write} not found in cucumber_testrail.yml" unless suite_config.length
      testrail_service = new TestRailService config, suite_config[0], opts, {}
      return testrail_service.fetchScenarios()
    cucumber_reader = new CucumberResultReader config, opts.result
    testrail_metrics = yield cucumber_reader.parse()
    yield Promise.all config.suites.map (suite_config) =>
      testrail_service = new TestRailService config, suite_config, opts, testrail_metrics
      testrail_service.sendTestResults()
  catch e
    console.log "#{e}"
