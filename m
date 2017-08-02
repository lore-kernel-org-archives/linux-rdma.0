From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] Revise systemd dependencies for all units
Date: Wed, 2 Aug 2017 16:59:36 -0600
Message-ID: <20170802225936.GA15693@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The goal here is to set the rdma components within the usual systemd
framework so that an out-of-tree unit can have some standard things to hook
into for ordering.

This does not eliminate the need for units to have dependencies on the
RDMA devices they use, but it does introduce a generic 'rdma-hw.target',
which gets pulled in when udev detects RDMA hardware, similar to
existing systemd targets like bluetooth.target.

This also uses rdma-hw.target as a synchronization point, the following
happen before rdma-hw becomes activated:
 - All RDMA kernel modules have completed loading
 - rdma-ndd is started and has set the node description
 - iwpmd has started and attached to the kernel
 - ibacm's socket is created

After rdma-hw is activated the following can happen:
 - ibacm can start (after basic.target)
 - srp_daemon_port can start (potentially before sysinit.target)

The basic rdma services are also connected to the pre-existing
network-pre.target, ordering the following before it becomes active:
 - iwpmd is running
 - rmda-ndd is running
 - hardware modules are loaded

As well as the existing network.target for compatibility with LSB
init.d scripts.

Finally this revises the coding format for the unit files to include
a discussion why each dependency exists and what it is trying to
accomplish. This should help maintenance down the road.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 Documentation/udev.md                     | 69 ++++++++++++++++++++++++++++++-
 debian/control                            |  5 ++-
 debian/rdma-core.install                  |  1 +
 ibacm/ibacm.service.in                    | 17 ++++++--
 ibacm/ibacm.socket                        |  5 +++
 iwpmd/iwpmd.service.in                    | 21 ++++++++--
 kernel-boot/CMakeLists.txt                |  5 +++
 kernel-boot/rdma-hw.target.in             | 13 ++++++
 kernel-boot/rdma-load-modules@.service.in | 15 +++++--
 kernel-boot/rdma-ulp-modules.rules        |  2 +-
 rdma-ndd/rdma-ndd.service.in              | 14 +++++++
 redhat/rdma-core.spec                     |  1 +
 srp_daemon/srp_daemon.service.in          |  2 +-
 srp_daemon/srp_daemon_port@.service.in    | 25 +++++++++--
 14 files changed, 177 insertions(+), 18 deletions(-)
 create mode 100644 kernel-boot/rdma-hw.target.in

This sits on top of all the outstanding PRs on github and shows how
everything fits together to set the boot time ordering for the new
systemd components.

