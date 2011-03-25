From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/4] opensm/perfmgr: Issue PortCountersExtended query when
 supported
Date: Thu, 24 Mar 2011 18:20:52 -0700
Message-ID: <20110324182052.cebe073c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 10 Mar 2011 14:28:10 -0800
Subject: [PATCH] opensm/perfmgr: Issue PortCountersExtended query when supported

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr_db.h |    2 +-
 opensm/osm_perfmgr.c            |  303 ++++++++++++++++++++++++++++++++-------
 opensm/osm_perfmgr_db.c         |    2 +-
 3 files changed, 253 insertions(+), 54 deletions(-)

diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 42a47bd..8f4706d 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -194,7 +194,7 @@ void perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
 			      perfmgr_db_err_reading_t * reading);
 void perfmgr_db_fill_data_cnt_read_pc(ib_port_counters_t * wire_read,
 				      perfmgr_db_data_cnt_reading_t * reading);
-void perfmgr_db_fill_data_cnt_read_epc(ib_port_counters_ext_t * wire_read,
+void perfmgr_db_fill_data_cnt_read_pce(ib_port_counters_ext_t * wire_read,
 				       perfmgr_db_data_cnt_reading_t * reading);
 
 END_C_DECLS
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 31e61b1..6952d72 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -543,6 +543,51 @@ static ib_api_status_t perfmgr_send_cpi_mad(osm_perfmgr_t * pm,
 }
 
 /**********************************************************************
+ * return if PortCountersExtended are supported.
+ **********************************************************************/
+static boolean_t pce_supported(monitored_node_t *mon_node, uint8_t port)
+{
+	monitored_port_t *mon_port = &(mon_node->port[port]);
+	return (mon_port->cpi_valid
+		&& (mon_port->cap_mask & IB_PM_EXT_WIDTH_SUPPORTED));
+}
+
+/**********************************************************************
+ * Form and send the PortCountersExtended MAD for a single port.
+ **********************************************************************/
+static ib_api_status_t perfmgr_send_pce_mad(osm_perfmgr_t * perfmgr,
+					    ib_net16_t dest_lid,
+					    ib_net32_t dest_qp,
+					    uint16_t pkey_ix,
+					    uint8_t port, uint8_t mad_method,
+					    osm_madw_context_t * p_context)
+{
+	ib_api_status_t status = IB_SUCCESS;
+	ib_port_counters_ext_t *port_counter_ext = NULL;
+	ib_perfmgt_mad_t *pm_mad = NULL;
+	osm_madw_t *p_madw = NULL;
+
+	OSM_LOG_ENTER(perfmgr->log);
+
+	/* FIXME SL != 0 */
+	p_madw = perfmgr_build_mad(perfmgr, dest_lid, 0, dest_qp, pkey_ix,
+				mad_method, IB_MAD_ATTR_PORT_CNTRS_EXT, p_context,
+				&pm_mad);
+	if (p_madw == NULL)
+		return IB_INSUFFICIENT_MEMORY;
+
+	port_counter_ext = (ib_port_counters_ext_t *) & pm_mad->data;
+	memset(port_counter_ext, 0, sizeof(*port_counter_ext));
+	port_counter_ext->port_select = port;
+	port_counter_ext->counter_select = cl_hton16(0xFF);
+
+	status = perfmgr_send_mad(perfmgr, p_madw);
+
+	OSM_LOG_EXIT(perfmgr->log);
+	return status;
+}
+
+/**********************************************************************
  * query the Port Counters of all the nodes in the subnet.
  **********************************************************************/
 static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
@@ -641,6 +686,27 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 					PRIx64 " port %d (%s)\n",
 					node->node_info.node_guid, port,
 					node->print_desc);
+
+			if (pce_supported(mon_node, port)) {
+
+#if ENABLE_OSM_PERF_MGR_PROFILE
+			gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
+#endif
+				status = perfmgr_send_pce_mad(pm, lid, remote_qp,
+							      mon_node->port[port].pkey_ix,
+							      port,
+							      IB_MAD_METHOD_GET,
+							      &mad_context);
+				if (status != IB_SUCCESS)
+					OSM_LOG(pm->log, OSM_LOG_ERROR,
+						"ERR 4C17: Failed to issue "
+						"port counter query for "
+						"node 0x%" PRIx64 " port "
+						"%d (%s)\n",
+						node->node_info.node_guid,
+						port,
+						node->print_desc);
+			}
 		}
 	}
 Exit:
@@ -980,11 +1046,9 @@ void osm_perfmgr_destroy(osm_perfmgr_t * pm)
  **********************************************************************/
 static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 				    monitored_node_t * mon_node, uint8_t port,
