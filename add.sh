#!/bin/bash

HOST=$1
PORT=${2:-443}
JAVA_HOME=`/usr/libexec/java_home`
KEYSTORE=${JAVA_HOME}/jre/lib/security/cacerts

if [ -x $HOST ]; then
  echo "need hostname"
  exit 1
fi

# Access server, and retrieve certificate (accept default certificate 1)
echo | java InstallCert $HOST:$PORT

# Extract certificate from created jssecacerts keystore
keytool -exportcert -alias ${HOST}-1 -keystore jssecacerts -storepass changeit -file ${HOST}.cer

# Import certificate into system keystore
echo "yes" | sudo keytool -importcert -alias $HOST -keystore $KEYSTORE -storepass changeit -file ${HOST}.cer

