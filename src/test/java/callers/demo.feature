Feature: demo callers

  Scenario: demo scenario
    Given url baseUrl
    And path 'pet', id
    When method GET
    Then print response