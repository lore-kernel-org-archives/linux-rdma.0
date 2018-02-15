From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] debian: Guard udevadm call again
Date: Thu, 15 Feb 2018 12:08:40 +0100
Message-ID: <20180215110842.6375-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lintian complains with udevadm-called-without-guard:

udevadm can exist but be non-functional (such as inside a chroot) and
thus can result in package installation or upgrade failure if the call
fails.

Please guard the return code of the call via wrapping it in a suitable
if construct or by appending || true.

Refer to https://bugs.debian.org/890224 and the udevadm(8) manual page
for details.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rdma-core.postinst | 6 +++---
 debian/srptools.postinst  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/debian/rdma-core.postinst b/debian/rdma-core.postinst
index a76368a4..6486f62e 100644
--- a/debian/rdma-core.postinst
+++ b/debian/rdma-core.postinst
@@ -6,7 +6,7 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband --action=change
-    udevadm trigger --subsystem-match=net --action=change
-    udevadm trigger --subsystem-match=infiniband_mad --action=change
+    udevadm trigger --subsystem-match=infiniband --action=change || true
+    udevadm trigger --subsystem-match=net --action=change || true
+    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
 fi
diff --git a/debian/srptools.postinst b/debian/srptools.postinst
index c69a3ad1..398534db 100644
--- a/debian/srptools.postinst
+++ b/debian/srptools.postinst
@@ -6,5 +6,5 @@ set -e
 if [ "$1" = "configure" ]; then
     # we ship udev rules, so trigger an update. This has to be done after
     # DEBHELPER restarts systemd to get our new service files loaded.
-    udevadm trigger --subsystem-match=infiniband_mad --action=change
+    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
 fi
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
