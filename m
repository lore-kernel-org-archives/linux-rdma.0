From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 5/6] srp_daemon: Autoload the SRP kernel module if required
Date: Thu, 27 Jul 2017 16:31:24 -0600
Message-ID: <1501194685-9447-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We use the rdma-core module loading infrastructure to load a srp_daemon
specific module list before allowing srp_daemon to start.

This is in lieu of kernel module auto loading, which is hard to trigger
for sysfs based interfaces.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/srptools.install                | 1 +
 redhat/rdma-core.spec                  | 1 +
 srp_daemon/CMakeLists.txt              | 4 ++++
 srp_daemon/modules-srp_daemon.conf     | 2 ++
 srp_daemon/srp_daemon.service.in       | 2 +-
 srp_daemon/srp_daemon_port@.service.in | 3 ++-
 6 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 srp_daemon/modules-srp_daemon.conf

diff --git a/debian/srptools.install b/debian/srptools.install
index f780d663c9113b..a30798cf088a03 100644
--- a/debian/srptools.install
+++ b/debian/srptools.install
@@ -1,3 +1,4 @@
+etc/rdma/modules/srp_daemon.conf
 etc/srp_daemon.conf
 lib/systemd/system/srp_daemon.service
 lib/systemd/system/srp_daemon_port@.service
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index a11de8df3f45a7..f1b23669e7e601 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -449,6 +449,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 
 %files -n srp_daemon
 %config(noreplace) %{_sysconfdir}/srp_daemon.conf
+%config(noreplace) %{_sysconfdir}/rdma/modules/srp_daemon.conf
 %{_libexecdir}/srp_daemon/start_on_all_ports
 %{_unitdir}/srp_daemon.service
 %{_unitdir}/srp_daemon_port@.service
diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index 92a1d709364b0b..0e7de9594b6375 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -47,6 +47,10 @@ install(FILES "srp_daemon.rules"
   RENAME "60-srp_daemon.rules"
   DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
+install(FILES modules-srp_daemon.conf
+  RENAME "srp_daemon.conf"
+  DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/modules")
+
 # FIXME: The ib init.d file should really be included in rdma-core as well.
 set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
 # NOTE: These defaults are for CentOS, packagers should override.
diff --git a/srp_daemon/modules-srp_daemon.conf b/srp_daemon/modules-srp_daemon.conf
new file mode 100644
index 00000000000000..dbe434362f10a3
--- /dev/null
+++ b/srp_daemon/modules-srp_daemon.conf
@@ -0,0 +1,2 @@
+# These modules are loaded by the system if srp_daemon is to be run
+ib_srp
diff --git a/srp_daemon/srp_daemon.service.in b/srp_daemon/srp_daemon.service.in
index 33dddd5cb46fef..cca1fce9c99283 100644
--- a/srp_daemon/srp_daemon.service.in
+++ b/srp_daemon/srp_daemon.service.in
@@ -1,6 +1,6 @@
 [Unit]
 Description=Daemon that discovers and logs in to SRP target systems
-Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
+Documentation=man:srp_daemon file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
 Before=remote-fs-pre.target
diff --git a/srp_daemon/srp_daemon_port@.service.in b/srp_daemon/srp_daemon_port@.service.in
index 2475db8640a9bd..5c215cb935bc73 100644
--- a/srp_daemon/srp_daemon_port@.service.in
+++ b/srp_daemon/srp_daemon_port@.service.in
@@ -3,7 +3,8 @@ Description=SRP daemon that monitors port %i
 Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
-After=srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device network.target
+Requires=rdma-load-modules@srp_daemon.service
+After=srp_daemon.service rdma-load-modules@srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device network.target
 BindsTo=srp_daemon.service sys-subsystem-rdma-devices-%i-umad.device
 Before=remote-fs-pre.target
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
