From: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] OpenSM: single port sweep
Date: Mon, 22 Jul 2013 19:10:56 +0300
Message-ID: <20130722161055.GC24222@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roy.Koren-mb1K0bWo544@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This provides possibility to keep SM/SA operational even in case when
the local SM port was disconnected. It is needed in order to not break
existing loopback connections.
As side effect it let us to startup OpenSM on disconnected port.

Signed-off-by: Sasha Khapyorsky <sashakh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 opensm/osm_state_mgr.c | 95 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 1b73834..c586e64 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1075,6 +1075,90 @@ int wait_for_pending_transactions(osm_stats_t * stats)
 	return osm_exit_flag;
 }
 
+static void single_node_sweep(osm_sm_t *sm)
+{
+	osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_HEAVY_SWEEP_DONE, NULL);
+
+	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HEAVY SWEEP COMPLETE");
+
+	osm_drop_mgr_process(sm);
+
+	/*
+	 * If we are not MASTER already - this means that we are
+	 * in discovery state. call osm_sm_state_mgr with signal
+	 * DISCOVERY_COMPLETED
+	 */
+	if (sm->p_subn->sm_state == IB_SMINFO_STATE_DISCOVERING)
+		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVERY_COMPLETED);
+
+	osm_pkey_mgr_process(sm->p_subn->p_osm);
+
+	/* try to restore SA DB (this should be before lid_mgr
+	   because we may want to disable clients reregistration
+	   when SA DB is restored) */
+	osm_sa_db_file_load(sm->p_subn->p_osm);
+
+	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
+		return;
+
+	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
+			"PKEY setup completed - STARTING SM LID CONFIG");
+
+	osm_lid_mgr_process_sm(&sm->lid_mgr);
+	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
+		return;
+
+	state_mgr_notify_lid_change(sm);
+
+	/* At this point we need to check the consistency of
+	 * the port_lid_tbl under the subnet. There might be
+	 * errors in it if PortInfo Set requests didn't reach
+	 * their destination. */
+	state_mgr_check_tbl_consistency(sm);
+
+	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "LID ASSIGNMENT COMPLETE");
+
+	/* in any case we zero this flag */
+	sm->p_subn->coming_out_of_standby = FALSE;
+
+	/* If there were errors - then the subnet is not really up */
+	if (sm->p_subn->subnet_initialization_error == TRUE) {
+		osm_log_v2(sm->p_log, OSM_LOG_SYS, FILE_ID,
+			   "Errors during initialization\n");
+		OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_ERROR,
+				"ERRORS DURING INITIALIZATION");
+	} else {
+		sm->p_subn->need_update = 0;
+		osm_dump_all(sm->p_subn->p_osm);
+		state_mgr_up_msg(sm);
+		sm->p_subn->first_time_master_sweep = FALSE;
+		sm->p_subn->set_client_rereg_on_sweep = FALSE;
+
+		if (OSM_LOG_IS_ACTIVE_V2(sm->p_log, OSM_LOG_VERBOSE) ||
+		    sm->p_subn->opt.sa_db_dump)
+			osm_sa_db_file_dump(sm->p_subn->p_osm);
+	}
+
+	/*
+	 * Finally signal the subnet up event
+	 */
+	cl_event_signal(&sm->subnet_up_event);
+
+	osm_opensm_report_event(sm->p_subn->p_osm, OSM_EVENT_ID_SUBNET_UP,
+				NULL);
+
+	/* if we got a signal to force heavy sweep or errors
+	 * in the middle of the sweep - try another sweep. */
+	if (sm->p_subn->force_heavy_sweep
+	    || sm->p_subn->subnet_initialization_error)
+		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
+
+	/* Write a new copy of our persistent guid2mkey database */
+	osm_db_store(sm->p_subn->p_g2m);
+	osm_db_store(sm->p_subn->p_neighbor);
+}
+
 static void do_sweep(osm_sm_t * sm)
 {
 	ib_api_status_t status;
@@ -1234,15 +1318,10 @@ repeat_discovery:
 					"SM PORT DOWN");
 		}
 
-		/* Run the drop manager - we want to clear all records */
-		osm_drop_mgr_process(sm);
-
-		/* Move to DISCOVERING state */
-		if (sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
-			osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
-		osm_opensm_report_event(sm->p_subn->p_osm,
-					OSM_EVENT_ID_STATE_CHANGE, NULL);
+		/* special case - just loopback on disconnected node */
+		single_node_sweep(sm);
 		return;
+
 	} else {
 		if (!sm->p_subn->last_sm_port_state) {
 			sm->p_subn->last_sm_port_state = 1;
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
