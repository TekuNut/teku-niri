ARG FEDORA_MAJOR_VERSION=rawhide
ARG FEDORA_DE=sway-atomic

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /build_files /build_files
COPY /system_files /system_files

# Base Image
FROM quay.io/fedora-ostree-desktops/${FEDORA_DE}:${FEDORA_MAJOR_VERSION}

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

# Install utililities needed and copy over the system files.
RUN --mount=type=bind,from=ctx,source=/,target=/ctx/ \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install dnf5-plugins rsync && rsync -rlvK /ctx/system_files/

RUN --mount=type=bind,from=ctx,source=/,target=/ctx/ \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/groups.sh 

RUN --mount=type=bind,from=ctx,source=/,target=/ctx/ \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/packages.sh 

RUN --mount=type=bind,from=ctx,source=/,target=/ctx/ \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/post-install.sh 

RUN ostree container commit


### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
