#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable ublue-os/packages

### Install packages
PACKAGES=(
  alacritty
  brightnessctl
  fuzzel
  gnome-keyring
  grim
  neovim
  mako
  niri
  sddm
  swaybg
  swayidle
  Thunar
  thunar-archive-plugin
  thunar-volman
  ublue-brew
  waybar
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome
  xwayland-satellite
  zsh
)

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y "${PACKAGES[@]}"

#### Example for enabling a System Unit File

systemctl enable podman.socket
