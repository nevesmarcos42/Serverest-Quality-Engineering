# ADR-001: Tool Selection for Test Automation

## Status

Accepted

## Date

2025-12

## Context

The ServeRest Quality Engineering project requires a comprehensive test automation solution covering both API and UI testing. The selection of appropriate tools is crucial for project success, maintainability, and demonstrating professional QE practices.

### Requirements

- API testing with BDD support
- UI end-to-end testing
- Readable test specifications
- Good reporting capabilities
- Community support and documentation
- Integration with CI/CD pipelines

## Decision

We have decided to use the following tool stack:

### API Testing: Karate DSL

**Version:** 1.4.1

**Rationale:**

- Native BDD support with Gherkin syntax
- Built-in assertions and JSON validation
- No need for additional assertion libraries
- Comprehensive HTML reports out of the box
- Excellent documentation and community support
- Java-based, integrates well with Maven

### UI Testing: Cypress

**Version:** 13.17.0

**Rationale:**

- Modern architecture with fast execution
- Built-in waiting and retry logic
- Excellent developer experience
- Screenshot and video recording on failures
- Time-travel debugging
- Strong community and ecosystem

### Specification: Gherkin/BDD

**Rationale:**

- Industry standard for BDD
- Human-readable specifications
- Serves as living documentation
- Facilitates collaboration between technical and non-technical stakeholders

### Build Tools

- **Maven 3.x** - For Java/Karate tests
- **npm** - For Node.js/Cypress dependencies

### CI/CD: GitHub Actions

**Rationale:**

- Native GitHub integration
- Free for public repositories
- YAML-based configuration
- Parallel job execution
- Artifact storage

## Consequences

### Positive

- Two specialized tools, each excellent in their domain
- Native BDD support in both frameworks
- Comprehensive reporting capabilities
- Strong community support for troubleshooting
- Good documentation for learning and reference
- Suitable for portfolio demonstration

### Negative

- Learning curve for two different tools
- Need to maintain two test suites
- Different programming languages (Java for Karate, JavaScript for Cypress)
- Requires Java and Node.js environments

### Neutral

- Need to keep both tool versions updated
- Documentation needs to cover both frameworks
- CI/CD pipeline needs separate jobs for each

## Alternatives Considered

### REST Assured + TestNG

- More verbose than Karate
- Requires additional libraries for assertions
- Less intuitive BDD support

### Selenium WebDriver

- More complex setup than Cypress
- Requires explicit waits management
- Slower execution
- More maintenance overhead

### Playwright

- Newer tool with smaller community
- Multi-browser support (not required for this project)
- Less established ecosystem

## References

- [Karate DSL Documentation](https://github.com/karatelabs/karate)
- [Cypress Documentation](https://docs.cypress.io/)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [Test Pyramid Pattern](https://martinfowler.com/articles/practical-test-pyramid.html)
