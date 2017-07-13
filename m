From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 19:20:57 +0200
Message-ID: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently upstream does not provide a rdma or openibd service. Only the
RedHat package ships a rdma service and rdma modules configuration
files. The ibacm and srp_daemon services depend on the openibd service.

Make RedHat's rdma service available to all distros by cherry-picking
the basic files for the rdma service to run and trim them down to the
minimum. Do not pick workarounds or other quirk that might not needed
any more. Then replace the openibd service dependency by the rdma
service.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 CMakeLists.txt                                     |   1 +
 debian/rdma-core.install                           |   4 +
 ibacm/CMakeLists.txt                               |   1 -
 ibacm/ibacm.init.in                                |   4 +-
 kernel-boot/CMakeLists.txt                         |  22 ++++
 kernel-boot/rdma-init-kernel.in                    | 143 +++++++++++++++++++++
 kernel-boot/rdma.conf                              |  23 ++++
 redhat/rdma.service => kernel-boot/rdma.service.in |   6 +-
 {redhat => kernel-boot}/rdma.udev-rules            |   6 +-
 redhat/rdma-core.spec                              |   2 -
 redhat/rdma.conf                                   |  25 ----
 srp_daemon/CMakeLists.txt                          |   2 -
 srp_daemon/srpd.in                                 |   4 +-
 13 files changed, 203 insertions(+), 40 deletions(-)
 create mode 100644 kernel-boot/CMakeLists.txt
 create mode 100644 kernel-boot/rdma-init-kernel.in
 create mode 100644 kernel-boot/rdma.conf
 rename redhat/rdma.service => kernel-boot/rdma.service.in (59%)
 rename {redhat => kernel-boot}/rdma.udev-rules (100%)
 delete mode 100644 redhat/rdma.conf

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 16196205..a03d8da3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -398,6 +398,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 add_subdirectory(ccan)
 add_subdirectory(util)
 add_subdirectory(Documentation)
+add_subdirectory(kernel-boot)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 371aaadc..d303a780 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,5 +1,9 @@
+etc/rdma/rdma.conf
 lib/systemd/system/rdma-ndd.service
+lib/systemd/system/rdma.service
+lib/udev/rules.d/98-rdma.rules
 lib/udev/rules.d/rdma-ndd.rules
+usr/lib/rdma-init-kernel
 usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 7eba294b..448d2e14 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -58,7 +58,6 @@ rdma_man_pages(
   )
 
 # FIXME: update the .init.in
