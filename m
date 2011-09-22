From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmt_multicast.c: Fix an unrealistic rate
 case
Date: Thu, 22 Sep 2011 14:22:46 -0400
Message-ID: <4E7B7CF6.7010601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


56 Gbps is really faster than 60 Gbps due to the link encoding difference
so use 56 Gbps rather than 60 Gbps here

300 Gbps rather than 120 Gbps is now the max rate

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 1054d49..46ed93b 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -894,13 +894,13 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	}
 
 	/* o15.0.1.8: */
-	/* - Request join with irrelevant RATE : get a ERR_INSUFFICIENT_COMPONENTS */
+	/* - Request join with unrealistic RATE : get REQ INVALID status */
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Join with unrealistic rate (o15.0.1.8)...\n");
 
 	/* impossible requested rate */
 	mc_req_rec.rate =
-	    IB_PATH_RECORD_RATE_60_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
+	    IB_PATH_RECORD_RATE_56_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
 
 	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
@@ -922,11 +922,11 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	/* Check Valid value which is unreasonable now */
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
-		"Checking Join with unrealistic rate 120GB (o15.0.1.8)...\n");
+		"Checking Join with unrealistic rate 300GB (o15.0.1.8)...\n");
 
 	/* impossible requested rate */
 	mc_req_rec.rate =
-	    IB_PATH_RECORD_RATE_120_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
+	    IB_PATH_RECORD_RATE_300_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
 
 	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
