From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] opensm: Fix incorrect use of sizeof
Date: Mon, 12 Nov 2012 11:51:09 -0800
Message-ID: <20121112115109.a4ad35d8a01cf177d36a0d71@llnl.gov>
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
 opensm/osm_helper.c |   53 ++++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index a24dd72..578f54a 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2589,7 +2589,8 @@ void osm_dump_notice_v2(IN osm_log_t * p_log,
 	}
 }
 
-static void osm_dump_dr_smp_to_buf(IN const ib_smp_t * p_smp, OUT char * buf)
+static void osm_dump_dr_smp_to_buf(IN const ib_smp_t * p_smp, OUT char * buf,
+				   IN size_t buf_size)
 {
 	if (!buf || !p_smp)
 		return;
@@ -2607,18 +2608,18 @@ static void osm_dump_dr_smp_to_buf(IN const ib_smp_t * p_smp, OUT char * buf)
 			    ib_get_sm_method_str(p_smp->method));
 
 		if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR) {
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\t\t\t\tD bit...................0x%X\n"
 				      "\t\t\t\tstatus..................0x%X\n",
 				      ib_smp_is_d(p_smp),
 				      cl_ntoh16(ib_smp_get_status(p_smp)));
 		} else {
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\t\t\t\tstatus..................0x%X\n",
 				      cl_ntoh16(p_smp->status));
 		}
 
-		n += snprintf(buf + n, sizeof(buf) - n,
+		n += snprintf(buf + n, buf_size - n,
 			      "\t\t\t\thop_ptr.................0x%X\n"
 			      "\t\t\t\thop_count...............0x%X\n"
 			      "\t\t\t\ttrans_id................0x%" PRIx64 "\n"
@@ -2636,34 +2637,34 @@ static void osm_dump_dr_smp_to_buf(IN const ib_smp_t * p_smp, OUT char * buf)
 
 		if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR) {
 			uint32_t i;
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\t\t\t\tdr_slid.................%u\n"
 				      "\t\t\t\tdr_dlid.................%u\n",
 				      cl_ntoh16(p_smp->dr_slid),
 				      cl_ntoh16(p_smp->dr_dlid));
 
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\n\t\t\t\tInitial path: ");
-			n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
+			n += sprint_uint8_arr(buf + n, buf_size - n,
 					      p_smp->initial_path,
 					      p_smp->hop_count + 1);
 
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\n\t\t\t\tReturn path:  ");
-			n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
+			n += sprint_uint8_arr(buf + n, buf_size - n,
 					      p_smp->return_path,
 					      p_smp->hop_count + 1);
 
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\n\t\t\t\tReserved:     ");
 			for (i = 0; i < 7; i++) {
-				n += snprintf(buf + n, sizeof(buf) - n,
+				n += snprintf(buf + n, buf_size - n,
 					      "[%0X]", p_smp->resv1[i]);
 			}
-			n += snprintf(buf + n, sizeof(buf) - n, "\n");
+			n += snprintf(buf + n, buf_size - n, "\n");
 
 			for (i = 0; i < 64; i += 16) {
-				n += snprintf(buf + n, sizeof(buf) - n,
+				n += snprintf(buf + n, buf_size - n,
 					      "\n\t\t\t\t%02X %02X %02X %02X "
 					      "%02X %02X %02X %02X"
 					      "   %02X %02X %02X %02X %02X %02X %02X %02X\n",
@@ -2686,7 +2687,7 @@ static void osm_dump_dr_smp_to_buf(IN const ib_smp_t * p_smp, OUT char * buf)
 			}
 		} else {
 			/* not a Direct Route so provide source and destination lids */
-			n += snprintf(buf + n, sizeof(buf) - n,
+			n += snprintf(buf + n, buf_size - n,
 				      "\t\t\t\tMAD IS LID ROUTED\n");
 		}
 	}
@@ -2698,7 +2699,7 @@ void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_smp_to_buf(p_smp, buf);
+		osm_dump_dr_smp_to_buf(p_smp, buf, BUF_SIZE);
 
 		osm_log(p_log, log_level, buf);
 	}
@@ -2710,7 +2711,7 @@ void osm_dump_dr_smp_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active_v2(p_log, log_level, file_id)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_smp_to_buf(p_smp, buf);
+		osm_dump_dr_smp_to_buf(p_smp, buf, BUF_SIZE);
 
 		osm_log_v2(p_log, log_level, file_id, buf);
 	}
@@ -2791,7 +2792,7 @@ void osm_dump_sa_mad_v2(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
 }
 
 static void osm_dump_dr_path_to_buf(IN const osm_dr_path_t * p_path,
-				    OUT char * buf)
+				    OUT char * buf, IN size_t buf_size)
 {
 	if (!buf || !p_path)
 		return;
@@ -2801,7 +2802,7 @@ static void osm_dump_dr_path_to_buf(IN const osm_dr_path_t * p_path,
 		n = sprintf(buf, "Directed Path Dump of %u hop path: "
 			    "Path = ", p_path->hop_count);
 
-		sprint_uint8_arr(buf + n, sizeof(buf) - n, p_path->path,
+		sprint_uint8_arr(buf + n, buf_size - n, p_path->path,
 				 p_path->hop_count + 1);
 	}
 }
@@ -2812,7 +2813,7 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_path_to_buf(p_path, buf);
+		osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
 
 		osm_log(p_log, log_level, buf);
 	}
@@ -2824,14 +2825,14 @@ void osm_dump_dr_path_v2(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
 	if (osm_log_is_active_v2(p_log, log_level, file_id)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_dr_path_to_buf(p_path, buf);
+		osm_dump_dr_path_to_buf(p_path, buf, BUF_SIZE);
 
 		osm_log_v2(p_log, log_level, file_id, buf);
 	}
 }
 
 static void osm_dump_smp_dr_path_to_buf(IN const ib_smp_t * p_smp,
-					OUT char * buf)
+					OUT char * buf, IN size_t buf_size)
 {
 	if (!buf || !p_smp)
 		return;
@@ -2840,12 +2841,12 @@ static void osm_dump_smp_dr_path_to_buf(IN const ib_smp_t * p_smp,
 
 		n = sprintf(buf, "Received SMP on a %u hop path: "
 			    "Initial path = ", p_smp->hop_count);
-		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
+		n += sprint_uint8_arr(buf + n, buf_size - n,
 				      p_smp->initial_path,
 				      p_smp->hop_count + 1);
 
-		n += sprintf(buf + n, ", Return path  = ");
-		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
+		n += snprintf(buf + n, ", Return path  = ");
+		n += sprint_uint8_arr(buf + n, buf_size - n,
 				      p_smp->return_path, p_smp->hop_count + 1);
 	}
 }
@@ -2856,7 +2857,7 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active(p_log, log_level)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_smp_dr_path_to_buf(p_smp, buf);
+		osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
 
 		osm_log(p_log, log_level, buf);
 	}
@@ -2868,7 +2869,7 @@ void osm_dump_smp_dr_path_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	if (osm_log_is_active_v2(p_log, log_level, file_id)) {
 		char buf[BUF_SIZE];
 
-		osm_dump_smp_dr_path_to_buf(p_smp, buf);
+		osm_dump_smp_dr_path_to_buf(p_smp, buf, BUF_SIZE);
 
 		osm_log_v2(p_log, log_level, file_id, buf);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
