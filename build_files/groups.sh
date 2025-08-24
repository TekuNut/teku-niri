#!/bin/bash

set -eoux pipefail

echo "::group:: Install group packages"

PACKAGE_GROUPS=(
  base-graphical
  container-management
  fonts
  hardware-support
  multimedia
  networkmanager-submodules
  printing
)

dnf5 group install -y "${PACKAGE_GROUPS[@]}"
