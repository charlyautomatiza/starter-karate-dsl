# SKILL.md — karate-core

## Metadata

| Field | Value |
|-------|-------|
| **Name** | karate-core |
| **Description** | Core Karate DSL skill: native syntax, fuzzy matchers, schema assertions, and upgrade roadmap for the starter-karate-dsl project |
| **Version** | 1.0.0 |
| **Karate Version** | 1.5.0 (io.karatelabs) |
| **Java Version** | 17 |
| **Last Updated** | 2026-03 |

---

## 1. Modern Syntax Reference

### 1.1 Base URL & Path

```gherkin
Background:
  * url 'https://jsonplaceholder.typicode.com'

Scenario: get a user by id
  Given path 'users', 1
  When method GET
  Then status 200
```

### 1.2 Fuzzy Matchers

Use fuzzy matchers instead of hard-coding dynamic values:

```gherkin
# Exact match
And match response.name == 'Leanne Graham'

# Type-only match (fuzzy)
And match response.id    == '#number'
And match response.email == '#string'
And match response.phone == '#regex ^[\\d\\s\\-\\.\\(\\)x]+$'

# Optionality
And match response.website == '##string'   # present but can be null

# Collection matchers
And match response.address == '#object'
And match response.tags    == '#[] #string'   # array of strings
```

### 1.3 Schema Assertion (JSON Schema-style)

Define a schema once and reuse it across scenarios:

```gherkin
* def addressSchema =
  """
  {
    street:  '#string',
    suite:   '#string',
    city:    '#string',
    zipcode: '#regex ^[\\d]{5}-[\\d]{4}$',
    geo: {
      lat: '#string',
      lng: '#string'
    }
  }
  """

* def userSchema =
  """
  {
    id:       '#number',
    name:     '#string',
    username: '#string',
    email:    '#regex ^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$',
    address:  '#(addressSchema)',
    phone:    '#string',
    website:  '#string',
    company:  '#object'
  }
  """

Given path 'users', 1
When method GET
Then status 200
And match response == userSchema
```

### 1.4 Reusable `call` Pattern

Create a shared feature for common API operations:

```gherkin
# shared/get-user.feature
@ignore
Feature: reusable get-user call

Scenario:
  Given path 'users', userId
  When method GET
  Then status 200
```

```gherkin
# Caller feature
* def result = call read('classpath:shared/get-user.feature') { userId: 1 }
* match result.response.name == '#string'
```

### 1.5 `karate.match()` in JavaScript blocks

```gherkin
* def validateUser =
  """
  function(user) {
    var result = karate.match(user, { id: '#number', name: '#string' });
    if (!result.pass) karate.fail('user schema mismatch: ' + result.message);
  }
  """

* call validateUser response
```

### 1.6 Data-Driven with `Scenario Outline`

```gherkin
Scenario Outline: create users from table
  Given url 'https://jsonplaceholder.typicode.com/users'
  And request { name: '<name>', username: '<username>', email: '<email>' }
  When method POST
  Then status 201
  And match response.name == '<name>'

Examples:
  | name        | username  | email             |
  | Alice Smith | alice     | alice@example.com |
  | Bob Jones   | bjones    | bob@example.com   |
```

### 1.7 External CSV/JSON for Data-Driven Tests

```gherkin
* def users = read('classpath:data/users.json')

Scenario Outline: validate each user
  Given path 'users', <id>
  When method GET
  Then status 200
  And match response.username == '<username>'

Examples:
  | karate.setup() |
  | users          |
```

Or with a direct table call:

```gherkin
* table users
  | id | username  |
  | 1  | Bret      |
  | 2  | Antonette |

* def validateAll =
  """
  function() {
    users.forEach(function(u) {
      var res = karate.call('classpath:shared/get-user.feature', { userId: u.id });
      karate.match(res.response.username, u.username);
    });
  }
  """
* call validateAll
```

### 1.8 GraphQL Requests

```gherkin
Background:
  * url 'https://graphqlzero.almansi.me/api'

Scenario: fetch user posts via GraphQL
  Given text query =
    """
    {
      user(id: 1) {
        posts { data { id title } }
      }
    }
    """
  And request { query: '#(query)' }
  When method POST
  Then status 200
  And match $.data.user.posts.data[0] contains { id: '1' }
```

