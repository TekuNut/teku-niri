#!/bin/bash

set -eoux pipefail

dnf5 -y install dnf5-plugins rsync
rsync -rlvK /ctx/system_files/ /

# Configure repos
/ctx/build_files/repos.sh

# Install package groups.
/ctx/build_files/groups.sh

# Install packages.
/ctx/build_files/packages.sh

# Run post-installation steps.
/ctx/build_files/post-install.sh
