From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 7/7] osmtest/osmt_multicast.c: Fix check of partial JoinState
 delete request - removing NonMember (o15.0.1.14)
Date: Sat, 01 Oct 2011 09:16:15 -0400
Message-ID: <4E87129F.8010702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


No need to supply rate to delete MC group
Rate being supplied was invalid and is now being verified by SA

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmt_multicast.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index f5e0dae..b861ad4 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -2052,11 +2052,8 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking partial JoinState delete request - removing NonMember (o15.0.1.14)...\n");
 
-	mc_req_rec.rate =
-	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
 	mc_req_rec.mgid = good_mgid;
-	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
-	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
+	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS;	/* all above are required */
 	/* link-local scope, non member (so we should not be able to delete) */
 	/* but the NonMember bit should be gone */
 	mc_req_rec.scope_state = 0x22;
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
