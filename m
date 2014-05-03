From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3 opensm] perfmgr: Add xmit_wait support
Date: Sat, 03 May 2014 01:40:36 -0400
Message-ID: <53648154.9070003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>, Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Sat, 5 Apr 2014 11:41:12 -0400

xmit_waits can be prevalent in an oversubscribed or otherwise congested fabric.
Therefore 2 options are added to the config file to control the logging of
these errors.  Errors are always collected if support is indicated by
ClassPortInfo and can be seen within the console output of the perfmgr.

perfmgr_xmit_wait_log FALSE
perfmgr_xmit_wait_threshold 65535

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_perfmgr.h    |    3 ++
 include/opensm/osm_perfmgr_db.h |    4 ++-
 include/opensm/osm_subnet.h     |    2 +
 opensm/osm_perfmgr.c            |   56 +++++++++++++++++++++++++++++++++++---
 opensm/osm_perfmgr_db.c         |   27 ++++++++++++++++---
 opensm/osm_subnet.c             |   16 +++++++++-
 6 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 0304d9c..93e57a6 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -75,6 +75,7 @@ extern "C" {
 #define OSM_PERFMGR_DEFAULT_SWEEP_TIME_S 180
 #define OSM_PERFMGR_DEFAULT_DUMP_FILE "opensm_port_counters.log"
 #define OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES 500
+#define OSM_PERFMGR_DEFAULT_XMIT_WAIT_THRESHOLD 0x0000FFFF
 
 /****s* OpenSM: PerfMgr/osm_perfmgr_state_t */
 typedef enum {
@@ -150,6 +151,8 @@ typedef struct osm_perfmgr {
 	int16_t local_port;
 	int rm_nodes;
 	boolean_t query_cpi;
+	boolean_t xmit_wait_log;
+	uint32_t xmit_wait_threshold;
 } osm_perfmgr_t;
 /*
 * FIELDS
diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index ed14f76..25d9c58 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -90,6 +90,7 @@ typedef struct {
 	uint64_t link_integrity;
 	uint64_t buffer_overrun;
 	uint64_t vl15_dropped;
+	uint64_t xmit_wait;
 	time_t time;
 } perfmgr_db_err_reading_t;
 
@@ -205,7 +206,8 @@ void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp,
  */
 
 void perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
-			      perfmgr_db_err_reading_t * reading);
+			      perfmgr_db_err_reading_t * reading,
+			      boolean_t xmit_wait_sup);
 void perfmgr_db_fill_data_cnt_read_pc(ib_port_counters_t * wire_read,
 				      perfmgr_db_data_cnt_reading_t * reading);
 void perfmgr_db_fill_data_cnt_read_pce(ib_port_counters_ext_t * wire_read,
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 37e0fb3..a4ce2ed 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -363,6 +363,8 @@ typedef struct osm_subn_opt {
 	int perfmgr_rm_nodes;
 	boolean_t perfmgr_log_errors;
 	boolean_t perfmgr_query_cpi;
+	boolean_t perfmgr_xmit_wait_log;
+	uint32_t perfmgr_xmit_wait_threshold;
 #endif				/* ENABLE_OSM_PERF_MGR */
 	char *event_plugin_name;
 	char *event_plugin_options;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index bf2bfc9..7e837e6 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -465,6 +465,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 					   ib_net32_t dest_qp, uint16_t pkey_ix,
 					   uint8_t port, uint8_t mad_method,
 					   uint16_t counter_select,
+					   uint8_t counter_select2,
 					   osm_madw_context_t * p_context,
 					   uint8_t sl)
 {
@@ -486,6 +487,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 	memset(port_counter, 0, sizeof(*port_counter));
 	port_counter->port_select = port;
 	port_counter->counter_select = cl_hton16(counter_select);
+	port_counter->counter_select2 = counter_select2;
 
 	status = perfmgr_send_mad(perfmgr, p_madw);
 
@@ -594,6 +596,16 @@ static inline boolean_t pce_supported(monitored_node_t *mon_node, uint8_t port)
 }
 
 /**********************************************************************
+ * return if CapMask.PortCountersXmitWaitSupported is set
+ **********************************************************************/
+static inline boolean_t xmit_wait_supported(monitored_node_t *mon_node, uint8_t port)
+{
+	monitored_port_t *mon_port = &(mon_node->port[port]);
+	return (mon_port->cpi_valid
+		&& (mon_port->cap_mask & IB_PM_PC_XMIT_WAIT_SUP));
+}
+
+/**********************************************************************
  * return if "full" PortCountersExtended (IETF) is indicated
  **********************************************************************/
 static inline boolean_t ietf_supported(monitored_node_t *mon_node, uint8_t port)
@@ -734,6 +746,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 						     mon_node->port[port].pkey_ix,
 						     port, IB_MAD_METHOD_GET,
 						     0xffff,
+						     1,
 						     &mad_context,
 						     0); /* FIXME SL != 0 */
 			if (status != IB_SUCCESS)
