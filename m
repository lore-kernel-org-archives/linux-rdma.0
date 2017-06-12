From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 1/2] Making the service available to all distros
Date: Mon, 12 Jun 2017 09:11:39 +0300
Message-ID: <20170612061140.7715-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, rdma service and rdma modules configuration files
installed for RedHat operation system as part of rdma-core
package, this patch makes the rdma service generic for all the
distributions.

It moves all rdma service related files out of "redhat"
directory to a new generic directory called "kernel-boot",
and changes file names.

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 CMakeLists.txt                                     |  4 ++
 debian/rdma-core.install                           | 14 +++++
 debian/rules                                       |  3 +-
 kernel-boot/CMakeLists.txt                         | 61 ++++++++++++++++++++++
 {redhat => kernel-boot}/rdma.conf                  |  0
 {redhat => kernel-boot}/rdma.cxgb3.sys.modprobe    |  0
 {redhat => kernel-boot}/rdma.cxgb4.sys.modprobe    |  0
 {redhat => kernel-boot}/rdma.fixup-mtrr.awk        |  0
 .../rdma.kernel-init.in                            |  6 +--
 .../rdma.mlx4-setup                                |  0
 {redhat => kernel-boot}/rdma.mlx4.conf             |  0
 .../rdma.mlx4.sys.modprobe.in                      |  2 +-
 {redhat => kernel-boot}/rdma.mlx4.user.modprobe    |  0
 redhat/rdma.service => kernel-boot/rdma.service.in |  4 +-
 {redhat => kernel-boot}/rdma.sriov-init            |  0
 {redhat => kernel-boot}/rdma.sriov-vfs             |  0
 .../rdma.udev-ipoib-naming.rules                   |  0
 {redhat => kernel-boot}/rdma.udev-rules            |  0
 rdma-core.spec                                     |  8 +++
 redhat/rdma-core.spec                              | 21 +-------
 redhat/rdma.modules-setup.sh                       |  4 +-
 21 files changed, 99 insertions(+), 28 deletions(-)
 create mode 100644 kernel-boot/CMakeLists.txt
 rename {redhat => kernel-boot}/rdma.conf (100%)
 rename {redhat => kernel-boot}/rdma.cxgb3.sys.modprobe (100%)
 rename {redhat => kernel-boot}/rdma.cxgb4.sys.modprobe (100%)
 rename {redhat => kernel-boot}/rdma.fixup-mtrr.awk (100%)
 rename redhat/rdma.kernel-init => kernel-boot/rdma.kernel-init.in (97%)
 rename redhat/rdma.mlx4-setup.sh => kernel-boot/rdma.mlx4-setup (100%)
 rename {redhat => kernel-boot}/rdma.mlx4.conf (100%)
 rename redhat/rdma.mlx4.sys.modprobe => kernel-boot/rdma.mlx4.sys.modprobe.in (54%)
 rename {redhat => kernel-boot}/rdma.mlx4.user.modprobe (100%)
 rename redhat/rdma.service => kernel-boot/rdma.service.in (70%)
 rename {redhat => kernel-boot}/rdma.sriov-init (100%)
 rename {redhat => kernel-boot}/rdma.sriov-vfs (100%)
 rename {redhat => kernel-boot}/rdma.udev-ipoib-naming.rules (100%)
 rename {redhat => kernel-boot}/rdma.udev-rules (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1d40b0cf..ffd2dfcf 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -73,6 +73,9 @@ set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system
 set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
   CACHE PATH "Location for ibacm provider plugin shared library files.")

+set(CMAKE_INSTALL_LIBMODPROBE_DIR "${CMAKE_INSTALL_PREFIX}/lib/modprobe.d"
+  CACHE PATH "Location for module configuration files")
+
 # Location to find the provider plugin shared library files
 set(VERBS_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/libibverbs"
   CACHE PATH "Location for provider plugin shared library files. If set to empty the system search path is used.")
@@ -385,6 +388,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 add_subdirectory(ccan)
 add_subdirectory(util)
 add_subdirectory(Documentation)
+add_subdirectory(kernel-boot)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 371aaadc..e75a8493 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,5 +1,19 @@
+etc/modprobe.d/mlx4.conf
+etc/rdma/mlx4.conf
+etc/rdma/rdma.conf
+etc/rdma/sriov-vfs
+lib/modprobe.d/cxgb3.conf
+lib/modprobe.d/cxgb4.conf
+lib/modprobe.d/libmlx4.conf
 lib/systemd/system/rdma-ndd.service
