# hub-ses-demo Project

This project is a template of MicroServices using Red Hat's Camel Extensions for Quarkus.

## Requirements

You need Red Hat's build of OpenJDK 17. You can download it from [here](https://developers.redhat.com/products/openjdk/download).

You also need AMQ Broker 7.10.0 which can be downloaded from [here](https://developers.redhat.com/content-gateway/file/amq-broker-7.10.0-bin.zip)

# Configure your environment

The files under the config/ directory define the properties for your environment.
Edit the properties in config/local/*.properties to match your local environment, then set the QUARKUS_CONFIG_LOCATION variable to point to those properties file:

```
export QUARKUS_CONFIG_LOCATIONS=/path/to/config/local/ses-common-local.properties,/path/to/config/local/ses-service-local.properties
```
# Starting the AMQ Broker
## Create an AMQ Broker
If you don't have an Artemis broker created already, create an Artemis broker by running the following command from within the AMQ directory:
```
./bin/artemis create brokers/quarkus-jms
```

## Starting the AMQ Broker
In a dedicated terminal, start the AMQ broker by running the command:
```
cd amq-broker-7.10.x/brokers/quarkus-jms
./bin/artemis run
```

## Running the microservices in dev mode

You can run the microservices in dev mode that enables live coding using:
```shell script
# Compile everything so that the shared library can be loaded by the microservices
./mvnw clean install -Dmaven.test.skip=true
# Run the first microservice in dev mode
export QUARKUS_CONFIG_LOCATIONS=/path/to/config/local/ses-common-local.properties,/path/to/config/local/ses-service-local.properties
./mvnw -pl ses-service quarkus:dev
```

> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at http://localhost:8080/q/dev/.

## Packaging and running the application

You can package the microservice by using:
```shell script
./mvnw package
```
It produces the `quarkus-run.jar` file in the `target/quarkus-app/` directory of each microservice.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/quarkus-app/lib/` directory.

The microservices are now runnable using `java -jar target/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:
```shell script
./mvnw package -Dquarkus.package.type=uber-jar
```

The microservices, packaged as an _über-jar_, are now runnable using `java -jar target/*-runner.jar`.

# Browsing the REST OpenAPI definition

The openAPI definition of your rest services is available under http://localhost:8080/api

# Testing the endpoints

```
testrunner.sh -e http://localhost:8080 EDE_EndToEndTest.xml -s EDETestSuite -c EDE_TestCases
```

# Deploying the application on OpenShift

# Using the docker-maven-plugin with podman
To can configure the `maven-docker-plugin` to use podman by running the following commands:

```
systemctl enable --now --user podman.socket
export DOCKER_HOST=/run/user/1000/podman/podman.sock
```

## Create the Container Image

```
podman build -f cicd/shared/Containerfile -t quarkus/ses-service ses-service
# or using Maven:
./mvnw docker:build -pl ses-service
```

## Run the Container Image
```
podman run quarkus/ses-service
# or using Maven:
./mvnw docker:run -pl ses-service
```

## Push the container image to OpenShift

```
REGHOST=`oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}'`
podman login -u myid -p $(oc whoami -t) ${REGHOST}
podman tag localhost/quarkus/ses-service:latest $REGHOST/`oc project -q`/ses-service:latest
podman push $REGHOST/`oc project -q`/ses-service:latest

```

## Create the OpenShift Resources
```
helm template ses -f values-IMP1B.yaml -f values.yaml -f secrets-IMP1B.yaml . --output-dir /tmp/helm

oc create -f /tmp/helm.yaml

```

OR

Go to the ses-config Repository, then run:
```
helm template ses-service . | oc apply -f -
```

# JMeter testing
You can run the JMeter tests for a specific project by running:
```
# Replace ses-service with your project name
./mvnw clean compile jmeter:configure jmeter:jmeter -pl ses-service
```
This generates the test report under `ses-service/target/jmeter/results` in `.csv` format.

You can also change the target hostname and port by passing them as properties to the `compile` phase:
```
./mvnw clean compile jmeter:configure jmeter:jmeter -pl ses-service -Pjmeter.target.host=my-remote-host -Pjmeter.target.port=8181
```
# Related Guides

- Camel REST OpenApi ([guide](https://camel.apache.org/camel-quarkus/latest/reference/extensions/rest-openapi.html)): Configure REST producers based on an OpenAPI specification document delegating to a component implementing the RestProducerFactory interface
- Camel Rest ([guide](https://access.redhat.com/documentation/en-us/red_hat_integration/2.latest/html/camel_extensions_for_quarkus_reference/extensions-rest)): Expose REST services and their OpenAPI Specification or call external REST services
- 
