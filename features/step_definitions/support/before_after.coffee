HttpRecorder = require 'record-http'

module.exports = ->
  @Before ->
    console.log 'initialize http proxy'
    @listener = new HttpRecorder()


  @After ->
    @listener.close()

