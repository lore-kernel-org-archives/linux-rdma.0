From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/4 for opensm] Make it possible to enable opensm with chkconfig
Date: Fri, 21 Sep 2012 16:43:03 +0200
Message-ID: <505C7CF7.8010804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

"chkconfig $service on" enables a service in the runlevels mentioned
next to "Default-Start" and only in those runlevels.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 configure.in                  |   10 ++++++++++
 scripts/opensm.init.in        |    4 ++--
 scripts/redhat-opensm.init.in |    3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index eb252ff..f660a5b 100644
--- a/configure.in
+++ b/configure.in
@@ -11,6 +11,16 @@ AM_INIT_AUTOMAKE
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
 
+if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
+   default_start="2 3 5"
+   default_stop="0 1 4 6"
+else
+   default_start="2 3 4 5"
+   default_stop="0 1 6"
+fi
+AC_SUBST(DEFAULT_START, $default_start)
+AC_SUBST(DEFAULT_STOP, $default_stop)
+
 dnl NOTE: AC_DEFINE's and AC_DEFINE_UNQUOTED's which are used in header files
 dnl       MUST have a corresponding entry in include/opensm/osm_config.h.in to
 dnl       ensure plugin compatibility.
diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 0c84bd3..007dae4 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -9,8 +9,8 @@
 # Provides: opensm
 # Required-Start: $syslog
 # Required-Stop:
-# Default-Start: none
-# Default-Stop: 0 1 6
+# Default-Start: @DEFAULT_START@
+# Default-Stop: @DEFAULT_STOP@
 # Description:  Manage OpenSM
 ### END INIT INFO
 #
diff --git a/scripts/redhat-opensm.init.in b/scripts/redhat-opensm.init.in
index 9c22275..bea0f0d 100755
--- a/scripts/redhat-opensm.init.in
+++ b/scripts/redhat-opensm.init.in
@@ -7,6 +7,9 @@
 #
 ### BEGIN INIT INFO
 # Provides:       opensm
+# Default-Start: @DEFAULT_START@
+# Default-Stop: @DEFAULT_STOP@
+# Description:  Manage OpenSM
 ### END INIT INFO
 #
 # Copyright (c) 2008 Voltaire, Inc. All rights reserved.
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
