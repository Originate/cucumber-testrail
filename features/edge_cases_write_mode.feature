Feature: Run CucumberTestRail with insufficient requirements

  @TestRail-CTR-14
  Scenario: Running CucumberTestRail with unrepresented project symbol in write mode shows proper error
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -c sample_files/cucumber_testrail_valid.yml
                      -u 'user@ctr.co'
                      -p 'password'
                      -w 'INVALID'
                      -i 'QA'
    """
    Then I see the error:
    """
    Error: project symbol INVALID not found in cucumber_testrail.yml
    """


  @TestRail-CTR-15
  Scenario: Running CucumberTestRail in write mode with missing options shows proper error
    Given a TestRail API at http://localhost:7000
    When I run the script:
    """
    cucumber-testrail -i 'QA'
                      -w 'DSPlaces'
    """
    Then I see the error:
    """
    Error: script is missing these required options: username,password,config
    """
    And the TestRail update fails to send
