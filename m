From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0:  add high resolution time stamps and thread id
 to sdtout debug logs
Date: Fri, 22 Oct 2010 13:15:58 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA209E8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_debug.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/dapl/common/dapl_debug.c b/dapl/common/dapl_debug.c
index 904d075..e1a940c 100644
--- a/dapl/common/dapl_debug.c
+++ b/dapl/common/dapl_debug.c
@@ -36,6 +36,8 @@ DAPL_DBG_DEST g_dapl_dbg_dest;	/* initialized in dapl_init.c */
 
 static char *_ptr_host_ = NULL;
 static char _hostname_[128];
+static DAPL_OS_TIMEVAL start_t, current_t, last_t; /* microsecond timeStamp STDOUT */
+static int delta_t, total_t;
 
 void dapl_internal_dbg_log(DAPL_DBG_TYPE type, const char *fmt, ...)
 {
@@ -44,13 +46,20 @@ void dapl_internal_dbg_log(DAPL_DBG_TYPE type, const char *fmt, ...)
 	if (_ptr_host_ == NULL) {
 		gethostname(_hostname_, sizeof(_hostname_));
 		_ptr_host_ = _hostname_;
+		dapl_os_get_time(&start_t);
+		last_t = start_t;
 	}
+	dapl_os_get_time(&current_t);
+	delta_t = current_t - last_t;
+	total_t = current_t - start_t;
+	last_t  = current_t;
 
 	if (type & g_dapl_dbg_type) {
 		if (DAPL_DBG_DEST_STDOUT & g_dapl_dbg_dest) {
 			va_start(args, fmt);
-			fprintf(stdout, "%s:%x: ", _ptr_host_,
-				dapl_os_getpid());
+			fprintf(stdout, "%s:%x:%x: %d us(%d us%s): ",
+				_ptr_host_, dapl_os_getpid(), dapl_os_gettid(),
+				total_t, delta_t, delta_t > 500000 ? "!!!":"");
 			dapl_os_vprintf(fmt, args);
 			va_end(args);
 		}
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
