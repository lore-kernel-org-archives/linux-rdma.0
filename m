From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core] debian: Only run udevadm if the binary is available
Date: Wed, 27 Dec 2017 11:41:35 +0100
Message-ID: <20171227104135.24391-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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

To silence these warnings, only run udevadm if this binary is available.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rdma-core.postinst | 8 +++++---
 debian/srptools.postinst  | 4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/debian/rdma-core.postinst b/debian/rdma-core.postinst
index 6486f62e..26aec6d1 100644
--- a/debian/rdma-core.postinst
+++ b/debian/rdma-core.postinst
@@ -6,7 +6,9 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband --action=change || true
-    udevadm trigger --subsystem-match=net --action=change || true
-    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+    if which udevadm >/dev/null 2>&1; then
+        udevadm trigger --subsystem-match=infiniband --action=change
+        udevadm trigger --subsystem-match=net --action=change
+        udevadm trigger --subsystem-match=infiniband_mad --action=change
+    fi
 fi
diff --git a/debian/srptools.postinst b/debian/srptools.postinst
index 398534db..9cdce914 100644
--- a/debian/srptools.postinst
+++ b/debian/srptools.postinst
@@ -6,5 +6,7 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+    if which udevadm >/dev/null 2>&1; then
+        udevadm trigger --subsystem-match=infiniband_mad --action=change
+    fi
 fi
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