-				    perfmgr_db_err_reading_t * cr,
-				    perfmgr_db_data_cnt_reading_t * dc)
+				    perfmgr_db_err_reading_t * cr)
 {
 	perfmgr_db_err_reading_t prev_err;
-	perfmgr_db_data_cnt_reading_t prev_dc;
 
 	if (perfmgr_db_get_prev_err(pm->db, mon_node->guid, port, &prev_err)
 	    != PERFMGR_EVENT_DB_SUCCESS) {
@@ -1012,31 +1076,11 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 			mon_node->name, mon_node->guid, port);
 		perfmgr_db_clear_prev_err(pm->db, mon_node->guid, port);
 	}
-
-	/* FIXME handle extended counters */
-	if (perfmgr_db_get_prev_dc(pm->db, mon_node->guid, port, &prev_dc)
-	    != PERFMGR_EVENT_DB_SUCCESS) {
-		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-			"Failed to find previous data count "
-			"reading for %s (0x%" PRIx64 ") port %u\n",
-			mon_node->name, mon_node->guid, port);
-		return;
-	}
-
-	if (dc->xmit_data < prev_dc.xmit_data ||
-	    dc->rcv_data < prev_dc.rcv_data ||
-	    dc->xmit_pkts < prev_dc.xmit_pkts ||
-	    dc->rcv_pkts < prev_dc.rcv_pkts) {
-		OSM_LOG(pm->log, OSM_LOG_ERROR,
-			"PerfMgr: ERR 4C0B: Detected an out of band data counter "
-			"clear on node %s (0x%" PRIx64 ") port %u\n",
-			mon_node->name, mon_node->guid, port);
-		perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
-	}
 }
 
 /**********************************************************************
  * Return 1 if the value is "close" to overflowing
+ * "close" is defined at 25% for now
  **********************************************************************/
 static int counter_overflow_4(uint8_t val)
 {
@@ -1058,6 +1102,11 @@ static int counter_overflow_32(ib_net32_t val)
 	return (cl_ntoh32(val) >= (UINT32_MAX - (UINT32_MAX / 4)));
 }
 
+static int counter_overflow_64(ib_net64_t val)
+{
+	return (cl_ntoh64(val) >= (UINT64_MAX - (UINT64_MAX / 4)));
+}
+
 /**********************************************************************
  * Check if the port counters have overflowed and if so issue a clear
  * MAD to the port.
@@ -1084,10 +1133,11 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 	    counter_overflow_4(PC_LINK_INT(pc->link_int_buffer_overrun)) ||
 	    counter_overflow_4(PC_BUF_OVERRUN(pc->link_int_buffer_overrun)) ||
 	    counter_overflow_16(pc->vl15_dropped) ||
-	    counter_overflow_32(pc->xmit_data) ||
-	    counter_overflow_32(pc->rcv_data) ||
-	    counter_overflow_32(pc->xmit_pkts) ||
-	    counter_overflow_32(pc->rcv_pkts)) {
+	    (!pce_supported(mon_node, port) &&
+			(counter_overflow_32(pc->xmit_data) ||
+			 counter_overflow_32(pc->rcv_data) ||
+			 counter_overflow_32(pc->xmit_pkts) ||
+			 counter_overflow_32(pc->rcv_pkts)))) {
 		osm_node_t *p_node = NULL;
 		ib_net16_t lid = 0;
 
@@ -1128,6 +1178,77 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 				mon_node->name, mon_node->guid, port);
 
 		perfmgr_db_clear_prev_err(pm->db, mon_node->guid, port);
+		if (!pce_supported(mon_node, port))
+			perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
+	}
+
+Exit:
+	OSM_LOG_EXIT(pm->log);
+}
+
+/**********************************************************************
+ * Check if the port counters have overflowed and if so issue a clear
+ * MAD to the port.
+ **********************************************************************/
+static void perfmgr_check_pce_overflow(osm_perfmgr_t * pm,
+				       monitored_node_t * mon_node,
+				       int16_t pkey_ix,
+				       uint8_t port,
+				       ib_port_counters_ext_t * pc)
+{
+	osm_madw_context_t mad_context;
+	ib_api_status_t status;
+	ib_net32_t remote_qp;
+
+	OSM_LOG_ENTER(pm->log);
+
+	if (counter_overflow_64(pc->xmit_data) ||
+	    counter_overflow_64(pc->rcv_data) ||
+	    counter_overflow_64(pc->xmit_pkts) ||
+	    counter_overflow_64(pc->rcv_pkts) ||
+	    counter_overflow_64(pc->unicast_xmit_pkts) ||
+	    counter_overflow_64(pc->unicast_rcv_pkts) ||
+	    counter_overflow_64(pc->multicast_xmit_pkts) ||
+	    counter_overflow_64(pc->multicast_rcv_pkts)) {
+		osm_node_t *p_node = NULL;
+		ib_net16_t lid = 0;
+
+		if (!mon_node->port[port].valid)
+			goto Exit;
+
+		osm_log(pm->log, OSM_LOG_VERBOSE,
+			"PerfMgr: PortCountersExtended overflow: %s (0x%"
+			PRIx64 ") port %d; clearing counters\n",
+			mon_node->name, mon_node->guid, port);
+
+		cl_plock_acquire(&pm->osm->lock);
+		p_node =
+		    osm_get_node_by_guid(pm->subn, cl_hton64(mon_node->guid));
+		lid = get_lid(p_node, port, mon_node);
+		cl_plock_release(&pm->osm->lock);
+		if (lid == 0) {
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C18: "
+				"Failed to clear counters for %s (0x%"
+				PRIx64 ") port %d; failed to get lid\n",
+				mon_node->name, mon_node->guid, port);
+			goto Exit;
+		}
+
+		remote_qp = get_qp(NULL, port);
+
+		mad_context.perfmgr_context.node_guid = mon_node->guid;
+		mad_context.perfmgr_context.port = port;
+		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_SET;
+		/* clear port counters */
+		status = perfmgr_send_pce_mad(pm, lid, remote_qp, pkey_ix,
+					      port, IB_MAD_METHOD_SET,
+					      &mad_context);
+		if (status != IB_SUCCESS)
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C19: "
+				"Failed to send clear counters MAD for %s (0x%"
+				PRIx64 ") port %d\n",
+				mon_node->name, mon_node->guid, port);
+
 		perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
 	}
 
