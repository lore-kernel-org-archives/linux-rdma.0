From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 2/6] Move umad udev rules to rdma-core
Date: Thu, 27 Jul 2017 16:31:21 -0600
Message-ID: <1501194685-9447-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This works better from a packaging perspective, eg rdma-core
is already a matched dependency for srp_daemon in RedHat, and provides
one place to get all the udev meta data rules.

Also update debian's dependencies to rely on a new RDMA core
for srptools, as it now requires the rules files and
rdma-load-modules@.service.in from rdma-core.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/control                                                | 5 ++++-
 debian/libibumad3.install                                     | 1 -
 debian/rdma-core.install                                      | 1 +
 kernel-boot/CMakeLists.txt                                    | 4 ++++
 libibumad/libibumad.udev-rules => kernel-boot/rdma-umad.rules | 0
 libibumad/CMakeLists.txt                                      | 5 -----
 redhat/rdma-core.spec                                         | 2 +-
 7 files changed, 10 insertions(+), 8 deletions(-)
 rename libibumad/libibumad.udev-rules => kernel-boot/rdma-umad.rules (100%)

diff --git a/debian/control b/debian/control
index 444b0eaa047ba8..e9d1f95bb7a5ca 100644
--- a/debian/control
+++ b/debian/control
@@ -339,7 +339,10 @@ Description: Examples for the librdmacm library
 
 Package: srptools
 Architecture: linux-any
-Depends: lsb-base (>= 3.2-14~), ${misc:Depends}, ${shlibs:Depends}
+Depends: lsb-base (>= 3.2-14~),
+         rdma-core (>= 15),
+         ${misc:Depends},
+         ${shlibs:Depends}
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
index 44437fcc83dbd8..8021a0c0d9242b 100644
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
index 9892566a0333f5..f1895ea260ac52 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -340,6 +340,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %{_udevrulesdir}/75-rdma-description.rules
 %{_udevrulesdir}/90-rdma-hw-modules.rules
 %{_udevrulesdir}/90-rdma-ulp-modules.rules
+%{_udevrulesdir}/90-rdma-umad.rules
 %{_udevrulesdir}/98-rdma.rules
 %{sysmodprobedir}/libmlx4.conf
 %{sysmodprobedir}/cxgb3.conf
@@ -414,7 +415,6 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 
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
