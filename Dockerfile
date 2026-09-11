# Step 1: Build PhantomSDR-Plus from source
FROM debian:bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    pkg-config \
    libfftw3-dev \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Rust via rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /build
RUN git clone https://github.com/PhantomSDR/PhantomSDR-Plus.git .
RUN cargo build --release

# Step 2: Minimal runtime image
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfftw3-double3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/target/release/phantomsdr-plus /app/phantomsdr-plus
COPY config.json /app/config.json

EXPOSE 8080
CMD ["./phantomsdr-plus", "-c", "config.json"]
