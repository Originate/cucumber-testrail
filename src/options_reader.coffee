_ = require 'lodash'
minimist = require 'minimist'
REQUIRED_SCRIPT_OPTIONS = ['result', 'write', 'username', 'password', 'config']

class OptionsReader

  constructor: ->
    @alias = u: 'username', p: 'password', c: 'config', r: 'result', i: 'runid', w: 'write'
    @unknown = (opt) -> throw new Error "unrecognized option #{opt} passed in command line"


  parse: ->
    @opts = minimist process.argv[2..], alias: @alias, unknown: @unknown
    missingOptions = @_validateOptions()
    throw new Error "script is missing these required options: #{missingOptions}" if missingOptions.length
    @opts


  _validateOptions: ->
    params = Object.keys @opts
    required_options = REQUIRED_SCRIPT_OPTIONS
    if @opts.write
      required_options.splice 0, 1
    else
      required_options.splice 1, 1
    _.compact required_options.map (field) ->
      field unless field in params


module.exports = OptionsReader
