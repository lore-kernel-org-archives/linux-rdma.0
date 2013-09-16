From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_state_mgr.c Add info to some error messages
Date: Mon, 16 Sep 2013 07:38:38 -0700 (PDT)
Message-ID: <addef83f-9034-44da-94ef-624feca50747@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index adfea9a..20f91da 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -146,7 +147,8 @@ static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 			     OSM_MSG_LIGHT_SWEEP_FAIL, &mad_context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3304: "
-			"Request for SwitchInfo failed (%s)\n",
+			"Request for SwitchInfo from 0x%" PRIx64 " failed (%s)\n",
+			cl_ntoh64(osm_node_get_node_guid(p_node)),
 			ib_get_err_str(status));
 
 	OSM_LOG_EXIT(sm->p_log);
@@ -191,8 +193,8 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
 			     TRUE, 0, CL_DISP_MSGID_NONE, &mad_context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 332E: "
-			"Request for PortInfo failed (%s)\n",
-			ib_get_err_str(status));
+			"Request for remote PortInfo from 0x%" PRIx64 " failed (%s)\n",
+			cl_ntoh64(p_physp->port_guid), ib_get_err_str(status));
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
@@ -566,7 +568,8 @@ static void state_mgr_update_node_desc(IN cl_map_item_t * obj, IN void *context)
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"ERR 331B: Failure initiating NodeDescription request "
-			"(%s)\n", ib_get_err_str(status));
+			"(%s) to 0x%016" PRIx64 "\n", ib_get_err_str(status),
+			cl_ntoh64(osm_node_get_node_guid(p_node)));
 
 exit:
 	OSM_LOG_EXIT(sm->p_log);
@@ -774,7 +777,7 @@ static osm_remote_sm_t *state_mgr_get_highest_sm(IN osm_sm_t * sm)
 	if (p_highest_sm != NULL) {
 		p_node = osm_get_node_by_guid(sm->p_subn, p_highest_sm->smi.guid);
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
-			"Found higher SM with guid: %016" PRIx64 " (node %s)\n",
+			"Found higher priority SM with guid: %016" PRIx64 " (node %s)\n",
 			cl_ntoh64(p_highest_sm->smi.guid),
 			p_node ? p_node->print_desc : "UNKNOWN");
 	}
@@ -848,8 +851,10 @@ static void state_mgr_send_handover(IN osm_sm_t * sm, IN osm_remote_sm_t * p_sm)
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3317: "
-			"Failure requesting SMInfo (%s)\n",
-			ib_get_err_str(status));
+			"Failure requesting SMInfo (%s), remote SM at 0x%"
+			PRIx64 "(node %s)\n",
+			ib_get_err_str(status), cl_ntoh64(p_port->guid),
+			p_port->p_node ? p_port->p_node->print_desc : "UNKNOWN");
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
