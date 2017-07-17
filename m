From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core v2] ibacm: Add systemd service file
Date: Mon, 17 Jul 2017 11:42:44 +0200
Message-ID: <20170717094244.9253-1-benjamin.drung@profitbricks.com>
References: <20170716152013.GC15371@mtr-leonro.local>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170716152013.GC15371-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibacm ships only a sysvinit script but no corresponding systemd unit
file. The RedHat package ships its own systemd unit file. Thus make it
available to all.

The ibacm service depends on sysinit.target (DefaultDependencies=yes)
and the proposed rdma or rdma-load-modules services declare a dependency
Before=sysinit.target. Thus the kernel modules will be loaded before the
sysinit target and the ibacm service does not need to depend on (the not
yet existing) rdma service.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/ibacm.install   |  1 +
 ibacm/CMakeLists.txt   |  5 +++++
 ibacm/ibacm.service.in | 11 +++++++++++
 redhat/ibacm.service   | 12 ------------
 redhat/rdma-core.spec  |  1 -
 5 files changed, 17 insertions(+), 13 deletions(-)
 create mode 100644 ibacm/ibacm.service.in
 delete mode 100644 redhat/ibacm.service

diff --git a/debian/ibacm.install b/debian/ibacm.install
index c8be4a6f..41cf5bad 100644
--- a/debian/ibacm.install
+++ b/debian/ibacm.install
@@ -1,4 +1,5 @@
 etc/init.d/ibacm
+lib/systemd/system/ibacm.service
 usr/bin/ib_acme
 usr/include/infiniband/acm.h
 usr/include/infiniband/acm_prov.h
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 7eba294b..5e3ea5e2 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -64,3 +64,8 @@ rdma_subst_install(FILES "ibacm.init.in"
   DESTINATION "${CMAKE_INSTALL_INITDDIR}"
   RENAME "ibacm"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+
+rdma_subst_install(FILES "ibacm.service.in"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
+  RENAME ibacm.service
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
new file mode 100644
index 00000000..6cbb203e
--- /dev/null
+++ b/ibacm/ibacm.service.in
@@ -0,0 +1,11 @@
+[Unit]
+Description=Starts the InfiniBand Address Cache Manager daemon
+Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
+After=opensm.service
+
+[Service]
+Type=forking
+ExecStart=@prefix@/sbin/ibacm
+
+[Install]
+WantedBy=network.target
diff --git a/redhat/ibacm.service b/redhat/ibacm.service
deleted file mode 100644
index bb28928c..00000000
--- a/redhat/ibacm.service
+++ /dev/null
@@ -1,12 +0,0 @@
-[Unit]
-Description=Starts the InfiniBand Address Cache Manager daemon
-Documentation=man:ibacm file:/etc/rdma/ibacm_opts.cfg
-Requires=rdma.service
-After=rdma.service opensm.service
-
-[Service]
-Type=forking
-ExecStart=/usr/sbin/ibacm
-
-[Install]
-WantedBy=network.target
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 5cebc251..817013bc 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -271,7 +271,6 @@ install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setu
 # ibacm
 bin/ib_acme -D . -O
 install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
-install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
 
 # Delete the package's init.d scripts
 rm -rf %{buildroot}/%{_initrddir}/
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
