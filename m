From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_perfmgr.c: Use non conflicting error
 codes in log messages
Date: Mon, 30 Jul 2012 09:25:34 -0400
Message-ID: <50168B4E.3020801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


4Cxx was already used by osm_sa.c so move perfmgr to 54xx error codes

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index a146990..0a29041 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -183,7 +183,7 @@ static void perfmgr_mad_recv_callback(osm_madw_t * p_madw, void *bind_context,
 	/* post this message for later processing. */
 	if (cl_disp_post(pm->pc_disp_h, OSM_MSG_MAD_PORT_COUNTERS,
 			 p_madw, NULL, NULL) != CL_SUCCESS) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C01: "
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5401: "
 			"PerfMgr Dispatcher post failed\n");
 		osm_mad_pool_put(pm->mad_pool, p_madw);
 	}
@@ -212,13 +212,13 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 	 */
 	if ((p_node = cl_qmap_get(&pm->monitored_map, node_guid)) ==
 	    cl_qmap_end(&pm->monitored_map)) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C15: GUID 0x%016"
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5415: GUID 0x%016"
 			PRIx64 " not found in monitored map\n", node_guid);
 		goto Exit;
 	}
 	p_mon_node = (monitored_node_t *) p_node;
 
-	OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C02: %s (0x%" PRIx64
+	OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5402: %s (0x%" PRIx64
 		") port %u LID %u TID 0x%" PRIx64 "\n",
 		p_mon_node->name, p_mon_node->guid, port,
 		cl_ntoh16(p_madw->mad_addr.dest_lid),
@@ -230,7 +230,7 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 		/* Now, validate port number */
 		if (port >= p_mon_node->num_ports) {
 			cl_plock_release(&pm->osm->lock);
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C16: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5416: "
 				"Invalid port num %u for %s (GUID 0x%016"
 				PRIx64 ") num ports %u\n", port,
 				p_mon_node->name, p_mon_node->guid,
@@ -265,7 +265,7 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
 
 	if (pm->bind_handle != OSM_BIND_INVALID_HANDLE) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C03: Multiple binds not allowed\n");
+			"ERR 5403: Multiple binds not allowed\n");
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -291,7 +291,7 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
 	if (pm->bind_handle == OSM_BIND_INVALID_HANDLE) {
 		status = IB_ERROR;
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C04: Vendor specific bind failed (%s)\n",
+			"ERR 5404: Vendor specific bind failed (%s)\n",
 			ib_get_err_str(status));
 	}
 
@@ -307,7 +307,7 @@ static void perfmgr_mad_unbind(osm_perfmgr_t * pm)
 {
 	OSM_LOG_ENTER(pm->log);
 	if (pm->bind_handle == OSM_BIND_INVALID_HANDLE) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C05: No previous bind\n");
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5405: No previous bind\n");
 		goto Exit;
 	}
 	osm_vendor_unbind(pm->bind_handle);
@@ -458,7 +458,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 		mon_node = malloc(sizeof(*mon_node) +
 				  sizeof(monitored_port_t) * num_ports);
 		if (!mon_node) {
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C06: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 5406: "
 				"malloc failed: not handling node %s"
 				"(GUID 0x%" PRIx64 ")\n", node->print_desc,
 				node_guid);
@@ -510,7 +510,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 	node = osm_get_node_by_guid(pm->subn, cl_hton64(mon_node->guid));
 	if (!node) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C07: Node \"%s\" (guid 0x%" PRIx64
+			"ERR 5407: Node \"%s\" (guid 0x%" PRIx64
 			") no longer exists so removing from PerfMgr monitoring\n",
 			mon_node->name, mon_node->guid);
 		mark_for_removal(pm, mon_node);
@@ -525,7 +525,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 				    num_ports, node->print_desc) !=
 	    PERFMGR_EVENT_DB_SUCCESS) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C08: DB create entry failed for 0x%"
+			"ERR 5408: DB create entry failed for 0x%"
 			PRIx64 " (%s) : %s\n", node_guid, node->print_desc,
 			strerror(errno));
 		goto Exit;
@@ -568,7 +568,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 					     port, IB_MAD_METHOD_GET,
 					     &mad_context);
 		if (status != IB_SUCCESS)
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C09: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5409: "
 				"Failed to issue port counter query for node 0x%"
 				PRIx64 " port %d (%s)\n",
 				node->node_info.node_guid, port,
@@ -604,7 +604,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-			"ERR 4C81: No SM port object\n");
+			"ERR 5481: No SM port object\n");
 		return -1;
 	}
 
@@ -631,7 +631,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 				     CL_DISP_MSGID_NONE, &context);
 
 		if (status != IB_SUCCESS)
-			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4C82: "
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 5482: "
 				"Request for NodeInfo failed\n");
 		break;
 
