#! /usr/bin/env bash

# Set additional kernel commandline options.
readonly -a KERNEL_CMDLINE_OPTS=(
    "cgroup_enable=memory"
)

readonly KERNEL_CMDLINE="${BINARIES_DIR}/rpi-firmware/cmdline.txt"
readonly KERNEL_CMDLINE_TMP=$(mktemp "${KERNEL_CMDLINE}.XXXX")

for opt in ${KERNEL_CMDLINE_OPTS[@]}; do
    if ! grep --fixed-strings --quiet ${opt} ${KERNEL_CMDLINE} ; then
        echo Adding \"${opt}\" to ${KERNEL_CMDLINE}
        echo " ${opt}" >> ${KERNEL_CMDLINE}
    fi
done

tr --squeeze-repeats '\n' ' ' < ${KERNEL_CMDLINE} > ${KERNEL_CMDLINE_TMP}
mv ${KERNEL_CMDLINE_TMP} ${KERNEL_CMDLINE}

# ROOT_DIR is the root of this git repo.
ROOT_DIR=$(cd $(dirname $0)/../.. && pwd)

readonly -a SYSTEMD_SERVICES=(
    "systemd-networkd.service"
    "systemd-resolved.service"
    "sshd.service"
    "containerd.service"
)

# Enable wanted systemd services.
for s in ${SYSTEMD_SERVICES[@]}; do
    if [ -r ${TARGET_DIR}/usr/lib/systemd/system/${s} ]; then
        ln --force --symbolic --target-directory ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants \
            ../../../../lib/systemd/system/${s}
    fi
done

# Disable NFS for now (until we can network boot).
rm -rf ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/nfs-*

# Remove the generic hostname so that systemd-networkd will properly
# set the transient hostname from DHCP.
rm -rf ${TARGET_DIR}/etc/hostname

cat >> ${TARGET_DIR}/etc/systemd/network/dhcp.network <<EOF
[DHCP]
UseDNS=true
UseNTP=true
UseHostname=true
UseDomains=true
EOF

# Disable sshd password logins.
cat > ${TARGET_DIR}/etc/ssh/sshd_config <<EOF
ChallengeResponseAuthentication no
PasswordAuthentication no
PermitRootLogin no
EOF

# Install the public key for the admin user.
mkdir -p ${TARGET_DIR}/home/admin/.ssh
cp ${ROOT_DIR}/config/admin@rpi.pub ${TARGET_DIR}/home/admin/.ssh/authorized_keys

# Allow sudo access for admin.
cat > ${TARGET_DIR}/etc/sudoers.d/admin <<EOF
admin ALL=(ALL) NOPASSWD: ALL
EOF
