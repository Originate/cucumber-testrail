expect = require 'expect.js'

module.exports = ->
  @Given /^a TestRail API at http:\/\/localhost:(\d+)$/, (port) ->
    port = parseInt port
    @server = @app.listen port


  @When /^I run the script "cucumber-testrail ([^"]*)"$/, (script) ->
    @resp = yield @execute_script "bin/cucumber-testrail #{script}"


  @Then /^my output (doesn't )?contain(s)? the following text:$/, (doesnt, _a, output) ->
    if doesnt
      expect(@resp).to.not.contain(output.trim())
    else
      expect(@resp).to.contain(output.trim())