@@ -1139,6 +1152,7 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 		"LI:   %"PRIu64" ?< %"PRIu64"\n"
 		"BO:   %"PRIu64" ?< %"PRIu64"\n"
 		"VL15: %"PRIu64" ?< %"PRIu64"\n"
+		"XW:   %"PRIu64" ?< %"PRIu64"\n"
 		,
 		mon_node->name, mon_node->guid, port,
 		cr->symbol_err_cnt, prev_err.symbol_err_cnt,
@@ -1152,7 +1166,8 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 		cr->rcv_constraint_err, prev_err.rcv_constraint_err,
 		cr->link_integrity, prev_err.link_integrity,
 		cr->buffer_overrun, prev_err.buffer_overrun,
-		cr->vl15_dropped, prev_err.vl15_dropped);
+		cr->vl15_dropped, prev_err.vl15_dropped,
+		cr->xmit_wait, prev_err.xmit_wait);
 
 	if (cr->symbol_err_cnt < prev_err.symbol_err_cnt ||
 	    cr->link_err_recover < prev_err.link_err_recover ||
@@ -1165,7 +1180,8 @@ static void perfmgr_check_oob_clear(osm_perfmgr_t * pm,
 	    cr->rcv_constraint_err < prev_err.rcv_constraint_err ||
 	    cr->link_integrity < prev_err.link_integrity ||
 	    cr->buffer_overrun < prev_err.buffer_overrun ||
-	    cr->vl15_dropped < prev_err.vl15_dropped) {
+	    cr->vl15_dropped < prev_err.vl15_dropped ||
+	    cr->xmit_wait < prev_err.xmit_wait) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 540A: "
 			"Detected an out of band error clear "
 			"on %s (0x%" PRIx64 ") port %u\n",
@@ -1209,12 +1225,14 @@ static int counter_overflow_64(ib_net64_t val)
  **********************************************************************/
 static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 				   monitored_node_t * mon_node, int16_t pkey_ix,
-				   uint8_t port, ib_port_counters_t * pc)
+				   uint8_t port, ib_port_counters_t * pc,
+				   boolean_t xmit_wait_sup)
 {
 	osm_madw_context_t mad_context;
 	ib_api_status_t status;
 	ib_net32_t remote_qp;
 	uint16_t counter_select;
+	uint8_t counter_select2;
 
 	OSM_LOG_ENTER(pm->log);
 
@@ -1230,6 +1248,7 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 	    counter_overflow_4(PC_LINK_INT(pc->link_int_buffer_overrun)) ||
 	    counter_overflow_4(PC_BUF_OVERRUN(pc->link_int_buffer_overrun)) ||
 	    counter_overflow_16(pc->vl15_dropped) ||
+	    (xmit_wait_sup && counter_overflow_32(pc->xmit_wait)) ||
 	    (!pce_supported(mon_node, port) &&
 	    (counter_overflow_32(pc->xmit_data) ||
 	     counter_overflow_32(pc->rcv_data) ||
@@ -1275,9 +1294,15 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 		else
 			counter_select = 0xffff;
 
+		if (xmit_wait_sup)
+			counter_select2 = 1;
+		else
+			counter_select2 = 0;
+
 		status = perfmgr_send_pc_mad(pm, lid, remote_qp, pkey_ix,
 					     port, IB_MAD_METHOD_SET,
 					     counter_select,
+					     counter_select2,
 					     &mad_context,
 					     0); /* FIXME SL != 0 */
 		if (status != IB_SUCCESS)
@@ -1377,6 +1402,7 @@ static void perfmgr_log_errors(osm_perfmgr_t * pm,
 	perfmgr_db_err_reading_t prev_read;
 	perfmgr_db_err_t err =
 	    perfmgr_db_get_prev_err(pm->db, mon_node->guid, port, &prev_read);
+	uint64_t cur, prev;
 
 	if (err != PERFMGR_EVENT_DB_SUCCESS) {
 		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Failed to find previous "
@@ -1406,6 +1432,15 @@ static void perfmgr_log_errors(osm_perfmgr_t * pm,
 	LOG_ERR_CNT("LocalLinkIntegrityErrors",     "543A", link_integrity);
 	LOG_ERR_CNT("ExcessiveBufferOverrunErrors", "543B", buffer_overrun);
 	LOG_ERR_CNT("VL15Dropped",                  "543C", vl15_dropped);
+
+	cur = reading->xmit_wait;
+	prev = prev_read.xmit_wait;
+	if (pm->xmit_wait_log && cur > prev &&
+	    (cur - prev) >= pm->xmit_wait_threshold) {
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 543D: XmitWait : %" PRIu64
+			" : node \"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u\n",
+			cur - prev, mon_node->name, mon_node->guid, port);
+	}
 }
 
 static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
@@ -1555,6 +1590,13 @@ static boolean_t handle_redirect(osm_perfmgr_t *pm,
 						0); /* FIXME SL != 0 */
 	} else {
 		/* reissue the original query to the redirected location */
+		uint8_t counter_select2;
+
+		if (xmit_wait_supported(p_mon_node, port))
+			counter_select2 = 1;
+		else
+			counter_select2 = 0;
+
 		mad_method = mad_context->perfmgr_context.mad_method;
 		if (mad_context->perfmgr_context.mad_attr_id
 		    == IB_MAD_ATTR_PORT_CNTRS) {
@@ -1562,6 +1604,7 @@ static boolean_t handle_redirect(osm_perfmgr_t *pm,
 						     pkey_ix, port,
 						     mad_method,
 						     0xffff,
+						     counter_select2,
 						     mad_context,
 						     0); /* FIXME SL != 0 */
 		} else {
@@ -1760,11 +1803,12 @@ static void pc_recv_process(void *context, void *data)
 					   port, ext_wire_read);
 	} else {
 		boolean_t pce_sup = pce_supported(p_mon_node, port);
+		boolean_t xmit_wait_sup = xmit_wait_supported(p_mon_node, port);
 		ib_port_counters_t *wire_read =
 				(ib_port_counters_t *)
 				&osm_madw_get_perfmgt_mad_ptr(p_madw)->data;
 
-		perfmgr_db_fill_err_read(wire_read, &err_reading);
+		perfmgr_db_fill_err_read(wire_read, &err_reading, xmit_wait_sup);
 		if (!pce_sup)
 			perfmgr_db_fill_data_cnt_read_pc(wire_read, &data_reading);
 
@@ -1791,7 +1835,7 @@ static void pc_recv_process(void *context, void *data)
 		}
 
 		perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
-				       port, wire_read);
+				       port, wire_read, xmit_wait_sup);
 
 	}
 
