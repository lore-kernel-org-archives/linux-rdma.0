From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 11/11] osmtest/osmt_multicast.c: Fix some typos
Date: Fri, 01 Apr 2011 14:38:40 -0400
Message-ID: <4D961BB0.6040700@dev.mellanox.co.il>
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
index b6dfdfc..6d0ed73 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -729,7 +729,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)

 	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID |
 	    /* IB_MCR_COMPMASK_QKEY |  */
-	    /* IB_MCR_COMPMASK_PKEY | intentionaly missed to raise the error */
+	    /* IB_MCR_COMPMASK_PKEY | intentionally missed to raise the error */
 	    IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW |
IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are
required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;

@@ -795,7 +795,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	comp_mask =
 	    IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID |
 	    IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL |
-	    /* IB_MCR_COMPMASK_FLOW | intentionaly missed to raise the error */
+	    /* IB_MCR_COMPMASK_FLOW | intentionally missed to raise the error */
 	    IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above
are required */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;

@@ -857,10 +857,10 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *
const p_osmt)
 	ib_member_set_join_state(&mc_req_rec, IB_MC_REC_STATE_FULL_MEMBER);

 	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID |
-	    /* IB_MCR_COMPMASK_QKEY | intentionaly missed to raise the error */
+	    /* IB_MCR_COMPMASK_QKEY | intentionally missed to raise the error */
 	    IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL |
 	    IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE |
-	    /* IB_MCR_COMPMASK_TCLASS |  intentionaly missed to raise the error */
+	    /* IB_MCR_COMPMASK_TCLASS |  intentionally missed to raise the
error */
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;

 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
