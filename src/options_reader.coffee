_ = require 'lodash'
minimist = require 'minimist'
REQUIRED_SCRIPT_OPTIONS = ['username', 'password', 'result', 'config']

class OptionsReader

  constructor: ->
    @alias = u: 'username', p: 'password', c: 'config', r: 'result', i: 'runid'
    @unknown = (opt) -> throw new Error "unrecognized option #{opt} passed in command line"


  parse: ->
    @opts = minimist process.argv[2..], alias: @alias, unknown: @unknown
    missingOptions = @_validateOptions()
    throw new Error "script is missing these required options: #{missingOptions}" if missingOptions.length
    @opts


  _validateOptions: ->
    params = Object.keys @opts
    _.compact REQUIRED_SCRIPT_OPTIONS.map (field) ->
      field unless field in params


module.exports = OptionsReader
