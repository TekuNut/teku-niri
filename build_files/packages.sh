#!/bin/bash

set -eoux pipefail

echo "::group:: Install packages"


dnf5 -y copr enable che/nerd-fonts fedora-42-x86_64
dnf5 -y copr enable solopasha/hyprland
dnf5 -y copr enable ublue-os/packages

# use negativo17 for 3rd party packages with higher priority than default
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    # Enable or Install Repofile
    dnf5 config-manager setopt fedora-multimedia.enabled=1 ||
        dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi
# Set higher priority
dnf5 config-manager setopt fedora-multimedia.priority=90

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    "libva"
    "intel-gmmlib"
    "intel-vpl-gpu-rt"
    "intel-mediasdk"
    "libva-intel-media-driver"
    "mesa-dri-drivers"
    "mesa-filesystem"
    "mesa-libEGL"
    "mesa-libGL"
    "mesa-libgbm"
    "mesa-va-drivers"
    "mesa-vulkan-drivers"
)

dnf5 distro-sync -y --repo='fedora-multimedia' "${OVERRIDES[@]}"
dnf5 versionlock add "${OVERRIDES[@]}"


# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

### Install packages
PACKAGES=(
  alacritty
  bootc
  brightnessctl
  curl
  file
  fuzzel
  gnome-keyring
  grim
  jetbrains-mono-fonts-all
  neovim
  make
  mako
  nerd-fonts
  niri
  procps-ng
  sddm
  sddm-themes
  setools-console
  swaybg
  swayidle
  swww
  Thunar
  thunar-archive-plugin
  thunar-volman
  waybar
  waypaper
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome
  xwayland-satellite
  zsh
)

DX_PACKAGES=(
  adobe-source-code-pro-fonts
  android-tools
  bpftop
  bpftrace
  cascadia-code-fonts
  code
  docker-buildkit
  docker-buildx
  docker-compose
  docker-cli
  google-droid-sans-mono-fonts
  google-go-mono-fonts
  ibm-plex-mono-fonts
  incus
  incus-agent
  iotop
  libvirt
  libvirt-nss
  lxc
  nicstat
  numactl
  osbuild-selinux
  p7zip
  p7zip-plugins
  qemu
  qemu-char-spice
  qemu-device-display-virtio-gpu
  qemu-device-display-virtio-vga
  qemu-img
  qemu-system-x86-core
  qemu-user-binfmt
  sysprof
  ublue-brew
  virt-manager
  virt-viewer
)


# this installs a package from fedora repos
dnf5 install -y "${PACKAGES[@]}" "${DX_PACKAGES[@]}"

echo "::endgroup::"
