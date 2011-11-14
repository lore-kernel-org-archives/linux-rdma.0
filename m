From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 1/5] Free memory from osm_subn_opt_t when
	osm_subn_t destroyed
Date: Mon, 14 Nov 2011 14:49:49 -0800
Message-ID: <1321310989.5518.50.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 554a950..03b73dd 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -435,6 +435,75 @@ void osm_subn_construct(IN osm_subn_t * p_subn)
 	cl_fmap_init(&p_subn->mgrp_mgid_tbl, compar_mgids);
 }
 
+static void subn_destroy_qos_options(osm_qos_options_t *opt)
+{
+	if (opt->vlarb_high)
+		free(opt->vlarb_high);
+	if (opt->vlarb_low)
+		free(opt->vlarb_low);
+	if (opt->sl2vl)
+		free(opt->sl2vl);
+}
+
+static void subn_opt_destroy(IN osm_subn_opt_t * p_opt)
+{
+	if (p_opt->console)
+		free(p_opt->console);
+	if (p_opt->port_prof_ignore_file)
+		free(p_opt->port_prof_ignore_file);
+	if (p_opt->hop_weights_file)
+		free(p_opt->hop_weights_file);
+	if (p_opt->port_search_ordering_file)
+		free(p_opt->port_search_ordering_file);
+	if (p_opt->routing_engine_names)
+		free(p_opt->routing_engine_names);
+	if (p_opt->log_file)
+		free(p_opt->log_file);
+	if (p_opt->partition_config_file)
+		free(p_opt->partition_config_file);
+	if (p_opt->qos_policy_file)
+		free(p_opt->qos_policy_file);
+	if (p_opt->dump_files_dir)
+		free(p_opt->dump_files_dir);
+	if (p_opt->lid_matrix_dump_file)
+		free(p_opt->lid_matrix_dump_file);
+	if (p_opt->lfts_file)
+		free(p_opt->lfts_file);
+	if (p_opt->root_guid_file)
+		free(p_opt->root_guid_file);
+	if (p_opt->cn_guid_file)
+		free(p_opt->cn_guid_file);
+	if (p_opt->io_guid_file)
+		free(p_opt->io_guid_file);
+	if (p_opt->ids_guid_file)
+		free(p_opt->ids_guid_file);
+	if (p_opt->guid_routing_order_file)
+		free(p_opt->guid_routing_order_file);
+	if (p_opt->sa_db_file)
+		free(p_opt->sa_db_file);
+	if (p_opt->torus_conf_file)
+		free(p_opt->torus_conf_file);
+#ifdef ENABLE_OSM_PERF_MGR
+	if (p_opt->event_db_dump_file)
+		free(p_opt->event_db_dump_file);
+#endif /* ENABLE_OSM_PERF_MGR */
+	if (p_opt->event_plugin_name)
+		free(p_opt->event_plugin_name);
+	if (p_opt->event_plugin_options)
+		free(p_opt->event_plugin_options);
+	if(p_opt->node_name_map_name)
+		free(p_opt->node_name_map_name);
+	if (p_opt->prefix_routes_file)
+		free(p_opt->prefix_routes_file);
+	if (p_opt->log_prefix)
+		free(p_opt->log_prefix);
+	subn_destroy_qos_options(&p_opt->qos_options);
+	subn_destroy_qos_options(&p_opt->qos_ca_options);
+	subn_destroy_qos_options(&p_opt->qos_sw0_options);
+	subn_destroy_qos_options(&p_opt->qos_swe_options);
+	subn_destroy_qos_options(&p_opt->qos_rtr_options);
+}
+
 void osm_subn_destroy(IN osm_subn_t * p_subn)
 {
 	int i;
@@ -526,6 +595,9 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 		cl_list_item_t *item = cl_qlist_remove_head(&p_subn->prefix_routes_list);
 		free(item);
 	}
+
+	subn_opt_destroy(&p_subn->opt);
+	free(p_subn->opt.file_opts);
 }
 
 ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
@@ -1218,6 +1290,7 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 		return -1;
 	}
 	memcpy(p_opts->file_opts, p_opts, sizeof(*p_opts));
+	p_opts->file_opts->file_opts = NULL;
 
 	while (fgets(line, 1023, opts_file) != NULL) {
 		/* get the first token */
-- 
1.7.1




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