+lib/systemd/system/rdma.service
+lib/udev/rules.d/70-persistent-ipoib.rules
+lib/udev/rules.d/98-rdma.rules
 lib/udev/rules.d/rdma-ndd.rules
+usr/lib/mlx4-setup
+usr/lib/rdma-fixup-mtrr
+usr/lib/rdma-init-kernel
+usr/lib/rdma-set-sriov-vf
 usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
diff --git a/debian/rules b/debian/rules
index 958443a0..32c4ae90 100755
--- a/debian/rules
+++ b/debian/rules
@@ -23,7 +23,8 @@ override_dh_auto_configure:
 			-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/lib/systemd/system \
 			-DCMAKE_INSTALL_INITDDIR:PATH=/etc/init.d \
 			-DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/lib \
-			-DCMAKE_INSTALL_UDEV_RULESDIR:PATH=/lib/udev/rules.d
+			-DCMAKE_INSTALL_UDEV_RULESDIR:PATH=/lib/udev/rules.d \
+			-DCMAKE_INSTALL_LIBMODPROBE_DIR:PATH=/lib/modprobe.d

 override_dh_auto_build:
 	ninja -C build-deb -v
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
new file mode 100644
index 00000000..0ea1b6af
--- /dev/null
+++ b/kernel-boot/CMakeLists.txt
@@ -0,0 +1,61 @@
+set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
+
+install(FILES "rdma.udev-rules" DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}"
+    RENAME "98-rdma.rules"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES "rdma.udev-ipoib-naming.rules" DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}"
+    RENAME "70-persistent-ipoib.rules"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+rdma_subst_install(FILES "rdma.service.in"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  RENAME "rdma.service"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+file(MAKE_DIRECTORY "${CMAKE_INSTALL_SYSCONFDIR}/rdma/")
+install(FILES rdma.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES rdma.sriov-vfs DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/"
+    RENAME "sriov-vfs"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES rdma.mlx4.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/"
+    RENAME "mlx4.conf"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES rdma.fixup-mtrr.awk DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
+    RENAME "rdma-fixup-mtrr"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES rdma.mlx4-setup DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
+    RENAME "mlx4-setup"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+
+rdma_subst_install(FILES rdma.kernel-init.in DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
+    RENAME "rdma-init-kernel"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+
+install(FILES rdma.sriov-init DESTINATION "${CMAKE_INSTALL_FULL_LIBEXECDIR}"
+    RENAME "rdma-set-sriov-vf"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+
+install(FILES "rdma.cxgb3.sys.modprobe"
+  DESTINATION "${CMAKE_INSTALL_LIBMODPROBE_DIR}"
+  RENAME "cxgb3.conf"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES "rdma.cxgb4.sys.modprobe"
+  DESTINATION "${CMAKE_INSTALL_LIBMODPROBE_DIR}"
+  RENAME "cxgb4.conf"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES "rdma.mlx4.sys.modprobe.in"
+  DESTINATION "${CMAKE_INSTALL_LIBMODPROBE_DIR}"
+  RENAME "libmlx4.conf"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES "rdma.mlx4.user.modprobe" DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/"
+  RENAME "mlx4.conf"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
diff --git a/redhat/rdma.conf b/kernel-boot/rdma.conf
similarity index 100%
rename from redhat/rdma.conf
rename to kernel-boot/rdma.conf
diff --git a/redhat/rdma.cxgb3.sys.modprobe b/kernel-boot/rdma.cxgb3.sys.modprobe
similarity index 100%
rename from redhat/rdma.cxgb3.sys.modprobe
rename to kernel-boot/rdma.cxgb3.sys.modprobe
diff --git a/redhat/rdma.cxgb4.sys.modprobe b/kernel-boot/rdma.cxgb4.sys.modprobe
similarity index 100%
rename from redhat/rdma.cxgb4.sys.modprobe
rename to kernel-boot/rdma.cxgb4.sys.modprobe
diff --git a/redhat/rdma.fixup-mtrr.awk b/kernel-boot/rdma.fixup-mtrr.awk
similarity index 100%
rename from redhat/rdma.fixup-mtrr.awk
rename to kernel-boot/rdma.fixup-mtrr.awk
diff --git a/redhat/rdma.kernel-init b/kernel-boot/rdma.kernel-init.in
similarity index 97%
rename from redhat/rdma.kernel-init
rename to kernel-boot/rdma.kernel-init.in
index ecfe5b57..2b0127b6 100644
--- a/redhat/rdma.kernel-init
+++ b/kernel-boot/rdma.kernel-init.in
@@ -8,8 +8,8 @@

 shopt -s nullglob

-CONFIG=/etc/rdma/rdma.conf
-MTRR_SCRIPT=/usr/libexec/rdma-fixup-mtrr.awk
+CONFIG=@CMAKE_INSTALL_SYSCONFDIR@/rdma/rdma.conf
+MTRR_SCRIPT=@CMAKE_INSTALL_FULL_LIBEXECDIR@/rdma-fixup-mtrr

 LOAD_ULP_MODULES=""
 LOAD_CORE_USER_MODULES="ib_umad ib_uverbs ib_ucm rdma_ucm"
@@ -257,6 +257,6 @@ RC=$[ $RC + $? ]
 errata_58
 errata_56

-/usr/libexec/rdma-set-sriov-vf
+@CMAKE_INSTALL_FULL_LIBEXECDIR@/rdma-set-sriov-vf

 exit $RC
diff --git a/redhat/rdma.mlx4-setup.sh b/kernel-boot/rdma.mlx4-setup
similarity index 100%
rename from redhat/rdma.mlx4-setup.sh
rename to kernel-boot/rdma.mlx4-setup
diff --git a/redhat/rdma.mlx4.conf b/kernel-boot/rdma.mlx4.conf
similarity index 100%
rename from redhat/rdma.mlx4.conf
rename to kernel-boot/rdma.mlx4.conf
diff --git a/redhat/rdma.mlx4.sys.modprobe b/kernel-boot/rdma.mlx4.sys.modprobe.in
similarity index 54%
rename from redhat/rdma.mlx4.sys.modprobe
rename to kernel-boot/rdma.mlx4.sys.modprobe.in
index 781562cd..6d87e428 100644
--- a/redhat/rdma.mlx4.sys.modprobe
+++ b/kernel-boot/rdma.mlx4.sys.modprobe.in
@@ -2,4 +2,4 @@
 # updated.  Please do not make any changes to this file.  Instead, make
 # changes to the mlx4.conf file.  It's contents are preserved if they
 # have been changed from the default values.
-install mlx4_core /sbin/modprobe --ignore-install mlx4_core $CMDLINE_OPTS && (if [ -f /usr/libexec/mlx4-setup.sh -a -f /etc/rdma/mlx4.conf ]; then /usr/libexec/mlx4-setup.sh < /etc/rdma/mlx4.conf; fi; /sbin/modprobe mlx4_en; if /sbin/modinfo mlx4_ib > /dev/null 2>&1; then /sbin/modprobe mlx4_ib; fi)
+install mlx4_core /sbin/modprobe --ignore-install mlx4_core $CMDLINE_OPTS && (if [ -f @CMAKE_INSTALL_FULL_LIBEXECDIR@/mlx4-setup -a -f /etc/rdma/mlx4.conf ]; then @CMAKE_INSTALL_FULL_LIBEXECDIR@/mlx4-setup < /etc/rdma/mlx4.conf; fi; /sbin/modprobe mlx4_en; if /sbin/modinfo mlx4_ib > /dev/null 2>&1; then /sbin/modprobe mlx4_ib; fi)
diff --git a/redhat/rdma.mlx4.user.modprobe b/kernel-boot/rdma.mlx4.user.modprobe
similarity index 100%
rename from redhat/rdma.mlx4.user.modprobe
rename to kernel-boot/rdma.mlx4.user.modprobe
diff --git a/redhat/rdma.service b/kernel-boot/rdma.service.in
similarity index 70%
rename from redhat/rdma.service
rename to kernel-boot/rdma.service.in
index 514ef58b..69d1f613 100644
--- a/redhat/rdma.service
+++ b/kernel-boot/rdma.service.in
@@ -1,6 +1,6 @@
 [Unit]
 Description=Initialize the iWARP/InfiniBand/RDMA stack in the kernel
-Documentation=file:/etc/rdma/rdma.conf
+Documentation=file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/rdma.conf
 RefuseManualStop=true
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
@@ -9,7 +9,7 @@ Before=network.target remote-fs-pre.target
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-ExecStart=/usr/libexec/rdma-init-kernel
+ExecStart=@CMAKE_INSTALL_FULL_LIBEXECDIR@/rdma-init-kernel

 [Install]
 WantedBy=sysinit.target
diff --git a/redhat/rdma.sriov-init b/kernel-boot/rdma.sriov-init
similarity index 100%
rename from redhat/rdma.sriov-init
rename to kernel-boot/rdma.sriov-init
diff --git a/redhat/rdma.sriov-vfs b/kernel-boot/rdma.sriov-vfs
similarity index 100%
rename from redhat/rdma.sriov-vfs
rename to kernel-boot/rdma.sriov-vfs
diff --git a/redhat/rdma.udev-ipoib-naming.rules b/kernel-boot/rdma.udev-ipoib-naming.rules
similarity index 100%
rename from redhat/rdma.udev-ipoib-naming.rules
rename to kernel-boot/rdma.udev-ipoib-naming.rules
diff --git a/redhat/rdma.udev-rules b/kernel-boot/rdma.udev-rules
similarity index 100%
rename from redhat/rdma.udev-rules
rename to kernel-boot/rdma.udev-rules
diff --git a/rdma-core.spec b/rdma-core.spec
index b923a5d7..af14a455 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -110,6 +110,7 @@ This is a simple example without the split sub packages to get things started.
 %install
 %cmake_install

+%global sysmodprobedir %{_prefix}/lib/modprobe.d
 %if 0%{?_unitdir:1}
 rm -rf %{buildroot}/%{_initrddir}/
 %else
@@ -120,8 +121,15 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %postun -p /sbin/ldconfig

 %files
+%dir %{_sysconfdir}/rdma
 %doc %{_mandir}/man*/*
+%config(noreplace) %{_sysconfdir}/rdma/*
+%config(noreplace) %{_sysconfdir}/modprobe.d/mlx4.conf
+%{_unitdir}/rdma.service
 %{_bindir}/*
+%{sysmodprobedir}/libmlx4.conf
+%{sysmodprobedir}/cxgb3.conf
+%{sysmodprobedir}/cxgb4.conf
 %{_includedir}/*
 %{_libdir}/lib*.so*
 %{_libdir}/libibverbs/*
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 1f5cd146..e9ec718f 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -243,30 +243,13 @@ mkdir -p %{buildroot}/%{_sysconfdir}/rdma

 # Red Hat specific glue
 %global dracutlibdir %{_prefix}/lib/dracut
-%global sysmodprobedir %{_prefix}/lib/modprobe.d
 mkdir -p %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts
-mkdir -p %{buildroot}%{_sysconfdir}/udev/rules.d
 mkdir -p %{buildroot}%{_libexecdir}
 mkdir -p %{buildroot}%{_udevrulesdir}
 mkdir -p %{buildroot}%{dracutlibdir}/modules.d/05rdma
-mkdir -p %{buildroot}%{sysmodprobedir}
-install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
-install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
-install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
 install -D -m0755 redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifup-ib
 install -D -m0755 redhat/rdma.ifdown-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifdown-ib
-install -D -m0644 redhat/rdma.service %{buildroot}%{_unitdir}/rdma.service
-install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}/udev/rules.d/70-persistent-ipoib.rules
-install -D -m0644 redhat/rdma.mlx4.user.modprobe %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf
 install -D -m0755 redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
-install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
-install -D -m0644 redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
-install -D -m0644 redhat/rdma.cxgb3.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb3.conf
-install -D -m0644 redhat/rdma.cxgb4.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb4.conf
-install -D -m0755 redhat/rdma.kernel-init %{buildroot}%{_libexecdir}/rdma-init-kernel
-install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
-install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
-install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh

 # ibacm
 bin/ib_acme -D . -O
@@ -334,8 +317,8 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{sysmodprobedir}/cxgb4.conf
 %{_libexecdir}/rdma-init-kernel
 %{_libexecdir}/rdma-set-sriov-vf
-%{_libexecdir}/rdma-fixup-mtrr.awk
-%{_libexecdir}/mlx4-setup.sh
+%{_libexecdir}/rdma-fixup-mtrr
+%{_libexecdir}/mlx4-setup
 %{_libexecdir}/truescale-serdes.cmds
 %{_sbindir}/rdma-ndd
 %{_unitdir}/rdma-ndd.service
diff --git a/redhat/rdma.modules-setup.sh b/redhat/rdma.modules-setup.sh
index 19a182fc..837bef92 100644
--- a/redhat/rdma.modules-setup.sh
+++ b/redhat/rdma.modules-setup.sh
@@ -15,8 +15,8 @@ install() {
 	inst /etc/rdma/mlx4.conf
 	inst /etc/rdma/sriov-vfs
 	inst /usr/libexec/rdma-init-kernel
-	inst /usr/libexec/rdma-fixup-mtrr.awk
-	inst /usr/libexec/mlx4-setup.sh
+	inst /usr/libexec/rdma-fixup-mtrr
+	inst /usr/libexec/mlx4-setup
 	inst /usr/libexec/rdma-set-sriov-vf
 	inst /usr/lib/modprobe.d/libmlx4.conf
 	inst_multiple lspci setpci awk sleep
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
