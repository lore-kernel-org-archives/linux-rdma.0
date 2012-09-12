From: Bart Van Assche <bartvanassche.gglplus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] opensm: Make it possible to enable opensm with chkconfig
Date: Wed, 12 Sep 2012 13:49:27 +0200
Message-ID: <505076C7.7050106@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The command "chkconfig $service on" enables a service in the "Default-Start"
runlevels.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 scripts/opensm.init.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 0c84bd3..9ec08a2 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -9,8 +9,8 @@
 # Provides: opensm
 # Required-Start: $syslog
 # Required-Stop:
-# Default-Start: none
-# Default-Stop: 0 1 6
+# Default-Start: 2 3 5
+# Default-Stop: 0 1 4 6
 # Description:  Manage OpenSM
 ### END INIT INFO
 #
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
