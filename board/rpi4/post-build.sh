#! /usr/bin/env bash

# ROOT_DIR is the root of this git repo.
ROOT_DIR=$(cd $(dirname $0)/../.. && pwd)

# Enable systemd-networkd for DHCP client.
ln --symbolic --target-directory ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants \
    ../../../../lib/systemd/system/systemd-networkd.service

# Enable systemd-resolved to set up DNS resolver from DHCP.
ln --symbolic --target-directory ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants \
    ../../../../lib/systemd/system/systemd-resolved.service

# Enable sshd service.
ln --symbolic --target-directory ${TARGET_DIR}/etc/systemd/system/multi-user.target.wants \
    ../../../../lib/systemd/system/sshd.service

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