#!/usr/bin/bash

set -eoux pipefail

echo "::group:: Post installation"

# Remove dnf5 versionlocks
dnf5 versionlock clear

#### Enable systemd services
systemctl enable podman.socket

# Install wants for niri.service
install -d -m 0755 /usr/lib/systemd/user/niri.service.wants
ln -s ../waybar.service /usr/lib/systemd/user/niri.service.wants/waybar.service
ln -s ../mako.service /usr/lib/systemd/user/niri.service.wants/mako.service

# Disable all COPRs
dnf5 -y copr disable che/nerd-fonts
echo "::endgroup::"

echo "::group:: Cleanup"
rm -rf /tmp/* || true
# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;
echo "::endgroup::"

