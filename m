From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 1/6] Common infrastructure for auto loading rdma modules
Date: Thu, 27 Jul 2017 16:31:20 -0600
Message-ID: <1501194685-9447-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is inspired by the similar approach in the redhat directory but
takes a more general approach relying on udev and systemd to do the
actual work fully dynamically instead of a oneshot shell script.

Loading is split into two cases
 1) Loading RDMA support modules when RDMA capable hardware is installed.
    This is only needed for ethernet devices which do not load their RDMA
    support modules via request_module in the kernel.

    udev is used to detect when an ethernet device controlled by a specific
    module is hot plugged and then udev directly loads the RDMA module

 2) Loading RDMA ULP support when RDMA hardware is installed
    This is done by having udev detect when RDMA hardware is installed and
    udev causes systemd to load a list of modules from config files in
    /etc/rdma/modules/

    The user can customize these files to select which ULP modules should be
    loaded.

This broadly replaces the redhat/rdma.conf scheme.

In all cases the users can prevent a module from being auto-loaded on their
system by blacking listing it in a file in /etc/modprobe.d/

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                            |  1 +
 Documentation/udev.md                     | 83 +++++++++++++++++++++++++++++++
 debian/rdma-core.install                  |  9 ++++
 kernel-boot/CMakeLists.txt                | 24 +++++++++
 kernel-boot/modules/infiniband.conf       | 12 +++++
 kernel-boot/modules/iwarp.conf            |  2 +
 kernel-boot/modules/opa.conf              | 10 ++++
 kernel-boot/modules/rdma.conf             | 21 ++++++++
 kernel-boot/modules/roce.conf             |  2 +
 kernel-boot/rdma-description.rules        | 42 ++++++++++++++++
 kernel-boot/rdma-hw-modules.rules         | 39 +++++++++++++++
 kernel-boot/rdma-load-modules@.service.in | 15 ++++++
 kernel-boot/rdma-ulp-modules.rules        | 11 ++++
 rdma-core.spec                            |  1 +
 redhat/rdma-core.spec                     | 11 +++-
 15 files changed, 282 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/udev.md
 create mode 100644 kernel-boot/CMakeLists.txt
 create mode 100644 kernel-boot/modules/infiniband.conf
 create mode 100644 kernel-boot/modules/iwarp.conf
 create mode 100644 kernel-boot/modules/opa.conf
 create mode 100644 kernel-boot/modules/rdma.conf
 create mode 100644 kernel-boot/modules/roce.conf
 create mode 100644 kernel-boot/rdma-description.rules
 create mode 100644 kernel-boot/rdma-hw-modules.rules
 create mode 100644 kernel-boot/rdma-load-modules@.service.in
 create mode 100644 kernel-boot/rdma-ulp-modules.rules

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 16196205035f61..a03d8da31cbc5d 100644
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
diff --git a/Documentation/udev.md b/Documentation/udev.md
new file mode 100644
index 00000000000000..a6328d322c5194
--- /dev/null
+++ b/Documentation/udev.md
@@ -0,0 +1,83 @@
+# Kernel Module Loading
+
+The RDMA subsystem relies on the kernel, udev and systemd to load modules on
+demand when RDMA hardware is present. The RDMA subsystem is unique in that we
+do not load the optional RDMA hardware modules unless the system has the
+rdma-core package installed.
+
+This is to avoid exposing systems not using RDMA from having RDMA enabled, for
+instance if a system has a multi-protocol ethernet adapter, but is only using
+the net stack interface.
+
+## Boot ordering with systemd
+
+systemd assumes everything is hot pluggable and runs in an event driven
+manner.  When working with RDMA devices we are firstly concerned with when the
+physical hardware its module loaded into the kernel.
+
+This can happen in several spots along the bootup:
+
+ - From the initrd or built into the kernel. If hardware modules are present
+   inthe initrd then they are loaded into the kernel before booting the
+   system. This is done largely synchronously with the boot process.
+
+ - From udev when it auto detects PCI hardware or otherwise.
+   This happens asynchronously in the boot process, systemd does not wait for
+   udev to finish loading modules before it continues on.
+
+   This path makes it very likely the system will experience a RDMA 'hot plug'
+   scenario.
+
+ - From systemd's fixed module loader systemd-modules-load.service, eg from
+   the list in /etc/modules-load.d/. In this case the modules load happens
+   synchronously within systemd and it will hold off sysinit.target until
+   modules are loaded
+
+Once the hardware module is loaded it may be necessary to load a protocol
+module, eg to enable RDMA support on an ethernet device.
+
+This is triggered automatically by udev rules that match the master devices
+and load the protocol module with udev's module loader. This happens
+asynchronously to the rest of the systemd startup.
+
+Once a RDMA device is created by the kernel then udev will cause systemd to
+schedule ULP module loading services (eg rdma-load-modules@.service) specific
+to the plugged hardware. If sysinit.target has not yet been passed then these
+loaders will defer sysinit.target until they complete, otherwise this is a hot
+plug event and things will load asynchronously to the boot up process.
+
+Finally udev will cause systemd to start RDMA specific daemons like
+srp_daemon, rdma-ndd and iwpmd. These starts are linked to the detection of
+the first RDMA hardware, and the daemons internally handle hot plug events for
+other hardware.
+
+## Hot Plug compatible services
+
+Services using RDMA need to have device specific systemd dependencies in their
+unit files, either created by hand by the admin or by using udev rules.
+
+For instance, a service that uses /dev/infiniband/umad0 requires:
+
+```
+After=dev-infiniband-umad0.device
+BindsTo=dev-infiniband-umad0.device
+```
+
+Which will ensure the service will not run until the required umad device
+appears.
+
+This is similar to how systemd handles mounting filesystems and configuring
+ethernet devices.
+
+## Interaction with legacy non-hotplug services
+
+Services that cannot handle hot plug must be ordered after
+systemd-udev-settle.service, which will wait for udev to complete loading
+modules and scheduling systemd services. This ensures that all RDMA hardware
+present at boot is setup before proceeding to run the legacy service.
+
+Admins using legacy services can also place their RDMA hardware modules (eg
+mlx4_ib) directly in /etc/modules-load.d/ or in their initrd which will cause
+systemd to defer passing to sysinit.target until all RDMA hardware is setup,
+this is usually sufficient for legacy services. This is probably the default
+behavior in many configurations.
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 0b35ab6372fcbe..44437fcc83dbd8 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,7 +1,16 @@
 etc/modprobe.d/mlx4.conf
 etc/modprobe.d/truescale.conf
