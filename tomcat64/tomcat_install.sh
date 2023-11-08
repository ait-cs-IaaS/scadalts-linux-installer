#!/bin/bash
export CATALINA_HOME="$1"
TOMCAT_MAJOR_VERSION="$2"
TOMCAT_MINOR_VERSION="$3"
TOMCAT_PATCH_VERSION="$4"

TOMCAT_VERSION="${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION}"
TOMCAT_DEST="apache-tomcat-${TOMCAT_VERSION}"
TOMCAT_TAR_GZ_FILE="${TOMCAT_DEST}.tar.gz"

mkdir -p "$CATALINA_HOME"
cd "$CATALINA_HOME"
wget "https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR_GZ_FILE}"
tar -xvf "${TOMCAT_TAR_GZ_FILE}" -C "$CATALINA_HOME"
cd "$CATALINA_HOME/${TOMCAT_DEST}"
mv * "$CATALINA_HOME"
cd ..
rm -rf "${TOMCAT_DEST}"
rm -f "${TOMCAT_TAR_GZ_FILE}"
echo "Tomcat version ${TOMCAT_VERSION} installed"