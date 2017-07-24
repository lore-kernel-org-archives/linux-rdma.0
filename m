From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 13/21] Prefix udev rules with a number
Date: Mon, 24 Jul 2017 14:00:21 -0600
Message-ID: <1500926429-31822-14-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This follows the standard convention for udev.

I could not find an outline of where different activities should fall
within the numbering scheme, so these are a guess:

- 90 for libibumad rules because it only sets SYSTEMD_ALIAS and the only
  other rules to do that are labeled 99
- 60 for srp_daemon/ndd because other rules dealing with matching
  hardware seem to be around there as well

Fixes: 5a6f287a3cdf ("libibumad: Introduce the /dev/infiniband/umad/${ibdev}:${port}.device alias")
Fixes: d35e5c4f7169 ("srp_daemon.service: Add support for hot-plugging")
Fixes: 4910f1eb752e ("rdma-ndd: add rdma-ndd from infiniband-diags")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/libibumad3.install | 2 +-
 debian/rdma-core.install  | 2 +-
 debian/srptools.install   | 2 +-
 libibumad/CMakeLists.txt  | 4 ++--
 rdma-ndd/CMakeLists.txt   | 4 +++-
 redhat/rdma-core.spec     | 6 +++---
 srp_daemon/CMakeLists.txt | 4 +++-
 7 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/debian/libibumad3.install b/debian/libibumad3.install
index 80a40982833e63..41339ebfa2f229 100644
--- a/debian/libibumad3.install
+++ b/debian/libibumad3.install
@@ -1,2 +1,2 @@
-lib/udev/rules.d/libibumad.rules
+lib/udev/rules.d/90-libibumad.rules
 usr/lib/*/libibumad*.so.*
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 871f5ff543f2bf..4bab264208b691 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,6 +1,6 @@
 etc/modprobe.d/truescale.conf
 lib/systemd/system/rdma-ndd.service
-lib/udev/rules.d/rdma-ndd.rules
+lib/udev/rules.d/60-rdma-ndd.rules
 usr/lib/truescale-serdes.cmds
 usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
diff --git a/debian/srptools.install b/debian/srptools.install
index d1c9a42c890fcd..f780d663c9113b 100644
--- a/debian/srptools.install
+++ b/debian/srptools.install
@@ -1,7 +1,7 @@
 etc/srp_daemon.conf
 lib/systemd/system/srp_daemon.service
 lib/systemd/system/srp_daemon_port@.service
-lib/udev/rules.d/srp_daemon.rules
+lib/udev/rules.d/60-srp_daemon.rules
 usr/lib/srp_daemon/start_on_all_ports
 usr/sbin/ibsrpdm
 usr/sbin/srp_daemon
diff --git a/libibumad/CMakeLists.txt b/libibumad/CMakeLists.txt
index 150ef59b920227..84673ee01271cb 100644
--- a/libibumad/CMakeLists.txt
+++ b/libibumad/CMakeLists.txt
@@ -15,7 +15,7 @@ rdma_library(ibumad libibumad.map
   umad_str.c
   )
 
-rdma_subst_install(FILES libibumad.udev-rules
-  RENAME libibumad.rules
+install(FILES libibumad.udev-rules
+  RENAME 90-libibumad.rules
   DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
diff --git a/rdma-ndd/CMakeLists.txt b/rdma-ndd/CMakeLists.txt
index 942d90b8943fe8..99e183e34ef758 100644
--- a/rdma-ndd/CMakeLists.txt
+++ b/rdma-ndd/CMakeLists.txt
@@ -14,7 +14,9 @@ rdma_man_pages(
   rdma-ndd.8.in
   )
 
-install(FILES "rdma-ndd.rules" DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+install(FILES "rdma-ndd.rules"
+  RENAME "60-rdma-ndd.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
 rdma_subst_install(FILES "rdma-ndd.service.in"
   DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 673ae0da1e5525..8961d33e618b1d 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -330,7 +330,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %dir %{dracutlibdir}/modules.d/05rdma
 %{dracutlibdir}/modules.d/05rdma/module-setup.sh
 %{_udevrulesdir}/98-rdma.rules
-%{_udevrulesdir}/rdma-ndd.rules
+%{_udevrulesdir}/60-rdma-ndd.rules
 %{sysmodprobedir}/libmlx4.conf
 %{sysmodprobedir}/cxgb3.conf
 %{sysmodprobedir}/cxgb4.conf
@@ -405,7 +405,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 
 %files -n libibumad
 %{_libdir}/libibumad*.so.*
-%{_udevrulesdir}/libibumad.rules
+%{_udevrulesdir}/90-libibumad.rules
 
 %files -n librdmacm
 %{_libdir}/librdmacm*.so.*
@@ -450,7 +450,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_sbindir}/ibsrpdm
 %{_sbindir}/srp_daemon
 %{_sbindir}/run_srp_daemon
-%{_udevrulesdir}/srp_daemon.rules
+%{_udevrulesdir}/60-srp_daemon.rules
 %{_mandir}/man1/ibsrpdm.1*
 %{_mandir}/man1/srp_daemon.1*
 %{_mandir}/man5/srp_daemon.service.5*
diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index 62e91bb0f321d8..92a1d709364b0b 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -43,7 +43,9 @@ rdma_subst_install(FILES srp_daemon_port@.service.in
 
 install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
-install(FILES srp_daemon.rules DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+install(FILES "srp_daemon.rules"
+  RENAME "60-srp_daemon.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
 
 # FIXME: The ib init.d file should really be included in rdma-core as well.
 set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
