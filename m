From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 05/06] opensm/perfmgr: don't clear data counters in
 PortCounters when ExtendedPortCounters is supported
Date: Thu, 21 Feb 2013 13:33:52 -0800
Message-ID: <20130221133352.c74b33ebbf372984578aed72@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Some hardware apparently clears the data counters of ExtendedPortCounters when
the PortCounters data counters are cleared.  (Must be using the same hardware
registers.)

Therefore, when ExtendedPortCounters is supported on a port; alter the counter
select of PortCounters to exclude the data counters when clearing.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |   88 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 65886f7..eb0c4f9 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -450,6 +450,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 					   ib_net16_t dest_lid,
 					   ib_net32_t dest_qp, uint16_t pkey_ix,
 					   uint8_t port, uint8_t mad_method,
+					   uint16_t counter_select,
 					   osm_madw_context_t * p_context,
 					   uint8_t sl)
 {
@@ -469,7 +470,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 	port_counter = (ib_port_counters_t *) & pm_mad->data;
 	memset(port_counter, 0, sizeof(*port_counter));
 	port_counter->port_select = port;
-	port_counter->counter_select = 0xFFFF;
+	port_counter->counter_select = cl_hton16(counter_select);
 
 	status = perfmgr_send_mad(perfmgr, p_madw);
 
@@ -613,7 +614,7 @@ static ib_api_status_t perfmgr_send_pce_mad(osm_perfmgr_t * perfmgr,
 	port_counter_ext = (ib_port_counters_ext_t *) & pm_mad->data;
 	memset(port_counter_ext, 0, sizeof(*port_counter_ext));
 	port_counter_ext->port_select = port;
-	port_counter_ext->counter_select = cl_hton16(0xFF);
+	port_counter_ext->counter_select = cl_hton16(0x00FF);
 
 	status = perfmgr_send_mad(perfmgr, p_madw);
 
@@ -715,6 +716,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 			status = perfmgr_send_pc_mad(pm, lid, remote_qp,
 						     mon_node->port[port].pkey_ix,
 						     port, IB_MAD_METHOD_GET,
+						     0xffff,
 						     &mad_context,
 						     0); /* FIXME SL != 0 */
 			if (status != IB_SUCCESS)
@@ -1098,6 +1100,35 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 		return;
 	}
 
+	OSM_LOG(pm->log, OSM_LOG_DEBUG,
+		"Errors vs previous node %s (0x%" PRIx64 ") port %u\n"
+		"SE:   %"PRIu64" ?< %"PRIu64"\n"
+		"LE:   %"PRIu64" ?< %"PRIu64"\n"
+		"LD:   %"PRIu64" ?< %"PRIu64"\n"
+		"RE:   %"PRIu64" ?< %"PRIu64"\n"
+		"RPE:  %"PRIu64" ?< %"PRIu64"\n"
+		"SRE:  %"PRIu64" ?< %"PRIu64"\n"
+		"XD:   %"PRIu64" ?< %"PRIu64"\n"
+		"XCE:  %"PRIu64" ?< %"PRIu64"\n"
+		"RCE:  %"PRIu64" ?< %"PRIu64"\n"
+		"LI:   %"PRIu64" ?< %"PRIu64"\n"
+		"BO:   %"PRIu64" ?< %"PRIu64"\n"
+		"VL15: %"PRIu64" ?< %"PRIu64"\n"
+		,
+		mon_node->name, mon_node->guid, port,
+		cr->symbol_err_cnt, prev_err.symbol_err_cnt,
+		cr->link_err_recover, prev_err.link_err_recover,
+		cr->link_downed, prev_err.link_downed,
+		cr->rcv_err, prev_err.rcv_err,
+		cr->rcv_rem_phys_err, prev_err.rcv_rem_phys_err,
+		cr->rcv_switch_relay_err, prev_err.rcv_switch_relay_err,
+		cr->xmit_discards, prev_err.xmit_discards,
+		cr->xmit_constraint_err, prev_err.xmit_constraint_err,
+		cr->rcv_constraint_err, prev_err.rcv_constraint_err,
+		cr->link_integrity, prev_err.link_integrity,
+		cr->buffer_overrun, prev_err.buffer_overrun,
+		cr->vl15_dropped, prev_err.vl15_dropped);
+
 	if (cr->symbol_err_cnt < prev_err.symbol_err_cnt ||
 	    cr->link_err_recover < prev_err.link_err_recover ||
 	    cr->link_downed < prev_err.link_downed ||
@@ -1158,6 +1189,7 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 	osm_madw_context_t mad_context;
 	ib_api_status_t status;
 	ib_net32_t remote_qp;
+	uint16_t counter_select;
 
 	OSM_LOG_ENTER(pm->log);
 
@@ -1207,9 +1239,20 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 		mad_context.perfmgr_context.node_guid = mon_node->guid;
 		mad_context.perfmgr_context.port = port;
 		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_SET;
-		/* clear port counters */
+
+		/* apparently some HW uses the same counters for the 32 and 64
+		 * bit versions and a clear of them in the PortCounters
+		 * attribute also clears the ExtendedPortCounters equivalant
+		 * counters
+		 */
+		if (pce_supported(mon_node, port))
+			counter_select = 0x0fff;
+		else
+			counter_select = 0xffff;
+
 		status = perfmgr_send_pc_mad(pm, lid, remote_qp, pkey_ix,
 					     port, IB_MAD_METHOD_SET,
+					     counter_select,
 					     &mad_context,
 					     0); /* FIXME SL != 0 */
 		if (status != IB_SUCCESS)
@@ -1513,6 +1556,27 @@ static void perfmgr_check_data_cnt_oob_clear(osm_perfmgr_t * pm,
 		return;
 	}
 
+	OSM_LOG(pm->log, OSM_LOG_DEBUG,
+		"Data vs previous node %s (0x%" PRIx64 ") port %u\n"
+		"TX:    %"PRIu64" ?< %"PRIu64"\n"
+		"RX:    %"PRIu64" ?< %"PRIu64"\n"
+		"TXP:   %"PRIu64" ?< %"PRIu64"\n"
+		"RXP:   %"PRIu64" ?< %"PRIu64"\n"
+		"UTXP:  %"PRIu64" ?< %"PRIu64"\n"
+		"URXP:  %"PRIu64" ?< %"PRIu64"\n"
+		"MTXP:  %"PRIu64" ?< %"PRIu64"\n"
+		"MRXP:  %"PRIu64" ?< %"PRIu64"\n"
+		,
+		mon_node->name, mon_node->guid, port,
+		dc->xmit_data, prev_dc.xmit_data,
+		dc->rcv_data, prev_dc.rcv_data,
+		dc->xmit_pkts, prev_dc.xmit_pkts,
+		dc->rcv_pkts, prev_dc.rcv_pkts,
+		dc->unicast_xmit_pkts, prev_dc.unicast_xmit_pkts,
+		dc->unicast_rcv_pkts, prev_dc.unicast_rcv_pkts,
+		dc->multicast_xmit_pkts, prev_dc.multicast_xmit_pkts,
+		dc->multicast_rcv_pkts, prev_dc.multicast_rcv_pkts);
+
 	if (dc->xmit_data < prev_dc.xmit_data ||
 	    dc->rcv_data < prev_dc.rcv_data ||
 	    dc->xmit_pkts < prev_dc.xmit_pkts ||
@@ -1526,6 +1590,7 @@ static void perfmgr_check_data_cnt_oob_clear(osm_perfmgr_t * pm,
 			"PerfMgr: ERR 540B: Detected an out of band data counter "
 			"clear on node %s (0x%" PRIx64 ") port %u\n",
 			mon_node->name, mon_node->guid, port);
+
 		perfmgr_db_clear_prev_dc(pm->db, mon_node->guid, port);
 	}
 }
@@ -1617,15 +1682,13 @@ static void pc_recv_process(void *context, void *data)
 						  ietf_supported(p_mon_node,
 								 port));
 
