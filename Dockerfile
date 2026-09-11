FROM ghcr.io/phantomsdr/phantomsdr-plus:latest

WORKDIR /app
COPY config.json /app/config.json

EXPOSE 8080
CMD ["./phantomsdr-plus", "-c", "config.json"]
