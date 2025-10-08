# GitHub Copilot Instructions for starter-karate-dsl

This repository contains API test automation using Karate DSL for RESTful and GraphQL APIs.

## Project Overview
- **Framework**: Karate DSL (version 1.5.0)
- **Java Version**: JDK 17
- **Build Tool**: Maven
- **Test Framework**: Karate with JUnit 5
- **Primary Language**: Java, Gherkin (for Karate feature files)

## Technology Stack
- Use **Maven** for dependency management, not Gradle
- Java Development Kit **17** is required
- Karate DSL framework for API testing (both REST and GraphQL)
- JUnit 5 for test execution

## Project Structure
- Test code is located in `src/test/java/examples/`
- Feature files (`.feature`) use Gherkin syntax and are co-located with Java runner classes
- Each test module has a Runner class (e.g., `UsersRunner.java`) that executes the corresponding feature file
- Configuration file: `src/test/java/karate-config.js`
- GraphQL queries are stored in separate `.graphql` files in `queries/` subdirectories

## Build and Test Commands
- **Build**: `mvn clean test -DskipTests`
- **Run all tests**: `mvn clean test`
- **Run tests with specific tag**: `mvn clean test "-Dkarate.options=--tags @tagname"`
- **Run all REST and GraphQL tests**: `mvn clean test "-Dkarate.options=--tags @run"`
- **Run only GraphQL tests**: `mvn clean test "-Dkarate.options=--tags @graphql_examples"`

## Test Reports
- Test reports are generated in `target/karate-reports/` directory after test execution
- Reports are in HTML format for easy visualization
- JUnit XML reports are also generated for CI/CD integration

## Coding Standards

### Java Code
- Follow standard Java conventions
- Use JUnit 5 annotations (`@Karate.Test`)
- Runner classes should extend or use Karate runner pattern
- Package structure: `examples.<module-name>` (e.g., `examples.users`, `examples.usersgql`)

### Karate Feature Files
- Use Gherkin syntax (Feature, Scenario, Given, When, Then)
- Tag scenarios appropriately (e.g., `@run`, `@graphql_examples`, `@get_users`)
- Background section for common setup steps
- Use `* def` for variable definitions
- Use JSON/text blocks with triple quotes for request bodies
- Prefer reading queries from external files for GraphQL tests

### Test Organization
- One Runner class per feature file
- Runner class naming: `<ModuleName>Runner.java`
- Feature file naming: `<module-name>.feature` (lowercase with hyphens)
- Group related tests in the same feature file using scenarios

## Environment Configuration
- Environment-specific configuration in `karate-config.js`
- Default environment is 'dev'
- Use `karate.env` system property to switch environments

## CI/CD
- GitHub Actions workflow: `.github/workflows/karate-test-runner.yml`
- Workflow triggers on push events
- Uses JUnit Report Action for test reporting

## Important Notes
- The project includes an intentionally failing test to demonstrate error reporting
- Always ensure environment variables `JAVA_HOME` and `M2_HOME`/`PATH` are properly configured
- Tests run in parallel (default: 5 threads)
- Use UTF-8 encoding for all files

## Dependencies
- Do not add external dependencies without updating `pom.xml`
- Primary dependency: `io.karatelabs:karate-junit5`
- Keep Karate version aligned with the project (currently 1.5.0)

## Documentation
- Refer to official Karate documentation: https://karatelabs.github.io/karate/
- README.md contains setup and execution instructions in Spanish
