module.exports = ->
  #"([^"]*)" - string regex
  @Given /^a TestRail API at "([^"]*)"$/, (url) ->
    @listener.listen parseInt url

  @When /^I run the script "cucumber-testrail ([^"]*)"$/, (script) ->
    console.log 'run script', script

  @Then /^stuff happens$/, ->
    console.log 'continue'

  # TODO: remove once done with generating sample json
  #@When /^I have ([^"]*)$/, (stuff) ->
  #  return true

  #@When /^I can ([^"]*)$/, (stuff) ->
  #  return true
