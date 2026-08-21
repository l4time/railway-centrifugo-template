FROM centrifugo/centrifugo:v6.9.2@sha256:f89352e38ef8043aaaa9045dec41cc8f2d35075b86ff553d4091ac19b547a3a6

LABEL org.opencontainers.image.title="Centrifugo on Railway" \
      org.opencontainers.image.description="Minimal Railway wrapper for a digest-pinned Centrifugo 6.9.2 image" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/l4time/railway-centrifugo-template" \
      org.opencontainers.image.version="6.9.2"

EXPOSE 8000 9000
