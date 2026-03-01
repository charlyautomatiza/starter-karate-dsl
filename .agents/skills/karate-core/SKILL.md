# SKILL.md — karate-core

## Metadata

| Field | Value |
|-------|-------|
| **Name** | karate-core |
| **Description** | Core Karate DSL skill: native syntax, fuzzy matchers, schema assertions, reusable call patterns, and upgrade roadmap for any Karate-based API test project |
| **Version** | 1.0.0 |
| **Karate Version** | 1.5.0+ (io.karatelabs) |
| **Java Version** | 17+ |
| **Last Updated** | 2026-03 |

---

## 1. Modern Syntax Reference

### 1.1 Base URL & Path

```gherkin
Background:
  * url 'https://api.example.com'

Scenario: get a resource by id
  Given path 'resources', 1
  When method GET
  Then status 200
```

### 1.2 Fuzzy Matchers

Use fuzzy matchers instead of hard-coding dynamic values:

```gherkin
# Exact match
And match response.name == 'Expected Name'

# Type-only match (fuzzy)
And match response.id        == '#number'
And match response.email     == '#string'
And match response.active    == '#boolean'
And match response.createdAt == '#string'
And match response.uuid      == '#uuid'
And match response.phone     == '#regex ^[\\d\\s\\-\\.\\(\\)x]+$'

# Optionality: if present, must be a string or null (field may also be absent)
And match response.website == '##string'

# Collection matchers
And match response.address == '#object'
And match response.tags    == '#[] #string'   # array of strings
And match response.items   == '#[_ > 0] #object'  # non-empty array of objects
```

### 1.3 Schema Assertion (JSON Schema-style)

Define a schema once and reuse it across scenarios:

```gherkin
* def addressSchema =
  """
  {
    street:  '#string',
    city:    '#string',
    country: '#string',
    zip:     '#regex ^[A-Z0-9\\-]{3,10}$'
  }
  """

* def itemSchema =
  """
  {
    id:        '#number',
    name:      '#string',
    email:     '#regex ^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$',
    address:   '#(addressSchema)',
    createdAt: '#string',
    active:    '#boolean'
  }
  """

Given path 'items', 1
When method GET
Then status 200
And match response == itemSchema
```

### 1.4 Reusable `call` Pattern

Extract repeated API call sequences into `@ignore` feature files:

```gherkin
# shared/get-item.feature
@ignore
Feature: reusable get-item call

Scenario:
  Given path 'items', itemId
  When method GET
  Then status 200
```

```gherkin
# Caller feature
* def result = call read('classpath:shared/get-item.feature') { itemId: 1 }
* match result.response.name == '#string'
```

### 1.5 `karate.match()` in JavaScript Blocks

Always check the `.pass` result and call `karate.fail()` to surface assertion failures:

```gherkin
* def validateItem =
  """
  function(item) {
    var result = karate.match(item, { id: '#number', name: '#string' });
    if (!result.pass) karate.fail('item schema mismatch: ' + result.message);
  }
  """

* call validateItem response
```

### 1.6 Data-Driven with `Scenario Outline`

```gherkin
Scenario Outline: validate item <name>
  Given path 'items', <id>
  When method GET
  Then status 200
  And match response.name == '<name>'

Examples:
  | id | name        |
  | 1  | First Item  |
  | 2  | Second Item |
```

### 1.7 External CSV/JSON for Data-Driven Tests

```gherkin
# Read from an external JSON array
* def items = read('classpath:data/items.json')

* def validateAll =
  """
  function() {
    items.forEach(function(item) {
      var res = karate.call('classpath:shared/get-item.feature', { itemId: item.id });
      var matchResult = karate.match(res.response.name, item.name);
      if (!matchResult.pass) {
        karate.fail('Expected name ' + item.name + ' but was ' + res.response.name);
      }
    });
  }
  """
* call validateAll
```

Or via CSV:

```gherkin
* def items = read('classpath:data/items.csv')
```

### 1.8 GraphQL Requests

```gherkin
Background:
  * url 'https://graphql.example.com/api'

Scenario: fetch item detail via GraphQL
  Given text query =
    """
    {
      item(id: 1) {
        id
        name
        tags { id label }
      }
    }
    """
  And request { query: '#(query)' }
  When method POST
  Then status 200
  And match $.data.item.id == '1'
  And match $.data.item.tags[0] == { id: '#string', label: '#string' }
```

For file-based queries:

```gherkin
Given def query = read('classpath:queries/get-item.graphql')
And request { query: '#(query)', variables: { id: 1 } }
When method POST
Then status 200
```

