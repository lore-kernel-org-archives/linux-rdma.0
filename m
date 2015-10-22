From: "Mccormick, Patrick M" <patrick.m.mccormick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] openibd
Date: Thu, 22 Oct 2015 19:59:59 +0000
Message-ID: <856EA97E2D31FB4CB11D0FAEE9481E4BA71B5C5C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes BZ issue: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2574

"QIB makes SCIF does not work with xeon-phi"

See the bug entry for more details. This is a low-risk, low-impact change intended for 3.18-1.

diff --git a/openibd b/openibd
index 5b5077a..9d849f4 100755
--- a/openibd
+++ b/openibd
@@ -3,11 +3,16 @@
 # Bring up/down openib
 #
 # chkconfig: 2345 05 95
-# description: Activates/Deactivates InfiniBand Driver to \
-#              start at boot time.
+# description: Activates/Deactivates InfiniBand Driver to start at boot time.
 #
 ### BEGIN INIT INFO
 # Provides:       openibd
+# Required-Start: mpss
+# Required-Stop:
+# Default-Start: 2 3 4 5
+# Default-Stop: 0 1 6
+# Short-Description: Activates/Deactivates InfiniBand Driver to start at boot
time.
+# Description: Loads kernel modules for Infiniband devices.
 ### END INIT INFO

 #

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
