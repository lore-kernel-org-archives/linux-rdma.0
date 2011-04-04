From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast.c: In some multicast flows, insufficient
 comps should be a warning
Date: Mon, 04 Apr 2011 15:25:02 -0400
Message-ID: <4D9A1B0E.9010904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than error (it's preferred but not required)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index b4e2a54..52577bc 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights
reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2010 HNR Consulting. All rights reserved.
  *
@@ -738,13 +738,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EE: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EE: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -769,13 +771,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02ED: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02ED: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -1073,6 +1077,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);

 	comp_mask =
@@ -1087,13 +1092,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t
* const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A8: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A8: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -1165,6 +1172,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	/* no MGID */
 	memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
 	/* Request Join */
+	mc_req_rec.pkey = IB_DEFAULT_PKEY;
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);

 	comp_mask =
@@ -1180,13 +1188,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t
* const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");

-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A6: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A6: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
