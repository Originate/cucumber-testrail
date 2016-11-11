Feature: Run CucumberTestRail

  @TestRail-CTR-3
  Scenario: Running CucumberTestRail With Valid Information Makes Valid Requests
    Given a TestRail API at localhost:7000
    When I run the script "cucumber-testrail -c sample_files/cucumber_testrail_test.yml -r sample_files/results.json -u 'user@ctr.co' -p 'password' -i 'QA'"
    Then my output contains the following text:
    """
    Successfully added the following results for project symbol DSFish to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """
    And my output contains the following text:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """
