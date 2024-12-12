#!/bin/bash

APP=$1
VERSION=$2

set -e 
set -o pipefail

if [[ -z ${APP} ]]; then
    echo 'No app with that name, exiting'
    exit 1
fi

if [[ -z ${VERSION} ]]; then
    docker buildx build -t davidfdezalcoba/${APP}:latest ./${APP}
    docker push davidfdezalcoba/${APP}:latest
else
    ARG="$(echo ${APP} | tr '[:lower:]' '[:upper:]')_VERSION"
    docker buildx build --build-arg ${ARG}=${VERSION} -t davidfdezalcoba/${APP}:${VERSION} ./${APP}
    docker push davidfdezalcoba/${APP}:${VERSION}
fi
