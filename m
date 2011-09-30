From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Only log SM PORT "state" when it changes
Date: Fri, 30 Sep 2011 11:41:59 -0400
Message-ID: <4E85E347.3030005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than every sweep time
so don't spam syslog and opensm.log when port stays down

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 8bbce7c..2e88479 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -548,6 +548,7 @@ typedef struct osm_subn {
 	ib_net16_t master_sm_base_lid;
 	ib_net16_t sm_base_lid;
 	ib_net64_t sm_port_guid;
+	uint8_t last_sm_port_state;
 	uint8_t sm_state;
 	osm_subn_opt_t opt;
 	struct osm_qos_policy *p_qos_policy;
@@ -607,6 +608,10 @@ typedef struct osm_subn {
 *	sm_port_guid
 *		This SM's own port GUID.
 *
+*	last_sm_port_state
+*		Last state of this SM's port.
+*		0 is down and 1 is up.
+*
 *	sm_state
 *		The high-level state of the SM.  This value is made available
 *		in the SMInfo attribute.
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index dd308f2..b413709 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1198,8 +1198,12 @@ repeat_discovery:
 		return;
 
 	if (state_mgr_is_sm_port_down(sm) == TRUE) {
-		osm_log(sm->p_log, OSM_LOG_SYS, "SM port is down\n");
-		OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "SM PORT DOWN");
+		if (sm->p_subn->last_sm_port_state) {
+			sm->p_subn->last_sm_port_state = 0;
+			osm_log(sm->p_log, OSM_LOG_SYS, "SM port is down\n");
+			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
+					"SM PORT DOWN");
+		}
 
 		/* Run the drop manager - we want to clear all records */
 		osm_drop_mgr_process(sm);
@@ -1210,6 +1214,13 @@ repeat_discovery:
 		osm_opensm_report_event(sm->p_subn->p_osm,
 				OSM_EVENT_ID_STATE_CHANGE, NULL);
 		return;
+	} else {
+		if (!sm->p_subn->last_sm_port_state) {
+			sm->p_subn->last_sm_port_state = 1;
+			osm_log(sm->p_log, OSM_LOG_SYS, "SM port is up\n");
+			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
+					"SM PORT UP");
+		}
 	}
 
 	status = state_mgr_sweep_hop_1(sm);
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 8d636bc..11d7cf5 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -563,6 +563,7 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 	/* we assume master by default - so we only need to set it true if STANDBY */
 	p_subn->coming_out_of_standby = FALSE;
 	p_subn->sweeping_enabled = TRUE;
+	p_subn->last_sm_port_state = 1;
 
 	return IB_SUCCESS;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
