Feature: Run CucumberTestRail with invalid config

  @TestRail-CTR-4
  Scenario: Running CucumberTestRail with non-existent testrail_url in config throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_invalid1.yml -r sample_files/results_valid.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: cucumber_testrail.yml is missing testrail_url
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-5
  Scenario: Running CucumberTestRail with non-existent suites in config throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_invalid2.yml -r sample_files/results_valid.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: cucumber_testrail.yml is missing suites
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-6
  Scenario: Running CucumberTestRail with missing required fields in first suite throws error
    Given a TestRail API at http://localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_invalid3.yml -r sample_files/results_valid.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Error processing request: Error: cucumber_testrail.yml is missing these required fields for suite 1: project_id,project_symbol,testplan_id
    """
    And my output doesn't contain the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


