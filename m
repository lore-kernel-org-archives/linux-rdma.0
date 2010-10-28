From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: debug build: only timestamp if sending message
 to stdout to avoid performance hit
Date: Thu, 28 Oct 2010 11:28:29 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BBD7F0F@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_debug.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/dapl/common/dapl_debug.c b/dapl/common/dapl_debug.c
index e1a940c..7a0a199 100644
--- a/dapl/common/dapl_debug.c
+++ b/dapl/common/dapl_debug.c
@@ -49,13 +49,13 @@ void dapl_internal_dbg_log(DAPL_DBG_TYPE type, const char *fmt, ...)
 		dapl_os_get_time(&start_t);
 		last_t = start_t;
 	}
-	dapl_os_get_time(&current_t);
-	delta_t = current_t - last_t;
-	total_t = current_t - start_t;
-	last_t  = current_t;
 
 	if (type & g_dapl_dbg_type) {
 		if (DAPL_DBG_DEST_STDOUT & g_dapl_dbg_dest) {
+			dapl_os_get_time(&current_t);
+			delta_t = current_t - last_t;
+			total_t = current_t - start_t;
+			last_t  = current_t;
 			va_start(args, fmt);
 			fprintf(stdout, "%s:%x:%x: %d us(%d us%s): ",
 				_ptr_host_, dapl_os_getpid(), dapl_os_gettid(),
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
