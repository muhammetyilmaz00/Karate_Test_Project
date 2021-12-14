Feature: Request Response Tests with Karate

  Background:
    Given url baseUrl
    And path 'pet'

  Scenario: GET request and status
#    Given url 'https://petstore.swagger.io/v2'
#    And path 'pet', 1
    And path 1
    When method GET
    Then print response
    And status 200


  Scenario: POST request with data
    Given url baseUrl
    And path 'pet'
    * def myBody =
    """
    {
  "category": {
    "id": 0,
    "name": "string"
  },
  "name": "doggie",
  "photoUrls": [
    "string"
  ],
  "tags": [
    {
      "id": 0,
      "name": "string"
    }
  ],
  "status": "available"
}
    """
    And request myBody
    When method POST
    Then karate.log(response)
    And match response.id == '#number'
    And match response.name == myBody.name

    Scenario: POST with external JSON file
      And def myRequestBody = read('classpath:data/pet.json')
      And request myRequestBody
      When method POST
      Then status 200
      And match response.id == '#present'
      And match response.name == myRequestBody.name
      And match response contains {category : { "name" : '#string', "id" : '#number'}}


    Scenario Outline: GET request for petId <id>
      And path "<id>"
      When method GET
      Then print response
      Examples:
      |id|
      |10|
      |11|
      |12|

  @regression @smoke
  Scenario Outline: GET request with csv for petId <id>
    And path id
    When method GET
    Then print response
    Examples:
     |read('data/data.csv')|

  @regression @smoke
  Scenario: Calling custom js function
    * def myString = call read('classpath:data/generate.js') 5
    * def myRequestBody = read('classpath:data/pet.json')
    And set myRequestBody.name = myString
    And request myRequestBody
    When method POST
    Then status 200
    And print response

  @regression
  Scenario: using callers
    * def myCaller = call read('classpath:callers/demo.feature') {id:10}
    Then match myCaller.responseStatus == 200
    And match myCaller.response.id == 10




















