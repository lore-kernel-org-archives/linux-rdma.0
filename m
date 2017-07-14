From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] ibacm: Add systemd service file
Date: Fri, 14 Jul 2017 15:26:04 +0200
Message-ID: <20170714132604.4629-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibacm ships only a sysvinit script but no corresponding systemd unit
file. The RedHat package ships its own systemd unit file. Thus make it
available to all.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/ibacm.install                           | 1 +
 ibacm/CMakeLists.txt                           | 5 +++++
 redhat/ibacm.service => ibacm/ibacm.service.in | 4 ++--
 redhat/rdma-core.spec                          | 1 -
 4 files changed, 8 insertions(+), 3 deletions(-)
 rename redhat/ibacm.service => ibacm/ibacm.service.in (63%)

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
diff --git a/redhat/ibacm.service b/ibacm/ibacm.service.in
similarity index 63%
rename from redhat/ibacm.service
rename to ibacm/ibacm.service.in
index bb28928c..3879dc45 100644
--- a/redhat/ibacm.service
+++ b/ibacm/ibacm.service.in
@@ -1,12 +1,12 @@
 [Unit]
 Description=Starts the InfiniBand Address Cache Manager daemon
-Documentation=man:ibacm file:/etc/rdma/ibacm_opts.cfg
+Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg
 Requires=rdma.service
 After=rdma.service opensm.service
 
 [Service]
 Type=forking
-ExecStart=/usr/sbin/ibacm
+ExecStart=@prefix@/sbin/ibacm
 
 [Install]
 WantedBy=network.target
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
