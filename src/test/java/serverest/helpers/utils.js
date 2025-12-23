function fn() {
  /**
   * Generate unique email for testing
   * @returns {string} Unique email address
   */
  var generateEmail = function () {
    var timestamp = new Date().getTime();
    var random = Math.floor(Math.random() * 10000);
    return "qa.user." + timestamp + "." + random + "@test.com";
  };

  /**
   * Generate unique product name
   * @returns {string} Unique product name
   */
  var generateProductName = function () {
    var timestamp = new Date().getTime();
    return "Produto Test " + timestamp;
  };

  /**
   * Generate unique user name
   * @returns {string} Unique user name
   */
  var generateUserName = function () {
    var timestamp = new Date().getTime();
    return "User Test " + timestamp;
  };

  /**
   * Create a test user and return user data with ID
   * @param {boolean} isAdmin - Whether user should be admin
   * @returns {object} User data with _id
   */
  var createTestUser = function (isAdmin) {
    var userData = {
      nome: generateUserName(),
      email: generateEmail(),
      password: "teste123",
      administrador: isAdmin ? "true" : "false",
    };

    var config = karate.call("classpath:karate-config.js");
    var response = karate.call(
      "classpath:serverest/helpers/create-user.feature",
      { user: userData }
    );

    return {
      _id: response.userId,
      nome: userData.nome,
      email: userData.email,
      password: userData.password,
      administrador: userData.administrador,
    };
  };

  /**
   * Login and return authorization token
   * @param {string} email - User email
   * @param {string} password - User password
   * @returns {string} Authorization token with Bearer prefix
   */
  var loginAndGetToken = function (email, password) {
    var loginData = { email: email, password: password };
    var response = karate.call(
      "classpath:serverest/helpers/login.feature",
      loginData
    );
    return response.token;
  };

  /**
   * Create admin user and return token
   * @returns {object} Object with user data and token
   */
  var createAdminAndGetToken = function () {
    var user = createTestUser(true);
    var token = loginAndGetToken(user.email, user.password);
    return { user: user, token: token };
  };

  /**
   * Generate random integer between min and max
   * @param {number} min - Minimum value
   * @param {number} max - Maximum value
   * @returns {number} Random integer
   */
  var randomInt = function (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  return {
    generateEmail: generateEmail,
    generateProductName: generateProductName,
    generateUserName: generateUserName,
    createTestUser: createTestUser,
    loginAndGetToken: loginAndGetToken,
    createAdminAndGetToken: createAdminAndGetToken,
    randomInt: randomInt,
  };
}
