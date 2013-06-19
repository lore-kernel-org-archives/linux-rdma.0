From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH][TRIVIAL] osm_sm_state_mgr.c Trivial log changes
Date: Wed, 19 Jun 2013 03:30:32 -0700 (PDT)
Message-ID: <51d9d87a-655f-41d1-87fe-ecf5a43fb30d@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 11defdd..e2cabd6 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -157,7 +157,7 @@ static void sm_state_mgr_start_polling(osm_sm_t * sm)
 	cl_status = cl_timer_start(&sm->polling_timer, timeout);
 	if (cl_status != CL_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3210: "
-			"Failed to start timer\n");
+			"Failed to start polling timer\n");
 
 	OSM_LOG_EXIT(sm->p_log);
 }
@@ -201,8 +201,8 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 	 * osm_sm_state_mgr_process with signal OSM_SM_SIGNAL_POLLING_TIMEOUT
 	 */
 	sm->retry_number++;
-	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE, "Retry number:%d\n",
-		sm->retry_number);
+	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE, "State %d, Retry number:%d\n",
+		sm->p_subn->sm_state, sm->retry_number);
 
 	if (sm->retry_number >= sm->p_subn->opt.polling_retry_number) {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
@@ -219,7 +219,7 @@ void osm_sm_state_mgr_polling_callback(IN void *context)
 	cl_status = cl_timer_start(&sm->polling_timer, timeout);
 	if (cl_status != CL_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3211: "
-			"Failed to restart timer\n");
+			"Failed to restart polling timer\n");
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
@@ -414,8 +414,8 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 * handover from it.
 			 */
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-				"Forcing heavy sweep. "
-				"Received OSM_SM_SIGNAL_HANDOVER or OSM_SM_SIGNAL_POLLING_TIMEOUT\n");
+				"Forcing heavy sweep. Received signal %s\n",
+				osm_get_sm_mgr_signal_str(signal));
 			/* Force set_client_rereg_on_sweep, we don't know what the other
 			 * SM may have configure/done on the fabric.
 			 */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
