From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmtest.c: Fix endian in some log messages
Date: Sat, 04 Jun 2011 11:06:35 -0400
Message-ID: <4DEA49FB.1040905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 7ecc8ce..baf7440 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -865,7 +865,7 @@ osmtest_get_path_rec_by_guid_pair(IN osmtest_t * const p_osmt,
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
 		"Query for path from 0x%" PRIx64 " to 0x%" PRIx64 "\n",
-		sguid, dguid);
+		cl_ntoh64(sguid), cl_ntoh64(dguid));
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
@@ -928,9 +928,11 @@ osmtest_get_path_rec_by_gid_pair(IN osmtest_t * const p_osmt,
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
 		"Query for path from 0x%016" PRIx64 " 0x%016" PRIx64
-		" to 0x%016" PRIx64 " 0x%016" PRIx64 "\n", sgid.unicast.prefix,
-		sgid.unicast.interface_id, dgid.unicast.prefix,
-		dgid.unicast.interface_id);
+		" to 0x%016" PRIx64 " 0x%016" PRIx64 "\n", 
+		cl_ntoh64(sgid.unicast.prefix),
+		cl_ntoh64(sgid.unicast.interface_id),
+		cl_ntoh64(dgid.unicast.prefix),
+		cl_ntoh64(dgid.unicast.interface_id));
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
@@ -1985,7 +1987,8 @@ osmtest_get_path_rec_by_lid_pair(IN osmtest_t * const p_osmt,
 	req.sm_key = 0;
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
-		"Query for path from 0x%X to 0x%X\n", slid, dlid);
+		"Query for path from 0x%X to 0x%X\n",
+		cl_ntoh16(slid), cl_ntoh16(dlid));
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0053: "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
