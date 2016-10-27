require 'require-yaml'

TestRailService = require './testrail_service.coffee'

# Reads and validates the configuration file for this tool
class ConfigReader

  constructor: (@config_file = {}) ->

  parse: -> 
    config = require "../#{@config_file}"
    testrail_service = new TestRailService config
    config.suites = config.suites.map ({suite}) -> suite
    testrail_service.validateConfig()
    config.symbols = config.suites.map ({project_symbol}) -> project_symbol
    config

module.exports = ConfigReader
