From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_log.c: Fix wrong hour and date display in log
 when CL_ASSERT fail
Date: Wed, 30 Apr 2014 10:35:39 -0400
Message-ID: <53610A3B.1040109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

using gettimeofday function instead of cl_get_time_stamp

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_log.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index 3460cc5..29e80e4 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -230,6 +230,7 @@ void osm_log_v2(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 	SYSTEMTIME st;
 	uint32_t pid = GetCurrentThreadId();
 #else
+	struct timeval tv;
 	pid_t pid = 0;
 	time_t tim;
 	struct tm result;
@@ -294,7 +295,9 @@ _retry:
 		    st.wHour, st.wMinute, st.wSecond, st.wMilliseconds,
 		    pid, verbosity, buffer);
 #else
-	time_usecs = cl_get_time_stamp();
+	gettimeofday(&tv, NULL);
+	/* Convert the time of day into a microsecond timestamp */
+	time_usecs = ((uint64_t) tv.tv_sec * 1000000) + (uint64_t) tv.tv_usec;
 	tim = time_usecs / 1000000;
 	usecs = time_usecs % 1000000;
 	localtime_r(&tim, &result);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
