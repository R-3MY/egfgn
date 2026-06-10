FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline

RUN dart compile exe bin/main.dart -o bin/main

FROM scratch

LABEL org.opencontainers.image.source=https://github.com/R-3MY/EGFGN
LABEL org.opencontainers.image.description="EpicGames Free Game Notifier (EGFGN) - A modular Dart CLI to notify Discord channels about free games."

COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /main

CMD ["/main"]