-		/* detect an out of band clear on the port */
-		if (mad_context->perfmgr_context.mad_method !=
-		    IB_MAD_METHOD_SET)
-			perfmgr_check_data_cnt_oob_clear(pm, p_mon_node, port,
-						    &data_reading);
-
 		/* add counter */
 		if (mad_context->perfmgr_context.mad_method
 		    == IB_MAD_METHOD_GET) {
+			/* detect an out of band clear on the port */
+			perfmgr_check_data_cnt_oob_clear(pm, p_mon_node, port,
+						    &data_reading);
+
 			perfmgr_db_add_dc_reading(pm->db, node_guid, port,
 						  &data_reading,
 						  ietf_supported(p_mon_node,
@@ -1634,7 +1697,6 @@ static void pc_recv_process(void *context, void *data)
 			perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
 		}
 
-		/* check overflow */
 		perfmgr_check_pce_overflow(pm, p_mon_node,
 					   p_mon_node->port[port].pkey_ix,
 					   port, ext_wire_read);
@@ -1648,15 +1710,13 @@ static void pc_recv_process(void *context, void *data)
 		if (!pce_sup)
 			perfmgr_db_fill_data_cnt_read_pc(wire_read, &data_reading);
 
-		/* detect an out of band clear on the port */
-		if (mad_context->perfmgr_context.mad_method != IB_MAD_METHOD_SET) {
+		if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
+			/* detect an out of band clear on the port */
 			perfmgr_check_oob_clear(pm, p_mon_node, port, &err_reading);
 			if (!pce_sup)
 				perfmgr_check_data_cnt_oob_clear(pm, p_mon_node, port,
 							    &data_reading);
-		}
 
-		if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
 			/* log errors from this reading */
 			if (pm->subn->opt.perfmgr_log_errors)
 				perfmgr_log_errors(pm, p_mon_node, port, &err_reading);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
