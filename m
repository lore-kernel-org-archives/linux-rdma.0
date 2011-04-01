From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 10/11] osmtest/osmt_multicast.c: Fixed some error codes in
 OSM_LOG messages
Date: Fri, 01 Apr 2011 14:38:31 -0400
Message-ID: <4D961BA7.90409@dev.mellanox.co.il>
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
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index b6dfdfc..cfeb61b 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -677,7 +677,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

 	if (status == IB_SUCCESS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 2E0 "
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E0: "
 			"SubnAdmGet with invalid mlid 0x%x succeeded\n",
 			cl_ntoh16(mc_req_rec.mlid));
 		status = IB_ERROR;
@@ -706,7 +706,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

 	if (status == IB_SUCCESS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 2E4 "
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E4: "
 			"SubnAdmGet with invalid port guid succeeded\n");
 		status = IB_ERROR;
 		goto Exit;
@@ -2409,7 +2409,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 					      cl_ntoh16(p_mc_res->mlid),
 					      p_mc_res);
 			} else if (cur_mlid > cl_ntoh16(max_mlid)) {
-				OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 2E1 "
+				OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E1: "
 					"Successful Join with greater mlid than switches support
(MulticastFDBCap) 0x%04X\n",
 					cur_mlid);
 				status = IB_ERROR;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