@@ -1327,6 +1448,47 @@ static void handle_redirect(osm_perfmgr_t *pm,
 }
 
 /**********************************************************************
+ * Detect if someone else on the network could have cleared the counters
+ * without us knowing.  This is easy to detect because the counters never
+ * wrap but are "sticky"  PortCountersExtended version.
+ *
+ * The one time this will not work is if the port is getting errors fast
+ * enough to have the reading overtake the previous reading.  In this case,
+ * counters will be missed.
+ **********************************************************************/
+static void perfmgr_check_data_cnt_oob_clear(osm_perfmgr_t * pm,
+					monitored_node_t * mon_node,
+					uint8_t port,
+					perfmgr_db_data_cnt_reading_t * dc)
+{
+	perfmgr_db_data_cnt_reading_t prev_dc;
+
+	if (perfmgr_db_get_prev_dc(pm->db, mon_node->guid, port, &prev_dc)
+	    != PERFMGR_EVENT_DB_SUCCESS) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+			"Failed to find previous data count "
+			"reading for %s (0x%" PRIx64 ") port %u\n",
+			mon_node->name, mon_node->guid, port);
+		return;
+	}
+
+	if (dc->xmit_data < prev_dc.xmit_data ||
+	    dc->rcv_data < prev_dc.rcv_data ||
+	    dc->xmit_pkts < prev_dc.xmit_pkts ||
+	    dc->rcv_pkts < prev_dc.rcv_pkts ||
+	    dc->unicast_xmit_pkts < prev_dc.unicast_xmit_pkts ||
+	    dc->unicast_rcv_pkts < prev_dc.unicast_rcv_pkts ||
+	    dc->multicast_xmit_pkts < prev_dc.multicast_xmit_pkts ||
+	    dc->multicast_rcv_pkts < prev_dc.multicast_rcv_pkts) {
+		OSM_LOG(pm->log, OSM_LOG_ERROR,
+			"PerfMgr: ERR 4C0B: Detected an out of band data counter "
+			"clear on node %s (0x%" PRIx64 ") port %u\n",
+			mon_node->name, mon_node->guid, port);
+		perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
+	}
+}
+
+/**********************************************************************
  * The dispatcher uses a thread pool which will call this function when
  * there is a thread available to process the mad received on the wire.
  **********************************************************************/
@@ -1335,8 +1497,6 @@ static void pc_recv_process(void *context, void *data)
 	osm_perfmgr_t *pm = context;
 	osm_madw_t *p_madw = data;
 	osm_madw_context_t *mad_context = &p_madw->context;
-	ib_port_counters_t *wire_read =
-	    (ib_port_counters_t *) & osm_madw_get_perfmgt_mad_ptr(p_madw)->data;
 	ib_mad_t *p_mad = osm_madw_get_mad_ptr(p_madw);
 	uint64_t node_guid = mad_context->perfmgr_context.node_guid;
 	uint8_t port = mad_context->perfmgr_context.port;
