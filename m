From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_trap_rcv.c: Lock released without locking in some
 cases of trap processing
Date: Thu, 05 Jun 2014 10:50:08 -0400
Message-ID: <539083A0.5040104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index ce26efa..2aef40e 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -390,7 +390,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 		   Otherwise we start a sweep on the trap 144 caused by
 		   cleaning up SM Cap bit...
 		 */
-		goto Exit;
+		goto Exit2;
 
 	/* update the is_gsi flag according to the mgmt_class field */
 	if (p_madw->p_mad->mgmt_class == IB_MCLASS_SUBN_LID ||
@@ -406,7 +406,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	if (p_smp->method != IB_MAD_METHOD_TRAP) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3801: "
 			"Unsupported method 0x%X\n", p_smp->method);
-		goto Exit;
+		goto Exit2;
 	}
 
 	/*
@@ -432,7 +432,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 			if (sm->p_subn->sm_base_lid == 0) {
 				OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 					"Received SLID=0 Trap with local LID=0. Ignoring MAD\n");
-				goto Exit;
+				goto Exit2;
 			}
 			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 				"Received SLID=0 Trap. Using local LID:%u instead\n",
@@ -665,6 +665,7 @@ check_report:
 
 Exit:
 	CL_PLOCK_RELEASE(sm->p_lock);
+Exit2:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
