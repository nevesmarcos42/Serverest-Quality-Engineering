function fn() {
  var config = {
    baseUrl: "https://serverest.dev",
    timeout: 10000,
  };

  // Configurações por ambiente (se necessário no futuro)
  var env = karate.env; // get java system property 'karate.env'
  karate.log("karate.env system property was:", env);

  if (!env) {
    env = "dev"; // default to dev
  }

  // Configurações específicas por ambiente
  if (env == "dev") {
    config.baseUrl = "https://serverest.dev";
  } else if (env == "prod") {
    config.baseUrl = "https://serverest.dev";
  }

  karate.configure("connectTimeout", config.timeout);
  karate.configure("readTimeout", config.timeout);

  return config;
}
