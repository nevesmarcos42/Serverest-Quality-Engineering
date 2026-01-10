# Execution Guide - ServeRest Quality Engineering

This guide provides detailed instructions for running project tests.

## Prerequisites

Before running tests, ensure you have installed:

- Node.js 18+
- Java 11+
- Maven 3.x
- Git

### Verify Installations

```bash
node --version
java -version
mvn --version
git --version
```

## Project Installation

### 1. Clone Repository

```bash
git clone https://github.com/nevesmarcos42/Serverest-Quality-Engineering.git
cd Serverest-Quality-Engineering
```

### 2. Install Dependencies

```bash
npm install
npx cypress verify
```

## Running Tests

### API Tests (Karate)

#### Run All API Tests

```bash
npm run test:api
```

Or directly with Maven:

```bash
mvn clean test
```

#### Run Specific Feature

```bash
# Users
mvn test -Dkarate.options="classpath:features/usuarios.feature"

# Login
mvn test -Dkarate.options="classpath:features/login.feature"

# Products
mvn test -Dkarate.options="classpath:features/produtos.feature"

# Carts
mvn test -Dkarate.options="classpath:features/carrinhos.feature"
```

#### Run Specific Scenario

```bash
mvn test -Dkarate.options="classpath:features/usuarios.feature:10"
```

(where 10 is the scenario line number)

#### Karate Report

After execution, open the report at:

```
target/karate-reports/karate-summary.html
```

### UI Tests (Cypress)

#### Run All UI Tests (Headless)

```bash
npm run test:ui
```

Or directly:

```bash
npx cypress run
```

#### Open Cypress Interface

```bash
npm run cy:open
```

Or:

```bash
npx cypress open
```

#### Run Specific Test

```bash
# Authentication
npx cypress run --spec "tests/ui/cypress/e2e/authentication.cy.js"

# Product Browsing
npx cypress run --spec "tests/ui/cypress/e2e/product-browsing.cy.js"

# Shopping Cart
npx cypress run --spec "tests/ui/cypress/e2e/shopping-cart.cy.js"
```

#### Run in Specific Browser

```bash
npx cypress run --browser chrome
npx cypress run --browser firefox
npx cypress run --browser edge
```

#### Cypress Reports

After execution:

- **Screenshots**: `tests/ui/cypress/screenshots/`
- **Videos**: `tests/ui/cypress/videos/`
- **Console**: Summary displayed in terminal

### Run Complete Suite

Run all tests (API + UI):

```bash
npm test
```

## Configuration

### Configure Base URL (Cypress)

Edit `cypress.config.js`:

```javascript
module.exports = defineConfig({
  e2e: {
    baseUrl: "https://front.serverest.dev",
    // ...
  },
});
```

### Configure Environment (Karate)

Edit `tests/api/karate/karate-config.js`:

```javascript
function fn() {
  var config = {
    baseUrl: "https://serverest.dev",
  };
  return config;
}
```

### Timeouts and Retries

**Cypress** (`cypress.config.js`):

```javascript
defaultCommandTimeout: 10000,
pageLoadTimeout: 30000,
retries: {
  runMode: 2,
  openMode: 0
}
```

## Debugging

### Debug API Tests

```bash
# Verbose output
mvn test -Dkarate.options="--tags @debug"

# Print variables
* print variable_name
```

### Debug UI Tests

```bash
# Open Cypress with Dev Tools
npx cypress open

# Add breakpoints in code
cy.debug()
cy.pause()
```

## Troubleshooting

### Common Issues

#### Java not found

```bash
# Verify Java installation
java -version

# Set JAVA_HOME if needed
export JAVA_HOME=/path/to/java
```

#### Cypress verification failed

```bash
# Clear cache and reinstall
npx cypress cache clear
npm install cypress --force
```

#### Tests failing intermittently

```bash
# Increase timeouts in cypress.config.js
defaultCommandTimeout: 15000

# Add explicit waits
cy.wait(2000)
```

## CI/CD Pipeline

This project includes a GitHub Actions workflow that automatically runs tests on every push and pull request.

### Pipeline Stages

1. **Setup** - Install dependencies (Node.js, Java, Maven)
2. **API Tests** - Run Karate tests with Maven
3. **UI Tests** - Run Cypress tests in headless mode
4. **Artifacts** - Save reports, videos, and screenshots

### View Results

Access the **Actions** tab in the GitHub repository to view execution results and download artifacts.
