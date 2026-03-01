<p align="center">
  <a href="https://www.twitch.tv/charlyautomatiza"><img alt="Twitch" src="https://img.shields.io/badge/CharlyAutomatiza-Twitch-9146FF.svg" style="max-height: 300px;"></a>
  <a href="https://discord.gg/wwM9GwxmRZ"><img alt="Discord" src="https://img.shields.io/discord/944608800361570315" style="max-height: 300px;"></a>
  <a href="http://twitter.com/char_automatiza"><img src="https://img.shields.io/badge/@char__automatiza-Twitter-1DA1F2.svg?style=flat" style="max-height: 300px;"></a>
  <a href="https://www.youtube.com/channel/UCwEb6xrQtQCEuN_gNgi_Xfg?sub_confirmation=1"><img src="https://img.shields.io/badge/Charly%20Automatiza-Youtube-FF0000.svg" style="max-height: 300px;" style="max-height: 300px;"></a>
  <a href="https://www.linkedin.com/in/gautocarlos/"><img src="https://img.shields.io/badge/Carlos%20 Gauto-LinkedIn-0077B5.svg" style="max-height: 300px;" style="max-height: 300px;"></a>
</p>

<p align="center">
    <a href="https://karatelabs.github.io/karate/">
        <img alt="Karate DSL" src="https://raw.githubusercontent.com/karatelabs/karate/v0.9.6/karate-core/src/main/resources/res/karate-logo.svg" height="60" width="60" style="max-width: 100%;">
    </a>
</p>

# API Test Automation - Karate DSL For Restful and GraphQL APIs
## Starter project creado en vivo en stream de [Twitch.tv/CharlyAutomatiza](https://www.twitch.tv/charlyautomatiza) basado en [Karate DSL](https://karatelabs.github.io/karate/).

### Requerimientos generales

- Instalar algún cliente git como por ejemplo [git bash](https://git-scm.com/downloads) 

Descargar e instalar

- Java Development Kit 17 [(JDK)](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133155.html)
    - Asegurarse de tener configurada la variable de entorno **JAVA_HOME** con la ruta de la JDK respectiva.
    - En caso de tener otra versión anterior de la JDK, para que funcione el proyecto se deberá actualizar en el archivo [pom.xml](pom.xml) la propiedad **java.version**.
- Maven [(Maven)](https://maven.apache.org/download.cgi)
    - Asegurarse de tener configurada la variable de entorno **M2_HOME** o **PATH** con la ruta de la Maven respectiva.

### Instalación del framework de pruebas

**Clonar el repositorio:**

    git clone https://github.com/charlyautomatiza/starter-karate-dsl.git

**Para la ejecución de los test de API Rest situarse en la raíz del proyecto y ejecutar**

    mvn clean test

Para ejecutar un test específico de API Rest, por ejemplo del feature [users.feature](src/test/java/examples/users/users.feature) aquellos casos con el tag **@create_user**.

    mvn clean test "-Dkarate.options=--tags @create_user"

Para ejecutar un test específico de API GraphQL, por ejemplo del feature [users-gql.feature](src/test/java/examples/usersgql/users-gql.feature) aquellos casos con el tag **@graphql_examples**.

    mvn clean test "-Dkarate.options=--tags @graphql_examples"

Para ejecutar todos los tests tanto de API Rest como de GraphQL se puede ejecutar con el tag **@run**.

    mvn clean test "-Dkarate.options=--tags @run"

**Importante**: Se agrega un test fallido para tener ejemplo de como se visualizan los errores en el reporte.

**El reporte unificado de los resultados de los test**

Luego de cada ejecución se genera dentro de la carpeta **target/karate-reports** los reportes en formato html.

Para más detalle se puede consultar [la documetación oficial](https://karatelabs.github.io/karate/#test-reports)

### Github Actions para ejecutar los test de APIs

Nueva carpeta [**.github/workflows**](.github/workflows) con el archivo [**karate-test-runner.yml**](.github/workflows/karate-test-runner.yml) para ejecutar nuestros tests desde un pipeline de Github Actions.

JUnit Report obtenido desde [Marketplace de GitHub](https://github.com/marketplace/actions/junit-report-action)

El workflow está configurado para que se ejecute ante el siguiente evento:

* **push**: cuando se hace un push a un repositorio

---

### Karate Debugger — VS Code / IntelliJ

#### VS Code

1. Instalar la extensión oficial **Karate Runner** (`karatelabs.karate`).
2. Abrir cualquier archivo `.feature` — aparecerá el botón **▷ Run | Debug** encima de cada `Scenario`.
3. Para debugging con breakpoints, hacer clic en **Debug** en lugar de **Run**.
4. El debugger se conecta automáticamente al puerto `8000` (configurable en los settings de la extensión).

#### IntelliJ IDEA

1. Instalar el plugin **Karate** desde *Settings → Plugins → Marketplace*.
2. Hacer clic derecho sobre cualquier `.feature` o `Scenario` → **Run / Debug**.
3. Para debugging remoto, agregar la configuración de JVM en el runner JUnit 5:

```java
// src/test/java/examples/ExamplesTest.java — agregar argLine para debug remoto
// Ejecutar con: mvn test -Dmaven.surefire.debug
```

---

### Ejecución en CI/CD con Tags Dinámicos

Ejecutar todos los tests del pipeline:

    mvn clean test "-Dkarate.options=--tags @run"

Ejecutar sólo tests de smoke:

    mvn clean test "-Dkarate.options=--tags @smoke"

Ejecutar regresión completa:

    mvn clean test "-Dkarate.options=--tags @regression"

Excluir tests en progreso:

    mvn clean test "-Dkarate.options=--tags @run and not @wip"

Especificar entorno de ejecución:

    mvn clean test -Dkarate.env=staging "-Dkarate.options=--tags @run"

Ejecutar en paralelo (por ejemplo, 5 threads):

    mvn clean test -Dkarate.options="--tags @run" -Dkarate.threads=5

---

### AI Co-pilot — Skills Instalados

Este repositorio incluye contexto de IA estructurado según el protocolo de Anthropic para que GitHub Copilot y otros asistentes ofrezcan sugerencias precisas para Karate DSL.

#### Archivos de contexto

| Archivo | Ubicación | Propósito |
|---------|-----------|-----------|
| `AGENTS.md` | `/AGENTS.md` | Define los agentes de IA disponibles (Automation Agent, Performance & Mock Agent) |
| `SKILL.md` | `.github/skills/karate-core/SKILL.md` | Sintaxis moderna, fuzzy matchers, aserciones de schema, roadmap de upgrade |
| `copilot-instructions.md` | `.github/copilot-instructions.md` | Reglas estrictas de generación de código para Copilot |

#### Cómo invocar los Skills en Copilot Chat

```
@workspace /explain Carga el skill karate-core y explica cómo usar fuzzy matchers en este proyecto
```

```
@workspace Basándote en .github/skills/karate-core/SKILL.md, genera un nuevo scenario para el endpoint /posts con validación de schema
```

```
@workspace Revisa users.feature y sugiere mejoras usando los patrones definidos en AGENTS.md
```

#### Skills disponibles

- **karate-core** (`.github/skills/karate-core/SKILL.md`): Sintaxis nativa Karate, matchers avanzados, schema assertions, guía de migración a 2026.