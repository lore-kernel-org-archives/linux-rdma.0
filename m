From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.{c,h}: passing options to the event
	plugins
Date: Tue, 13 Apr 2010 13:43:14 +0300
Message-ID: <4BC44AC2.8010403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding new option string: "event_plugin_options"
A user can use this option to pass any plugin options.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    4 ++++
 opensm/opensm/osm_subnet.c         |   12 ++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 83705a5..c609723 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -223,6 +223,7 @@ typedef struct osm_subn_opt {
 	char *event_db_dump_file;
 #endif				/* ENABLE_OSM_PERF_MGR */
 	char *event_plugin_name;
+	char *event_plugin_options;
 	char *node_name_map_name;
 	char *prefix_routes_file;
 	char *log_prefix;
@@ -459,6 +460,9 @@ typedef struct osm_subn_opt {
 *       event_plugin_name
 *               Specify the name(s) of the event plugin(s)
 *
+*       event_plugin_options
+*               Options string that would be passed to the plugin(s)
+*
 *	qos_options
 *		Default set of QoS options
 *
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index e4126bc..9132c82 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -364,6 +364,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
 	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
+	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
 	{ "node_name_map_name", OPT_OFFSET(node_name_map_name), opts_parse_charp, NULL, 0 },
 	{ "qos_max_vls", OPT_OFFSET(qos_options.max_vls), opts_parse_uint32, NULL, 1 },
 	{ "qos_high_limit", OPT_OFFSET(qos_options.high_limit), opts_parse_int32, NULL, 1 },
@@ -727,6 +728,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 #endif				/* ENABLE_OSM_PERF_MGR */

 	p_opt->event_plugin_name = NULL;
+	p_opt->event_plugin_options = NULL;
 	p_opt->node_name_map_name = NULL;

 	p_opt->dump_files_dir = getenv("OSM_TMP_DIR");
@@ -1544,8 +1546,14 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)

 	fprintf(out,
 		"#\n# Event Plugin Options\n#\n"
-		"event_plugin_name %s\n\n", p_opts->event_plugin_name ?
-		p_opts->event_plugin_name : null_str);
+		"# Event plugin name(s)\n"
+		"event_plugin_name %s\n\n"
+		"# Options string that would be passed to the plugin(s)\n"
+		"event_plugin_options %s\n\n",
+		p_opts->event_plugin_name ?
+		p_opts->event_plugin_name : null_str,
+		p_opts->event_plugin_options ?
+		p_opts->event_plugin_options : null_str);

 	fprintf(out,
 		"#\n# Node name map for mapping node's to more descriptive node descriptions\n"
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
