From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 6/6] opensm: /etc/init.d/opensmd: Port to Debian
Date: Tue, 11 Sep 2012 16:21:14 +0200
Message-ID: <504F48DA.3030400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 scripts/opensm.init.in |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 01d2bb9..1b9348c 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -45,14 +45,20 @@ exec_prefix=@exec_prefix@
 
 # Source function library.
 if [[ -s /etc/init.d/functions ]]; then
+    # RHEL / Fedora.
     . /etc/init.d/functions
     rc_status() { :; }
     rc_exit() { exit $RETVAL; }
-fi
-if [[ -s /etc/rc.status ]]; then
+elif [[ -s /etc/rc.status ]]; then
     . /etc/rc.status
     failure() { rc_status -v; }
     success() { rc_status -v; }
+elif [[ -s /lib/lsb/init-functions ]]; then
+    # SLES / openSuSE / Debian.
+    . /lib/lsb/init-functions
+    rc_exit() { exit $RETVAL; }
+    failure() { log_failure_msg; }
+    success() { log_success_msg; }
 fi
 
 CONFIG=@sysconfdir@/sysconfig/opensm
@@ -62,7 +68,7 @@ fi
 
 start () {
     echo -n "Starting opensm: "
-    @sbindir@/opensm --daemon $OPTIONS > /dev/null
+    @sbindir@/opensm --daemon --pidfile /var/run/opensm.pid $OPTIONS > /dev/null
     if [[ $RETVAL -eq 0 ]]; then
         touch /var/lock/subsys/opensm
         success
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
