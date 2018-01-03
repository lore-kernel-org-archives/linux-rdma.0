From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core v2] debian: Add udev dependency to rdma-core and srptools
Date: Wed,  3 Jan 2018 11:22:11 +0100
Message-ID: <20180103102211.28307-1-benjamin.drung@profitbricks.com>
References: <20171228210124.GI25436@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228210124.GI25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When udevadm is not available (e.g. in a minimal chroot environment),
the rdma-core package installation will print these warnings:

/var/lib/dpkg/info/rdma-core.postinst: 33:
/var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
/var/lib/dpkg/info/rdma-core.postinst: 34:
/var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
/var/lib/dpkg/info/rdma-core.postinst: 35:
/var/lib/dpkg/info/rdma-core.postinst: udevadm: not found

Add udev dependency to rdma-core and srptools (which provides udevadm),
because these packages rely on udev to load the kernel modules.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control            | 2 ++
 debian/rdma-core.postinst | 6 +++---
 debian/srptools.postinst  | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/debian/control b/debian/control
index 451b379f..27d23791 100644
--- a/debian/control
+++ b/debian/control
@@ -24,6 +24,7 @@ Homepage: https://github.com/linux-rdma/rdma-core
 Package: rdma-core
 Architecture: linux-any
 Depends: lsb-base (>= 3.2-14~),
+         udev,
          ${misc:Depends},
          ${perl:Depends},
          ${shlibs:Depends}
@@ -342,6 +343,7 @@ Package: srptools
 Architecture: linux-any
 Depends: lsb-base (>= 3.2-14~),
          rdma-core (>= 15),
+         udev,
          ${misc:Depends},
          ${shlibs:Depends}
 Description: Tools for Infiniband attached storage (SRP)
diff --git a/debian/rdma-core.postinst b/debian/rdma-core.postinst
index 6486f62e..a76368a4 100644
--- a/debian/rdma-core.postinst
+++ b/debian/rdma-core.postinst
@@ -6,7 +6,7 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband --action=change || true
-    udevadm trigger --subsystem-match=net --action=change || true
-    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+    udevadm trigger --subsystem-match=infiniband --action=change
+    udevadm trigger --subsystem-match=net --action=change
+    udevadm trigger --subsystem-match=infiniband_mad --action=change
 fi
diff --git a/debian/srptools.postinst b/debian/srptools.postinst
index 398534db..c69a3ad1 100644
--- a/debian/srptools.postinst
+++ b/debian/srptools.postinst
@@ -6,5 +6,5 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+    udevadm trigger --subsystem-match=infiniband_mad --action=change
 fi
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
