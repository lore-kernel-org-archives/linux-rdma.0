From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/7] osmtest/osmt_multicast.c: Fix first MGID=0 MC group creation
 case
Date: Sat, 01 Oct 2011 09:16:05 -0400
Message-ID: <4E871295.5090902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to use any rate rather than greater than an invalid rate
where invalid rates are now being checked in SA

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmt_multicast.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 69d1730..346c966 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1215,18 +1215,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Create given MGID=0 valid Set several options :\n\t\t"
-		"First above min RATE, Second less than max RATE\n\t\t"
+		"First any RATE, Second less than max RATE\n\t\t"
 		"Third above min MTU, Fourth less than max MTU\n\t\t"
 		"Fifth exact MTU & RATE feasible, Sixth exact RATE feasible\n\t\t"
 		"Seventh exact MTU feasible (o15.0.1.4)...\n");
 
 	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
 
-	mc_req_rec.rate =
-	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
-
-	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
-	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
+	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS;	/* all above are required */
 
 	status = osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
 					 sa_mad);
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