diff --git a/Documentation/udev.md b/Documentation/udev.md
index 4d06fa84942660..7da3ed94b850eb 100644
--- a/Documentation/udev.md
+++ b/Documentation/udev.md
@@ -65,12 +65,12 @@ BindsTo=dev-infiniband-umad0.device
 ```
 
 Which will ensure the service will not run until the required umad device
-appears.
+appears, and will be stopped if the umad device is unplugged.
 
 This is similar to how systemd handles mounting filesystems and configuring
 ethernet devices.
 
-## Interaction with le.g.acy non-hotplug services
+## Interaction with legacy non-hotplug services
 
 Services that cannot handle hot plug must be ordered after
 systemd-udev-settle.service, which will wait for udev to complete loading
@@ -82,3 +82,68 @@ Admins using le.g.acy services can also place their RDMA hardware modules
 cause systemd to defer passing to sysinit.target until all RDMA hardware is
 setup, this is usually sufficient for le.g.acy services. This is probably the
 default behavior in many configurations.
+
+# Systemd Ordering
+
+Within rdma-core we have a series of units which run in the pre `basic.target`
+world to setup kernel services:
+
+ - `iwpmd`
+ - `rdma-ndd`
+ - `rdma-load-modules@.service`
+ - `ibacmd.socket`
+
+These special units use DefaultDependencies=no and order before any other unit that
+uses DefaultDependencies=yes. This will happen even in the case of hotplug.
+
+Units for normal rdma-using daemons should use DefaultDependencies=yes, and
+either this pattern for 'any RDMA device':
+
+```
+[Unit]
+# Order after rdma-hw.target has become active and setup the kernel services
+Requires=rdma-hw.target
+After=rdma-hw.target
+
+[Install]
+# Autostart when RDMA hardware is present
+WantedBy=rdma-hw.target
+```
+
+Or this pattern for a specific RDMA device:
+
+```
+[Unit]
+# Order after RDMA services are setup
+After=rdma-hw.target
+# Run only while a specific umad device is present
+After=dev-infiniband-umad0.device
+BindsTo=dev-infiniband-umad0.device
+
+[Install]
+# Schedual the unit to be runnable when RDMA hardware is present, but
+# it will only start once the requested device actuall appears.
+WantedBy=rdma-hw.target
+```
+
+Note, the above does explicitly reference `After=rdma-hw.target` even though
+all the current constituents of that target order before
+`sysinit.target`. This is to provide greater flexibility in the future.
+
+## rdma-hw.target
+
+This target is Wanted automatically by udev as soon as any RDMA hardware is
+plugged in or becomes available at boot.
+
+This may be used to pull in rdma management daemons dynamically when RDMA
+hardware is found. Such daemons should use:
+
+```
+[Install]
+WantedBy=rdma-hw.target
+```
+
+In their unit files.
+
+`rdma-hw.target` is also a synchronization point that orders after the low level,
+pre `sysinit.target` RDMA related units have been started.
diff --git a/debian/control b/debian/control
index 40773e322d1051..5308378198bfac 100644
--- a/debian/control
+++ b/debian/control
@@ -37,7 +37,10 @@ Description: RDMA core userspace infrastructure and documentation
 
 Package: ibacm
 Architecture: any
-Depends: lsb-base (>= 3.2-14~), ${misc:Depends}, ${shlibs:Depends}
+Depends: lsb-base (>= 3.2-14~),
+         rdma-core (>= 15),
+         ${misc:Depends},
+         ${shlibs:Depends}
 Description: InfiniBand Communication Manager Assistant (ACM)
  The IB ACM implements and provides a framework for name, address, and
  route (path) resolution services over InfiniBand.
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 860d54364af6f5..7129c912069a75 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -5,6 +5,7 @@ etc/rdma/modules/iwarp.conf
 etc/rdma/modules/opa.conf
 etc/rdma/modules/rdma.conf
 etc/rdma/modules/roce.conf
+lib/systemd/system/rdma-hw.target
 lib/systemd/system/rdma-load-modules@.service
 lib/systemd/system/rdma-ndd.service
 lib/udev/rules.d/60-rdma-ndd.rules
diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index 7f31ba673da979..d0f5c58d5038f0 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -1,12 +1,23 @@
 [Unit]
 Description=InfiniBand Address Cache Manager Daemon
-Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
-After=opensm.service
+Documentation=man:ibacm file:@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/ibacm_opts.cfg
+# Cause systemd to always start the socket, which means the parameters in
+# ibacm.socket always configures the listening socket, even if the deamon is
+# started directly.
 Wants=ibacm.socket
+# Ensure required kernel modules are loaded before starting
+Wants=rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org
+After=rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org
+# Order ibacm startup after basic RDMA hw setup.
+After=rdma-hw.target
+
+# Implicitly after basic.target, note that ibacm writes to /var/log directly
+# and thus needs writable filesystems setup.
 
 [Service]
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm --systemd
 
 [Install]
 Also=ibacm.socket
-WantedBy=network.target
+# Only want ibacm if RDMA hardware is present (or the socket is touched)
+WantedBy=rdma-hw.target
diff --git a/ibacm/ibacm.socket b/ibacm/ibacm.socket
index 080257e9c7c320..aa94c91d60daf1 100644
--- a/ibacm/ibacm.socket
+++ b/ibacm/ibacm.socket
@@ -1,10 +1,15 @@
 [Unit]
 Description=Socket for InfiniBand Address Cache Manager Daemon
 Documentation=man:ibacm
+# Ensure that anything ordered after rdma-hw.target will see the socket, even
+# if that thing is not ordered after socket.target/basic.target.
+Before=rdma-hw.target
+# ibacm.socket always starts
 
 [Socket]
 ListenStream=6125
 BindToDevice=lo
 
 [Install]
+# Standard for all sockets
 WantedBy=sockets.target
diff --git a/iwpmd/iwpmd.service.in b/iwpmd/iwpmd.service.in
index 4e4b49738fa29d..289991dcb9cd8a 100644
--- a/iwpmd/iwpmd.service.in
+++ b/iwpmd/iwpmd.service.in
@@ -1,11 +1,26 @@
 [Unit]
 Description=iWarp Port Mapper
 Documentation=man:iwpmd file:/etc/iwpmd.conf
-Requires=rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
-After=network.target rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
+# iwpmd is a kernel support program and needs to run as early as possible,
+# otherwise the kernel or userspace cannot establish RDMA connections and
+# things will just fail, not block until iwpmd arrives.
+DefaultDependencies=no
+Before=sysinit.target
+# Do not execute concurrently with an ongoing shutdown (required for DefaultDependencies=no)
+Conflicts=shutdown.target
+Before=shutdown.target
+# Ensure required kernel modules are loaded before starting
+Wants=rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
+After=rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
+# iwpmd needs to start before networking is brought up, even kernel networking
+# (eg NFS) since it provides kernel support for iWarp's RDMA CM.
+Wants=network-pre.target
+Before=network-pre.target
+# rdma-hw is not ready until iwpmd is running
+Before=rdma-hw.target
 
 [Service]
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd --systemd
 LimitNOFILE=102400
 
-# iwpmd is automatically started by udev when an iWarp RDMA device is present
+# iwpmd is automatically wanted by udev when an iWarp RDMA device is present
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
index fdb70117f5899c..299a8f3f66364c 100644
--- a/kernel-boot/CMakeLists.txt
+++ b/kernel-boot/CMakeLists.txt
@@ -3,6 +3,11 @@ rdma_subst_install(FILES rdma-load-modules@.service.in
   RENAME rdma-load-modules@.service
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
 
+rdma_subst_install(FILES "rdma-hw.target.in"
+  RENAME "rdma-hw.target"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
+
 install(FILES
   modules/infiniband.conf
   modules/iwarp.conf
diff --git a/kernel-boot/rdma-hw.target.in b/kernel-boot/rdma-hw.target.in
new file mode 100644
index 00000000000000..010e21e6704389
--- /dev/null
+++ b/kernel-boot/rdma-hw.target.in
@@ -0,0 +1,13 @@
+[Unit]
+Description=RDMA Hardware
+Documentation=file:@CMAKE_INSTALL_FULL_DOCDIR@/udev.md
+StopWhenUnneeded=yes
+
+# Start the basic ULP RDMA kernel modules when RDMA hardware is detected (note
+# the rdma-load-modules@.service is already before this target)
+Wants=rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org
+# Order after the standard network.target for compatibility with init.d
+# scripts that order after networking - this will mean RDMA is ready too.
+Before=network.target
+# We do not order rdma-hw before basic.target, units for daemons that use RDMA
+# have to manually order after rdma-hw.target
diff --git a/kernel-boot/rdma-load-modules@.service.in b/kernel-boot/rdma-load-modules@.service.in
index e5552ebf379355..d381bc5ba359e7 100644
--- a/kernel-boot/rdma-load-modules@.service.in
+++ b/kernel-boot/rdma-load-modules@.service.in
@@ -1,12 +1,21 @@
 [Unit]
 Description=Load RDMA modules from @CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/modules/%I.conf
 Documentation=file:@CMAKE_INSTALL_FULL_DOCDIR@/udev.md
+# Kernel module loading must take place before sysinit.target, similar to
+# systemd-modules-load.service
 DefaultDependencies=no
+Before=sysinit.target
+# Do not execute concurrently with an ongoing shutdown
 Conflicts=shutdown.target
-# network-pre.target is to support distro network setup scripts that run after
+Before=shutdown.target
+# Partially support distro network setup scripts that run after
 # systemd-modules-load.service but before sysinit.target, eg a classic network
-# setup script.
-Before=sysinit.target shutdown.target network-pre.target
+# setup script. Run them after modules have loaded.
+Wants=network-pre.target
+Before=network-pre.target
+# Orders all kernel module startup before rdma-hw.target can become ready
+Before=rdma-hw.target
+
 ConditionCapability=CAP_SYS_MODULE
 
 [Service]
diff --git a/kernel-boot/rdma-ulp-modules.rules b/kernel-boot/rdma-ulp-modules.rules
index c090700c754b19..fbd195a2c0b3e8 100644
--- a/kernel-boot/rdma-ulp-modules.rules
+++ b/kernel-boot/rdma-ulp-modules.rules
@@ -2,7 +2,7 @@ ACTION=="remove", GOTO="rdma_ulp_modules_end"
 SUBSYSTEM!="infiniband", GOTO="rdma_ulp_modules_end"
 
 # Automatically load general RDMA ULP modules when RDMA hardware is installed
-TAG+="systemd", ENV{SYSTEMD_WANTS}+="rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org"
+TAG+="systemd", ENV{SYSTEMD_WANTS}+="rdma-hw.target"
 TAG+="systemd", ENV{ID_RDMA_INFINIBAND}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-WW8hglTQ5Ylgot6vXr2xLYq0XWbe/Iga@public.gmane.org"
 TAG+="systemd", ENV{ID_RDMA_IWARP}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org"
 TAG+="systemd", ENV{ID_RDMA_OPA}=="1", ENV{SYSTEMD_WANTS}+="rdma-load-modules-EhpGOaQAOk9DcWalurthmA@public.gmane.org"
diff --git a/rdma-ndd/rdma-ndd.service.in b/rdma-ndd/rdma-ndd.service.in
index ba6868cc13801a..f96d169efb4201 100644
--- a/rdma-ndd/rdma-ndd.service.in
+++ b/rdma-ndd/rdma-ndd.service.in
@@ -1,8 +1,22 @@
 [Unit]
 Description=RDMA Node Description Daemon
 Documentation=man:rdma-ndd
+# rdma-ndd is a kernel support program and needs to run as early as possible,
+# before the network link is brought up, and before an external manager tries
+# to read the local node description.
+DefaultDependencies=no
+Before=sysinit.target
+# Do not execute concurrently with an ongoing shutdown (required for DefaultDependencies=no)
+Conflicts=shutdown.target
+Before=shutdown.target
+# Networking, particularly link up, should not happen until ndd is ready
+Wants=network-pre.target
+Before=network-pre.target
+# rdma-hw is not ready until ndd is running
+Before=rdma-hw.target
 
 [Service]
 Restart=always
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/rdma-ndd -f
 
+# rdma-ndd is automatically wanted by udev when an RDMA device with a node description is present
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index b4715b53365bdc..61e16de5c784c4 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -331,6 +331,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %config(noreplace) %{_sysconfdir}/modprobe.d/mlx4.conf
 %config(noreplace) %{_sysconfdir}/modprobe.d/truescale.conf
 %{_sysconfdir}/sysconfig/network-scripts/*
+%{_unitdir}/rdma-hw.target
 %{_unitdir}/rdma-load-modules@.service
 %{_unitdir}/rdma.service
 %dir %{dracutlibdir}/modules.d/05rdma
diff --git a/srp_daemon/srp_daemon.service.in b/srp_daemon/srp_daemon.service.in
index cca1fce9c99283..188b7e1a3712fd 100644
--- a/srp_daemon/srp_daemon.service.in
+++ b/srp_daemon/srp_daemon.service.in
@@ -8,7 +8,7 @@ Before=remote-fs-pre.target
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-ExecStart=@CMAKE_INSTALL_LIBEXECDIR@/srp_daemon/start_on_all_ports
+ExecStart=@CMAKE_INSTALL_FULL_LIBEXECDIR@/srp_daemon/start_on_all_ports
 MemoryDenyWriteExecute=yes
 PrivateTmp=yes
 ProtectHome=yes
diff --git a/srp_daemon/srp_daemon_port@.service.in b/srp_daemon/srp_daemon_port@.service.in
index 5c215cb935bc73..3d5a11e86cab85 100644
--- a/srp_daemon/srp_daemon_port@.service.in
+++ b/srp_daemon/srp_daemon_port@.service.in
@@ -1,12 +1,25 @@
 [Unit]
 Description=SRP daemon that monitors port %i
 Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
+# srp_daemon is required to mount filesystems, and could run before sysinit.target
 DefaultDependencies=false
-Conflicts=emergency.target emergency.service
-Requires=rdma-load-modules@srp_daemon.service
-After=srp_daemon.service rdma-load-modules@srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device network.target
-BindsTo=srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device
 Before=remote-fs-pre.target
+# Do not execute concurrently with an ongoing shutdown (required for DefaultDependencies=no)
+Conflicts=shutdown.target
+Before=shutdown.target
+# Ensure required kernel modules are loaded before starting
+Requires=rdma-load-modules@srp_daemon.service
+After=rdma-load-modules@srp_daemon.service
+# Complete setting up low level RDMA hardware
+After=rdma-hw.target
+# Only run while the RDMA udev device is in an active state, and shutdown if
+# it becomes unplugged.
+After=sys-subsystem-rdma-devices-%i-umad.device
+BindsTo=sys-subsystem-rdma-devices-%i-umad.device
+# Allow srp_daemon to act as a leader for all of the port services for
+# stop/start/reset
+After=srp_daemon.service
+BindsTo=srp_daemon.service
 
 [Service]
 Type=simple
@@ -22,4 +35,8 @@ RestrictRealtime=yes
 SystemCallFilter=~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io
 
 [Install]
+# Instances of this template unit file is started automatically by udev or by
+# srp_daemon.service as devices are discovered.  However, if the user manually
+# enables a template unit then it will be installed with remote-fs-pre. Note
+# that systemd will defer starting the unit until the rdma .device appears.
 WantedBy=remote-fs-pre.target
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