@@ -1868,6 +1912,8 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 
 	pm->rm_nodes = p_opt->perfmgr_rm_nodes;
 	pm->query_cpi = p_opt->perfmgr_query_cpi;
+	pm->xmit_wait_log = p_opt->perfmgr_xmit_wait_log;
+	pm->xmit_wait_threshold = p_opt->perfmgr_xmit_wait_threshold;
 	status = IB_SUCCESS;
 Exit:
 	OSM_LOG_EXIT(pm->log);
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 92e1a39..5b476bd 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -341,6 +341,10 @@ debug_dump_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port_num,
 		   "vld %" PRIu64 " <-- %" PRIu64 " (%" PRIu64 ")\n",
 		   cur->vl15_dropped, port->err_previous.vl15_dropped,
 		   port->err_total.vl15_dropped);
+	osm_log_v2(log, OSM_LOG_DEBUG, FILE_ID,
+		   "xw %" PRIu64 " <-- %" PRIu64 " (%" PRIu64 ")\n",
+		   cur->xmit_wait, port->err_previous.xmit_wait,
+		   port->err_total.xmit_wait);
 }
 
 /**********************************************************************
@@ -355,6 +359,7 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	perfmgr_db_err_reading_t *previous = NULL;
 	perfmgr_db_err_t rc = PERFMGR_EVENT_DB_SUCCESS;
 	osm_epi_pe_event_t epi_pe_data;
+	uint64_t xmit_wait_diff;
 
 	cl_plock_excl_acquire(&db->lock);
 	node = get(db, guid);
@@ -410,6 +415,9 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	epi_pe_data.vl15_dropped =
 	    (reading->vl15_dropped - previous->vl15_dropped);
 	p_port->err_total.vl15_dropped += epi_pe_data.vl15_dropped;
+	xmit_wait_diff =
+	    (reading->xmit_wait - previous->xmit_wait);
+	p_port->err_total.xmit_wait += xmit_wait_diff;
 
 	p_port->err_previous = *reading;
 
@@ -662,7 +670,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 		"%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
-		"%s\t%s\t%s\t%s\n",
+		"%s\t%s\t%s\t%s\t%s\n",
 		"symbol_err_cnt",
 		"link_err_recover",
 		"link_downed",
@@ -675,6 +683,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 		"link_int_err",
 		"buf_overrun_err",
 		"vl15_dropped",
+		"xmit_wait",
 		"xmit_data",
 		"rcv_data",
 		"xmit_pkts",
@@ -704,7 +713,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 			"%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64 "\t%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64 "\t%" PRIu64
-			"\t%" PRIu64 "\t%" PRIu64 "\n", node->node_name,
+			"\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", node->node_name,
 			node->node_guid,
 			node->active ? "TRUE" : "FALSE",
 			i, last_reset, last_err_update, last_data_update,
@@ -720,6 +729,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 			node->ports[i].err_total.link_integrity,
 			node->ports[i].err_total.buffer_overrun,
 			node->ports[i].err_total.vl15_dropped,
+			node->ports[i].err_total.xmit_wait,
 			node->ports[i].dc_total.xmit_data,
 			node->ports[i].dc_total.rcv_data,
 			node->ports[i].dc_total.xmit_pkts,
@@ -827,7 +837,8 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 		    && err->rcv_constraint_err == 0
 		    && err->link_integrity == 0
 		    && err->buffer_overrun == 0
-		    && err->vl15_dropped == 0)
+		    && err->vl15_dropped == 0
+		    && err->xmit_wait == 0)
 			continue;
 
 		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d\n"
@@ -873,6 +884,9 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 		if (!err_only || err->vl15_dropped != 0)
 			fprintf(fp, "     vl15_dropped         : %" PRIu64 "\n",
 				err->vl15_dropped);
+		if (!err_only || err->xmit_wait != 0)
+			fprintf(fp, "     xmit_wait            : %" PRIu64 "\n",
+				err->xmit_wait);
 
 		if (err_only)
 			continue;
@@ -1022,7 +1036,8 @@ perfmgr_db_dump(perfmgr_db_t * db, char *file, perfmgr_db_dump_t dump_type)
  **********************************************************************/
 void
 perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
