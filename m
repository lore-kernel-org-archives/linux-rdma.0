From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sm_state_mgr.c Fix handling of polling retry number
Date: Fri, 15 Nov 2013 04:15:51 -0800 (PST)
Message-ID: <3b0cb098-1e00-417d-8a5b-0aa766926867@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The retry counter is now only updated if a packet is actually sent.
(But as before the initial request is also counted.)

Prior to this change the actual maximum number of packets sent were
polling retry number minus one.

Signed-off-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 596ad8f..6eff9ee 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -197,16 +197,14 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 	}
 
 	/*
-	 * Incr the retry number.
-	 * If it reached the max_retry_number in the subnet opt - call
+	 * If retry number reached the max_retry_number in the subnet opt - call
 	 * osm_sm_state_mgr_process with signal OSM_SM_SIGNAL_POLLING_TIMEOUT
 	 */
-	sm->retry_number++;
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE, "SM State %d (%s), Retry number:%d\n",
 		sm->p_subn->sm_state,  osm_get_sm_mgr_state_str(sm->p_subn->sm_state),
 		sm->retry_number);
 
-	if (sm->retry_number >= sm->p_subn->opt.polling_retry_number) {
+	if (sm->retry_number > sm->p_subn->opt.polling_retry_number) {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Reached polling_retry_number value in retry_number. "
 			"Go to DISCOVERY state\n");
@@ -214,6 +212,9 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 		goto Exit;
 	}
 
+	/* Increment the retry number */
+	sm->retry_number++;
+
 	/* Send a SubnGet(SMInfo) request to the remote sm (depends on our state) */
 	sm_state_mgr_send_master_sm_info_req(sm);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
