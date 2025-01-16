@run
Feature: Validar reserva de vuelos con datos dinámicos

Scenario: Validar creación de reserva
  * def testData = read('src/test/resources/test-data.json')
  Given url 'https://api.instantwebtools.net/v1/passenger'
  And request {
    name: '#(testData.flight.name)',
    flightNumber: '#(testData.flight.flightNumber)',
    date: '#(testData.flight.date)',
    class: '#(testData.flight.class)'
  }
  When method post
  Then status 201
