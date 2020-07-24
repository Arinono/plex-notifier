FROM google/dart:2.8 as dart-runtime

WORKDIR /app

ARG DISCORD_BOT_TOKEN
ARG DISCORD_CLIENT_ID

COPY pubspec.* /app/
RUN pub get
COPY . .
RUN pub get --offline
RUN mkdir build
RUN dart2native -DDISCORD_CLIENT_ID=${DISCORD_CLIENT_ID} -DDISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN} bin/main.dart -o build/server

FROM frolvlad/alpine-glibc

COPY --from=dart-runtime /app/build/server /server
RUN mkdir /images
RUN apk add --no-cache curl

CMD []
ENTRYPOINT [ "/server" ]
