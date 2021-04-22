# Xtext-DSLs

This repository contains Xtext DSL projects that will be used by Custom-MADE Xtext-WebUI (see https://github.com/schubmat/Custom-MADE/). The languages come along with:

* a DSL project
* an `...ide` project containing the language server for the specified DSL (cf. [Language Server Protocol](https://github.com/Microsoft/language-server-protocol))
* a test project
* a websocket project that is wrapping the language server so that it can be tied to another application


## Quickstart

- Run `./gradlew run`

This will start the server with the help of `org.xtext.example.mydsl.websockets.RunWebSocketServer3`.

## Project Structure

- `org.xtext.example.mydsl` (contains the DSL)
- `org.xtext.example.mydsl.ide` (contains the DSL specific customizations of the Xtext language server)
- `org.xtext.example.mydsl.tests`
- `org.xtext.example.mydsl.websockets` (contains the code to launch a websocket and the language server and tie them to each other)

## Building in Details

1. Make sure that `java -version` is executable and pointing to a Java 11 JDK or a Java 13 JDK.

### Scenario 1 -- build and run the LSP binary

1. Run `./gradlew distZip`.
2. Go to zip file of the ide sub project (, e.g. `find . -name "*ide*zip"`)
3. Inflate it
4. Find the binary file `mydsl-socket`, and
5. start it as follows:
   - `./mydsl-socket [PORT_THE_LSP_SHOULD_RUN_ON]`, e.g., `./mydsl-socket 38123`

### Scenario 2 -- install the language into the local Maven repository

1. Set the language name in `settings.gradle` file with the help of the `rootProject.name` attribute. Do it, for instance, as follows:
   - `rootProject.name = '[PROJECT_NAME]'`,
   - e.g., `rootProject.name = 'grammar_MDR_simplified'`
2. Set the language version in `gradle.properties` file as follows:
   - `version = [VERSION]`, 
   - e.g., `version = 1.0.0-SNAPSHOT`
3. Run `./gradlew install`.

### Scenario 3 -- client-only with separate server process

1. Run `./gradlew run` or launch RunServer from Eclipse.