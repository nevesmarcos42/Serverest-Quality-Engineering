# Test Strategy - ServeRest Quality Engineering

## 1. Overview

This document describes the complete test strategy for the ServeRest Quality Engineering project, including approach, scope, tools, and adopted practices.

## 2. Objectives

### Primary Objectives

- Ensure functional quality of ServeRest API and UI
- Implement automated test coverage following the test pyramid
- Create executable specifications using BDD/Gherkin
- Demonstrate expertise in Quality Engineering and test automation

### Secondary Objectives

- Serve as a professional portfolio project
- Document test automation best practices
- Create reusable knowledge base
- Integrate tests with CI/CD pipeline

## 3. Test Scope

### 3.1. Covered Features

#### API

- User Management (Complete CRUD)
- Authentication and Authorization (Login, JWT)
- Product Management (Complete CRUD)
- Shopping Cart Management (Purchase operations)

#### UI

- User Authentication (Registration, Login, Logout)
- Product Navigation (Catalog, Search, Filters)
- Shopping Cart (Add, Remove, Clear)

### 3.2. Out of Scope

- Performance/Load Testing
- Security Testing (Penetration Testing)
- Accessibility Testing (WCAG)
- Cross-browser Compatibility (Chrome only)

## 4. Test Approach

### 4.1. Test Pyramid

Following the industry-recommended test pyramid:

```
        /\
       /UI\      UI Tests
      /____\     Critical end-to-end flows
     /      \
    /  API  \    API Tests
   /__________\  Business logic
```

**Rationale:**

- API tests are faster, more stable, and cheaper to maintain
- UI tests focus on critical user flows
- Distribution allows adequate coverage with efficient maintenance

### 4.2. BDD (Behavior-Driven Development)

**All scenarios** are written in Gherkin (Portuguese):

```gherkin
Feature: User Authentication

  Scenario: Login with valid credentials
    Given I have a registered user
    When I login with valid credentials
    Then I should be authenticated successfully
    And I should receive a JWT token
```

**Benefits:**

- Specifications readable by all stakeholders
- Living documentation of the system
- Clear separation between specification and implementation
- Facilitates communication between teams

### 4.3. Test Levels

#### API Tests (Integration)

- REST endpoint validation
- Contract testing
- Status code validation
- JSON schema validation
- Authentication and authorization testing
- Success and failure cases

#### UI Tests (End-to-End)

- Critical user flows
- Interface validation
- Page navigation
- Element interaction
- Message validation
- Failure screenshots

## 5. Tools and Technologies

### 5.1. Automation Stack

| Layer         | Tool           | Version | Rationale                         |
| ------------- | -------------- | ------- | --------------------------------- |
| API Testing   | Karate DSL     | 1.4.1   | Native BDD, integrated assertions |
| UI Testing    | Cypress        | 13.17.0 | Modern, fast, reliable            |
| Specification | Gherkin        | -       | Industry BDD standard             |
| Build (Java)  | Maven          | 3.x     | Dependency management             |
| Build (Node)  | npm            | 8+      | Node package manager              |
| CI/CD         | GitHub Actions | -       | Native GitHub integration         |

### 5.2. Code Structure

#### API Tests (Karate)

```
tests/api/karate/
├── karate-config.js         # Global configuration
└── features/
    ├── usuarios.feature     # User scenarios
    ├── login.feature        # Login scenarios
    ├── produtos.feature     # Product scenarios
    └── carrinhos.feature    # Cart scenarios
```

#### UI Tests (Cypress)

```
tests/ui/cypress/
├── e2e/
│   ├── authentication.cy.js      # Authentication tests
│   ├── product-browsing.cy.js    # Product tests
│   └── shopping-cart.cy.js       # Cart tests
├── support/
│   ├── commands.js               # Custom commands
│   ├── e2e.js                    # Global setup
│   └── pages/
│       ├── LoginPage.js          # Login Page Object
│       ├── RegisterPage.js       # Register Page Object
│       └── HomePage.js           # Home Page Object
└── fixtures/
    └── testData.json             # Test data
```

## 6. Test Types

### 6.1. Positive Test Cases

Validate that the system works as expected in normal scenarios.

**Examples:**

- User registration with valid data
- Login with correct credentials
- Add product to cart

### 6.2. Negative Test Cases

Validate error handling and validations.

**Examples:**

- Registration with duplicate email
- Login with incorrect password
- Add out-of-stock product

### 6.3. Validation Tests

Verify business rules and data validations.

**Examples:**

- Invalid email format
- Empty required fields
- Values outside allowed range

### 6.4. Authorization Tests

Verify access control and permissions.

**Examples:**

- Operations restricted to administrators
- Access without authentication token
- Expired or invalid token

## 7. Test Data Strategy

### 7.1. Data Generation

- **Dynamic Generation** - Data created during test execution
- **Unique Values** - Random emails, names to avoid conflicts
- **Helper Functions** - Reusable utilities for data creation

### 7.2. Test Isolation

- Each test is independent
- No dependencies between tests
- State cleanup after execution

## 8. Execution Strategy

### 8.1. Local Execution

- Developers run tests before commits
- Quick feedback on changes
- Interactive debugging with Cypress

### 8.2. CI/CD Pipeline

- Automatic execution on push/PR
- Parallel jobs (API + UI)
- Artifact generation (reports, videos)
- Build failure on test failures

## 9. Reporting

### 9.1. Karate Reports

- HTML report with metrics
- Scenario pass/fail status
- Request/response details
- Execution time

### 9.2. Cypress Reports

- Console summary
- Screenshots of failures
- Video recordings
- Test execution timeline

## 10. Maintenance

### 10.1. Test Maintenance

- Regular review of tests
- Refactoring for better readability
- Update selectors when UI changes
- Keep documentation updated

### 10.2. Code Quality

- Follow Page Object Model
- Use descriptive names
- Add comments where needed
- Keep tests simple and focused

## 11. Success Criteria

Tests are considered successful when:

- All scenarios pass consistently
- No flaky tests
- Reports are clear and actionable
- Execution time is acceptable
- Coverage meets requirements

## 12. Risks and Mitigations

| Risk                    | Impact | Mitigation                          |
| ----------------------- | ------ | ----------------------------------- |
| UI changes break tests  | High   | Page Object Model, stable selectors |
| API changes break tests | High   | Contract testing, version control   |
| Flaky tests             | Medium | Explicit waits, retry mechanism     |
| Slow execution          | Low    | Parallel execution, selective runs  |

## 13. Future Improvements

- Add API contract testing
- Implement visual regression testing
- Add performance testing
- Expand cross-browser coverage
- Integrate with test management tool

---

**Version:** 1.0.0

**Last Updated:** January 2026
