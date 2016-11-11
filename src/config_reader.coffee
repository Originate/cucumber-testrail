_ = require 'lodash'

require 'require-yaml'
REQUIRED_CONFIG_FIELDS = ['project_id', 'project_symbol', 'testplan_id']

# Reads and validates the configuration file for this tool
class ConfigReader

  constructor: (@config_file = {}) ->

  parse: -> 
    config = require "../#{@config_file}"
    config.suites = (config.suites?.map ({suite}) -> suite) or []
    @_validateConfig config
    config.symbols = config.suites.map ({project_symbol}) -> project_symbol
    config


  _validateConfig: (config) ->
    throw new Error 'cucumber_testrail.yml is missing testrail_url' unless config.testrail_url
    throw new Error 'cucumber_testrail.yml is missing suites' unless config.suites.length
    config.suites.forEach (config, index) ->
      params = Object.keys config
      missingFields = _.compact REQUIRED_CONFIG_FIELDS.map (field) ->
        field unless field in params
      return unless missingFields.length
      throw new Error "cucumber_testrail.yml is missing these required fields for suite #{index + 1}: #{missingFields}"

module.exports = ConfigReader
