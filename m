From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] opensm: fix missing newline on DR path log messages
Date: Mon, 12 Nov 2012 11:51:10 -0800
Message-ID: <20121112115110.b72a88a6412859038bbad664@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_helper.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 578f54a..78286a2 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2791,20 +2791,21 @@ void osm_dump_sa_mad_v2(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
 	}
 }
 
-static void osm_dump_dr_path_to_buf(IN const osm_dr_path_t * p_path,
+static int osm_dump_dr_path_to_buf(IN const osm_dr_path_t * p_path,
 				    OUT char * buf, IN size_t buf_size)
 {
+	unsigned n = 0;
+
 	if (!buf || !p_path)
-		return;
+		return 0;
 	else {
-		unsigned n = 0;
-
-		n = sprintf(buf, "Directed Path Dump of %u hop path: "
+		n = snprintf(buf, buf_size, "Directed Path Dump of %u hop path: "
 			    "Path = ", p_path->hop_count);
 
-		sprint_uint8_arr(buf + n, buf_size - n, p_path->path,
+		n += sprint_uint8_arr(buf + n, buf_size - n, p_path->path,
 				 p_path->hop_count + 1);
 	}
+	return n;
 }
 
 void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
@@ -2813,7 +2814,10 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
+		int n = osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
+		if (n == BUF_SIZE)
+			n--;
+		buf[n] = '\n';
 
 		osm_log(p_log, log_level, buf);
 	}
@@ -2825,30 +2829,34 @@ void osm_dump_dr_path_v2(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 	if (osm_log_is_active_v2(p_log, log_level, file_id)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
+		int n = osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
+		if (n == BUF_SIZE)
+			n--;
+		buf[n] = '\n';
 
 		osm_log_v2(p_log, log_level, file_id, buf);
 	}
 }
 
-static void osm_dump_smp_dr_path_to_buf(IN const ib_smp_t * p_smp,
+static int osm_dump_smp_dr_path_to_buf(IN const ib_smp_t * p_smp,
 					OUT char * buf, IN size_t buf_size)
 {
+	unsigned n = 0;
+
 	if (!buf || !p_smp)
-		return;
+		return 0;
 	else {
-		unsigned n;
-
-		n = sprintf(buf, "Received SMP on a %u hop path: "
+		n = snprintf(buf, buf_size, "Received SMP on a %u hop path: "
 			    "Initial path = ", p_smp->hop_count);
 		n += sprint_uint8_arr(buf + n, buf_size - n,
 				      p_smp->initial_path,
 				      p_smp->hop_count + 1);
 
-		n += snprintf(buf + n, ", Return path  = ");
+		n += snprintf(buf + n, buf_size - n, ", Return path  = ");
 		n += sprint_uint8_arr(buf + n, buf_size - n,
 				      p_smp->return_path, p_smp->hop_count + 1);
 	}
+	return n;
 }
 
 void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
@@ -2857,7 +2865,10 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
+		int n = osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
+		if (n == BUF_SIZE)
+			n--;
+		buf[n] = '\n';
 
 		osm_log(p_log, log_level, buf);
 	}
@@ -2869,7 +2880,10 @@ void osm_dump_smp_dr_path_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active_v2(p_log, log_level, file_id)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
+		int n = osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
+		if (n == BUF_SIZE)
+			n--;
+		buf[n] = '\n';
 
 		osm_log_v2(p_log, log_level, file_id, buf);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
