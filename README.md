<p align="center">
    <a href="https://karatelabs.github.io/karate/">
        <img alt="Karate DSL" src="https://raw.githubusercontent.com/karatelabs/karate/v0.9.6/karate-core/src/main/resources/res/karate-logo.svg" height="60" width="60" style="max-width: 100%;">
    </a>
</p>

# API Test Automation - Karate DSL For Restful and GraphQL APIs
## Starter project creado en vivo en stream de Twitch de [@CharlyAutomatiza](https://www.twitch.tv/charlyautomatiza) basado en [Karate DSL](https://karatelabs.github.io/karate/).

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
