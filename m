From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 2/2] debian: Adding initramfs hook for debian
Date: Mon, 12 Jun 2017 09:11:40 +0300
Message-ID: <20170612061140.7715-2-leon@kernel.org>
References: <20170612061140.7715-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612061140.7715-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Install the network configuration files into initramfs.

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 debian/rdma-core.install                 |  1 +
 kernel-boot/CMakeLists.txt               |  7 +++
 kernel-boot/rdma-initramfs-tools-hook.in | 90 ++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)
 create mode 100755 kernel-boot/rdma-initramfs-tools-hook.in

diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index e75a8493..5b1dbe4f 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,3 +1,4 @@
+etc/initramfs-tools/hooks/rdma/rdma-initramfs-tools-hook
 etc/modprobe.d/mlx4.conf
 etc/rdma/mlx4.conf
 etc/rdma/rdma.conf
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
index 0ea1b6af..de1ae62c 100644
--- a/kernel-boot/CMakeLists.txt
+++ b/kernel-boot/CMakeLists.txt
@@ -37,6 +37,13 @@ rdma_subst_install(FILES rdma.kernel-init.in DESTINATION "${CMAKE_INSTALL_FULL_L
     RENAME "rdma-init-kernel"
     PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)

+if ("${DISTRO_FLAVOUR}" STREQUAL "Debian")
+    file(MAKE_DIRECTORY "${CMAKE_INSTALL_SYSCONFDIR}/initramfs-tools/hooks/rdma/")
+    rdma_subst_install(FILES rdma-initramfs-tools-hook.in DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/initramfs-tools/hooks/rdma"
+        RENAME "rdma-initramfs-tools-hook"
+        PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+endif()
+
 install(FILES rdma.sriov-init DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
     RENAME "rdma-set-sriov-vf"
     PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
diff --git a/kernel-boot/rdma-initramfs-tools-hook.in b/kernel-boot/rdma-initramfs-tools-hook.in
new file mode 100755
index 00000000..e3a9c696
--- /dev/null
+++ b/kernel-boot/rdma-initramfs-tools-hook.in
@@ -0,0 +1,90 @@
+#!/bin/sh -e
+#
+# Network Interface Configuration System
+# Copyright (c) 2017 Mellanox Technologies, Inc.  All rights reserved.
+#
+# This software is available to you under a choice of one of two
+# licenses.  You may choose to be licensed under the terms of the GNU
+# General Public License (GPL) Version 2, available from the file
+# COPYING in the main directory of this source tree, or the
+# OpenIB.org BSD license below:
+#
+#     Redistribution and use in source and binary forms, with or
+#     without modification, are permitted provided that the following
+#     conditions are met:
+#
+#      - Redistributions of source code must retain the above
+#        copyright notice, this list of conditions and the following
+#        disclaimer.
+#
+#      - Redistributions in binary form must reproduce the above
+#        copyright notice, this list of conditions and the following
+#        disclaimer in the documentation and/or other materials
+#        provided with the distribution.
+#
+# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+# SOFTWARE.
+
+
+
+PREREQS=""
+
+prereqs() { echo "$PREREQS"; }
+
+case "$1" in
+    prereqs)
+    prereqs
+    exit 0
+    ;;
+esac
+
+. /usr/share/initramfs-tools/hook-functions
+# Begin real processing below this line
+
+_install_file()
+{
+    local fpath=$1; shift
+    local dest=$1; shift
+
+    if [ "X$fpath" = "X" ] || [ "X$dest" = "X" ]; then
+        exit 1
+    fi
+
+    fname=$(basename $fpath)
+    if [ -e $DESTDIR/$dest/$fname ]; then
+        return
+    fi
+
+    mkdir -p $DESTDIR/$dest
+    cp $fpath $DESTDIR/$dest
+}
+
+_install_file ${CMAKE_INSTALL_SYSCONFDIR}/rdma/rdma.conf ${CMAKE_INSTALL_SYSCONFDIR}/rdma
+_install_file ${CMAKE_INSTALL_SYSCONFDIR}/rdma/mlx4.conf ${CMAKE_INSTALL_SYSCONFDIR}/rdma
+_install_file ${CMAKE_INSTALL_SYSCONFDIR}/rdma/sriov-vfs ${CMAKE_INSTALL_SYSCONFDIR}/rdma
+
+_install_file ${CMAKE_INSTALL_FULL_LIBEXECDIR}/rdma-init-kernel ${CMAKE_INSTALL_FULL_LIBEXECDIR}
+_install_file ${CMAKE_INSTALL_FULL_LIBEXECDIR}/rdma-fixup-mtrr ${CMAKE_INSTALL_FULL_LIBEXECDIR}
+_install_file ${CMAKE_INSTALL_FULL_LIBEXECDIR}/mlx4-setup ${CMAKE_INSTALL_FULL_LIBEXECDIR}
+_install_file ${CMAKE_INSTALL_FULL_LIBEXECDIR}/rdma-set-sriov-vf ${CMAKE_INSTALL_FULL_LIBEXECDIR}
+
+_install_file ${CMAKE_INSTALL_LIBMODPROBE_DIR}/libmlx4.conf ${CMAKE_INSTALL_LIBMODPROBE_DIR}
+
+_install_file ${CMAKE_INSTALL_LIBMODPROBE_DIR}/mlx4-rdma.conf ${CMAKE_INSTALL_LIBMODPROBE_DIR}
+
+_install_file ${CMAKE_INSTALL_UDEV_RULESDIR}/98-rdma.rules ${CMAKE_INSTALL_UDEV_RULESDIR}
+
+_install_file ${CMAKE_INSTALL_UDEV_RULESDIR}/70-persistent-ipoib.rules ${CMAKE_INSTALL_UDEV_RULESDIR}
+
+for program in bash lspci setpci awk sleep; do
+  programpath=$(which $program)
+  copy_exec $programpath $(dirname $programpath)
+done
+
+exit 0
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
