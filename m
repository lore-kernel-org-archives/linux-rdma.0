From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fix crash during handover
Date: Tue,  4 Mar 2014 13:07:48 +0200
Message-ID: <1393931268-15316-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Another MASTER SM with lower priority sends HANDOVER to our SM,
before our SM *starts* polling it.

In sm_state_mgr_start_polling() there is no validation whether
p_polling_sm is valid.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_sm.h   |    2 +-
 opensm/osm_drop_mgr.c     |    6 +++---
 opensm/osm_sm_state_mgr.c |   12 ++++++------
 opensm/osm_sminfo_rcv.c   |    2 +-
 opensm/osm_state_mgr.c    |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
index e48c549..94d1831 100644
--- a/include/opensm/osm_sm.h
+++ b/include/opensm/osm_sm.h
@@ -116,7 +116,7 @@ typedef struct osm_sm {
 	unsigned master_sm_found;
 	uint32_t retry_number;
 	ib_net64_t master_sm_guid;
-	osm_remote_sm_t *p_polling_sm;
+	ib_net64_t polling_sm_guid;
 	osm_subn_t *p_subn;
 	osm_db_t *p_db;
 	osm_vendor_t *p_vendor;
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index ff6a81b..c1cdc0d 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -257,9 +257,9 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Cleaned SM for port guid 0x%016" PRIx64 "\n",
 			cl_ntoh64(port_guid));
-		/* clean up the polling_sm pointer */
-		if (sm->p_polling_sm == p_sm)
-			sm->p_polling_sm = NULL;
+		/* clean up the polling_sm_guid */
+		if (sm->polling_sm_guid == p_sm->smi.guid)
+			sm->polling_sm_guid = 0;
 		free(p_sm);
 	}
 
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 0660fb9..e5a11da 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -97,11 +97,11 @@ static boolean_t sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm, uint8_t sm_
 	} else {
 		/*
 		 * We are not in STANDBY - this means we are in MASTER state -
-		 * so we need to poll the SM that is saved in p_polling_sm
+		 * so we need to poll the SM that is saved in polling_sm_guid
 		 * under sm.
 		 * Send a query of SubnGet(SMInfo) to that SM.
 		 */
-		guid = sm->p_polling_sm->smi.guid;
+		guid = sm->polling_sm_guid;
 	}
 
 	/* Verify that SM is not polling itself */
@@ -198,7 +198,7 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 	 * If we are not in one of these cases - don't need to restart the poller.
 	 */
 	if (!((sm_state == IB_SMINFO_STATE_MASTER &&
-	       sm->p_polling_sm != NULL) ||
+	       sm->polling_sm_guid != 0) ||
 	      sm_state == IB_SMINFO_STATE_STANDBY)) {
 		CL_PLOCK_RELEASE(sm->p_lock);
 		goto Exit;
@@ -426,7 +426,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * We want to force a heavy sweep - hopefully this
 			 * occurred because the remote sm died, and we'll find
 			 * this out and configure the subnet after a heavy sweep.
-			 * We also want to clear the p_polling_sm object - since
+			 * We also want to clear the polling_sm_guid - since
 			 * we are done polling on that remote sm - we are
 			 * sweeping again.
 			 */
@@ -438,7 +438,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * change, or we are in idle state - since we
 			 * recognized a master SM before - so we want to make a
 			 * heavy sweep and reconfigure the new subnet.
-			 * We also want to clear the p_polling_sm object - since
+			 * We also want to clear the polling_sm_guid - since
 			 * we are done polling on that remote sm - we got a
 			 * handover from it.
 			 */
@@ -449,7 +449,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * SM may have configure/done on the fabric.
 			 */
 			sm->p_subn->set_client_rereg_on_sweep = TRUE;
-			sm->p_polling_sm = NULL;
+			sm->polling_sm_guid = 0;
 			sm->p_subn->force_heavy_sweep = TRUE;
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 66ad410..9f62f9f 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -392,7 +392,7 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 			 * as it might not get it and we don't want to wait for a HANDOVER
 			 * forever.
 			 */
-			if (sm->p_polling_sm) {
+			if (sm->polling_sm_guid) {
 				if (smi_rcv_remote_sm_is_higher(sm, p_smi))
 					sm->p_subn->force_heavy_sweep = TRUE;
 				else
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index f9b20e2..c4f4978 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1386,7 +1386,7 @@ repeat_discovery:
 				 * need to wait for that SM to relinquish control
 				 * of its portion of the subnet. C14-60.2.1.
 				 * Also - need to start polling on that SM. */
-				sm->p_polling_sm = p_remote_sm;
+				sm->polling_sm_guid = p_remote_sm->smi.guid;
 				osm_sm_state_mgr_process(sm,
 							 OSM_SM_SIGNAL_WAIT_FOR_HANDOVER);
 				return;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
