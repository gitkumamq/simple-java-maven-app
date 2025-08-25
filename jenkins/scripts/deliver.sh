#!/usr/bin/env bash

echo 'Installing Maven-built Java application into the local Maven repository.'
set -x
mvn clean package install
set +x

echo 'Extracting the <name> element from pom.xml'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | grep -Ev '^\[|Download')
set +x

echo 'Extracting the <version> element from pom.xml'
set -x
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | grep -Ev '^\[|Download')
set +x

JAR_FILE="target/${NAME}-${VERSION}.jar"
echo "Resolved JAR file path: ${JAR_FILE}"

if [[ -f "$JAR_FILE" ]]; then
    echo "Running the Java application:"
    set -x
    java -jar "$JAR_FILE"
    set +x
else
    echo "❌ ERROR: JAR file not found: $JAR_FILE"
    echo "       Check that 'mvn package' succeeded and the artifact is in the target/ directory."
    exit 1
fi
