#!/usr/bin/bash

set -eoux pipefail

echo "::group:: Post installation"

# Remove dnf5 versionlocks
dnf5 versionlock clear

#### Enable systemd services
systemctl enable podman.socket

# Install wants for niri.service
systemctl --global add-wants niri.service waybar.service
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service swww.service
systemctl --global add-wants niri.service xwayland-satellite.service

# Disable all COPRs
dnf5 -y copr disable che/nerd-fonts
dnf5 -y copr disable solopasha/hyprland
dnf5 -y copr disable ublue-os/packages
echo "::endgroup::"

echo "::group:: Cleanup"
rm -rf /tmp/* || true
# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;
echo "::endgroup::"

