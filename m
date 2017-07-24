From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 19/21] iwpmd: Fix install path for iwpmd
Date: Mon, 24 Jul 2017 14:00:27 -0600
Message-ID: <1500926429-31822-20-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

iwpmd is not user runnable, so it should be installed in sbin.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/iwpmd.install                      | 2 +-
 iwpmd/CMakeLists.txt                      | 8 +++++---
 iwpmd/{iwpmd.service => iwpmd.service.in} | 2 +-
 iwpmd/{iwpmd_init => iwpmd_init.in}       | 2 +-
 redhat/rdma-core.spec                     | 2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)
 rename iwpmd/{iwpmd.service => iwpmd.service.in} (80%)
 rename iwpmd/{iwpmd_init => iwpmd_init.in} (97%)
 mode change 100755 => 100644

diff --git a/debian/iwpmd.install b/debian/iwpmd.install
index bff17f15abf7d9..cd9f7adbdd287d 100644
--- a/debian/iwpmd.install
+++ b/debian/iwpmd.install
@@ -1,6 +1,6 @@
 etc/init.d/iwpmd
 etc/iwpmd.conf
 lib/systemd/system/iwpmd.service
-usr/bin/iwpmd
+usr/sbin/iwpmd
 usr/share/man/man1/iwpmd.1
 usr/share/man/man5/iwpmd.conf.5
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index ee9e5a3dfeb24e..200b14c1786422 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -1,4 +1,4 @@
-rdma_executable(iwpmd
+rdma_sbin_executable(iwpmd
   iwarp_pm_common.c
   iwarp_pm_helper.c
   iwarp_pm_server.c
@@ -13,8 +13,10 @@ rdma_man_pages(
   iwpmd.conf.5.in
   )
 
-install(FILES "iwpmd.service" DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
-install(FILES "iwpmd_init"
+rdma_subst_install(FILES "iwpmd.service.in"
+  RENAME "iwpmd.service"
+  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+rdma_subst_install(FILES "iwpmd_init.in"
   DESTINATION "${CMAKE_INSTALL_INITDDIR}"
   RENAME "iwpmd"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
diff --git a/iwpmd/iwpmd.service b/iwpmd/iwpmd.service.in
similarity index 80%
rename from iwpmd/iwpmd.service
rename to iwpmd/iwpmd.service.in
index 6d093fb2fda5a7..47ca6518ee127c 100644
--- a/iwpmd/iwpmd.service
+++ b/iwpmd/iwpmd.service.in
@@ -4,7 +4,7 @@ Documentation=man:iwpmd file:/etc/iwpmd.conf
 After=network.target
 
 [Service]
-ExecStart=/usr/bin/iwpmd
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd
 LimitNOFILE=102400
 KillMode=process
 
diff --git a/iwpmd/iwpmd_init b/iwpmd/iwpmd_init.in
old mode 100755
new mode 100644
similarity index 97%
rename from iwpmd/iwpmd_init
rename to iwpmd/iwpmd_init.in
index 0d2559e9de4a98..f3ae269c795c89
--- a/iwpmd/iwpmd_init
+++ b/iwpmd/iwpmd_init.in
@@ -16,7 +16,7 @@
 # Description: iWarp Port Mapper Daemon for opening sockets to claim TCP ports from userspace
 ### END INIT INFO
 
-IWPMD_BIN="/usr/bin/iwpmd"
+IWPMD_BIN="@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd"
 LOCK="/var/lock/subsys/iwpmd"
 IWPMD_PID=0
 RETVAL=0
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 8961d33e618b1d..fb6d7ffc4f29fa 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -393,7 +393,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %doc %{_docdir}/%{name}-%{version}/ibacm.md
 
 %files -n iwpmd
-%{_bindir}/iwpmd
+%{_sbindir}/iwpmd
 %{_unitdir}/iwpmd.service
 %config(noreplace) %{_sysconfdir}/iwpmd.conf
 %{_mandir}/man1/iwpmd.*
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