+etc/rdma/modules/infiniband.conf
+etc/rdma/modules/iwarp.conf
+etc/rdma/modules/opa.conf
+etc/rdma/modules/rdma.conf
+etc/rdma/modules/roce.conf
+lib/systemd/system/rdma-load-modules@.service
 lib/systemd/system/rdma-ndd.service
 lib/udev/rules.d/60-rdma-ndd.rules
+lib/udev/rules.d/75-rdma-description.rules
+lib/udev/rules.d/90-rdma-hw-modules.rules
+lib/udev/rules.d/90-rdma-ulp-modules.rules
 usr/bin/rxe_cfg
 usr/lib/truescale-serdes.cmds
 usr/sbin/rdma-ndd
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
new file mode 100644
index 00000000000000..0d4a2aec1c6a94
--- /dev/null
+++ b/kernel-boot/CMakeLists.txt
@@ -0,0 +1,24 @@
+rdma_subst_install(FILES rdma-load-modules@.service.in
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  RENAME rdma-load-modules@.service
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
+install(FILES
+  modules/infiniband.conf
+  modules/iwarp.conf
+  modules/opa.conf
+  modules/rdma.conf
+  modules/roce.conf
+  DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/modules")
+
+install(FILES "rdma-description.rules"
+  RENAME "75-rdma-description.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+
+install(FILES "rdma-hw-modules.rules"
+  RENAME "90-rdma-hw-modules.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+
+install(FILES "rdma-ulp-modules.rules"
+  RENAME "90-rdma-ulp-modules.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
diff --git a/kernel-boot/modules/infiniband.conf b/kernel-boot/modules/infiniband.conf
new file mode 100644
index 00000000000000..99526e156fff40
--- /dev/null
+++ b/kernel-boot/modules/infiniband.conf
@@ -0,0 +1,12 @@
+# These modules are loaded by the system if any InfiniBand device is installed
+# InfiniBand over IP netdevice
+ib_ipoib
+
+# Access to fabric management SMPs and GMPs from userspace.
+ib_umad
+
+# SCSI Remote Protocol target support
+# ib_srpt
+
+# ib_ucm provides the obsolete /dev/infiniband/ucm0
+# ib_ucm
diff --git a/kernel-boot/modules/iwarp.conf b/kernel-boot/modules/iwarp.conf
new file mode 100644
index 00000000000000..882146e41ee2ba
--- /dev/null
+++ b/kernel-boot/modules/iwarp.conf
@@ -0,0 +1,2 @@
+# These modules are loaded by the system if any iWarp device is installed
+iw_cm
diff --git a/kernel-boot/modules/opa.conf b/kernel-boot/modules/opa.conf
new file mode 100644
index 00000000000000..b9bc9f1f0146af
--- /dev/null
+++ b/kernel-boot/modules/opa.conf
@@ -0,0 +1,10 @@
+# These modules are loaded by the system if any OmniPath Architecture device
+# is installed
+# Infiniband over IP netdevice
+ib_ipoib
+
+# Access to fabric management SMPs and GMPs from userspace.
+ib_umad
+
+# Omnipath Ethernet Virtual NIC netdevice
+opa_vnic
diff --git a/kernel-boot/modules/rdma.conf b/kernel-boot/modules/rdma.conf
new file mode 100644
index 00000000000000..2d342dd82f7db0
--- /dev/null
+++ b/kernel-boot/modules/rdma.conf
@@ -0,0 +1,21 @@
+# These modules are loaded by the system if any RDMA devices is installed
+# iSCSI over RDMA client support
+ib_iser
+
+# iSCSI over RDMA target support
+# ib_isert
+
+# User access to RDMA verbs (supports libibverbs)
+ib_uverbs
+
+# User access to RDMA connection management (supports librdmacm)
+rdma_ucm
+
+# RDS over RDMA support
+# rds_rdma
+
+# NFS over RDMA client support
+xprtrdma
+
+# NFS over RDMA server support
+svcrdma
diff --git a/kernel-boot/modules/roce.conf b/kernel-boot/modules/roce.conf
new file mode 100644
index 00000000000000..8e4927ce26f043
--- /dev/null
+++ b/kernel-boot/modules/roce.conf
@@ -0,0 +1,2 @@
+# These modules are loaded by the system if any RDMA over Converged Ethernet
+# device is installed
diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-description.rules
new file mode 100644
index 00000000000000..4d7c5808401ac7
--- /dev/null
+++ b/kernel-boot/rdma-description.rules
@@ -0,0 +1,42 @@
+# This is a version of net-description.rules for /sys/class/infiniband devices
+
+ACTION=="remove", GOTO="rdma_description_end"
+SUBSYSTEM!="infiniband", GOTO="rdma_description_end"
+
+# NOTE: DRIVERS searches up the sysfs path to find the driver that is bound to
+# the PCI/etc device that the RDMA device is linked to. This is not the kernel
+# driver that is supplying the RDMA device (eg as seen in ID_NET_DRIVER)
+
+# FIXME: with kernel support we could actually detect the protocols the RDMA
+# driver itself supports, this is a work around for lack of that support.
+# In future we could do this with a udev IMPORT{program} helper program
+# that extracted the ID information from the RDMA netlink.
+
+# Hardware that supports InfiniBand
+DRIVERS=="mlx4_core", ENV{ID_RDMA_INFINIBAND}="1"
+DRIVERS=="mlx5_core", ENV{ID_RDMA_INFINIBAND}="1"
+DRIVERS=="qib", ENV{ID_RDMA_INFINIBAND}="1"
+
+# Hardware that supports OPA
+DRIVERS=="hfi1verbs", ENV{ID_RDMA_OPA}="1"
+
+# Hardware that supports iWarp
+DRIVERS=="cxgb3", ENV{ID_RDMA_IWARP}="1"
+DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
+
+# Hardware that supports RoCE
+DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="i40e", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
+DEVPATH=="*/infiniband/rxe*", ATTR{parent}=="*", ENV{ID_RDMA_ROCE}="1"
+
+# Setup the usual ID information so that systemd will display a sane name for
+# the RDMA device units.
+SUBSYSTEMS=="pci", ENV{ID_BUS}="pci", ENV{ID_VENDOR_ID}="$attr{vendor}", ENV{ID_MODEL_ID}="$attr{device}"
+SUBSYSTEMS=="pci", IMPORT{builtin}="hwdb --subsystem=pci"
+
+LABEL="rdma_description_end"
diff --git a/kernel-boot/rdma-hw-modules.rules b/kernel-boot/rdma-hw-modules.rules
new file mode 100644
index 00000000000000..dde0ab8dacacab
--- /dev/null
+++ b/kernel-boot/rdma-hw-modules.rules
@@ -0,0 +1,39 @@
+ACTION=="remove", GOTO="rdma_hw_modules_end"
+SUBSYSTEM!="net", GOTO="rdma_hw_modules_end"
+
+# Automatically load RDMA specific kernel modules when a multi-function device is installed
+
+# These drivers autoload an ethernet driver based on hardware detection and
+# need userspace to load the module that has their RDMA component to turn on
+# RDMA.
+ENV{ID_NET_DRIVER}=="be2net", RUN{builtin}+="kmod load ocrdma"
+ENV{ID_NET_DRIVER}=="bnxt_en", RUN{builtin}+="kmod load bnxt_re"
+ENV{ID_NET_DRIVER}=="cxgb3", RUN{builtin}+="kmod load iw_cxgb3"
+ENV{ID_NET_DRIVER}=="cxgb4", RUN{builtin}+="kmod load iw_cxgb4"
+ENV{ID_NET_DRIVER}=="hns", RUN{builtin}+="kmod load hns_roce"
+ENV{ID_NET_DRIVER}=="i40e", RUN{builtin}+="kmod load i40iw"
+ENV{ID_NET_DRIVER}=="mlx4_en", RUN{builtin}+="kmod load mlx4_ib"
+ENV{ID_NET_DRIVER}=="mlx5_core", RUN{builtin}+="kmod load mlx5_ib"
+ENV{ID_NET_DRIVER}=="qede", RUN{builtin}+="kmod load qedr"
+
+# The user must explicitly load these modules via /etc/modules-load.d/ or otherwise
+# rxe
+
+# When in IB mode the kernel PCI core module autoloads the protocol modules
+# for these providers
+# mlx4
+# mlx5
+
+# enic no longer has a userspace verbs driver, this rule should probably be
+# owned by libfabric
+ENV{ID_NET_DRIVER}=="enic", RUN{builtin}+="kmod load usnic_verbs"
+
+# These providers are single function and autoload RDMA automatically based on
+# PCI probing
+# hfi1verbs
+# ipathverbs
+# mthca
+# vmw_pvrdma
+# nes
+
+LABEL="rdma_hw_modules_end"
diff --git a/kernel-boot/rdma-load-modules@.service.in b/kernel-boot/rdma-load-modules@.service.in
new file mode 100644
index 00000000000000..b35a493ebf230b
--- /dev/null
+++ b/kernel-boot/rdma-load-modules@.service.in
@@ -0,0 +1,15 @@
+[Unit]
+Description=Load RDMA modules from @CMAKE_INSTALL_SYSCONFDIR@/rdma/modules/%I.conf
+DefaultDependencies=no
+Conflicts=shutdown.target
+# network-pre.target is to support distro network setup scripts that run after
+# systemd-modules-load.service but before sysinit.target, eg a classic network
+# setup script.
+Before=sysinit.target shutdown.target network-pre.target
+ConditionCapability=CAP_SYS_MODULE
+
+[Service]
+Type=oneshot
+RemainAfterExit=yes
+ExecStart=/lib/systemd/systemd-modules-load @CMAKE_INSTALL_SYSCONFDIR@/rdma/modules/%I.conf
+TimeoutSec=90s
diff --git a/kernel-boot/rdma-ulp-modules.rules b/kernel-boot/rdma-ulp-modules.rules
new file mode 100644
index 00000000000000..c090700c754b19
--- /dev/null
+++ b/kernel-boot/rdma-ulp-modules.rules
@@ -0,0 +1,11 @@
+ACTION=="remove", GOTO="rdma_ulp_modules_end"
+SUBSYSTEM!="infiniband", GOTO="rdma_ulp_modules_end"
+
+# Automatically load general RDMA ULP modules when RDMA hardware is installed
+TAG+="systemd", ENV{SYSTEMD_WANTS}+="rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org"
+TAG+="systemd", ENV{ID_RDMA_INFINIBAND}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-WW8hglTQ5Ylgot6vXr2xLYq0XWbe/Iga@public.gmane.org"
+TAG+="systemd", ENV{ID_RDMA_IWARP}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org"
+TAG+="systemd", ENV{ID_RDMA_OPA}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-EhpGOaQAOk9DcWalurthmA@public.gmane.org"
+TAG+="systemd", ENV{ID_RDMA_ROCE}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-eW91h9tu8Y5TDjBF/Jpztg@public.gmane.org"
+
+LABEL="rdma_ulp_modules_end"
diff --git a/rdma-core.spec b/rdma-core.spec
index b923a5d7636548..0c721158d537b4 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -139,4 +139,5 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %config %{_sysconfdir}/iwpmd.conf
 %config %{_sysconfdir}/srp_daemon.conf
 %config %{_sysconfdir}/libibverbs.d/*
+%config %{_sysconfdir}/rdma/modules/*
 %{_sysconfdir}/modprobe.d/*
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 4413418ffc44cc..9892566a0333f5 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -321,17 +321,26 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %doc %{_docdir}/%{name}-%{version}/README.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
 %config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/infiniband.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/iwarp.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/opa.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/rdma.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/roce.conf
 %config(noreplace) %{_sysconfdir}/rdma/rdma.conf
 %config(noreplace) %{_sysconfdir}/rdma/sriov-vfs
 %config(noreplace) %{_sysconfdir}/udev/rules.d/*
 %config(noreplace) %{_sysconfdir}/modprobe.d/mlx4.conf
 %config(noreplace) %{_sysconfdir}/modprobe.d/truescale.conf
 %{_sysconfdir}/sysconfig/network-scripts/*
+%{_unitdir}/rdma-load-modules@.service
 %{_unitdir}/rdma.service
 %dir %{dracutlibdir}/modules.d/05rdma
 %{dracutlibdir}/modules.d/05rdma/module-setup.sh
-%{_udevrulesdir}/98-rdma.rules
 %{_udevrulesdir}/60-rdma-ndd.rules
+%{_udevrulesdir}/75-rdma-description.rules
+%{_udevrulesdir}/90-rdma-hw-modules.rules
+%{_udevrulesdir}/90-rdma-ulp-modules.rules
+%{_udevrulesdir}/98-rdma.rules
 %{sysmodprobedir}/libmlx4.conf
 %{sysmodprobedir}/cxgb3.conf
 %{sysmodprobedir}/cxgb4.conf
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
