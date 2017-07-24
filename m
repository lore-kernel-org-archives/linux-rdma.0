From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/5] Move umad udev rules to rdma-core
Date: Mon, 24 Jul 2017 14:44:27 -0600
Message-ID: <1500929067-1583-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This works better from a packaging perspective, eg rdma-core
is already a matched dependency for srp_daemon in RedHat, and provides
one place to get all the udev meta data rules.

Also update debian's dependencies to rely on a new RDMA core
for srptools, as it now requires the rules files and
rdma-load-modules@.service.in from rdma-core.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/control                                                | 2 +-
 debian/libibumad3.install                                     | 1 -
 debian/rdma-core.install                                      | 1 +
 kernel-boot/CMakeLists.txt                                    | 4 ++++
 libibumad/libibumad.udev-rules => kernel-boot/rdma-umad.rules | 0
 libibumad/CMakeLists.txt                                      | 5 -----
 redhat/rdma-core.spec                                         | 2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)
 rename libibumad/libibumad.udev-rules => kernel-boot/rdma-umad.rules (100%)

diff --git a/debian/control b/debian/control
index d7e20e4879a19c..9a40ef17d60833 100644
--- a/debian/control
+++ b/debian/control
@@ -341,7 +341,7 @@ Description: Examples for the librdmacm library
 
 Package: srptools
 Architecture: linux-any
-Depends: lsb-base (>= 3.2-14~), rdma-core, ${misc:Depends}, ${shlibs:Depends}
+Depends: lsb-base (>= 3.2-14~), rdma-core (>= 15), ${misc:Depends}, ${shlibs:Depends}
 Description: Tools for Infiniband attached storage (SRP)
  In conjunction with the kernel ib_srp driver, srptools allows you to
  discover and use Infiniband attached storage devices which use the
diff --git a/debian/libibumad3.install b/debian/libibumad3.install
index 41339ebfa2f229..f6c298db52eb34 100644
--- a/debian/libibumad3.install
+++ b/debian/libibumad3.install
@@ -1,2 +1 @@
-lib/udev/rules.d/90-libibumad.rules
 usr/lib/*/libibumad*.so.*
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 0bda539494189a..df33b8a6070d22 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -11,6 +11,7 @@ lib/udev/rules.d/60-rdma-ndd.rules
 lib/udev/rules.d/75-rdma-description.rules
 lib/udev/rules.d/90-rdma-hw-modules.rules
 lib/udev/rules.d/90-rdma-ulp-modules.rules
+lib/udev/rules.d/90-rdma-umad.rules
 usr/bin/rxe_cfg
 usr/lib/truescale-serdes.cmds
 usr/sbin/rdma-ndd
diff --git a/kernel-boot/CMakeLists.txt b/kernel-boot/CMakeLists.txt
index 0d4a2aec1c6a94..fdb70117f5899c 100644
--- a/kernel-boot/CMakeLists.txt
+++ b/kernel-boot/CMakeLists.txt
@@ -22,3 +22,7 @@ install(FILES "rdma-hw-modules.rules"
 install(FILES "rdma-ulp-modules.rules"
   RENAME "90-rdma-ulp-modules.rules"
   DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
+
+install(FILES "rdma-umad.rules"
+  RENAME "90-rdma-umad.rules"
+  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
diff --git a/libibumad/libibumad.udev-rules b/kernel-boot/rdma-umad.rules
similarity index 100%
rename from libibumad/libibumad.udev-rules
rename to kernel-boot/rdma-umad.rules
diff --git a/libibumad/CMakeLists.txt b/libibumad/CMakeLists.txt
index 84673ee01271cb..ba2463b47ed82a 100644
--- a/libibumad/CMakeLists.txt
+++ b/libibumad/CMakeLists.txt
@@ -14,8 +14,3 @@ rdma_library(ibumad libibumad.map
   umad.c
   umad_str.c
   )
-
-install(FILES libibumad.udev-rules
-  RENAME 90-libibumad.rules
-  DESTINATION "${CMAKE_INSTALL_UDEV_RULESDIR}")
-
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 1e4aee6a211f33..7ed419394d22d6 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -337,6 +337,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_udevrulesdir}/75-rdma-description.rules
 %{_udevrulesdir}/90-rdma-hw-modules.rules
 %{_udevrulesdir}/90-rdma-ulp-modules.rules
+%{_udevrulesdir}/90-rdma-umad.rules
 %{_udevrulesdir}/98-rdma.rules
 %{sysmodprobedir}/libmlx4.conf
 %{_libexecdir}/rdma-init-kernel
@@ -411,7 +412,6 @@ rm -rf %{buildroot}/%{_initrddir}/
 
 %files -n libibumad
 %{_libdir}/libibumad*.so.*
-%{_udevrulesdir}/90-libibumad.rules
 
 %files -n librdmacm
 %{_libdir}/librdmacm*.so.*
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
