expect = require 'expect.js'

module.exports = ->
  @Given /^a TestRail API at http:\/\/localhost:(\d+)$/, (port) ->
    port = parseInt port
    @server = @app.listen port


  @When /^I run the script:$/, (script) ->
    script = script.replace 'cucumber-testrail ', ''
    script = script.replace /\n\s*/g, ' '
    @resp = yield @execute_script "bin/cucumber-testrail #{script}"


  @Then /^I see the (success message|error):$/, (_, output) ->
      expect(@resp).to.contain output.trim()


  @Then /^the TestRail update fails to send$/, ->
      expect(@resp).to.not.contain "Successfully added the following results"

