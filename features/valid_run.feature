Feature: Run CucumberTestRail with valid config/results

  @TestRail-CTR-3
  Scenario: Running CucumberTestRail with valid information makes valid requests
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -c sample_files/cucumber_testrail_valid.yml
                      -r sample_files/results_valid.json
                      -u 'user@ctr.co'
                      -p 'password'
                      -i 'QA'
    """
    Then I see the success message:
    """
    Successfully added the following results for project symbol DSFish to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """
    And I see the success message:
    """
    Successfully added the following results for project symbol DSPlaces to TestRail. Visit http://localhost:7000/runs/view/5 to access.
    """


  @TestRail-CTR-13
  Scenario: Running CucumberTestRail with valid information in write mode returns proper information
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -c sample_files/cucumber_testrail_valid.yml
                      -u 'user@ctr.co'
                      -p 'password'
                      -w 'DSPlaces'
                      -i 'QA'
    """
    Then I see the table:
    """
    ┌─────────┬────────────┬────────┐
    │ Case ID │ Section ID │ Title  │
    ├─────────┼────────────┼────────┤
    │ 1       │ 2          │ Test A │
    ├─────────┼────────────┼────────┤
    │ 2       │ 3          │ Test B │
    └─────────┴────────────┴────────┘

    """
