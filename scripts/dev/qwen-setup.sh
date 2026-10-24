#!/usr/bin/env bash
# Idempotent bootstrap for OpenMW-MP dev environments. Safe to re-run.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

$SUDO apt-get update -qq
$SUDO apt-get install -y --no-install-recommends \
  build-essential cmake ninja-build ccache pkg-config git curl \
  libboost-dev libboost-system-dev libboost-filesystem-dev \
  libboost-iostreams-dev libboost-program-options-dev \
  libsdl2-dev liblz4-dev libpng-dev libjpeg-dev libtinyxml2-dev libunshield-dev \
  libssl-dev libsodium-dev libprotobuf-dev protobuf-compiler \
  libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libswresample-dev \
  libopenal-dev clang-format clang-tidy rustc cargo
# NOTE: Qt/OSG/VSG intentionally absent: server build is headless.

# GameNetworkingSockets: prefer submodule, fallback to shallow clone
# (fallback will be removed by issue #1 when GNS becomes a proper submodule).
if [ ! -d extern/GameNetworkingSockets/src ]; then
  git clone --depth 1 https://github.com/ValveSoftware/GameNetworkingSockets \
    extern/GameNetworkingSockets || true
fi
if [ -d extern/GameNetworkingSockets/src ] && [ ! -f /usr/local/lib/libgame_networking_sockets.a ]; then
  cmake -S extern/GameNetworkingSockets -B /tmp/gns-build -G Ninja \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF
  cmake --build /tmp/gns-build && $SUDO cmake --install /tmp/gns-build
fi

ccache --max-size 20G || true
echo "=== qwen-setup: OK ==="