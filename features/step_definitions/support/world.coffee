{spawn} = require 'child_process'
path = require 'path'
module.exports = ->

  @World = ->
    @execute_script = (cmd) ->
      @msg = ''
      new Promise (resolve, reject) ->
        proc = spawn "/bin/sh", ['-c', cmd], cwd: path.join __dirname, '../../../'
        proc.stdout.on 'data', (data) =>
          return if data is undefined
          @msg += data.toString()
        proc.on 'exit', (code) =>
          reject 'non-zero exit status' if code isnt 0
          resolve @msg

    null