-			 perfmgr_db_err_reading_t * reading)
+			 perfmgr_db_err_reading_t * reading,
+			 boolean_t xmit_wait_sup)
 {
 	reading->symbol_err_cnt = cl_ntoh16(wire_read->symbol_err_cnt);
 	reading->link_err_recover = wire_read->link_err_recover;
@@ -1039,6 +1054,10 @@ perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
 	reading->buffer_overrun =
 	    PC_BUF_OVERRUN(wire_read->link_int_buffer_overrun);
 	reading->vl15_dropped = cl_ntoh16(wire_read->vl15_dropped);
+	if (xmit_wait_sup)
+		reading->xmit_wait = cl_ntoh32(wire_read->xmit_wait);
+	else
+		reading->xmit_wait = 0;
 	reading->time = time(NULL);
 }
 
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index a1c7648..f30d852 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -854,6 +854,8 @@ static const opt_rec_t opt_tbl[] = {
 	{ "perfmgr_rm_nodes", OPT_OFFSET(perfmgr_rm_nodes), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_log_errors", OPT_OFFSET(perfmgr_log_errors), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_query_cpi", OPT_OFFSET(perfmgr_query_cpi), opts_parse_boolean, NULL, 0 },
+	{ "perfmgr_xmit_wait_log", OPT_OFFSET(perfmgr_xmit_wait_log), opts_parse_boolean, NULL, 0 },
+	{ "perfmgr_xmit_wait_threshold", OPT_OFFSET(perfmgr_xmit_wait_threshold), opts_parse_uint32, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
 	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
@@ -1563,6 +1565,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->perfmgr_rm_nodes = TRUE;
 	p_opt->perfmgr_log_errors = TRUE;
 	p_opt->perfmgr_query_cpi = FALSE;
+	p_opt->perfmgr_xmit_wait_log = FALSE;
+	p_opt->perfmgr_xmit_wait_threshold = OSM_PERFMGR_DEFAULT_XMIT_WAIT_THRESHOLD;
 #endif				/* ENABLE_OSM_PERF_MGR */
 
 	p_opt->event_plugin_name = NULL;
@@ -2637,7 +2641,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Log error counters to opensm.log\n"
 		"perfmgr_log_errors %s\n\n"
 		"# Query PerfMgrGet(ClassPortInfo) for extended capabilities\n"
-		"perfmgr_query_cpi %s\n\n",
+		"perfmgr_query_cpi %s\n\n"
+		"# Log xmit_wait errors\n"
+		"perfmgr_xmit_wait_log %s\n\n"
+		"# If logging xmit_wait's; set threshold (default %u)\n"
+		"perfmgr_xmit_wait_threshold %u\n\n"
+		,
 		p_opts->perfmgr ? "TRUE" : "FALSE",
 		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
 		p_opts->perfmgr_sweep_time_s,
@@ -2645,7 +2654,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE",
 		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE",
 		p_opts->perfmgr_log_errors ? "TRUE" : "FALSE",
-		p_opts->perfmgr_query_cpi ? "TRUE" : "FALSE");
+		p_opts->perfmgr_query_cpi ? "TRUE" : "FALSE",
+		p_opts->perfmgr_xmit_wait_log ? "TRUE" : "FALSE",
+		OSM_PERFMGR_DEFAULT_XMIT_WAIT_THRESHOLD,
+		p_opts->perfmgr_xmit_wait_threshold);
 
 	fprintf(out,
 		"#\n# Event DB Options\n#\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
