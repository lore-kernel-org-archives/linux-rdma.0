From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast.c: In osmt_run_mcast_flow, handle
 invalid status better
Date: Tue, 05 Apr 2011 14:05:17 -0400
Message-ID: <4D9B59DD.1040209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Invalid status may be returned for the insufficient components tests
Also, set pkey when component mask set

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 4325119..2ee6470 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -757,6 +757,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 
 	comp_mask =
@@ -794,6 +795,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		"Checking Join with insufficient comp mask - flow label (o15.0.1.3)...\n");
 
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 
 	comp_mask =
@@ -808,13 +810,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
 
-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EC: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EC: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -825,6 +829,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 		"Checking Join with insufficient comp mask - tclass (o15.0.1.3)...\n");
 
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 
 	comp_mask =
@@ -839,13 +844,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
 
-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EA: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EA: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -858,6 +865,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	/* no MGID */
 	/* memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t)); */
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);
 
 	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID |
@@ -872,13 +880,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
 
-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E9: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E9: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
