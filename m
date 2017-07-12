From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 1/2] ibacm: Fix service start_daemon call on Debian
Date: Wed, 12 Jul 2017 17:42:54 +0200
Message-ID: <20170712154255.21296-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The script start_daemon does not exist on Debian/Ubuntu.
/lib/lsb/init-functions defines a start_daemon functions that calls
/sbin/start_daemon on openSUSE. Thus call the start_daemon LSB
function instead.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 ibacm/ibacm.init.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/ibacm.init.in b/ibacm/ibacm.init.in
index bd7b70a1..e53ce1d6 100644
--- a/ibacm/ibacm.init.in
+++ b/ibacm/ibacm.init.in
@@ -35,7 +35,7 @@ if [ -s /etc/init.d/functions ]; then
 elif [ -s /lib/lsb/init-functions ]; then
 	# SLES / OpenSuSE / Debian
 	. /lib/lsb/init-functions
-	_daemon()   { /sbin/start_daemon ${1+"$@"}; }
+	_daemon()   { start_daemon "$@"; }
         _checkpid() { checkproc -p $pidfile @prefix@/sbin/ibacm; }
 	_success()  { log_success_msg; }
 	_failure()  { log_failure_msg; }
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
