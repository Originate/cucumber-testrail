Feature: Run CucumberTestRail

  Scenario: Running CucumberTestRail With Valid Information Makes Valid Requests
    Given a TestRail API at "http://localhost:4000"
    When I run the script "cucumber-testrail -c cucumber_testrail_test.yml -r results.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then stuff happens
