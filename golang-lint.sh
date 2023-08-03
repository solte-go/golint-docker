#!/bin/bash
CACHE_DIR="/tmp/golint-docker-$USER"
DEFAULT_CONFIG="./.golangci.yml"
FOLDER=$(pwd)

mkdir -p "$CACHE_DIR"

if [ -f "$DEFAULT_CONFIG" ]; then
    n=$(basename "$DEFAULT_CONFIG")
    config_file=("-v" "${DEFAULT_CONFIG}:/$n")
    printf "config file will be used: %s\n" "$DEFAULT_CONFIG"
fi


docker run \
    --rm -t \
    --user "$(id -u):$(id -g)" \
    -v "$CACHE_DIR:/.cache" \
    -v "$(go env GOPATH)/pkg:/go/pkg" \
    -v "${FOLDER}/:/app" \
    "${config_file[@]}" \
    --workdir /app \
    golangci/golangci-lint \
    golangci-lint run
