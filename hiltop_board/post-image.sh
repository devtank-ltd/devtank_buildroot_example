#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for arg in "$@"
do
	case "${arg}" in
		--add-miniuart-bt-overlay)
		if ! grep -qE '^dtoverlay=' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi (3B, 3B+, 3A+, 4B and Zero W) ttyAMA0 serial console
dtoverlay=miniuart-bt
__EOF__
		fi
		;;
		--aarch64)
		# Run a 64bits kernel (armv8)
		sed -e '/^kernel=/s,=.*,=Image,' -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		if ! grep -qE '^arm_64bit=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_64bit=1
__EOF__
		fi
		;;
		--gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
		# Set GPU memory
		gpu_mem="${arg:2}"
		sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		;;
	esac

done


grep hdmi_ignore_hotplug "${BINARIES_DIR}/rpi-firmware/config.txt" || \
  echo "hdmi_ignore_hotplug=1" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

grep enable_uart "${BINARIES_DIR}/rpi-firmware/config.txt" || \
  echo "enable_uart=1" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

grep hiltop "${BINARIES_DIR}/rpi-firmware/config.txt" || \
  echo "dtoverlay=hiltop" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

grep disable_splash "${BINARIES_DIR}/rpi-firmware/config.txt" || \
  printf "disable_splash=1\nboot_delay=0\n" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

grep sdtweak "${BINARIES_DIR}/rpi-firmware/config.txt" || \
  echo "dtoverlay=sdtweak,overclock_50=100" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

grep quiet "${BINARIES_DIR}/rpi-firmware/cmdline.txt" || \
  echo -n "root=/dev/mmcblk0p2 rootwait console=ttyAMA0,115200 quiet" > "${BINARIES_DIR}/rpi-firmware/cmdline.txt"


# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--loglevel 7 \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
