# GitHub Copilot Instructions — starter-karate-dsl

These instructions are automatically loaded by GitHub Copilot and compatible AI coding assistants
when working inside this repository.

---

## 🎯 Project Context

This is a **Karate DSL** API test automation framework (not a Cucumber project).
Karate is an autonomous testing DSL — it does **not** require Java Step Definition classes.

Stack: **Karate 1.5.0** · **Java 17** · **Maven** · **JUnit 5** · **GraalVM JS**

---

## 🚫 Strict Rules

### Rule 1 — No External Step Definitions

> ❌ **PROHIBITED**: Creating Java classes with `@Given`, `@When`, `@Then` annotations.

Karate parses and executes `.feature` files natively. There is no Cucumber glue layer.
**Never** suggest files like `UserStepDefinitions.java`, `StepDefs.java`, or any class that imports
`io.cucumber.java.en.*`.

### Rule 2 — No Unnecessary Java Code

> ❌ **PROHIBITED**: Writing custom Java helpers for tasks Karate handles natively.

Karate provides built-in support for:
- HTTP calls (`url`, `path`, `method`, `request`)
- JSON/XML parsing and matching (`match`, `contains`, `each`)
- File reading (`read('classpath:...')`)
- JavaScript execution (inline `* def fn = function() {...}`)
- Waiting / retry (`retry until`, `waitFor()`)

Only create Java classes when absolutely necessary (e.g., proprietary encryption libraries,
JDBC connections not achievable via Karate's built-in `karate.call()`).

### Rule 3 — GraalVM-Safe JavaScript

> ❌ **PROHIBITED**: Nashorn-only APIs (`importPackage`, `importClass`, `with` statement).

When writing JS in `.feature` files or `karate-config.js`:
- Use `Java.type('com.example.Foo')` for Java interop.
- Use `karate.properties['ENV_VAR']` instead of `java.lang.System.getenv()`.
- Keep functions wrapped in `function fn() { ... }` to avoid scope pollution.

---

## ✅ Mandatory Patterns

### Data-Driven Testing

> **REQUIRED**: Use structured data sources — never hard-code multiple test values inline.

**Option A — `Scenario Outline` with `Examples` table:**

```gherkin
Scenario Outline: validate user <username>
  Given path 'users', <id>
  When method GET
  Then status 200
  And match response.username == '<username>'

Examples:
  | id | username  |
  | 1  | Bret      |
  | 2  | Antonette |
```

**Option B — External JSON file (`src/test/java/data/users.json`):**

```gherkin
* def users = read('classpath:data/users.json')
* call read('classpath:shared/validate-user.feature') users
```

**Option C — External CSV file:**

```gherkin
* def users = read('classpath:data/users.csv')
```

### Schema Assertions

> **REQUIRED**: Use fuzzy matchers for dynamic/generated fields; never assert UUIDs or timestamps as literals.

```gherkin
And match response.id        == '#number'
And match response.createdAt == '#string'
And match response           == { id: '#number', name: '#string', email: '#regex ^.+@.+$' }
```

### Reusable Calls

> **PREFERRED**: Extract repeated API call sequences into `@ignore` feature files and `call read(...)` them.

```gherkin
* def result = call read('classpath:shared/create-user.feature') { name: 'Alice' }
* def createdId = result.response.id
```

---

## 🖥️ Karate UI Rules (if Karate UI is used)

If this project ever adds Karate UI tests:

> **REQUIRED**: Use `locate()` and `waitFor()` for all element interactions.

```gherkin
* waitFor('#submit-button').click()
* input('input[name="email"]', 'user@example.com')
```

> ❌ **PROHIBITED**: Raw `driver.findElement()` calls or `Thread.sleep()` for synchronisation.

---

## 📁 File & Folder Conventions

```
src/test/java/
├── karate-config.js          # Global config; one block per environment
├── examples/
│   ├── users/
│   │   └── users.feature     # REST API scenarios
│   └── usersgql/
│       ├── users-gql.feature # GraphQL scenarios
│       └── queries/          # .graphql query files
└── shared/                   # @ignore reusable features (call targets)
```

- Feature files live **alongside** their runner classes.
- Shared/reusable features go in `shared/` and are tagged `@ignore`.
- Test data files go in `data/` (JSON, CSV).
- GraphQL query files go in a `queries/` subfolder next to the feature.

---

## 🏷️ Tag Conventions

| Tag | Meaning |
|-----|---------|
| `@run` | Included in the default CI run |
| `@ignore` | Reusable call target — never executed directly |
| `@wip` | Work in progress — excluded from CI |
| `@smoke` | Smoke test subset |
| `@regression` | Full regression suite |

CI command template:

```bash
mvn clean test "-Dkarate.options=--tags @run"
```

---

## 🤖 AI Skill Context

For deeper Karate-specific context, load the skill files defined in `.github/skills/`:

- **karate-core**: `.github/skills/karate-core/SKILL.md` — syntax, matchers, schema assertions, upgrade roadmap.

Agent definitions are in [`AGENTS.md`](../AGENTS.md) at the repository root.
