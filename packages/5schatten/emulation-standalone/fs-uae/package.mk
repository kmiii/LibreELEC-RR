# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (at) gmail.com)

PKG_NAME="fs-uae"
PKG_VERSION="246a829ffc3251b663c943952e74c81f4e1c03ca" # 2.9.8dev2+
PKG_SHA256="52377004c3c5b3cbce7406463f137fd7678e14a9f92c2313ac8d10b4fd2ea57c"
PKG_ARCH="x86_64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/FrodeSolheim/fs-uae"
PKG_URL="https://github.com/FrodeSolheim/fs-uae/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux glibc glib SDL2-git glew glu libmpeg2 libXi openal-soft capsimg zlib libpng"
PKG_LONGDESC="FS-UAE amiga emulator."
PKG_TOOLCHAIN="autotools"

configure_package() {
  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server"
  fi
}

pre_configure_target() {
  export ac_cv_func_realloc_0_nonnull=yes
  export SYSROOT_PREFIX
  cp ${PKG_DIR}/input/* ../share/fs-uae/input/
}

post_makeinstall_target() {
  # install scripts
  cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/

  # set up default config directory
  mkdir -p ${INSTALL}/usr/config
  cp -R ${PKG_DIR}/config ${INSTALL}/usr/config/fs-uae
  ln -s /storage/roms/bios/Kickstarts ${INSTALL}/usr/config/fs-uae/Kickstarts

  # create symlink to capsimg for IPF support
  mkdir -p ${INSTALL}/usr/config/fs-uae/Plugins
  ln -sf /usr/lib/libcapsimage.so.5.1 ${INSTALL}/usr/config/fs-uae/Plugins/capsimg.so

  # clean up
  rm -rf ${INSTALL}/usr/share/applications
  rm -rf ${INSTALL}/usr/share/icons
  rm -rf ${INSTALL}/usr/share/mime
}
