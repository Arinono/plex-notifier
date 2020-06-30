FROM google/dart:2.8 as dart-runtime

WORKDIR /app

ARG DISCORD_BOT_TOKEN
ARG DISCORD_CLIENT_ID

COPY pubspec.* /app/
RUN pub get
COPY . .
RUN pub get --offline
RUN mkdir build
RUN dart2native -DPORT="5000" -DDISCORD_CLIENT_ID=${DISCORD_CLIENT_ID} -DDISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN} bin/main.dart -o build/server

FROM ubuntu:xenial

COPY --from=dart-runtime /app/build/server /server

# Used if i'd like to use a smaller image, such as alpine or scratch
# But when I do, I get this error: SocketException: Failed host lookup: 'discord.com' (OS Error: System error, errno = -11)
# COPY --from=dart-runtime /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
# COPY --from=dart-runtime /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
# COPY --from=dart-runtime /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
# COPY --from=dart-runtime /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
# COPY --from=dart-runtime /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
# COPY --from=dart-runtime /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1

CMD []
ENTRYPOINT [ "/server" ]
