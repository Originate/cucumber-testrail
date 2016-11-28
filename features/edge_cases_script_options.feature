Feature: Run CucumberTestRail with invalid script options

  @TestRail-CTR-10
  Scenario: Running CucumberTestRail without required options throws error
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -i 'QA'
    """
    Then I see the error:
    """
    Error: script is missing these required options: result,username,password,config
    """
    And the TestRail update fails to send


  @TestRail-CTR-11
  Scenario: Running CucumberTestRail with unrecognized option throws error
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -z
                      -c sample_files/cucumber_testrail_valid.yml
                      -r sample_files/results_valid.json
                      -u 'user@ctr.co'
                      -p 'password'
                      -i 'QA'
    """
    Then I see the error:
    """
    Error: unrecognized option -z passed in command line
    """
    And the TestRail update fails to send
