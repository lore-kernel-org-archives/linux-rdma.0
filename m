From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] osm_sm_state_mgr.c: Fix handling of polling retry number
Date: Thu, 5 Dec 2013 06:10:19 -0800 (PST)
Message-ID: <dffb6af4-bcf7-45ed-a7ec-ce5972e3959e@default>
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
index 596ad8f..920923b 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
- * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2013, Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -74,13 +74,14 @@ void osm_report_sm_state(osm_sm_t * sm)
 	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, buf);
 }
 
-static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
+static boolean_t sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 {
 	osm_madw_context_t context;
 	const osm_port_t *p_port;
 	ib_api_status_t status;
 	osm_dr_path_t dr_path;
 	ib_net64_t guid;
+	boolean_t sent_req = FALSE;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -128,9 +129,13 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3204: "
 			"Failure requesting SMInfo (%s)\n",
 			ib_get_err_str(status));
+	else
+		sent_req = TRUE;
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
+
+	return (sent_req);
 }
 
 static void sm_state_mgr_start_polling(osm_sm_t * sm)
@@ -197,16 +202,14 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
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
@@ -215,7 +218,10 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 	}
 
 	/* Send a SubnGet(SMInfo) request to the remote sm (depends on our state) */
-	sm_state_mgr_send_master_sm_info_req(sm);
+	if (sm_state_mgr_send_master_sm_info_req(sm)) {
+		/* Request sent, increment the retry number */
+		sm->retry_number++;
+	}
 
 	/* restart the timer */
 	cl_status = cl_timer_start(&sm->polling_timer, timeout);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