### 1.9 `configure` Settings

```gherkin
# In karate-config.js or Background:
* configure connectTimeout  = 10000
* configure readTimeout     = 30000
* configure followRedirects = false
* configure headers         = { 'Accept': 'application/json', 'Content-Type': 'application/json' }
```

> ⚠️ **Security note**: `configure ssl = true` disables TLS certificate validation and should **only** be used
> with local self-signed certificates in non-production environments. Never commit this setting for
> tests targeting real/production services.

---

## 2. Upgrade Roadmap (→ 2026 Standard)

### Step 1 — Verify Karate Version

Ensure `pom.xml` uses `io.karatelabs` (not the legacy `com.intuit.karate` group):

```xml
<properties>
  <karate.version>1.5.0</karate.version>
</properties>

<dependency>
  <groupId>io.karatelabs</groupId>
  <artifactId>karate-junit5</artifactId>
  <version>${karate.version}</version>
  <scope>test</scope>
</dependency>
```

### Step 2 — Enable Official Karate Labs HTML Reports

The built-in HTML report is generated automatically in `target/karate-reports/` after each run.
For **Karate Gatling** performance reports, add the optional dependency:

```xml
<!-- Optional: Karate Gatling bridge for performance simulations -->
<dependency>
  <groupId>io.karatelabs</groupId>
  <artifactId>karate-gatling</artifactId>
  <version>${karate.version}</version>
  <scope>test</scope>
</dependency>
```

To enable Gatling HTML reporting, extend `KarateSimulation` and run via the Gatling Maven plugin:

```xml
<plugin>
  <groupId>io.gatling</groupId>
  <artifactId>gatling-maven-plugin</artifactId>
  <version>4.3.0</version>
  <configuration>
    <simulationClass>simulations.PerfSimulation</simulationClass>
  </configuration>
</plugin>
```

### Step 3 — GraalVM-Compatible JavaScript

Karate 1.4+ uses **GraalVM JS** as its embedded scripting engine (replacing Nashorn).
Rules for writing GraalVM-safe JS in `.feature` files and `karate-config.js`:

| ❌ Legacy / Nashorn-only patterns | ✅ Use instead |
|----------------------------------|---------------|
| `importPackage`, `importClass` | `Java.type('com.example.MyClass')` |
| `with` statement | Rewrite without `with` |
| `var` in function scope leak | Use `var` inside `function fn()` wrapper only |
| JVM system property access in JS | `karate.properties['my.prop']` or `Java.type('java.lang.System').getProperty('my.prop')` |

> **Note**: OS environment variables (`System.getenv('MY_VAR')`) are **not** Nashorn-only and work
> under GraalVM. Use `karate.properties['name']` for JVM `-D` system properties, and
> `Java.type('java.lang.System').getenv('MY_VAR')` (or centralise via `karate-config.js`) for
> OS env vars.

### Step 4 — Maven Surefire Upgrade

```xml
<properties>
  <maven.surefire.version>3.2.5</maven.surefire.version>
</properties>
```

### Step 5 — GitHub Actions Modernisation

```yaml
- uses: actions/checkout@v4
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'        # 'adopt' is deprecated
- uses: mikepenz/action-junit-report@v4
```

### Step 6 — Review Compiler Flags

Avoid `<compilerArgument>-Werror</compilerArgument>` after dependency upgrades, as it treats all
compiler warnings as errors. Use targeted suppression annotations or remove the flag once the
upgrade stabilises.

---

## 3. Project Layout Convention

```
src/test/java/
├── karate-config.js          # Global config; one block per environment
├── features/
│   ├── users/
│   │   └── users.feature
│   └── orders/
│       └── orders.feature
├── shared/                   # @ignore reusable call targets
│   ├── create-resource.feature
│   └── auth.feature
└── data/                     # External test data (JSON, CSV)
    ├── users.json
    └── products.csv
```

---

## 4. Tag Conventions

| Tag | Meaning |
|-----|---------|
| `@run` | Included in the default CI run |
| `@ignore` | Reusable call target — never executed directly |
| `@wip` | Work in progress — excluded from CI |
| `@smoke` | Smoke test subset |
| `@regression` | Full regression suite |

```bash
# Run default CI suite
mvn clean test "-Dkarate.options=--tags @run"

# Run smoke tests only
mvn clean test "-Dkarate.options=--tags @smoke"

# Exclude WIP scenarios
mvn clean test "-Dkarate.options=--tags @run and not @wip"
```

---

*This skill is referenced by the agent registry in [`/AGENTS.md`](/AGENTS.md).*
