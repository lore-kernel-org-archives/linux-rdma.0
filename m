From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 04/07] opensm/perfmgr; add support for
 PortCountersExtended NOIETF
Date: Thu, 28 Feb 2013 17:08:07 -0800
Message-ID: <20130228170807.c4b7413b81b9d166aa32e816@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rebased for new series

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr_db.h |    6 +++-
 opensm/osm_perfmgr.c            |   35 +++++++++++++++++++++-------
 opensm/osm_perfmgr_db.c         |   47 +++++++++++++++++++++++---------------
 3 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index ada6765..ed14f76 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -179,7 +179,8 @@ perfmgr_db_err_t perfmgr_db_clear_prev_err(perfmgr_db_t * db, uint64_t guid,
 perfmgr_db_err_t perfmgr_db_add_dc_reading(perfmgr_db_t * db, uint64_t guid,
 					   uint8_t port,
 					   perfmgr_db_data_cnt_reading_t *
-					   reading);
+					   reading,
+					   int ietf_sup);
 perfmgr_db_err_t perfmgr_db_get_prev_dc(perfmgr_db_t * db, uint64_t guid,
 					uint8_t port,
 					perfmgr_db_data_cnt_reading_t *
@@ -208,7 +209,8 @@ void perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
 void perfmgr_db_fill_data_cnt_read_pc(ib_port_counters_t * wire_read,
 				      perfmgr_db_data_cnt_reading_t * reading);
 void perfmgr_db_fill_data_cnt_read_pce(ib_port_counters_ext_t * wire_read,
-				       perfmgr_db_data_cnt_reading_t * reading);
+				       perfmgr_db_data_cnt_reading_t * reading,
+				       int ietf_sup);
 
 END_C_DECLS
 
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index a06f8bc..8e74256 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -569,9 +569,20 @@ static ib_api_status_t perfmgr_send_cpi_mad(osm_perfmgr_t * pm,
 }
 
 /**********************************************************************
- * return if PortCountersExtended are supported.
+ * return if some form of PortCountersExtended (PCE || PCE NoIETF) are supported.
  **********************************************************************/
