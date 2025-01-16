Feature: Generación de datos realistas para pruebas automatizadas

Scenario: Crear datos dinámicos para múltiples escenarios
  * def generateTestData = call read('generate-test-data.js')
  * def testData = generateTestData()
  * karate.write(testData, 'src/test/resources/test-data.json')
