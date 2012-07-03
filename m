From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 01/10] opensm/perfmgr: Add config option to ignore Channel
 Adapters.
Date: Tue, 3 Jul 2012 16:52:23 -0700
Message-ID: <20120703165223.36c7162b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



   On many fabrics nodes have monitoring software which can querry counters on
   the nodes (CA's) themselves.  In this case it may be more efficient to keep
   this perfmgr traffic off the subnet.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h |    1 +
 include/opensm/osm_subnet.h  |    1 +
 opensm/osm_perfmgr.c         |    6 ++++++
 opensm/osm_subnet.c          |    8 ++++++--
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 86066a7..0e9f66f 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -138,6 +138,7 @@ typedef struct osm_perfmgr {
 	atomic32_t outstanding_queries;	/* this along with sig_query */
 	cl_event_t sig_query;	/* will throttle our queries */
 	uint32_t max_outstanding_queries;
+	boolean_t ignore_cas;
 	cl_qmap_t monitored_map;	/* map the nodes being tracked */
 	monitored_node_t *remove_list;
 	ib_net64_t port_guid;
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 838ca82..abd2158 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -251,6 +251,7 @@ typedef struct osm_subn_opt {
 	boolean_t perfmgr_redir;
 	uint16_t perfmgr_sweep_time_s;
 	uint32_t perfmgr_max_outstanding_queries;
+	boolean_t perfmgr_ignore_cas;
 	char *event_db_dump_file;
 #endif				/* ENABLE_OSM_PERF_MGR */
 	char *event_plugin_name;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index a7ff017..e213b3a 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -438,6 +438,11 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 
 	if (cl_qmap_get(&pm->monitored_map, node_guid)
 	    == cl_qmap_end(&pm->monitored_map)) {
+
+		if (pm->ignore_cas &&
+		    (node->node_info.node_type == IB_NODE_TYPE_CA))
+			goto Exit;
+
 		/* if not already in map add it */
 		num_ports = osm_node_get_num_physp(node);
 		mon_node = malloc(sizeof(*mon_node) +
@@ -1349,6 +1354,7 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 	    p_opt->perfmgr ? PERFMGR_STATE_ENABLED : PERFMGR_STATE_DISABLE;
 	pm->sweep_time_s = p_opt->perfmgr_sweep_time_s;
 	pm->max_outstanding_queries = p_opt->perfmgr_max_outstanding_queries;
+	pm->ignore_cas = p_opt->perfmgr_ignore_cas;
 	pm->osm = osm;
 	pm->local_port = -1;
 
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7fb5c8f..662e591 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -491,6 +491,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_sweep_time_s", OPT_OFFSET(perfmgr_sweep_time_s), opts_parse_uint16, NULL, 0 },
 	{ "perfmgr_max_outstanding_queries", OPT_OFFSET(perfmgr_max_outstanding_queries), opts_parse_uint32, NULL, 0 },
+	{ "perfmgr_ignore_cas", OPT_OFFSET(perfmgr_ignore_cas), opts_parse_boolean, NULL, 0 },
 	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
@@ -982,6 +983,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->perfmgr_sweep_time_s = OSM_PERFMGR_DEFAULT_SWEEP_TIME_S;
 	p_opt->perfmgr_max_outstanding_queries =
 	    OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES;
+	p_opt->perfmgr_ignore_cas = FALSE;
 	p_opt->event_db_dump_file = NULL; /* use default */
 #endif				/* ENABLE_OSM_PERF_MGR */
 
@@ -2006,11 +2008,13 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# sweep time in seconds\n"
 		"perfmgr_sweep_time_s %u\n\n"
 		"# Max outstanding queries\n"
-		"perfmgr_max_outstanding_queries %u\n\n",
+		"perfmgr_max_outstanding_queries %u\n"
+		"perfmgr_ignore_cas %s\n\n",
 		p_opts->perfmgr ? "TRUE" : "FALSE",
 		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
 		p_opts->perfmgr_sweep_time_s,
-		p_opts->perfmgr_max_outstanding_queries);
+		p_opts->perfmgr_max_outstanding_queries,
+		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"#\n# Event DB Options\n#\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
