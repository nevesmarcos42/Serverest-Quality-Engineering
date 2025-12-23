Feature: Helper - Criar Usuário
  
  Scenario: Criar usuário via API
    * url baseUrl
    * path '/usuarios'
    * request user
    * method POST
    * def userId = response._id
