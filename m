From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 1/4] osm_trap_rcv.c: fix locking in, trap_rcv_process_request()
Date: Wed, 15 Jan 2014 15:28:26 -0500
Message-ID: <52D6EF6A.9040603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 280a2ac0ba17b909481ebbd3ed406104629f2a36 Mon Sep 17 00:00:00 2001
From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 29 Aug 2012 19:31:19 +0300
Subject: [PATCH 1/4] osm_trap_rcv.c: fix locking in
 trap_rcv_process_request()

Write lock should be taken before accessing p_physp.
In case of traps 144/145, we also update the physp data.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 663fa35..9d7ed74 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -447,7 +447,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	}
 
 	osm_dump_notice_v2(sm->p_log, p_ntci, FILE_ID, OSM_LOG_VERBOSE);
-
+	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	p_physp = osm_get_physp_by_mad_addr(sm->p_log, sm->p_subn,
 					    &tmp_madw.mad_addr);
 	if (p_physp)
@@ -545,9 +545,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_INFO, "Trap 144 Node description update\n");
 
 		if (p_physp) {
-			CL_PLOCK_ACQUIRE(sm->p_lock);
 			osm_req_get_node_desc(sm, p_physp);
-			CL_PLOCK_RELEASE(sm->p_lock);
 			if (!(p_ntci->data_details.ntc_144.change_flgs & ~TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) &&
 			    p_ntci->data_details.ntc_144.new_cap_mask == p_physp->port_info.capability_mask)
 				goto check_report;
@@ -647,9 +645,7 @@ check_report:
 	}
 
 	/* we need a lock here as the InformInfo DB must be stable */
-	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_report_notice(sm->p_log, sm->p_subn, p_ntci);
-	CL_PLOCK_RELEASE(sm->p_lock);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3803: "
 			"Error sending trap reports (%s)\n",
@@ -658,6 +654,7 @@ check_report:
 	}
 
 Exit:
+	CL_PLOCK_RELEASE(sm->p_lock);
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
