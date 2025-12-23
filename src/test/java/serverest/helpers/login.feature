Feature: Helper - Login
  
  Scenario: Fazer login e obter token
    * url baseUrl
    * path '/login'
    * request { email: '#(email)', password: '#(password)' }
    * method POST
    * def token = response.authorization
