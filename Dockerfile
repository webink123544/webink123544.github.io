FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install pre-built sdrpp dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    libfftw3-single3 \
    libvolk2.5 \
    libglfw3 \
    libglew2.2 \
    libairspyhf0 \
    libiio0 \
    libad9361-0 \
    librtlsdr0 \
    libportaudio2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download pre-compiled SDR++ release directly to avoid compiling
RUN wget https://github.com/AlexandreRouma/SDRPlusPlus/releases/latest/download/sdrpp_debian_bookworm_amd64.deb \
    && dpkg -i sdrpp_debian_bookworm_amd64.deb \
    && rm sdrpp_debian_bookworm_amd64.deb

EXPOSE 7342
CMD ["sdrpp", "-s"]
