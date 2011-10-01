From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 6/7] osmtest/osmt_multicast.c: Fix check of BAD RATE when
 connecting to existing MGID (o15.0.1.13)
Date: Sat, 01 Oct 2011 09:16:11 -0400
Message-ID: <4E87129B.7000502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use valid rather than invalid rate as this is now validated by SA

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmt_multicast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index 346c966..f5e0dae 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1978,7 +1978,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 
 	mc_req_rec.mgid = good_mgid;
 	mc_req_rec.rate =
-	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_LESS_THAN << 6;
+	    IB_PATH_RECORD_RATE_2_5_GBS | IB_PATH_SELECTOR_LESS_THAN << 6;
 	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
 
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
