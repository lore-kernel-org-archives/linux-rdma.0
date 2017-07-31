From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/6] ibacm: Avoid using @prefix@
Date: Mon, 31 Jul 2017 14:25:41 -0600
Message-ID: <1501532745-28378-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead use @CMAKE_INSTALL_FULL_SBINDIR@ like everything else.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/CMakeLists.txt   | 1 -
 ibacm/ibacm.init.in    | 6 +++---
 ibacm/ibacm.service.in | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 5e3ea5e29de0b6..75869968534438 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -59,7 +59,6 @@ rdma_man_pages(
 
 # FIXME: update the .init.in
 set(rdmascript "openibd")
-set(prefix "${CMAKE_INSTALL_PREFIX}")
 rdma_subst_install(FILES "ibacm.init.in"
   DESTINATION "${CMAKE_INSTALL_INITDDIR}"
   RENAME "ibacm"
diff --git a/ibacm/ibacm.init.in b/ibacm/ibacm.init.in
index e53ce1d6e5f7c0..f37dc03a29010c 100644
--- a/ibacm/ibacm.init.in
+++ b/ibacm/ibacm.init.in
@@ -36,14 +36,14 @@ elif [ -s /lib/lsb/init-functions ]; then
 	# SLES / OpenSuSE / Debian
 	. /lib/lsb/init-functions
 	_daemon()   { start_daemon "$@"; }
-        _checkpid() { checkproc -p $pidfile @prefix@/sbin/ibacm; }
+        _checkpid() { checkproc -p $pidfile @CMAKE_INSTALL_FULL_SBINDIR@/ibacm; }
 	_success()  { log_success_msg; }
 	_failure()  { log_failure_msg; }
 elif [ -s /etc/rc.status ]; then
 	# Older SuSE
 	. /etc/rc.status
 	_daemon()   { /sbin/start_daemon ${1+"$@"}; }
-        _checkpid() { checkproc -p $pidfile @prefix@/sbin/ibacm; }
+        _checkpid() { checkproc -p $pidfile @CMAKE_INSTALL_FULL_SBINDIR@/ibacm; }
 	_success()  { rc_status -v; }
 	_failure()  { rc_status -v; }
 fi	
@@ -51,7 +51,7 @@ fi
 start()
 {
     echo -n "Starting ibacm daemon:"
-    _daemon @prefix@/sbin/ibacm
+    _daemon @CMAKE_INSTALL_FULL_SBINDIR@/ibacm
     if [[ $RETVAL -eq 0 ]]; then
         _success
     else
diff --git a/ibacm/ibacm.service.in b/ibacm/ibacm.service.in
index 6cbb203e320884..fae768faef560b 100644
--- a/ibacm/ibacm.service.in
+++ b/ibacm/ibacm.service.in
@@ -5,7 +5,7 @@ After=opensm.service
 
 [Service]
 Type=forking
-ExecStart=@prefix@/sbin/ibacm
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/ibacm
 
 [Install]
 WantedBy=network.target
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
