From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 2/4] osm_trap_rcv.c: In trap_rcv_process_request, change,
 locking strategy
Date: Wed, 15 Jan 2014 15:28:41 -0500
Message-ID: <52D6EF79.4090204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 1418f8a2673162fa888cf42f51ca5c4890dde3e8 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 18 Oct 2012 17:59:04 +0200
Subject: [PATCH 2/4] osm_trap_rcv.c: In trap_rcv_process_request, change
 locking strategy

RW lock is only needed for trap 145 when modifying SystemImageGUID
Scope of holding RO lock holding fixes original reported issue with trap 144
for port disconnected during this code flow

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 9d7ed74..27f3e4a 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -447,7 +447,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	}
 
 	osm_dump_notice_v2(sm->p_log, p_ntci, FILE_ID, OSM_LOG_VERBOSE);
-	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 	p_physp = osm_get_physp_by_mad_addr(sm->p_log, sm->p_subn,
 					    &tmp_madw.mad_addr);
 	if (p_physp)
@@ -555,11 +555,18 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 				"trap 144: \"node description update\"\n");
 		goto check_sweep;
 	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_SYS_IMG_GUID_CHANGED_TRAP) {
-		if (p_physp)
-			/* this assumes that trap 145 content is not broken? */
-			p_physp->p_node->node_info.sys_guid =
-				p_ntci->data_details.ntc_145.new_sys_guid;
-		else
+		if (p_physp) {
+			CL_PLOCK_RELEASE(sm->p_lock);
+			CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+			p_physp = osm_get_physp_by_mad_addr(sm->p_log,
+							    sm->p_subn,
+							    &tmp_madw.mad_addr);
+			if (p_physp) {
+				/* this assumes that trap 145 content is not broken? */
+				p_physp->p_node->node_info.sys_guid =
+					p_ntci->data_details.ntc_145.new_sys_guid;
+			}
+		} else
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 				"ERR 3813: No physical port found for "
 				"trap 145: \"SystemImageGUID update\"\n");
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
