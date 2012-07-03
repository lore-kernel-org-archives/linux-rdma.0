From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 04/10] opensm: perfmgr delete "inactive" nodes from the DB
Date: Tue, 3 Jul 2012 16:53:12 -0700
Message-ID: <20120703165312.4096026b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



When a node drops from the fabric the default behavior was to leave the node
data in the PerfMgr DB.  Add the option (with default set to TRUE) to delete
these "inactive" or missing nodes from the DB.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h    |   11 +++++++++++
 include/opensm/osm_perfmgr_db.h |    1 +
 include/opensm/osm_subnet.h     |    1 +
 opensm/osm_console.c            |   22 ++++++++++++++++------
 opensm/osm_perfmgr.c            |    4 ++++
 opensm/osm_perfmgr_db.c         |   13 +++++++++++++
 opensm/osm_subnet.c             |    9 +++++++--
 7 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 0e9f66f..be6f978 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -143,6 +143,7 @@ typedef struct osm_perfmgr {
 	monitored_node_t *remove_list;
 	ib_net64_t port_guid;
 	int16_t local_port;
+	int rm_nodes;
 } osm_perfmgr_t;
 /*
 * FIELDS
@@ -180,6 +181,16 @@ inline static osm_perfmgr_state_t osm_perfmgr_get_state(osm_perfmgr_t * perfmgr)
 	return perfmgr->state;
 }
 
+inline static void osm_perfmgr_set_rm_nodes(osm_perfmgr_t *perfmgr,
+					    int rm_nodes)
+{
+	perfmgr->rm_nodes = rm_nodes;
+}
+inline static int osm_perfmgr_get_rm_nodes(osm_perfmgr_t *perfmgr)
+{
+	return perfmgr->rm_nodes;
+}
+
 inline static const char *osm_perfmgr_get_state_str(osm_perfmgr_t * p_perfmgr)
 {
 	switch (p_perfmgr->state) {
diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 4c7996d..8231a12 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -160,6 +160,7 @@ void perfmgr_db_destroy(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_create_entry(perfmgr_db_t * db, uint64_t guid,
 					 boolean_t esp0, uint8_t num_ports,
 					 char *node_name);
+perfmgr_db_err_t perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid);
 
 perfmgr_db_err_t perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid,
 					    uint8_t port,
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index abd2158..37314cc 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -253,6 +253,7 @@ typedef struct osm_subn_opt {
 	uint32_t perfmgr_max_outstanding_queries;
 	boolean_t perfmgr_ignore_cas;
 	char *event_db_dump_file;
+	int perfmgr_rm_nodes;
 #endif				/* ENABLE_OSM_PERF_MGR */
 	char *event_plugin_name;
 	char *event_plugin_options;
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 5b602d1..e68be25 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -239,7 +239,7 @@ static void help_update_desc(FILE *out, int detail)
 static void help_perfmgr(FILE * out, int detail)
 {
 	fprintf(out,
-		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|sweep_time[seconds]]\n");
+		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|set_rm_nodes|clear_rm_nodes|sweep_time[seconds]]\n");
 	if (detail) {
 		fprintf(out,
 			"perfmgr -- print the performance manager state\n");
@@ -257,6 +257,9 @@ static void help_perfmgr(FILE * out, int detail)
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
 			"   [clear_redir [<nodename|nodeguid>]] -- clear the redirection table\n");
