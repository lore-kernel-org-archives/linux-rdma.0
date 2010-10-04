From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_state_mgr.c: Don't signal DISCOVER to SM state
	machine when already DISCOVERING
Date: Mon, 4 Oct 2010 09:16:44 -0400
Message-ID: <20101004131644.GA24620@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Eliminate this "illegal" state machine transition which triggers the following
log message:

sm_state_mgr_signal_error: ERR 3207: Invalid signal OSM_SM_SIGNAL_DISCOVER in state DISCOVERING

This is observed when the SM port is down. 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e7bff46..68841f8 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1191,7 +1191,8 @@ repeat_discovery:
 		osm_drop_mgr_process(sm);
 
 		/* Move to DISCOVERING state */
-		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
+		 if (sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
+			osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
 		osm_opensm_report_event(sm->p_subn->p_osm,
 				OSM_EVENT_ID_STATE_CHANGE, NULL);
 		return;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
