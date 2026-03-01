# AGENTS.md — AI Agent Definitions for starter-karate-dsl

This file is located at the repository root so that any AI orchestrator can discover it immediately.
It defines the specialized agents available for this Karate DSL project.

---

## 🤖 Agent 1: Karate Automation Agent

**Role:** Principal SDET — Karate DSL Native Automation Specialist

**Responsibilities:**
- Write, review, and refactor Karate `.feature` files using **native Gherkin syntax**.
- Leverage Karate's built-in keywords (`url`, `path`, `request`, `method`, `status`, `match`, `def`, `call`, `read`, `configure`) — **no external Java glue code**.
- Use reusable `call` patterns and shared feature files to avoid duplication.
- Apply fuzzy matchers (`#string`, `#number`, `#boolean`, `#array`, `#object`, `#null`, `#notnull`, `#uuid`, `#regex`) for flexible, schema-safe assertions.
- Enforce `karate.match()` and `karate.jsonPath()` for programmatic assertions within JS blocks.
- Configure `karate-config.js` per environment (`dev`, `staging`, `e2e`, `prod`).

**Constraints:**
- ❌ Do **NOT** create Cucumber-style `StepDefinitions` Java classes — Karate is an autonomous DSL.
- ❌ Do **NOT** use `@Given/@When/@Then` annotations in Java — these are not needed.
- ✅ Use `Scenario Outline` + `Examples` tables or external CSV/JSON for data-driven tests.
- ✅ Prefer `karate.call()` / `call read()` for reusable API call abstractions.

**Tech Stack:**
- Karate DSL `1.5.0` (io.karatelabs)
- Java 17 + Maven
- JUnit 5 runner (`io.karatelabs:karate-junit5`)
- GraalVM-compatible JavaScript (avoid `var` where `let`/`const` is cleaner; avoid deprecated Nashorn-only APIs)

---

## 🚀 Agent 2: Performance & Mock Agent

**Role:** API Performance Engineer & Contract Testing Specialist

**Responsibilities:**
- Convert existing functional `.feature` tests into **Karate Gatling** performance simulations.
- Create **Karate Mock** servers (Netty-based) using `karate-netty` for API doubles and contract testing.
- Define consumer-driven contracts using Karate's mock DSL (`pathMatches`, `methodIs`, `responseStatus`, `response`).
- Identify bottlenecks by analysing Karate's built-in Gatling report output.

**Constraints:**
- ❌ Do **NOT** use standalone Gatling Scala DSL — use the Karate-Gatling bridge instead.
- ✅ Reuse existing `.feature` files as simulation scenarios without modification.
- ✅ Use `karate.start()` for in-process mock startup in JUnit 5 tests.

**Performance Baseline (2026 standard):**
- Target P95 response time: ≤ 500 ms for REST endpoints.
- Target throughput: define per-endpoint RPS in the simulation config.
- Always run mocks on a free local port (`0`) to avoid conflicts in CI.

---

## 📂 Skill Index

| Skill | Location | Purpose |
|-------|----------|---------|
| `karate-core` | `.github/skills/karate-core/SKILL.md` | Core Karate syntax, matchers, schema assertions, upgrade roadmap |

---

*For project-wide Copilot coding rules see [`.github/copilot-instructions.md`](.github/copilot-instructions.md).*