-set(rdmascript "openibd")
 set(prefix "${CMAKE_INSTALL_PREFIX}")
 rdma_subst_install(FILES "ibacm.init.in"
   DESTINATION "${CMAKE_INSTALL_INITDDIR}"
diff --git a/ibacm/ibacm.init.in b/ibacm/ibacm.init.in
index bd7b70a1..73a333b2 100644
--- a/ibacm/ibacm.init.in
+++ b/ibacm/ibacm.init.in
@@ -10,8 +10,8 @@
 # Provides:       ibacm
 # Default-Start: 2 3 4 5
 # Default-Stop: 0 1 6
-# Required-Start: @rdmascript@ $network $remote_fs
-# Required-Stop: @rdmascript@ $network $remote_fs
+# Required-Start: rdma $network $remote_fs
+# Required-Stop: rdma $network $remote_fs
 # Should-Start:
 # Should-Stop:
 # Short-Description: Starts and stops the InfiniBand ACM service
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
new file mode 100644
index 00000000..f674d2a6
--- /dev/null
+++ b/kernel-boot/CMakeLists.txt
@@ -0,0 +1,22 @@
+# Copyright (c) 2017 Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
+
+install(FILES rdma.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+rdma_subst_install(FILES "rdma-init-kernel.in"
+  DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
+  RENAME "rdma-init-kernel"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+
+install(FILES "rdma.udev-rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}"
+  RENAME "98-rdma.rules"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+rdma_subst_install(FILES "rdma.service.in"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  RENAME "rdma.service"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
diff --git a/kernel-boot/rdma-init-kernel.in b/kernel-boot/rdma-init-kernel.in
new file mode 100644
index 00000000..9d1da12b
--- /dev/null
+++ b/kernel-boot/rdma-init-kernel.in
@@ -0,0 +1,143 @@
+#!/bin/bash
+#
+# Bring up the kernel RDMA stack
+#
+# This is usually run automatically by systemd after a hardware activation
+# event in udev has triggered a start of the rdma.service unit
+#
+
+set -eu
+shopt -s nullglob
+
+CONFIG=@CMAKE_INSTALL_SYSCONFDIR@/rdma/rdma.conf
+
+LOAD_ULP_MODULES=""
+LOAD_CORE_USER_MODULES="ib_umad ib_uverbs ib_ucm rdma_ucm"
+LOAD_CORE_CM_MODULES="iw_cm ib_cm rdma_cm"
+LOAD_CORE_MODULES="ib_core"
+
+if [ -f $CONFIG ]; then
+    . $CONFIG
+
+    if [ "${RDS_LOAD-}" = "yes" ]; then
+        IPOIB_LOAD=yes
+    fi
+
+    if [ "${IPOIB_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_ipoib"
+    fi
+
+    if [ "${RDS_LOAD-}" = "yes" ] && [ -f "/lib/modules/$(uname -r)/kernel/net/rds/rds.ko" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds"
+        if [ -f "/lib/modules/$(uname -r)/kernel/net/rds/rds_tcp.ko" ]; then
+            LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds_tcp"
+        fi
+        if [ -f "/lib/modules/$(uname -r)/kernel/net/rds/rds_rdma.ko" ]; then
+            LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds_rdma"
+        fi
+    fi
+
+    if [ "${SRP_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_srp"
+    fi
+
+    if [ "${SRPT_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_srpt"
+    fi
+
+    if [ "${ISER_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_iser"
+    fi
+
+    if [ "${ISERT_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_isert"
+    fi
+
+    if [ "${XPRTRDMA_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES xprtrdma"
+    fi
+
+    if [ "${SVCRDMA_LOAD-}" = "yes" ]; then
+        LOAD_ULP_MODULES="$LOAD_ULP_MODULES svcrdma"
+    fi
+else
+    LOAD_ULP_MODULES="ib_ipoib"
+fi
+
+# If module $1 is loaded return - 0 else - 1
+is_loaded()
+{
+    /sbin/lsmod | grep -w "$1" > /dev/null 2>&1
+}
+
+load_modules()
+{
+    local RC=0
+
+    for module in "$@"; do
+        if ! /sbin/modinfo "$module" > /dev/null 2>&1; then
+            # do not attempt to load modules which do not exist
+            continue
+        fi
+        if ! is_loaded "$module"; then
+            if ! /sbin/modprobe "$module"; then
+                RC=$(( RC + 1 ))
+                echo
+                echo "Failed to load module $module"
+            fi
+        fi
+    done
+    return $RC
+}
+
+load_hardware_modules()
+{
+    local -i RC=0
+
+    # We match both class NETWORK and class INFINIBAND devices since our
+    # iWARP hardware is listed under class NETWORK.  The side effect of
+    # this is that we might cause a non-iWARP network driver to be loaded.
+    udevadm trigger --subsystem-match=pci --attr-nomatch=driver --attr-match=class=0x020000 --attr-match=class=0x0c0600
+    udevadm settle
+    if [ -r /proc/device-tree ]; then
+        if ls /proc/device-tree/*lhca* >/dev/null 2>&1; then
+            if ! is_loaded ib_ehca; then
+                load_modules ib_ehca || RC=$(( RC + $? ))
+            fi
+        fi
+    fi
+    if is_loaded mlx4_core -a ! is_loaded mlx4_ib; then
+        load_modules mlx4_ib || RC=$(( RC + $? ))
+    fi
+    if is_loaded mlx4_core -a ! is_loaded mlx4_en; then
+        load_modules mlx4_en || RC=$(( RC + $? ))
+    fi
+    if is_loaded mlx5_core -a ! is_loaded mlx5_ib; then
+        load_modules mlx5_ib || RC=$(( RC + $? ))
+    fi
+    if is_loaded cxgb3 -a ! is_loaded iw_cxgb3; then
+        load_modules iw_cxgb3 || RC=$(( RC + $? ))
+    fi
+    if is_loaded cxgb4 -a ! is_loaded iw_cxgb4; then
+        load_modules iw_cxgb4 || RC=$(( RC + $? ))
+    fi
+    if is_loaded be2net -a ! is_loaded ocrdma; then
+        load_modules ocrdma || RC=$(( RC + $? ))
+    fi
+    if is_loaded enic -a ! is_loaded usnic_verbs; then
+        load_modules usnic_verbs || RC=$(( RC + $? ))
+    fi
+    if is_loaded i40e -a ! is_loaded i40iw; then
+        load_modules i40iw || RC=$(( RC + $? ))
+    fi
+    return $RC
+}
+
+RC=0
+load_hardware_modules || RC=$(( RC + $? ))
+load_modules $LOAD_CORE_MODULES || RC=$(( RC + $? ))
+load_modules $LOAD_CORE_CM_MODULES || RC=$(( RC + $? ))
+load_modules $LOAD_CORE_USER_MODULES || RC=$(( RC + $? ))
+load_modules $LOAD_ULP_MODULES || RC=$(( RC + $? ))
+
+exit $RC
diff --git a/kernel-boot/rdma.conf b/kernel-boot/rdma.conf
new file mode 100644
index 00000000..ad4dc737
--- /dev/null
+++ b/kernel-boot/rdma.conf
@@ -0,0 +1,23 @@
+# Load IP over InfiniBand (IPoIB) network driver module
+IPOIB_LOAD=yes
+
+# Load SCSI Remote Protocol (SRP) initiator support module
+SRP_LOAD=yes
+
+# Load SCSI Remote Protocol target (SRPT) support module
+SRPT_LOAD=yes
+
+# Load iSCSI Extensions for RDMA (iSER) initiator support module
+ISER_LOAD=yes
+
+# Load iSCSI Extensions for RDMA target (iSERT) support module
+ISERT_LOAD=yes
+
+# Load Reliable Datagram Service (RDS) network protocol
+RDS_LOAD=no
+
+# Load NFS over RDMA (NFSoRDMA) client transport module
+XPRTRDMA_LOAD=yes
+
+# Load NFS over RDMA (NFSoRDMA) server transport module
+SVCRDMA_LOAD=no
diff --git a/redhat/rdma.service b/kernel-boot/rdma.service.in
similarity index 59%
rename from redhat/rdma.service
rename to kernel-boot/rdma.service.in
index 514ef58b..14e2f8f4 100644
--- a/redhat/rdma.service
+++ b/kernel-boot/rdma.service.in
@@ -1,15 +1,15 @@
 [Unit]
 Description=Initialize the iWARP/InfiniBand/RDMA stack in the kernel
-Documentation=file:/etc/rdma/rdma.conf
+Documentation=file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/rdma.conf
 RefuseManualStop=true
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
-Before=network.target remote-fs-pre.target
+Before=network-pre.target remote-fs-pre.target
 
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-ExecStart=/usr/libexec/rdma-init-kernel
+ExecStart=@CMAKE_INSTALL_FULL_LIBEXECDIR@/rdma-init-kernel
 
 [Install]
 WantedBy=sysinit.target
diff --git a/redhat/rdma.udev-rules b/kernel-boot/rdma.udev-rules
similarity index 100%
rename from redhat/rdma.udev-rules
rename to kernel-boot/rdma.udev-rules
index 7f44fe30..31d45b41 100644
--- a/redhat/rdma.udev-rules
+++ b/kernel-boot/rdma.udev-rules
@@ -4,9 +4,9 @@
 # enable the IB stack, so do so unilaterally) and on load of any of that
 # hardware, we trigger the rdma.service load in systemd
 
+SUBSYSTEM=="module", KERNEL=="be2net", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
 SUBSYSTEM=="module", KERNEL=="cxgb*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="enic", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
 SUBSYSTEM=="module", KERNEL=="ib_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
-SUBSYSTEM=="module", KERNEL=="mlx*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
 SUBSYSTEM=="module", KERNEL=="iw_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
-SUBSYSTEM=="module", KERNEL=="be2net", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
-SUBSYSTEM=="module", KERNEL=="enic", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="mlx*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 5cebc251..94c5f95b 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -250,7 +250,6 @@ mkdir -p %{buildroot}%{_libexecdir}
 mkdir -p %{buildroot}%{_udevrulesdir}
 mkdir -p %{buildroot}%{dracutlibdir}/modules.d/05rdma
 mkdir -p %{buildroot}%{sysmodprobedir}
-install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
 install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
 install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
 install -D -m0755 redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifup-ib
@@ -259,7 +258,6 @@ install -D -m0644 redhat/rdma.service %{buildroot}%{_unitdir}/rdma.service
 install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}/udev/rules.d/70-persistent-ipoib.rules
 install -D -m0644 redhat/rdma.mlx4.user.modprobe %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf
 install -D -m0755 redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
-install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
 install -D -m0644 redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
 install -D -m0644 redhat/rdma.cxgb3.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb3.conf
 install -D -m0644 redhat/rdma.cxgb4.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb4.conf
diff --git a/redhat/rdma.conf b/redhat/rdma.conf
deleted file mode 100644
index 94465649..00000000
--- a/redhat/rdma.conf
+++ /dev/null
@@ -1,25 +0,0 @@
-# Load IPoIB
-IPOIB_LOAD=yes
-# Load SRP (SCSI Remote Protocol initiator support) module
-SRP_LOAD=yes
-# Load SRPT (SCSI Remote Protocol target support) module
-SRPT_LOAD=yes
-# Load iSER (iSCSI over RDMA initiator support) module
-ISER_LOAD=yes
-# Load iSERT (iSCSI over RDMA target support) module
-ISERT_LOAD=yes
-# Load RDS (Reliable Datagram Service) network protocol
-RDS_LOAD=no
-# Load NFSoRDMA client transport module
-XPRTRDMA_LOAD=yes
-# Load NFSoRDMA server transport module
-SVCRDMA_LOAD=no
-# Load Tech Preview device driver modules
-TECH_PREVIEW_LOAD=no
-# Should we modify the system mtrr registers?  We may need to do this if you
-# get messages from the ib_ipath driver saying that it couldn't enable
-# write combining for the PIO buffs on the card.
-#
-# Note: recent kernels should do this for us, but in case they don't, we'll
-# leave this option
-FIXUP_MTRR_REGS=no
diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index 62e91bb0..ee569ac1 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -45,8 +45,6 @@ install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
 install(FILES srp_daemon.rules DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
-# FIXME: The ib init.d file should really be included in rdma-core as well.
-set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
 # NOTE: These defaults are for CentOS, packagers should override.
 set(SRP_DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
 set(SRP_DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
diff --git a/srp_daemon/srpd.in b/srp_daemon/srpd.in
index 7e2316f6..4aa68483 100755
--- a/srp_daemon/srpd.in
+++ b/srp_daemon/srpd.in
@@ -9,8 +9,8 @@
 #
 ### BEGIN INIT INFO
 # Provides:       srpd
-# Required-Start: $syslog @RDMA_SERVICE@
-# Required-Stop: $syslog @RDMA_SERVICE@
+# Required-Start: $syslog rdma
+# Required-Stop: $syslog rdma
 # Default-Start: @SRP_DEFAULT_START@
 # Default-Stop: @SRP_DEFAULT_STOP@
 # Should-Start:
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
