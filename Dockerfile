FROM wiremock/wiremock:3.5.2

COPY ./extensions /var/wiremock/extensions

RUN mkdir /home/wiremock/grpc
RUN apt-get update && apt install -y protobuf-compiler

CMD echo "Generate stub for protobuf" \
&& protoc -I./protos --descriptor_set_out ./grpc/services.dsc mock.proto \
| echo "start wiremock" \
&& /docker-entrypoint.sh --global-response-templating --disable-gzip --verbose
