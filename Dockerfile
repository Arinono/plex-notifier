FROM google/dart as builder

WORKDIR /app

COPY pubspec.* /app/
RUN pub get
COPY . .
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "/app/bin/main.dart"]

