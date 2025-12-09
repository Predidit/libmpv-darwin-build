#!/bin/sh

set -e # exit immediately if a command exits with a non-zero status
set -u # treat unset variables as an error

cd ${SRC_DIR}

# silence clang >=15 int-to-pointer diagnostics in bundled glib
CFLAGS="${CFLAGS:-} -Wno-int-conversion"
export CFLAGS

cp ${PROJECT_DIR}/scripts/pkg-config/meson.build ./meson.build
meson setup build \
    --cross-file ${PROJECT_DIR}/cross-files/${OS}-${ARCH}.ini \
    --prefix="${OUTPUT_DIR}"

meson compile -C build pkg-config

# manual install to preserve symlinks (meson install -C build)
mkdir -p "${OUTPUT_DIR}"
cp -R build/dist"${OUTPUT_DIR}"/* "${OUTPUT_DIR}"/