-static boolean_t pce_supported(monitored_node_t *mon_node, uint8_t port)
+static inline boolean_t pce_supported(monitored_node_t *mon_node, uint8_t port)
+{
+	monitored_port_t *mon_port = &(mon_node->port[port]);
+	return (mon_port->cpi_valid
+		&& (mon_port->cap_mask & IB_PM_EXT_WIDTH_SUPPORTED
+		|| mon_port->cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP));
+}
+
+/**********************************************************************
+ * return if "full" PortCountersExtended (IETF) is indicated
+ **********************************************************************/
+static inline boolean_t ietf_supported(monitored_node_t *mon_node, uint8_t port)
 {
 	monitored_port_t *mon_port = &(mon_node->port[port]);
 	return (mon_port->cpi_valid
@@ -1242,10 +1253,11 @@ static void perfmgr_check_pce_overflow(osm_perfmgr_t * pm,
 	    counter_overflow_64(pc->rcv_data) ||
 	    counter_overflow_64(pc->xmit_pkts) ||
 	    counter_overflow_64(pc->rcv_pkts) ||
-	    counter_overflow_64(pc->unicast_xmit_pkts) ||
+	    (ietf_supported(mon_node, port) &&
+	    (counter_overflow_64(pc->unicast_xmit_pkts) ||
 	    counter_overflow_64(pc->unicast_rcv_pkts) ||
 	    counter_overflow_64(pc->multicast_xmit_pkts) ||
-	    counter_overflow_64(pc->multicast_rcv_pkts)) {
+	    counter_overflow_64(pc->multicast_rcv_pkts)))) {
 		osm_node_t *p_node = NULL;
 		ib_net16_t lid = 0;
 
@@ -1537,10 +1549,11 @@ static void perfmgr_check_data_cnt_oob_clear(osm_perfmgr_t * pm,
 	    dc->rcv_data < prev_dc.rcv_data ||
 	    dc->xmit_pkts < prev_dc.xmit_pkts ||
 	    dc->rcv_pkts < prev_dc.rcv_pkts ||
-	    dc->unicast_xmit_pkts < prev_dc.unicast_xmit_pkts ||
+	    (ietf_supported(mon_node, port) &&
+	    (dc->unicast_xmit_pkts < prev_dc.unicast_xmit_pkts ||
 	    dc->unicast_rcv_pkts < prev_dc.unicast_rcv_pkts ||
 	    dc->multicast_xmit_pkts < prev_dc.multicast_xmit_pkts ||
-	    dc->multicast_rcv_pkts < prev_dc.multicast_rcv_pkts) {
+	    dc->multicast_rcv_pkts < prev_dc.multicast_rcv_pkts))) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
 			"PerfMgr: ERR 540B: Detected an out of band data counter "
 			"clear on node %s (0x%" PRIx64 ") port %u\n",
@@ -1638,7 +1651,9 @@ static void pc_recv_process(void *context, void *data)
 				&osm_madw_get_perfmgt_mad_ptr(p_madw)->data;
 
 		/* convert wire data to perfmgr data counter reading */
-		perfmgr_db_fill_data_cnt_read_pce(ext_wire_read, &data_reading);
+		perfmgr_db_fill_data_cnt_read_pce(ext_wire_read, &data_reading,
+						  ietf_supported(p_mon_node,
+								 port));
 
 		/* detect an out of band clear on the port */
 		if (mad_context->perfmgr_context.mad_method !=
@@ -1650,7 +1665,9 @@ static void pc_recv_process(void *context, void *data)
 		if (mad_context->perfmgr_context.mad_method
 		    == IB_MAD_METHOD_GET) {
 			perfmgr_db_add_dc_reading(pm->db, node_guid, port,
-						  &data_reading);
+						  &data_reading,
+						  ietf_supported(p_mon_node,
+								 port));
 		} else {
 			perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
 		}
@@ -1686,7 +1703,7 @@ static void pc_recv_process(void *context, void *data)
 						   &err_reading);
 			if (!pce_sup)
 				perfmgr_db_add_dc_reading(pm->db, node_guid, port,
-							  &data_reading);
+							  &data_reading, 0);
 		} else {
 			perfmgr_db_clear_prev_err(pm->db, node_guid, port);
 			if (!pce_sup)
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index f8d0403..d17315f 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -495,7 +495,8 @@ debug_dump_dc_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port_num,
  **********************************************************************/
 perfmgr_db_err_t
 perfmgr_db_add_dc_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
-			  perfmgr_db_data_cnt_reading_t * reading)
+			  perfmgr_db_data_cnt_reading_t * reading,
+			  int ietf_sup)
 {
 	db_port_t *p_port = NULL;
 	db_node_t *node = NULL;
@@ -528,18 +529,22 @@ perfmgr_db_add_dc_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	p_port->dc_total.xmit_pkts += epi_dc_data.xmit_pkts;
 	epi_dc_data.rcv_pkts = reading->rcv_pkts - previous->rcv_pkts;
 	p_port->dc_total.rcv_pkts += epi_dc_data.rcv_pkts;
-	epi_dc_data.unicast_xmit_pkts =
-	    reading->unicast_xmit_pkts - previous->unicast_xmit_pkts;
-	p_port->dc_total.unicast_xmit_pkts += epi_dc_data.unicast_xmit_pkts;
-	epi_dc_data.unicast_rcv_pkts =
-	    reading->unicast_rcv_pkts - previous->unicast_rcv_pkts;
-	p_port->dc_total.unicast_rcv_pkts += epi_dc_data.unicast_rcv_pkts;
-	epi_dc_data.multicast_xmit_pkts =
-	    reading->multicast_xmit_pkts - previous->multicast_xmit_pkts;
-	p_port->dc_total.multicast_xmit_pkts += epi_dc_data.multicast_xmit_pkts;
-	epi_dc_data.multicast_rcv_pkts =
-	    reading->multicast_rcv_pkts - previous->multicast_rcv_pkts;
-	p_port->dc_total.multicast_rcv_pkts += epi_dc_data.multicast_rcv_pkts;
+
+	if (ietf_sup)
+	{
+		epi_dc_data.unicast_xmit_pkts =
+		    reading->unicast_xmit_pkts - previous->unicast_xmit_pkts;
+		p_port->dc_total.unicast_xmit_pkts += epi_dc_data.unicast_xmit_pkts;
+		epi_dc_data.unicast_rcv_pkts =
+		    reading->unicast_rcv_pkts - previous->unicast_rcv_pkts;
+		p_port->dc_total.unicast_rcv_pkts += epi_dc_data.unicast_rcv_pkts;
+		epi_dc_data.multicast_xmit_pkts =
+		    reading->multicast_xmit_pkts - previous->multicast_xmit_pkts;
+		p_port->dc_total.multicast_xmit_pkts += epi_dc_data.multicast_xmit_pkts;
+		epi_dc_data.multicast_rcv_pkts =
+		    reading->multicast_rcv_pkts - previous->multicast_rcv_pkts;
+		p_port->dc_total.multicast_rcv_pkts += epi_dc_data.multicast_rcv_pkts;
+	}
 
 	p_port->dc_previous = *reading;
 
@@ -1054,17 +1059,21 @@ perfmgr_db_fill_data_cnt_read_pc(ib_port_counters_t * wire_read,
 
 void
 perfmgr_db_fill_data_cnt_read_pce(ib_port_counters_ext_t * wire_read,
-				  perfmgr_db_data_cnt_reading_t * reading)
+				  perfmgr_db_data_cnt_reading_t * reading,
+				  int ietf_sup)
 {
 	reading->xmit_data = cl_ntoh64(wire_read->xmit_data);
 	reading->rcv_data = cl_ntoh64(wire_read->rcv_data);
 	reading->xmit_pkts = cl_ntoh64(wire_read->xmit_pkts);
 	reading->rcv_pkts = cl_ntoh64(wire_read->rcv_pkts);
-	reading->unicast_xmit_pkts = cl_ntoh64(wire_read->unicast_xmit_pkts);
-	reading->unicast_rcv_pkts = cl_ntoh64(wire_read->unicast_rcv_pkts);
-	reading->multicast_xmit_pkts =
-	    cl_ntoh64(wire_read->multicast_xmit_pkts);
-	reading->multicast_rcv_pkts = cl_ntoh64(wire_read->multicast_rcv_pkts);
+	if (ietf_sup)
+	{
+		reading->unicast_xmit_pkts = cl_ntoh64(wire_read->unicast_xmit_pkts);
+		reading->unicast_rcv_pkts = cl_ntoh64(wire_read->unicast_rcv_pkts);
+		reading->multicast_xmit_pkts =
+		    cl_ntoh64(wire_read->multicast_xmit_pkts);
+		reading->multicast_rcv_pkts = cl_ntoh64(wire_read->multicast_rcv_pkts);
+	}
 	reading->time = time(NULL);
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
