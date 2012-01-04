From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed multicast groups reconfiguration during heawy
 sweep
Date: Wed, 4 Jan 2012 12:08:01 +0200
Message-ID: <20120104100801.GA8530@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A bug was introduced by patch: 15989afbfbe55b2785acebf29a3db536d4910fec,
causing the SM to configure only new MC request during the heavy sweep.
So in case of a topology change, SM wouldn't recalculate the MC.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |   15 ++++++++++-----
 opensm/osm_state_mgr.c |    6 +++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index e33c716..d2cc465 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -1151,13 +1151,15 @@ static int alloc_mfts(osm_sm_t * sm)
 }
 
 /**********************************************************************
-  This is the function that is invoked during idle time to handle the
-  process request for mcast groups where join/leave/delete was required.
+  This is the function that is invoked during idle time and sweep to
+  handle the process request for mcast groups where join/leave/delete
+  was required.
  **********************************************************************/
-int osm_mcast_mgr_process(osm_sm_t * sm)
+int osm_mcast_mgr_process(osm_sm_t * sm, boolean_t config_all)
 {
 	int ret = 0;
 	unsigned i;
+	unsigned max_mlid;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -1177,8 +1179,11 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
 		goto exit;
 	}
 
-	for (i = 0; i <= sm->mlids_req_max; i++) {
-		if (!sm->mlids_req[i])
+	max_mlid = config_all ? sm->p_subn->max_mcast_lid_ho
+			- IB_LID_MCAST_START_HO : sm->mlids_req_max;
+	for (i = 0; i <= max_mlid; i++) {
+		if (!sm->mlids_req[i] &&
+		    !(config_all && sm->p_subn->mboxes[i]))
 			continue;
 		sm->mlids_req[i] = 0;
 		mcast_mgr_process_mlid(sm, i + IB_LID_MCAST_START_HO);
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index b413709..96b445f 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -68,7 +68,7 @@
 extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
 extern int osm_pkey_mgr_process(IN osm_opensm_t * p_osm);
-extern int osm_mcast_mgr_process(IN osm_sm_t * sm);
+extern int osm_mcast_mgr_process(IN osm_sm_t * sm, boolean_t config_all);
 extern int osm_link_mgr_process(IN osm_sm_t * sm, IN uint8_t state);
 
 static void state_mgr_up_msg(IN const osm_sm_t * sm)
@@ -1360,7 +1360,7 @@ repeat_discovery:
 			OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
 
 	if (!sm->p_subn->opt.disable_multicast) {
-		osm_mcast_mgr_process(sm);
+		osm_mcast_mgr_process(sm, TRUE);
 		if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 			return;
 		OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
@@ -1442,7 +1442,7 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
 	if (sm->p_subn->sm_state != IB_SMINFO_STATE_MASTER)
 		return;
 	if (!sm->p_subn->opt.disable_multicast) {
-		osm_mcast_mgr_process(sm);
+		osm_mcast_mgr_process(sm, FALSE);
 		wait_for_pending_transactions(&sm->p_subn->p_osm->stats);
 	}
 }
-- 
1.7.7.4

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