@@ -664,14 +664,14 @@ static int sweep_hop_1(osm_sm_t * sm)
 					     CL_DISP_MSGID_NONE, &context);
 
 			if (status != IB_SUCCESS)
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4C84: "
+				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 5484: "
 					"Request for NodeInfo failed\n");
 		}
 		break;
 
 	default:
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-			"ERR 4C83: Unknown node type %d\n",
+			"ERR 5483: Unknown node type %d\n",
 			osm_node_get_type(p_node));
 	}
 
@@ -691,7 +691,7 @@ static unsigned is_sm_port_down(osm_sm_t * sm)
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
 		CL_PLOCK_RELEASE(sm->p_lock);
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4C85: "
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 5485: "
 			"SM port with GUID:%016" PRIx64 " is unknown\n",
 			cl_ntoh64(port_guid));
 		return 1;
@@ -726,7 +726,7 @@ static int sweep_hop_0(osm_sm_t * sm)
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-			"ERR 4C86: Request for NodeInfo failed\n");
+			"ERR 5486: Request for NodeInfo failed\n");
 
 	return status;
 }
@@ -819,7 +819,7 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 			    ib_node_info_get_local_port_num(&p_node->node_info);
 		} else
 			OSM_LOG(pm->log, OSM_LOG_ERROR,
-				"ERR 4C87: No PerfMgr port object\n");
+				"ERR 5487: No PerfMgr port object\n");
 		CL_PLOCK_RELEASE(pm->sm->p_lock);
 	}
 
@@ -928,7 +928,7 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 	    cr->link_integrity < prev_err.link_integrity ||
 	    cr->buffer_overrun < prev_err.buffer_overrun ||
 	    cr->vl15_dropped < prev_err.vl15_dropped) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C0A: "
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 540A: "
 			"Detected an out of band error clear "
 			"on %s (0x%" PRIx64 ") port %u\n",
 			mon_node->name, mon_node->guid, port);
@@ -950,7 +950,7 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 	    dc->xmit_pkts < prev_dc.xmit_pkts ||
 	    dc->rcv_pkts < prev_dc.rcv_pkts) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"PerfMgr: ERR 4C0B: Detected an out of band data counter "
+			"PerfMgr: ERR 540B: Detected an out of band data counter "
 			"clear on node %s (0x%" PRIx64 ") port %u\n",
 			mon_node->name, mon_node->guid, port);
 		perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
@@ -1027,7 +1027,7 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 		lid = get_lid(p_node, port, mon_node);
 		cl_plock_release(&pm->osm->lock);
 		if (lid == 0) {
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C0C: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 540C: "
 				"Failed to clear counters for %s (0x%"
 				PRIx64 ") port %d; failed to get lid\n",
 				mon_node->name, mon_node->guid, port);
@@ -1044,7 +1044,7 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 					     port, IB_MAD_METHOD_SET,
 					     &mad_context);
 		if (status != IB_SUCCESS)
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C11: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 5411: "
 				"Failed to send clear counters MAD for %s (0x%"
 				PRIx64 ") port %d\n",
 				mon_node->name, mon_node->guid, port);
@@ -1114,7 +1114,7 @@ static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
 	if (!p_port) {
 		CL_PLOCK_RELEASE(pm->sm->p_lock);
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C1E: No PerfMgr port object\n");
+			"ERR 541E: No PerfMgr port object\n");
 		goto Exit;
 	}
 	if (p_port->p_physp && osm_physp_is_valid(p_port->p_physp)) {
@@ -1148,7 +1148,7 @@ static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
 	} else {
 		CL_PLOCK_RELEASE(pm->sm->p_lock);
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"ERR 4C20: Local PerfMgt port physp invalid\n");
+			"ERR 5420: Local PerfMgt port physp invalid\n");
 	}
 
 Exit:
@@ -1185,7 +1185,7 @@ static void pc_recv_process(void *context, void *data)
 	 */
 	if ((p_node = cl_qmap_get(&pm->monitored_map, node_guid)) ==
 	    cl_qmap_end(&pm->monitored_map)) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C12: GUID 0x%016"
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5412: GUID 0x%016"
 			PRIx64 " not found in monitored map\n", node_guid);
 		goto Exit;
 	}
@@ -1261,7 +1261,7 @@ static void pc_recv_process(void *context, void *data)
 		/* Now, validate port number */
 		if (port >= p_mon_node->num_ports) {
 			cl_plock_release(&pm->osm->lock);
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C13: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5413: "
 				"Invalid port num %d for GUID 0x%016"
 				PRIx64 " num ports %d\n", port, node_guid,
 				p_mon_node->num_ports);
@@ -1287,7 +1287,7 @@ static void pc_recv_process(void *context, void *data)
 					     mad_context->perfmgr_context.
 					     mad_method, mad_context);
 		if (status != IB_SUCCESS)
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C14: "
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
 				"Failed to send redirected MAD with method 0x%x for node 0x%"
 				PRIx64 " port %d\n",
 				mad_context->perfmgr_context.mad_method,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
