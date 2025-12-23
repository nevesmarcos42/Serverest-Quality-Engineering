const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "https://front.serverest.dev",
    setupNodeEvents(on, config) {
      // implementa event listeners do node aqui
    },
    specPattern: "tests/ui/cypress/e2e/**/*.cy.js",
    supportFile: "tests/ui/cypress/support/e2e.js",
    fixturesFolder: "tests/ui/cypress/fixtures",
    screenshotsFolder: "tests/ui/cypress/screenshots",
    videosFolder: "tests/ui/cypress/videos",

    // Configuração de viewport
    viewportWidth: 1280,
    viewportHeight: 720,

    // Timeouts
    defaultCommandTimeout: 10000,
    pageLoadTimeout: 30000,

    // Configuração de tentativas de teste
    retries: {
      runMode: 2,
      openMode: 0,
    },

    // Configurações de vídeo e screenshot
    video: true,
    videoCompression: 32,
    screenshotOnRunFailure: true,

    // Configurações específicas do Chrome
    chromeWebSecurity: false,

    env: {
      apiUrl: "https://serverest.dev",
    },
  },
});