@@ -1365,6 +1525,7 @@ static void pc_recv_process(void *context, void *data)
 		PRIx64 " port %u\n", p_mad->status, node_guid, port);
 
 	CL_ASSERT(p_mad->attr_id == IB_MAD_ATTR_PORT_CNTRS ||
+		  p_mad->attr_id == IB_MAD_ATTR_PORT_CNTRS_EXT ||
 		  p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO);
 
 	/* capture CLASS_PORT_INFO data */
@@ -1404,32 +1565,70 @@ static void pc_recv_process(void *context, void *data)
 		goto Exit;
 	}
 
-	perfmgr_db_fill_err_read(wire_read, &err_reading);
-	/* FIXME separate query for extended counters if they are supported
-	 * on the port.
-	 */
-	perfmgr_db_fill_data_cnt_read_pc(wire_read, &data_reading);
+	if (p_mad->attr_id == IB_MAD_ATTR_PORT_CNTRS_EXT) {
+		ib_port_counters_ext_t *ext_wire_read =
+				(ib_port_counters_ext_t *)
+				&osm_madw_get_perfmgt_mad_ptr(p_madw)->data;
+
+		/* convert wire data to perfmgr data counter reading */
+		perfmgr_db_fill_data_cnt_read_pce(ext_wire_read, &data_reading);
+
+		/* detect an out of band clear on the port */
+		if (mad_context->perfmgr_context.mad_method !=
+		    IB_MAD_METHOD_SET)
+			perfmgr_check_data_cnt_oob_clear(pm, p_mon_node, port,
+						    &data_reading);
+
+		/* add counter */
+		if (mad_context->perfmgr_context.mad_method
+		    == IB_MAD_METHOD_GET) {
+			perfmgr_db_add_dc_reading(pm->db, node_guid, port,
+						  &data_reading);
+		} else {
+			perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
+		}
 
-	/* log any critical events from this reading */
-	perfmgr_log_events(pm, p_mon_node, port, &err_reading);
+		/* check overflow */
+		perfmgr_check_pce_overflow(pm, p_mon_node,
+					   p_mon_node->port[port].pkey_ix,
+					   port, ext_wire_read);
+	} else {
+		boolean_t pce_sup = pce_supported(p_mon_node, port);
+		ib_port_counters_t *wire_read =
+				(ib_port_counters_t *)
+				&osm_madw_get_perfmgt_mad_ptr(p_madw)->data;
+
+		perfmgr_db_fill_err_read(wire_read, &err_reading);
+		if (!pce_sup)
+			perfmgr_db_fill_data_cnt_read_pc(wire_read, &data_reading);
+
+		/* detect an out of band clear on the port */
+		if (mad_context->perfmgr_context.mad_method != IB_MAD_METHOD_SET) {
+			perfmgr_check_oob_clear(pm, p_mon_node, port, &err_reading);
+			if (!pce_sup)
+				perfmgr_check_data_cnt_oob_clear(pm, p_mon_node, port,
+							    &data_reading);
+		}
 
-	/* detect an out of band clear on the port */
-	if (mad_context->perfmgr_context.mad_method != IB_MAD_METHOD_SET)
-		perfmgr_check_oob_clear(pm, p_mon_node, port, &err_reading,
-					&data_reading);
+		/* log any critical events from this reading */
+		perfmgr_log_events(pm, p_mon_node, port, &err_reading);
 
-	if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
-		perfmgr_db_add_err_reading(pm->db, node_guid, port,
-					   &err_reading);
-		perfmgr_db_add_dc_reading(pm->db, node_guid, port,
-					  &data_reading);
-	} else {
-		perfmgr_db_clear_prev_err(pm->db, node_guid, port);
-		perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
-	}
+		if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
+			perfmgr_db_add_err_reading(pm->db, node_guid, port,
+						   &err_reading);
+			if (!pce_sup)
+				perfmgr_db_add_dc_reading(pm->db, node_guid, port,
+							  &data_reading);
+		} else {
+			perfmgr_db_clear_prev_err(pm->db, node_guid, port);
+			if (!pce_sup)
+				perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
+		}
 
-	perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
-			       port, wire_read);
+		perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
+				       port, wire_read);
+
+	}
 
 #if ENABLE_OSM_PERF_MGR_PROFILE
 	do {
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index f51b4ca..7a96d41 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -801,7 +801,7 @@ perfmgr_db_fill_data_cnt_read_pc(ib_port_counters_t * wire_read,
 }
 
 void
-perfmgr_db_fill_data_cnt_read_epc(ib_port_counters_ext_t * wire_read,
+perfmgr_db_fill_data_cnt_read_pce(ib_port_counters_ext_t * wire_read,
 				  perfmgr_db_data_cnt_reading_t * reading)
 {
 	reading->xmit_data = cl_ntoh64(wire_read->xmit_data);
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
