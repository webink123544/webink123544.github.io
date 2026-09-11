# Step 1: Build PhantomSDR-Plus (C++ backend) from source
FROM debian:bookworm AS builder

# Prevent interactive prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install CA certificates first, then the actual C++ dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    pkg-config \
    meson \
    ninja-build \
    libusb-1.0-0-dev \
    libfftw3-dev \
    libwebsocketpp-dev \
    libflac++-dev \
    zlib1g-dev \
    libzstd-dev \
    libboost-all-dev \
    libopus-dev \
    libliquid-dev \
    psmisc \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
# Clone the official repository
RUN git clone https://github.com/sv1btl/PhantomSDR-Plus.git .

# Build using Meson and Ninja
RUN meson setup build --buildtype=release \
    && meson compile -C build

# Step 2: Minimal runtime image
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies and certificates
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libfftw3-double3 \
    libfftw3-single3 \
    libboost-system1.81.0 \
    libboost-iostreams1.81.0 \
    libzstd1 \
    libflac++6v5 \
    libopus0 \
    libliquid2d \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the compiled spectrumserver binary
COPY --from=builder /build/build/spectrumserver /app/spectrumserver
COPY config.json /app/config.json

EXPOSE 8080
CMD ["./spectrumserver", "--config", "config.json"]
