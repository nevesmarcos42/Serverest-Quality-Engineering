const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "https://front.serverest.dev",
    specPattern: "tests/ui/cypress/e2e/**/*.cy.{js,jsx,ts,tsx}",
    supportFile: "tests/ui/cypress/support/e2e.js",
    fixturesFolder: "tests/ui/cypress/fixtures",
    screenshotsFolder: "tests/ui/cypress/screenshots",
    videosFolder: "tests/ui/cypress/videos",

    viewportWidth: 1280,
    viewportHeight: 720,

    defaultCommandTimeout: 10000,
    pageLoadTimeout: 30000,

    video: true,
    screenshotOnRunFailure: true,

    retries: {
      runMode: 2,
      openMode: 0,
    },

    env: {
      apiUrl: "https://serverest.dev",
    },

    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
