From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/5] iwpmd: Autoload iwpmd if required
Date: Mon, 24 Jul 2017 14:44:25 -0600
Message-ID: <1500929067-1583-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use udev to determine if an iWarp device is present, and if so then start
iwpmd and autoload the required module. iwpmd no longer starts if it is
simply installed.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/iwpmd.install           | 2 ++
 iwpmd/CMakeLists.txt           | 8 ++++++++
 iwpmd/iwpmd.rules              | 1 +
 iwpmd/iwpmd.service.in         | 6 +++---
 iwpmd/modules-iwpmd.conf       | 2 ++
 kernel-boot/modules/iwarp.conf | 1 -
 redhat/rdma-core.spec          | 2 ++
 7 files changed, 18 insertions(+), 4 deletions(-)
 create mode 100644 iwpmd/iwpmd.rules
 create mode 100644 iwpmd/modules-iwpmd.conf

diff --git a/debian/iwpmd.install b/debian/iwpmd.install
index cd9f7adbdd287d..51ac19ad382e9e 100644
--- a/debian/iwpmd.install
+++ b/debian/iwpmd.install
@@ -1,6 +1,8 @@
 etc/init.d/iwpmd
 etc/iwpmd.conf
+etc/rdma/modules/iwpmd.conf
 lib/systemd/system/iwpmd.service
+lib/udev/rules.d/90-iwpmd.rules
 usr/sbin/iwpmd
 usr/share/man/man1/iwpmd.1
 usr/share/man/man5/iwpmd.conf.5
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index 200b14c1786422..f500d196acf649 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -21,3 +21,11 @@ rdma_subst_install(FILES "iwpmd_init.in"
   RENAME "iwpmd"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
 install(FILES "iwpmd.conf" DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
+
+install(FILES "iwpmd.rules"
+  RENAME "90-iwpmd.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+
+install(FILES modules-iwpmd.conf
+  RENAME "iwpmd.conf"
+  DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rdma/modules")
diff --git a/iwpmd/iwpmd.rules b/iwpmd/iwpmd.rules
new file mode 100644
index 00000000000000..5b22cceaf29f8c
--- /dev/null
+++ b/iwpmd/iwpmd.rules
@@ -0,0 +1 @@
+TAG+="systemd", ENV{ID_RDMA_IWARP}=="1", ENV{SYSTEMD_WANTS}+="iwpmd.service"
diff --git a/iwpmd/iwpmd.service.in b/iwpmd/iwpmd.service.in
index 47ca6518ee127c..83c1da98558a9f 100644
--- a/iwpmd/iwpmd.service.in
+++ b/iwpmd/iwpmd.service.in
@@ -1,12 +1,12 @@
 [Unit]
 Description=iWarp Port Mapper
 Documentation=man:iwpmd file:/etc/iwpmd.conf
-After=network.target
+Requires=rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
+After=network.target rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
 
 [Service]
 ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd
 LimitNOFILE=102400
 KillMode=process
 
-[Install]
-WantedBy=multi-user.target
+# iwpmd is automatically started by udev when an iWarp RDMA device is present
diff --git a/iwpmd/modules-iwpmd.conf b/iwpmd/modules-iwpmd.conf
new file mode 100644
index 00000000000000..5544b359c08814
--- /dev/null
+++ b/iwpmd/modules-iwpmd.conf
@@ -0,0 +1,2 @@
+# These modules are loaded by the system if iwpmd is to be run
+iw_cm
diff --git a/kernel-boot/modules/iwarp.conf b/kernel-boot/modules/iwarp.conf
index 882146e41ee2ba..0cb831da5bb557 100644
--- a/kernel-boot/modules/iwarp.conf
+++ b/kernel-boot/modules/iwarp.conf
@@ -1,2 +1 @@
 # These modules are loaded by the system if any iWarp device is installed
-iw_cm
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 124aec402997c5..901c726037fdfe 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -403,7 +403,9 @@ rm -rf %{buildroot}/%{_initrddir}/
 %files -n iwpmd
 %{_sbindir}/iwpmd
 %{_unitdir}/iwpmd.service
+%config(noreplace) %{_sysconfdir}/rdma/modules/iwpmd.conf
 %config(noreplace) %{_sysconfdir}/iwpmd.conf
+%{_udevrulesdir}/90-iwpmd.rules
 %{_mandir}/man1/iwpmd.*
 %{_mandir}/man5/iwpmd.*
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
