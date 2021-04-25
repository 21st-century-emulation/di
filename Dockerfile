FROM ubuntu:20.04 AS build

RUN apt-get update && \
    apt-get install apt-transport-https curl gnupg2 -y && \
    sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' && \
    apt-get update && \
    apt-get install dart -y

WORKDIR /app

# Download dependencies
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

COPY bin/ bin/

RUN dart compile exe bin/run.dart -o bin/run

FROM ubuntu:20.04 AS runtime

WORKDIR /app
COPY --from=build /app/bin/run run

ENTRYPOINT ["./run"]