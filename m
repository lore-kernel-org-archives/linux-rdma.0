From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmt_multicast.c: Fixed another insufficient component
 case
Date: Thu, 07 Apr 2011 15:02:53 -0400
Message-ID: <4D9E0A5D.8050602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Checking Create given MGID=0 skip Qkey and Pkey (o15.0.1.4) - Error 02A7

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 2ee6470..e4eba64 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1159,13 +1159,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
 
-	if (status != IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
-	    IB_SA_MAD_STATUS_INSUF_COMPS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A7: "
-			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
-			ib_get_err_str(status),
+	if (((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=
+	     IB_SA_MAD_STATUS_INSUF_COMPS)
+		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
+			"Expected IB_SA_MAD_STATUS_INSUF_COMPS got:%s\n",
 			ib_get_mad_status_str((ib_mad_t *) sa_mad));
+	if (status != IB_REMOTE_ERROR) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A7: "
+			"Expected REMOTE ERROR got:%s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
