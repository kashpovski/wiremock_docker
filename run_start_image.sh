#!/usr/bin/env bash

docker run -it --rm \
  -p 8080:8080 \
  --name wiremock \
  -v $PWD/protos/mock.proto:/home/wiremock/protos/mock.proto \
  custom/wiremock_grpc:3.5.2
