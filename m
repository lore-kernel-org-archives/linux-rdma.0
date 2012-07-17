From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] opensm/perfmgr: add logging of error counters
Date: Tue, 17 Jul 2012 11:40:41 -0700
Message-ID: <20120717114041.88bd67854d40f20cad3fe856@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

NOTE: the following applies after previous Performance Manager patches posted to the list.

The initial performance manager only logged Symbol Error, Receive errors, and
xmit discards.  Additional errors from PortCounters should be logged.

   - Change error codes to use 4C3X, allows future expansion
   - Add perfmgr_log_errors flag (default true), allows users to reduce log
     spamming if they are using an alternate method to collect perfmgr data.

Changes since V1:
	Add help message within generated opensm.conf

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_perfmgr.c        |   56 ++++++++++++++++++++----------------------
 opensm/osm_subnet.c         |    9 +++++-
 3 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 1067ece..2088929 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -360,6 +360,7 @@ typedef struct osm_subn_opt {
 	boolean_t perfmgr_ignore_cas;
 	char *event_db_dump_file;
 	int perfmgr_rm_nodes;
+	boolean_t perfmgr_log_errors;
 #endif				/* ENABLE_OSM_PERF_MGR */
 	char *event_plugin_name;
 	char *event_plugin_options;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index e47935a..3b36ef6 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1061,12 +1061,11 @@ Exit:
 /**********************************************************************
  * Check values for logging of errors
  **********************************************************************/
-static void perfmgr_log_events(osm_perfmgr_t * pm,
+static void perfmgr_log_errors(osm_perfmgr_t * pm,
 			       monitored_node_t * mon_node, uint8_t port,
 			       perfmgr_db_err_reading_t * reading)
 {
 	perfmgr_db_err_reading_t prev_read;
-	time_t time_diff = 0;
 	perfmgr_db_err_t err =
 	    perfmgr_db_get_prev_err(pm->db, mon_node->guid, port, &prev_read);
 
@@ -1076,30 +1075,28 @@ static void perfmgr_log_events(osm_perfmgr_t * pm,
 			mon_node->name, mon_node->guid, port);
 		return;
 	}
-	time_diff = (reading->time - prev_read.time);
-
-	/* FIXME these events should be defineable by the user in a config
-	 * file somewhere. */
-	if (reading->symbol_err_cnt > prev_read.symbol_err_cnt)
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C0D: "
-			"Found %" PRIu64 " Symbol errors in %lu sec on %s (0x%"
-			PRIx64 ") port %u\n",
-			reading->symbol_err_cnt - prev_read.symbol_err_cnt,
-			time_diff, mon_node->name, mon_node->guid, port);
-
-	if (reading->rcv_err > prev_read.rcv_err)
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C0E: "
-			"Found %" PRIu64
-			" Receive errors in %lu sec on %s (0x%" PRIx64
-			") port %u\n", reading->rcv_err - prev_read.rcv_err,
-			time_diff, mon_node->name, mon_node->guid, port);
-
-	if (reading->xmit_discards > prev_read.xmit_discards)
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C0F: "
-			"Found %" PRIu64 " Xmit Discards in %lu sec on %s (0x%"
-			PRIx64 ") port %u\n",
-			reading->xmit_discards - prev_read.xmit_discards,
-			time_diff, mon_node->name, mon_node->guid, port);
+
+#define LOG_ERR_CNT(errname, errnum, counter_name) \
+	if (reading->counter_name > prev_read.counter_name) \
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR %s: " \
+			"%s : %" PRIu64 " : node " \
+			"\"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u\n", \
+			errnum, errname, \
+			reading->counter_name - prev_read.counter_name, \
+			mon_node->name, mon_node->guid, port);
+
+	LOG_ERR_CNT("SymbolErrorCounter",           "4C31", symbol_err_cnt);
+	LOG_ERR_CNT("LinkErrorRecoveryCounter",     "4C32", link_err_recover);
+	LOG_ERR_CNT("LinkDownedCounter",            "4C33", link_downed);
+	LOG_ERR_CNT("PortRcvErrors",                "4C34", rcv_err);
+	LOG_ERR_CNT("PortRcvRemotePhysicalErrors",  "4C35", rcv_rem_phys_err);
+	LOG_ERR_CNT("PortRcvSwitchRelayErrors",     "4C36", rcv_switch_relay_err);
+	LOG_ERR_CNT("PortXmitDiscards",             "4C37", xmit_discards);
+	LOG_ERR_CNT("PortXmitConstraintErrors",     "4C38", xmit_constraint_err);
+	LOG_ERR_CNT("PortRcvConstraintErrors",      "4C39", rcv_constraint_err);
+	LOG_ERR_CNT("LocalLinkIntegrityErrors",     "4C3A", link_integrity);
+	LOG_ERR_CNT("ExcessiveBufferOverrunErrors", "4C3B", buffer_overrun);
+	LOG_ERR_CNT("VL15Dropped",                  "4C3C", vl15_dropped);
 }
 
 static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
@@ -1310,10 +1307,11 @@ static void pc_recv_process(void *context, void *data)
 		perfmgr_check_oob_clear(pm, p_mon_node, port, &err_reading,
 					&data_reading);
 
-	/* log any critical events from this reading */
-	perfmgr_log_events(pm, p_mon_node, port, &err_reading);
-
 	if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
+		/* log errors from this reading */
+		if (pm->subn->opt.perfmgr_log_errors)
+			perfmgr_log_errors(pm, p_mon_node, port, &err_reading);
+
 		perfmgr_db_add_err_reading(pm->db, node_guid, port,
 					   &err_reading);
 		perfmgr_db_add_dc_reading(pm->db, node_guid, port,
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 230e6de..9b87ea2 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -782,6 +782,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "perfmgr_ignore_cas", OPT_OFFSET(perfmgr_ignore_cas), opts_parse_boolean, NULL, 0 },
 	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
 	{ "perfmgr_rm_nodes", OPT_OFFSET(perfmgr_rm_nodes), opts_parse_boolean, NULL, 0 },
+	{ "perfmgr_log_errors", OPT_OFFSET(perfmgr_log_errors), opts_parse_boolean, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
 	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
@@ -1472,6 +1473,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->perfmgr_ignore_cas = FALSE;
 	p_opt->event_db_dump_file = NULL; /* use default */
 	p_opt->perfmgr_rm_nodes = TRUE;
+	p_opt->perfmgr_log_errors = TRUE;
 #endif				/* ENABLE_OSM_PERF_MGR */
 
 	p_opt->event_plugin_name = NULL;
@@ -2537,13 +2539,16 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"perfmgr_max_outstanding_queries %u\n"
 		"perfmgr_ignore_cas %s\n\n"
 		"# Remove missing nodes from DB\n"
-		"perfmgr_rm_nodes %s\n",
+		"perfmgr_rm_nodes %s\n\n"
+		"# Log error counters to opensm.log\n"
+		"perfmgr_log_errors %s\n\n",
 		p_opts->perfmgr ? "TRUE" : "FALSE",
 		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
 		p_opts->perfmgr_sweep_time_s,
 		p_opts->perfmgr_max_outstanding_queries,
 		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE",
-		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE");
+		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE",
+		p_opts->perfmgr_log_errors ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"#\n# Event DB Options\n#\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
