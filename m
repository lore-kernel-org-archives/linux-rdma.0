From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmt_multicast.c: Use proper defines for rate
Date: Tue, 05 Jul 2011 13:24:34 -0400
Message-ID: <4E1348D2.8080109@dev.mellanox.co.il>
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
index 9ea56c8..1054d49 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -385,7 +385,7 @@ void osmt_init_mc_query_rec(IN osmtest_t * const p_osmt,
 	/*  uint8_t     mtu; - keep it zero means - anything you have please. */
 	/*  uint8_t     tclass; can leave as zero for now (between subnets) */
 	/*  ib_net16_t  pkey; leave as zero */
-	p_mc_req->rate = IB_LINK_WIDTH_ACTIVE_4X;
+	p_mc_req->rate = IB_PATH_RECORD_RATE_2_5_GBS;
 	/*  uint8_t     pkt_life; zero means greater than zero ... */
 	/*  ib_net32_t  sl_flow_hop; keep it all zeros */
 	/*  we want to use a link local scope: 0x02 */
@@ -900,7 +900,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	/* impossible requested rate */
 	mc_req_rec.rate =
-	    IB_LINK_WIDTH_ACTIVE_12X | IB_PATH_SELECTOR_GREATER_THAN << 6;
+	    IB_PATH_RECORD_RATE_60_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
 
 	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
@@ -1247,7 +1247,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 
 	mc_req_rec.rate =
-	    IB_LINK_WIDTH_ACTIVE_12X | IB_PATH_SELECTOR_LESS_THAN << 6;
+	    IB_PATH_RECORD_RATE_60_GBS | IB_PATH_SELECTOR_LESS_THAN << 6;
 
 	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