+		fprintf(out,
+			"   [[set|clear]_rm_nodes] -- enable/disable the removal of \"inactive\" nodes from the DB\n"
+			"                             Inactive nodes are those which no longer appear on the fabric\n");
 	}
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
@@ -1443,6 +1446,10 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 					      PERFMGR_STATE_DISABLE);
 		} else if (strcmp(p_cmd, "clear_counters") == 0) {
 			osm_perfmgr_clear_counters(&p_osm->perfmgr);
+		} else if (strcmp(p_cmd, "set_rm_nodes") == 0) {
+			osm_perfmgr_set_rm_nodes(&p_osm->perfmgr, 1);
+		} else if (strcmp(p_cmd, "clear_rm_nodes") == 0) {
+			osm_perfmgr_set_rm_nodes(&p_osm->perfmgr, 0);
 		} else if (strcmp(p_cmd, "dump_counters") == 0) {
 			p_cmd = next_token(p_last);
 			if (p_cmd && (strcmp(p_cmd, "mach") == 0)) {
@@ -1491,15 +1498,18 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		}
 	} else {
 		fprintf(out, "Performance Manager status:\n"
-			"state                   : %s\n"
-			"sweep state             : %s\n"
-			"sweep time              : %us\n"
-			"outstanding queries/max : %d/%u\n",
+			"state                        : %s\n"
+			"sweep state                  : %s\n"
+			"sweep time                   : %us\n"
+			"outstanding queries/max      : %d/%u\n"
+			"remove missing nodes from DB : %s\n",
 			osm_perfmgr_get_state_str(&p_osm->perfmgr),
 			osm_perfmgr_get_sweep_state_str(&p_osm->perfmgr),
 			osm_perfmgr_get_sweep_time_s(&p_osm->perfmgr),
 			p_osm->perfmgr.outstanding_queries,
-			p_osm->perfmgr.max_outstanding_queries);
+			p_osm->perfmgr.max_outstanding_queries,
+			osm_perfmgr_get_rm_nodes(&p_osm->perfmgr)
+						 ? "TRUE" : "FALSE");
 	}
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index e213b3a..bec2381 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -146,6 +146,9 @@ static void remove_marked_nodes(osm_perfmgr_t * pm)
 		cl_qmap_remove_item(&pm->monitored_map,
 				    (cl_map_item_t *) (pm->remove_list));
 
+		if (pm->rm_nodes)
+			perfmgr_db_delete_entry(pm->db, pm->remove_list->guid);
+
 		if (pm->remove_list->name)
 			free(pm->remove_list->name);
 		free(pm->remove_list);
@@ -1381,6 +1384,7 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 	if (pm->state == PERFMGR_STATE_ENABLED)
 		cl_timer_start(&pm->sweep_timer, pm->sweep_time_s * 1000);
 
+	pm->rm_nodes = p_opt->perfmgr_rm_nodes;
 	status = IB_SUCCESS;
 Exit:
 	OSM_LOG_EXIT(pm->log);
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 98bf59c..b04be27 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -194,6 +194,19 @@ Exit:
 	return rc;
 }
 
+perfmgr_db_err_t
+perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid)
+{
+	cl_map_item_t * rc = cl_qmap_remove(&db->pc_data, guid);
+
+	if (rc == cl_qmap_end(&db->pc_data))
+		return(PERFMGR_EVENT_DB_GUIDNOTFOUND);
+
+	db_node_t *pc_node = (db_node_t *)rc;
+	free_node(pc_node);
+	return(PERFMGR_EVENT_DB_SUCCESS);
+}
+
 /**********************************************************************
  * Dump a reading vs the previous reading to stdout
  **********************************************************************/
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 662e591..06efa9c 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -493,6 +493,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "perfmgr_max_outstanding_queries", OPT_OFFSET(perfmgr_max_outstanding_queries), opts_parse_uint32, NULL, 0 },
 	{ "perfmgr_ignore_cas", OPT_OFFSET(perfmgr_ignore_cas), opts_parse_boolean, NULL, 0 },
 	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
+	{ "perfmgr_rm_nodes", OPT_OFFSET(perfmgr_rm_nodes), opts_parse_boolean, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
 	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
@@ -985,6 +986,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	    OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES;
 	p_opt->perfmgr_ignore_cas = FALSE;
 	p_opt->event_db_dump_file = NULL; /* use default */
+	p_opt->perfmgr_rm_nodes = TRUE;
 #endif				/* ENABLE_OSM_PERF_MGR */
 
 	p_opt->event_plugin_name = NULL;
@@ -2009,12 +2011,15 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"perfmgr_sweep_time_s %u\n\n"
 		"# Max outstanding queries\n"
 		"perfmgr_max_outstanding_queries %u\n"
-		"perfmgr_ignore_cas %s\n\n",
+		"perfmgr_ignore_cas %s\n\n"
+		"# Remove missing nodes from DB\n"
+		"perfmgr_rm_nodes %s\n",
 		p_opts->perfmgr ? "TRUE" : "FALSE",
 		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
 		p_opts->perfmgr_sweep_time_s,
 		p_opts->perfmgr_max_outstanding_queries,
-		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE");
+		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE",
+		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"#\n# Event DB Options\n#\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
