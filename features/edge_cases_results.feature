Feature: Run CucumberTestRail with invalid results.json

  @TestRail-CTR-7
  Scenario: Running CucumberTestRail with results that include one invalid case_id throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_valid.yml -r sample_files/results_invalid1.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: case_id invalidCaseId found in cucumber results has an invalid format. id should be numeric
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-8
  Scenario: Running CucumberTestRail with results that include an unrecognized project symbol throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_valid.yml -r sample_files/results_invalid2.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: symbol InvalidProjectSymbol found in cucumber results is not configured in cucumber_testrail.yml
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-9
  Scenario: Running CucumberTestRail with results that include an unrecognized step result throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_valid.yml -r sample_files/results_invalid3.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: unknown step result status: invalidStepResult
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """
