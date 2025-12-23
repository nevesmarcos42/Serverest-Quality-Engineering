function fn() {
  var env = karate.env; // obtém propriedade do sistema 'karate.env'
  karate.log("karate.env system property was:", env);

  if (!env) {
    env = "dev";
  }

  var config = {
    env: env,
    baseUrl: "https://serverest.dev",
    defaultTimeout: 10000,
  };

  // Configuração específica do ambiente
  if (env == "dev") {
    config.baseUrl = "https://serverest.dev";
  } else if (env == "staging") {
    config.baseUrl = "https://serverest.dev";
  } else if (env == "prod") {
    config.baseUrl = "https://serverest.dev";
  }

  karate.configure("connectTimeout", config.defaultTimeout);
  karate.configure("readTimeout", config.defaultTimeout);

  return config;
}
