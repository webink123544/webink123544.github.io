# Step 1: Build PhantomSDR-Plus backend
FROM debian:bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
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
    libcurl4-openssl-dev \
    libliquid-dev \
    psmisc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone https://github.com/sv1btl/PhantomSDR-Plus.git .

# Pass extra compiler flags to suppress treat-as-error warnings on GCC 12
RUN meson setup build --buildtype=release -Dc_args="-Wno-error" -Dcpp_args="-Wno-error" \
    && meson compile -C build

# Step 2: Minimal runtime stage
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libfftw3-single3 \
    libfftw3-double3 \
    libboost-system-dev \
    libboost-iostreams-dev \
    libzstd1 \
    libopus0 \
    libcurl4 \
    libliquid2d \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy executable and configuration
COPY --from=builder /build/build/spectrumserver /app/spectrumserver
COPY config.json /app/config.json

EXPOSE 8080
CMD ["./spectrumserver", "-c", "config.json"]
