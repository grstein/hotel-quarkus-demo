# Quarkus demo: Hibernate ORM with Panache and RESTEasy

This is a minimal CRUD service exposing a couple of endpoints over REST with a front-end based on Vue.js

Original version [available here](https://github.com/quarkusio/quarkus-quickstarts/tree/master/hibernate-orm-panache-resteasy)

While the code is surprisingly simple, under the hood this is using:
 - RESTEasy to expose the REST endpoints
 - Hibernate ORM with Panache to perform the CRUD operations on the database
 - A PostgreSQL database; see below to run one via Docker
 - ArC, the CDI inspired dependency injection tool with zero overhead
 - The high performance Agroal connection pool
 - Infinispan based caching
 - All safely coordinated by the Narayana Transaction Manager

## Requirements

To compile and run this demo you will need:
- GraalVM - see [our Building native image guide](https://quarkus.io/guides/building-native-image-guide)
- Apache Maven `3.5.3+`

If you don't have GraalVM installed, you can download it here:

<https://github.com/oracle/graal/releases>

Installing GraalVM is very similar to installing any other JDK:
just unpack it, add it to your path, and point the `JAVA_HOME`
and `GRAALVM_HOME` environment variables to it.

You should then use this JDK to run the Maven build.


## Building the demo

After having set GraalVM as your JVM, go to 'hotel-quarkus' subfolder and build a static version of the site with `npm install && npm build dist`.
See below the 'Frontend development' documentation for more details.

Once the static part is built and you have copied the hotel-quarkus/dist folder to the src/resources/META-INF/resources, you can start the Quarkus app.

> mvn package

## Running the demo

### Prepare a PostgreSQL instance

First we will need a PostgreSQL database; you can launch one easily if you have Docker installed:

> docker run --ulimit memlock=-1:-1 -it --rm=true --memory-swappiness=0 --name quarkus_test -e POSTGRES_USER=quarkus_test -e POSTGRES_PASSWORD=quarkus_test -e POSTGRES_DB=quarkus_test -p 5432:5432 postgres:10.5

Alternatively you can setup a PostgreSQL instance in any another way.

The connection properties of the Agroal datasource are configured in the standard Quarkus configuration file, which you will find in
`src/main/resources/application.properties`.

### Run Quarkus in developer mode

To run the application in interactive mode (developer mode):

>  mvn compile quarkus:dev

In this mode you can make changes to the code and have the changes immediately applied, by just refreshing your browser.

    Hot reload works even when modifying your JPA entities.
    Try it! Even the database schema will be updated on the fly.

### Run Quarkus in JVM mode

When you're done playing with "dev-mode" you can run it as a standard Java application.

First compile it:

> mvn package

Then run it:

> java -jar ./target/hibernate-orm-panache-resteasy-1.0-SNAPSHOT-runner.jar

    Have a look at how fast it boots.
    Or measure total native memory consumption...

### Run Quarkus as a native application

This same demo can be compiled into native code: no modifications required.

This implies that you no longer need to install a JVM on your production environment, as the runtime technology is included in the produced binary, and optimized to run with minimal resource overhead.

Compilation will take a bit longer, so this step is disabled by default;
let's build again by enabling the `native` profile:

> mvn package -Dnative

After getting a cup of coffee, you'll be able to run this binary directly:

> ./target/hibernate-orm-panache-resteasy-1.0-SNAPSHOT-runner

    Please brace yourself: don't choke on that fresh cup of coffee you just got.
    
    Now observe the time it took to boot, and remember: that time was mostly spent to generate the tables in your database and import the initial data.
    
    Next, maybe you're ready to measure how much memory this service is consuming.

N.B. This implies all dependencies have been compiled to native;
that's a whole lot of stuff: from the bytecode enhancements that Panache
applies to your entities, to the lower level essential components such as the PostgreSQL JDBC driver, the Undertow webserver.

## See the demo in your browser

Navigate to:

<http://localhost:8080/index.html>

Have fun, and join the team of contributors!

# Frontend with Vue.JS

The `hotel-quarkus` folder is a Vue 3.8.2 web app application, createad with the Vue CLI tools.

Pre-requisite  : 
 - npm 6.9.0+
 
## Project setup

This will download all dependencies :

```
npm install
```

### Compiles and hot-reloads for development

Serve in dev mode, with hot reload at localhost:8080

```
npm run serve
```

### Compiles and minifies for production

```
npm run build
```


You can then copy this folder into src/main/resources/META-INF/resources
` cp -R dist/* ../src/main/resources/META-INF/resources/`


End of document