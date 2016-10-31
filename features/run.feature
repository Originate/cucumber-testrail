Feature: Run CucumberTestRail

  @TestRail-CTR-3
  Scenario: Running CucumberTestRail With Valid Information Makes Valid Requests
    Given a TestRail API at localhost:7000
    When I run the script "cucumber-testrail -c cucumber_testrail_test.yml -r results.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then stuff happens
