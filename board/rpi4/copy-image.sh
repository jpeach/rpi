#! /usr/bin/env bash

# copy-image.sh: rpi1 image copying script.
#
# This script copies a rpi4 SD card image to an SD card device. It assumes
# there are 2 partitions, the first being the boot filesystem, the second
# being the root filesystems. The foot filesystem is exanded to fill all
# the remaining space on the SD card device.

set -o errexit
set -o pipefail

readonly MB=$((1024 * 1024))
readonly ROOT_DIR=$(cd $(dirname $0) && pwd)

readonly DEVICE=${DEVICE:-/dev/mmcblk0}
readonly IMG=${IMG:=${ROOT_DIR}/../../build/sysimage/images/sdcard.img}

indent() {
    awk '{printf "\t%s\n", $0}'
}

echo Unmounting filesytems on ${DEVICE}
cat /proc/mounts | awk "\$1 ~ \"${DEVICE}\" { system(sprintf(\"umount %s\n\", \$2)) }"

echo Writing $(basename ${IMG}) to ${DEVICE}
dd bs=1M conv=fsync if=${IMG} of=${DEVICE} 2>&1 | indent

echo Re-reading partition table for ${DEVICE}
blockdev --rereadpt ${DEVICE}

DEVICE_SIZE_MB=$(($(blockdev --getsize64 ${DEVICE}) / ${MB}))

echo Resizing partition 2 on ${DEVICE}
parted --script ${DEVICE} \
    unit MiB \
    resizepart 2 $(( ${DEVICE_SIZE_MB} - 1 ))

echo Re-reading partition table for ${DEVICE}
blockdev --rereadpt ${DEVICE}

echo Resizing filesystem on ${DEVICE}p2
e2fsck -p -f ${DEVICE}p2 2>&1 | indent

# resize with no size option fills the partition
resize2fs -p ${DEVICE}p2 2>&1 | indent
