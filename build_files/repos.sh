#!/bin/bash

set -eoux pipefail

echo "::group:: Configure Repos"

dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 -y copr enable che/nerd-fonts fedora-42-x86_64
dnf5 -y copr enable solopasha/hyprland
dnf5 -y copr enable ublue-os/packages

echo "::endgroup::"

