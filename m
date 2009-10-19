From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_state_mgr.c: Cosmetic formatting changes
Date: Mon, 19 Oct 2009 09:03:51 -0400
Message-ID: <20091019130351.GC18483@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sm_state_mgr.c b/opensm/opensm/osm_sm_state_mgr.c
index d06e6aa..f046447 100644
--- a/opensm/opensm/osm_sm_state_mgr.c
+++ b/opensm/opensm/osm_sm_state_mgr.c
@@ -86,15 +86,17 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 	memset(&context, 0, sizeof(context));
 	if (sm->p_subn->sm_state == IB_SMINFO_STATE_STANDBY) {
 		/*
-		 * We are in STANDBY state - this means we need to poll on the master
-		 * SM (according to master_guid)
-		 * Send a query of SubnGet(SMInfo) to the subn master_sm_base_lid object.
+		 * We are in STANDBY state - this means we need to poll the
+		 * master SM (according to master_guid).
+		 * Send a query of SubnGet(SMInfo) to the subn
+		 * master_sm_base_lid object.
 		 */
 		p_port = osm_get_port_by_guid(sm->p_subn, sm->master_sm_guid);
 	} else {
 		/*
-		 * We are not in STANDBY - this means we are in MASTER state - so we need
-		 * to poll on the SM that is saved in p_polling_sm under sm.
+		 * We are not in STANDBY - this means we are in MASTER state -
+		 * so we need to poll the SM that is saved in p_polling_sm
+		 * under sm.
 		 * Send a query of SubnGet(SMInfo) to that SM.
 		 */
 		p_port = sm->p_polling_sm->p_port;
@@ -338,8 +340,10 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			/* Turn on the first_time_master_sweep flag */
 			sm->p_subn->first_time_master_sweep = TRUE;
-			/* Turn on the force_heavy_sweep - we want a
-			 * heavy sweep to occur on the first sweep of this SM. */
+			/*
+			 * Turn on the force_heavy_sweep - we want a
+			 * heavy sweep to occur on the first sweep of this SM.
+			 */
 			sm->p_subn->force_heavy_sweep = TRUE;
 
 			sm->p_subn->sm_state = IB_SMINFO_STATE_MASTER;
@@ -387,24 +391,28 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 		switch (signal) {
 		case OSM_SM_SIGNAL_POLLING_TIMEOUT:
 			/*
-			 * we received a polling timeout - this means that we waited for
-			 * a remote master sm to send us a handover, but didn't get it, and
-			 * didn't get a response from that remote sm.
-			 * We want to force a heavy sweep - hopefully this occurred because
-			 * the remote sm died, and we'll find this out and configure the
-			 * subnet after a heavy sweep.
-			 * We also want to clear the p_polling_sm object - since we are
-			 * done polling on that remote sm - we are sweeping again.
+			 * We received a polling timeout - this means that we
+			 * waited for a remote master sm to send us a handover,
+			 * but didn't get it, and didn't get a response from
+			 * that remote sm.
+			 * We want to force a heavy sweep - hopefully this
+			 * occurred because the remote sm died, and we'll find
+			 * this out and configure the subnet after a heavy sweep.
+			 * We also want to clear the p_polling_sm object - since
+			 * we are done polling on that remote sm - we are
+			 * sweeping again.
 			 */
 		case OSM_SM_SIGNAL_HANDOVER:
 			/*
-			 * If we received a handover in a master state - then we want to
-			 * force a heavy sweep. This means that either we are in a sweep
-			 * currently - in this case - no change, or we are in idle state -
-			 * since we recognized a master SM before - so we want to make a
+			 * If we received a handover in a master state - then we
+			 * want to force a heavy sweep. This means that either
+			 * we are in a sweep currently - in this case - no
+			 * change, or we are in idle state - since we
+			 * recognized a master SM before - so we want to make a
 			 * heavy sweep and reconfigure the new subnet.
-			 * We also want to clear the p_polling_sm object - since we are
-			 * done polling on that remote sm - we got a handover from it.
+			 * We also want to clear the p_polling_sm object - since
+			 * we are done polling on that remote sm - we got a
+			 * handover from it.
 			 */
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Forcing heavy sweep. "
@@ -424,11 +432,11 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			break;
 		case OSM_SM_SIGNAL_WAIT_FOR_HANDOVER:
 			/*
-			 * We found a remote master SM, and we are waiting for it
-			 * to handover the mastership to us. Need to start polling
-			 * on that SM, to make sure it is alive, if it isn't - then
-			 * we should move back to discovering, since something must
-			 * have happened to it.
+			 * We found a remote master SM, and we are waiting for
+			 * it to handover the mastership to us. Need to start
+			 * polling that SM, to make sure it is alive, if it
+			 * isn't - then we should move back to discovering,
+			 * since something must have happened to it.
 			 */
 			sm_state_mgr_start_polling(sm);
 			break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
