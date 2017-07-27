From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 3/6] debian: Cause udev to evaluate the installed rules after install
Date: Thu, 27 Jul 2017 16:31:22 -0600
Message-ID: <1501194685-9447-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Call uadevadm trigger with all the subsystems our rules touch.

Following the advice of
 https://lists.ubuntu.com/archives/ubuntu-devel/2009-January/027260.html

And general consensus of other posinst files we We inject a change
message and ignore failure. This means the udev rules must accept
a change message and cannot just use ACTION=="add".

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/rdma-core.postinst   | 13 +++++++++++++
 debian/srptools.postinst    | 11 +++++++++++
 kernel-boot/rdma-umad.rules |  2 +-
 srp_daemon/srp_daemon.rules |  2 +-
 4 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 debian/rdma-core.postinst
 create mode 100644 debian/srptools.postinst

diff --git a/debian/rdma-core.postinst b/debian/rdma-core.postinst
new file mode 100644
index 00000000000000..de13363f0ad7c7
--- /dev/null
+++ b/debian/rdma-core.postinst
@@ -0,0 +1,13 @@
+#!/bin/sh
+
+set -e
+
+#DEBHELPER#
+
+if [ "$1" = "configure" ]; then
+    # we ship udev rules, so trigger an update. This has to be done after
+    # DEBHELPER restarts systemd to get our new service files loaded.
+    udevadm trigger --subsystem-match=infiniband --action=change || true
+    udevadm trigger --subsystem-match=net --action=change || true
+    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+fi
diff --git a/debian/srptools.postinst b/debian/srptools.postinst
new file mode 100644
index 00000000000000..c5a3e86261b338
--- /dev/null
+++ b/debian/srptools.postinst
@@ -0,0 +1,11 @@
+#!/bin/sh
+
+set -e
+
+#DEBHELPER#
+
+if [ "$1" = "configure" ]; then
+    # we ship udev rules, so trigger an update. This has to be done after
+    # DEBHELPER restarts systemd to get our new service files loaded.
+    udevadm trigger --subsystem-match=infiniband_mad --action=change || true
+fi
diff --git a/kernel-boot/rdma-umad.rules b/kernel-boot/rdma-umad.rules
index cfb790e051ced7..ba7ee613815a7d 100644
--- a/kernel-boot/rdma-umad.rules
+++ b/kernel-boot/rdma-umad.rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/sys/subsystem/rdma/devices/$attr{ibdev}:$attr{port}/umad"
+SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/sys/subsystem/rdma/devices/$attr{ibdev}:$attr{port}/umad"
diff --git a/srp_daemon/srp_daemon.rules b/srp_daemon/srp_daemon.rules
index 4cfeabc762da2a..b6411dcec72432 100644
--- a/srp_daemon/srp_daemon.rules
+++ b/srp_daemon/srp_daemon.rules
@@ -1 +1 @@
-ACTION=="add", SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", PROGRAM=="/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
+SUBSYSTEM=="infiniband_mad", KERNEL=="*umad*", PROGRAM=="/bin/systemctl show srp_daemon -p ActiveState", RESULT=="ActiveState=active", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
