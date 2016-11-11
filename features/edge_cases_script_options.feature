Feature: Run CucumberTestRail with invalid script options

  @TestRail-CTR-10
  Scenario: Running CucumberTestRail with required options throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: script is missing these required options: username,password,result,config
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-11
  Scenario: Running CucumberTestRail with unrecognized option throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -z 'invalid' -c sample_files/cucumber_testrail_valid.yml -r sample_files/results_invalid2.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: unrecognized option -z passed in command line
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """
