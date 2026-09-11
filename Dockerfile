# Step 1: Build PhantomSDR-Plus from source
FROM rust:1-slim-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    clang \
    cmake \
    pkg-config \
    libfftw3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone https://github.com/PhantomSDR/PhantomSDR-Plus.git .
RUN cargo build --release

# Step 2: Minimal runtime image
FROM debian:bookworm-slim

# Added apt-get update here to fix exit code 100
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfftw3-3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/target/release/phantomsdr-plus /app/phantomsdr-plus
COPY config.json /app/config.json

EXPOSE 8080
CMD ["./phantomsdr-plus", "-c", "config.json"]
