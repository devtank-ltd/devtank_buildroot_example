#!/bin/sh

BOARD_DIR="$(dirname $0)"

set -u
set -e

# Add host qemu
if [ -e /usr/bin/qemu-arm-static ]; then
    cp /usr/bin/qemu-arm-static ${TARGET_DIR}/usr/bin/
fi

# Add DT blob for touch screen : https://www.raspberrypi.org/documentation/hardware/computemodule/cmio-display.md
cp "${BOARD_DIR}/dt-blob.bin" "${BINARIES_DIR}"

# Copy Hiltop overlay.
mkdir -p "${BINARIES_DIR}/overlays"
cp "${BUILD_DIR}"/linux-*/arch/arm/boot/dts/overlays/hiltop.dtbo "${BINARIES_DIR}/overlays"

# Add groups
if [ -e "${TARGET_DIR}/etc/group" ]; then
    grep iio "${TARGET_DIR}/etc/group" || echo "
iio:x:200:
spi:x:201:
i2c:x:202:
gpio:x:203:
" >> "${TARGET_DIR}/etc/group"
fi

# Add data disk mount point
mkdir -p "${TARGET_DIR}/mnt/data"

# Remove default Xort starting script.
rm -f "${TARGET_DIR}/etc/init.d/S40xorg"