### 1.9 `configure` Settings

```gherkin
# In karate-config.js or Background:
* configure connectTimeout = 10000
* configure readTimeout    = 30000
* configure ssl            = true
* configure followRedirects = false
* configure headers        = { 'Accept': 'application/json', 'Content-Type': 'application/json' }
```

---

## 2. Upgrade Roadmap (→ 2026 Standard)

### Step 1 — Verify Karate Version

Current `pom.xml` already uses `io.karatelabs:karate-junit5:1.5.0` ✅

To upgrade to the latest release:

```xml
<properties>
  <karate.version>1.5.0</karate.version>  <!-- bump to latest io.karatelabs release -->
</properties>

<dependency>
  <groupId>io.karatelabs</groupId>
  <artifactId>karate-junit5</artifactId>
  <version>${karate.version}</version>
  <scope>test</scope>
</dependency>
```

### Step 2 — Switch to Official Karate Labs Reports

Add the `karate-core` HTML report (already included transitively with `karate-junit5`).
For richer Karate Labs dashboard reports, configure the `KarateReporter`:

```xml
<!-- Optional: Karate Gatling for performance -->
<dependency>
  <groupId>io.karatelabs</groupId>
  <artifactId>karate-gatling</artifactId>
  <version>${karate.version}</version>
  <scope>test</scope>
</dependency>
```

### Step 3 — GraalVM-Compatible JavaScript

Karate 1.4+ uses **GraalVM JS** as its embedded scripting engine (replacing Nashorn).

Rules for writing GraalVM-safe JS in `.feature` files and `karate-config.js`:

| ❌ Avoid (Nashorn-only) | ✅ Use instead |
|------------------------|---------------|
| `java.lang.System.getenv()` called directly in JS | `karate.properties['MY_VAR']` |
| `importPackage`, `importClass` | `Java.type('com.example.MyClass')` |
| `with` statement | Rewrite without `with` |
| `var` in function scope leak | Use `var` inside `function fn()` wrapper only |

Current `karate-config.js` is GraalVM-compatible ✅

### Step 4 — Maven Surefire Upgrade

```xml
<properties>
  <maven.surefire.version>3.2.5</maven.surefire.version>  <!-- was 2.22.2 -->
</properties>
```

### Step 5 — GitHub Actions Modernisation

Update `.github/workflows/karate-test-runner.yml` to use current action versions:

```yaml
- uses: actions/checkout@v4         # was v2
- uses: actions/setup-java@v4       # was v2
  with:
    java-version: '17'
    distribution: 'temurin'         # was 'adopt' (deprecated)
- uses: mikepenz/action-junit-report@v4  # was v2
```

### Step 6 — Remove Compiler `-Werror` Flag (Optional)

The current `pom.xml` uses `<compilerArgument>-Werror</compilerArgument>`.
This treats all compiler warnings as errors and may block builds after dependency upgrades.
Consider switching to `<compilerArgs>` with targeted suppressions or remove it once the upgrade stabilises.

---

## 3. Real Examples from This Repository

### REST — Get Users (`users.feature`)

The existing test chain (get all → get first by id) can be enhanced with schema validation:

```gherkin
@get_users
Scenario: get all users and validate schema of first result
  Given path 'users'
  When method GET
  Then status 200
  And match response == '#[] #object'

  * def first = response[0]
  * match first.id      == '#number'
  * match first.name    == '#string'
  * match first.email   == '#string'

  Given path 'users', first.id
  When method GET
  Then status 200
  And match response == { id: '#number', name: '#string', username: '#string', email: '#string', address: '#object', phone: '#string', website: '#string', company: '#object' }
```

### GraphQL — User by ID with File Query (`users-gql.feature`)

The existing parametrised scenario uses `read('./queries/user-by-id.graphql')` — this is the recommended approach ✅.
Add schema assertion for the nested address:

```gherkin
* def geoSchema = { lat: '#string', lng: '#string' }
And match response.data.user.address.geo == geoSchema
```

---

*This skill is loaded by the Karate Automation Agent defined in [`/AGENTS.md`](/AGENTS.md).*
