# Project Summary - ServeRest Quality Engineering

## Overview

**ServeRest Quality Engineering** is a professional test automation project that demonstrates expertise in Quality Engineering through complete implementation of API and UI tests for the [ServeRest](https://serverest.dev/) application.

## Statistics

- **Test Scenarios**: API tests (Karate) + UI tests (Cypress)
- **Success Rate**: All tests validated and passing
- **Frameworks**: 2 specialized tools
- **BDD**: Complete Gherkin specifications
- **CI/CD**: GitHub Actions configured

## Tech Stack

| Technology     | Version | Purpose            |
| -------------- | ------- | ------------------ |
| Cypress        | 13.17.0 | E2E Testing (UI)   |
| Karate DSL     | 1.4.1   | API Testing        |
| Gherkin        | -       | BDD Specifications |
| Maven          | 3.x     | Java Build Tool    |
| Node.js        | 18+     | JavaScript Runtime |
| GitHub Actions | -       | CI/CD Pipeline     |

## Project Structure

```
ServeRest-Quality-Engineering/
├── docs/                    # Complete documentation
│   ├── architecture/        # ADRs and mapping
│   ├── test-strategy/       # Test strategy
│   └── PROJECT_SUMMARY.md
│
├── tests/                   # Test implementation
│   ├── api/karate/          # Karate tests
│   └── ui/cypress/          # Cypress tests
│
├── src/                     # Test runner
├── .github/workflows/       # CI/CD pipeline
├── cypress.config.js        # Cypress config
├── package.json             # Node dependencies
└── pom.xml                  # Maven config
```

## Test Coverage

### API Tests (Karate)

#### Users

- List users
- Search by ID
- Create (success/failure)
- Update
- Delete
- Validations (duplicate email, required fields)

#### Login

- Valid login
- JWT token
- Invalid credentials
- Field validation

#### Products

- List and filters
- Search by ID
- Create (admin)
- Update (admin)
- Delete (admin)
- Authorization validations

#### Shopping Carts

- List carts
- Add products
- Stock validation
- Complete purchase
- Cancel purchase
- Business validations

### UI Tests (Cypress)

#### Authentication

- User registration
- Admin registration
- Valid/invalid login
- Duplicate email validation
- Logout

#### Products

- Catalog visualization
- Product cards
- Product information
- Navigation

#### Cart

- Add to list
- View list
- Remove items
- Validate quantities
- Clear list

## Patterns and Practices

### Architecture

- **Test Pyramid** - Appropriate distribution between API and UI
- **Page Object Model** - Organized UI tests
- **BDD with Gherkin** - Readable specifications
- **Custom Commands** - Code reuse

### Code Quality

- Independent tests
- Dynamically generated data
- Explicit waits
- Clear assertions
- State cleanup

### Documentation

- Documented ADRs
- Complete test strategy
- API mapping
- Execution guide
- Detailed README

## CI/CD Pipeline

### GitHub Actions

- Automatic execution (push/PR)
- Separate jobs (API + UI)
- Dependency caching
- Artifact generation
- Automated reports

### Generated Artifacts

- Karate reports (HTML)
- Cypress videos
- Failure screenshots
- Execution logs

## Quick Start

```bash
# Install dependencies
npm install

# Run API tests
npm run test:api

# Run UI tests
npm run test:ui

# Run complete suite
npm test

# Open Cypress interactive
npm run cy:open
```

## Quality Metrics

| Metric         | Value                |
| -------------- | -------------------- |
| Test Scenarios | Complete coverage    |
| Success Rate   | All tests passing    |
| API Coverage   | All endpoints        |
| UI Coverage    | Critical flows       |
| Execution Time | 6-8 min (full suite) |
| Flaky Tests    | 0                    |

## Project Differentiators

### Technical

- Two specialized tools (Karate + Cypress)
- Complete BDD with Gherkin
- Page Object Model implemented
- Detailed automatic reports
- Functional CI/CD pipeline
- All tests passing

### Documentation

- ADRs (Architecture Decision Records)
- Professional test strategy
- Complete API mapping
- Detailed execution guides
- Comprehensive README
