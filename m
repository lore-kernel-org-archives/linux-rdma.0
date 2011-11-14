From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 3/5] Fix rescan config file parsing spamming and
	loading bugs
Date: Mon, 14 Nov 2011 14:51:27 -0800
Message-ID: <1321311087.5518.52.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes several major issues when config files are rescanned.

First, config file changes were only noticed if users listed the
config file option in the file.  If a user commented out an option
(or uncommented a previously commented out option) the change may
not be noticed.

Second, under several circumstances, mostly notably qos options,
ill-recognized changes were leading to excessive log messages.

To solve this, we do three major things.

A) We split the original config file parsing functions into store
and diff callback functions.  Config files are now completely parsed,
then afterwards looked at.  It no longer happens at the same time.

B) We store an additional copy of osm_subn_opt_t, which temporarily
stores the most recently parsed scan of the config file.  This gives
us the ability to notice commented out settings as well as remove
spam to logs.

C) We support a set of flags recognizing when an option is parsed
or not parsed, so that fields that were uncommented are recognized.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |  103 +++++++-
 opensm/osm_subnet.c         |  661 +++++++++++++++++++++++++++----------------
 2 files changed, 516 insertions(+), 248 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 90eae8b..90168a8 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -107,6 +107,12 @@ typedef struct osm_qos_options {
 	char *vlarb_high;
 	char *vlarb_low;
 	char *sl2vl;
+	/* Flags indicating if element parsed in config file */
+	boolean_t max_vls_parsed;
+	boolean_t high_limit_parsed;
+	boolean_t vlarb_high_parsed;
+	boolean_t vlarb_low_parsed;
+	boolean_t sl2vl_parsed;
 } osm_qos_options_t;
 /*
 * FIELDS
@@ -237,9 +243,104 @@ typedef struct osm_subn_opt {
 	char *prefix_routes_file;
 	char *log_prefix;
 	boolean_t consolidate_ipv6_snm_req;
-	struct osm_subn_opt *file_opts; /* used for update */
+	struct osm_subn_opt *old_file_opts; /* used for config file update */
+	struct osm_subn_opt *new_file_opts; /* used for config file updates */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
+	/* Flags indicating if element parsed in config file */
+	boolean_t guid_parsed;
+	boolean_t m_key_parsed;
+	boolean_t sm_key_parsed;
+	boolean_t sa_key_parsed;
+	boolean_t subnet_prefix_parsed;
+	boolean_t m_key_lease_period_parsed;
+	boolean_t sweep_interval_parsed;
+	boolean_t max_wire_smps_parsed;
+	boolean_t max_wire_smps2_parsed;
+	boolean_t max_smps_timeout_parsed;
+	boolean_t transaction_timeout_parsed;
+	boolean_t transaction_retries_parsed;
+	boolean_t sm_priority_parsed;
+	boolean_t lmc_parsed;
+	boolean_t lmc_esp0_parsed;
+	boolean_t max_op_vls_parsed;
+	boolean_t force_link_speed_parsed;
+	boolean_t force_link_speed_ext_parsed;
+	boolean_t fdr10_parsed;
+	boolean_t reassign_lids_parsed;
+	boolean_t ignore_other_sm_parsed;
+	boolean_t single_thread_parsed;
+	boolean_t disable_multicast_parsed;
+	boolean_t force_log_flush_parsed;
+	boolean_t subnet_timeout_parsed;
+	boolean_t packet_life_time_parsed;
+	boolean_t vl_stall_count_parsed;
+	boolean_t leaf_vl_stall_count_parsed;
+	boolean_t head_of_queue_lifetime_parsed;
+	boolean_t leaf_head_of_queue_lifetime_parsed;
+	boolean_t local_phy_errors_threshold_parsed;
+	boolean_t overrun_errors_threshold_parsed;
+	boolean_t use_mfttop_parsed;
+	boolean_t sminfo_polling_timeout_parsed;
+	boolean_t polling_retry_number_parsed;
+	boolean_t max_msg_fifo_timeout_parsed;
+	boolean_t force_heavy_sweep_parsed;
+	boolean_t log_flags_parsed;
+	boolean_t dump_files_dir_parsed;
+	boolean_t log_file_parsed;
+	boolean_t log_max_size_parsed;
+	boolean_t partition_config_file_parsed;
+	boolean_t no_partition_enforcement_parsed;
+	boolean_t qos_parsed;
+	boolean_t qos_policy_file_parsed;
+	boolean_t accum_log_file_parsed;
+	boolean_t console_parsed;
+	boolean_t console_port_parsed;
+	boolean_t port_prof_ignore_file_parsed;
+	boolean_t hop_weights_file_parsed;
+	boolean_t port_search_ordering_file_parsed;
+	boolean_t port_profile_switch_nodes_parsed;
+	boolean_t sweep_on_trap_parsed;
+	boolean_t routing_engine_names_parsed;
+	boolean_t use_ucast_cache_parsed;
+	boolean_t connect_roots_parsed;
+	boolean_t lid_matrix_dump_file_parsed;
+	boolean_t lfts_file_parsed;
+	boolean_t root_guid_file_parsed;
+	boolean_t cn_guid_file_parsed;
+	boolean_t io_guid_file_parsed;
+	boolean_t port_shifting_parsed;
+	boolean_t scatter_ports_parsed;
+	boolean_t max_reverse_hops_parsed;
+	boolean_t ids_guid_file_parsed;
+	boolean_t guid_routing_order_file_parsed;
+	boolean_t sa_db_file_parsed;
+	boolean_t sa_db_dump_parsed;
+	boolean_t torus_conf_file_parsed;
+	boolean_t do_mesh_analysis_parsed;
+	boolean_t exit_on_fatal_parsed;
+	boolean_t honor_guid2lid_file_parsed;
+	boolean_t daemon_parsed;
+	boolean_t sm_inactive_parsed;
+	boolean_t babbling_port_policy_parsed;
+	boolean_t use_optimized_slvl_parsed;
+	boolean_t enable_quirks_parsed;
+	boolean_t no_clients_rereg_parsed;
+#ifdef ENABLE_OSM_PERF_MGR
+	boolean_t perfmgr_parsed;
+	boolean_t perfmgr_redir_parsed;
+	boolean_t perfmgr_sweep_time_s_parsed;
+	boolean_t perfmgr_max_outstanding_queries_parsed;
+	boolean_t event_db_dump_file_parsed;
+#endif				/* ENABLE_OSM_PERF_MGR */
+	boolean_t event_plugin_name_parsed;
+	boolean_t event_plugin_options_parsed;
+	boolean_t node_name_map_name_parsed;
+	boolean_t prefix_routes_file_parsed;
+	boolean_t log_prefix_parsed;
+	boolean_t consolidate_ipv6_snm_req_parsed;
+	boolean_t lash_start_vl_parsed;
+	boolean_t sm_sl_parsed;
 } osm_subn_opt_t;
 /*
 * FIELDS
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 03b73dd..6b6bd63 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -74,14 +74,17 @@
 
 static const char null_str[] = "(null)";
 
-#define OPT_OFFSET(opt) offsetof(osm_subn_opt_t, opt)
+#define OPT_OFFSET(opt) offsetof(osm_subn_opt_t, opt), offsetof(osm_subn_opt_t, opt##_parsed)
 
 typedef struct opt_rec {
 	const char *name;
 	unsigned long opt_offset;
-	void (*parse_fn)(osm_subn_t *p_subn, char *p_key, char *p_val_str,
-			 void *p_val1, void *p_val2,
-			 void (*)(osm_subn_t *, void *));
+	unsigned long parsed_offset;
+	void (*store_fn)(char *p_val_str, void *p_val, boolean_t *p_parsed);
+	void (*diff_fn)(osm_subn_t *p_subn, const char *p_key,
+			void *p_main, void *p_old_file, void *p_new_file,
+			boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			boolean_t compare_parsed, void (*)(osm_subn_t *, void *));
 	void (*setup_fn)(osm_subn_t *p_subn, void *p_val);
 	int  can_update;
 } opt_rec_t;
@@ -97,7 +100,7 @@ static void log_report(const char *fmt, ...)
 	cl_log_event("OpenSM", CL_LOG_INFO, buf, NULL, 0);
 }
 
-static void log_config_value(char *name, const char *fmt, ...)
+static void log_config_value(const char *name, const char *fmt, ...)
 {
 	char buf[128];
 	va_list args;
@@ -154,101 +157,63 @@ static void opts_setup_sm_priority(osm_subn_t *p_subn, void *p_val)
 	osm_set_sm_priority(p_sm, sm_priority);
 }
 
-static void opts_parse_net64(IN osm_subn_t *p_subn, IN char *p_key,
-			     IN char *p_val_str, void *p_v1, void *p_v2,
-			     void (*pfn)(osm_subn_t *, void *))
+static void opts_store_net64(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	uint64_t *p_val1 = p_v1, *p_val2 = p_v2;
+	uint64_t *p_val = p_v;
 	uint64_t val = strtoull(p_val_str, NULL, 0);
 
-	if (cl_hton64(val) != *p_val1) {
-		log_config_value(p_key, "0x%016" PRIx64, val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = cl_ntoh64(val);
-	}
+	*p_val = cl_ntoh64(val);
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_uint32(IN osm_subn_t *p_subn, IN char *p_key,
-			      IN char *p_val_str, void *p_v1, void *p_v2,
-			      void (*pfn)(osm_subn_t *, void *))
+static void opts_store_uint32(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	uint32_t *p_val1 = p_v1, *p_val2 = p_v2;
+	uint32_t *p_val = p_v;
 	uint32_t val = strtoul(p_val_str, NULL, 0);
 
-	if (val != *p_val1) {
-		log_config_value(p_key, "%u", val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = val;
-	}
+	*p_val = val;
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_int32(IN osm_subn_t *p_subn, IN char *p_key,
-			     IN char *p_val_str, void *p_v1, void *p_v2,
-			     void (*pfn)(osm_subn_t *, void *))
+static void opts_store_int32(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	int32_t *p_val1 = p_v1, *p_val2 = p_v2;
+	int32_t *p_val = p_v;
 	int32_t val = strtol(p_val_str, NULL, 0);
 
-	if (val != *p_val1) {
-		log_config_value(p_key, "%d", val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = val;
-	}
+	*p_val = val;
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_uint16(IN osm_subn_t *p_subn, IN char *p_key,
-			      IN char *p_val_str, void *p_v1, void *p_v2,
-			      void (*pfn)(osm_subn_t *, void *))
+static void opts_store_uint16(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	uint16_t *p_val1 = p_v1, *p_val2 = p_v2;
+	uint16_t *p_val = p_v;
 	uint16_t val = (uint16_t) strtoul(p_val_str, NULL, 0);
 
-	if (val != *p_val1) {
-		log_config_value(p_key, "%u", val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = val;
-	}
+	*p_val = val;
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_net16(IN osm_subn_t *p_subn, IN char *p_key,
-			     IN char *p_val_str, void *p_v1, void *p_v2,
-			     void (*pfn)(osm_subn_t *, void *))
+static void opts_store_net16(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	uint16_t *p_val1 = p_v1, *p_val2 = p_v2;
+	uint16_t *p_val = p_v;
 	uint16_t val = strtoul(p_val_str, NULL, 0);
 
-	if (cl_hton16(val) != *p_val1) {
-		log_config_value(p_key, "0x%04x", val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = cl_hton16(val);
-	}
+	*p_val = cl_hton16(val);
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_uint8(IN osm_subn_t *p_subn, IN char *p_key,
-			     IN char *p_val_str, void *p_v1, void *p_v2,
-			     void (*pfn)(osm_subn_t *, void *))
+static void opts_store_uint8(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	uint8_t *p_val1 = p_v1, *p_val2 = p_v2;
+	uint8_t *p_val = p_v;
 	uint8_t val = strtoul(p_val_str, NULL, 0);
 
-	if (val != *p_val1) {
-		log_config_value(p_key, "%u", val);
-		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = val;
-	}
+	*p_val = val;
+	*p_parsed = TRUE;
 }
 
-static void opts_parse_boolean(IN osm_subn_t *p_subn, IN char *p_key,
-			       IN char *p_val_str, void *p_v1, void *p_v2,
-			       void (*pfn)(osm_subn_t *, void *))
+static void opts_store_boolean(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
 {
-	boolean_t *p_val1 = p_v1, *p_val2 = p_v2;
+	boolean_t *p_val = p_v;
 	boolean_t val;
 
 	if (!p_val_str)
@@ -259,157 +224,323 @@ static void opts_parse_boolean(IN osm_subn_t *p_subn, IN char *p_key,
 	else
 		val = TRUE;
 
-	if (val != *p_val1) {
-		log_config_value(p_key, "%s", p_val_str);
+	*p_val = val;
+	*p_parsed = TRUE;
+}
+
+static void opts_store_charp(IN char *p_val_str, void *p_v, boolean_t *p_parsed)
+{
+	char **p_val = p_v;
+	char *new;
+
+	/* special case the "(null)" string */
+	new = strcmp(null_str, p_val_str) ? strdup(p_val_str) : NULL;
+	if (*p_val)
+		free(*p_val);
+	*p_val = new;
+	*p_parsed = TRUE;
+}
+
+static void opts_diff_net64(IN osm_subn_t *p_subn, IN const char *p_key,
+			    void *p_main, void *p_old_file, void *p_new_file,
+			    boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			    boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	uint64_t *p_val_main = p_main;
+	uint64_t *p_val_old_file = p_old_file;
+	uint64_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "0x%016" PRIx64, *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_uint32(IN osm_subn_t *p_subn, IN const char *p_key,
+			     void *p_main, void *p_old_file, void *p_new_file,
+			     boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			     boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	uint32_t *p_val_main = p_main;
+	uint32_t *p_val_old_file = p_old_file;
+	uint32_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "%u", *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_int32(IN osm_subn_t *p_subn, IN const char *p_key,
+			    void *p_main, void *p_old_file, void *p_new_file,
+			    boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			    boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	int32_t *p_val_main = p_main;
+	int32_t *p_val_old_file = p_old_file;
+	int32_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "%d", *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_uint16(IN osm_subn_t *p_subn, IN const char *p_key,
+			     void *p_main, void *p_old_file, void *p_new_file,
+			     boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			     boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	uint16_t *p_val_main = p_main;
+	uint16_t *p_val_old_file = p_old_file;
+	uint16_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "%u", *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_net16(IN osm_subn_t *p_subn, IN const char *p_key,
+			    void *p_main, void *p_old_file, void *p_new_file,
+			    boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			    boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	uint16_t *p_val_main = p_main;
+	uint16_t *p_val_old_file = p_old_file;
+	uint16_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "0x%04x", *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_uint8(IN osm_subn_t *p_subn, IN const char *p_key,
+			    void *p_main, void *p_old_file, void *p_new_file,
+			    boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			    boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	uint8_t *p_val_main = p_main;
+	uint8_t *p_val_old_file = p_old_file;
+	uint8_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "%u", *p_val_new_file);
 		if (pfn)
-			pfn(p_subn, &val);
-		*p_val1 = *p_val2 = val;
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
 	}
+	*p_old_file_parsed = *p_new_file_parsed;
 }
 
-static void opts_parse_charp(IN osm_subn_t *p_subn, IN char *p_key,
-			     IN char *p_val_str, void *p_v1, void *p_v2,
-			     void (*pfn)(osm_subn_t *, void *))
+static void opts_diff_boolean(IN osm_subn_t *p_subn, IN const char *p_key,
+			      void *p_main, void *p_old_file, void *p_new_file,
+			      boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			      boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
 {
-	char **p_val1 = p_v1, **p_val2 = p_v2;
-	const char *current_str = *p_val1 ? *p_val1 : null_str ;
-
-	if (p_val_str && strcmp(p_val_str, current_str)) {
-		char *new;
-		log_config_value(p_key, "%s", p_val_str);
-		/* special case the "(null)" string */
-		new = strcmp(null_str, p_val_str) ? strdup(p_val_str) : NULL;
+	boolean_t *p_val_main = p_main;
+	boolean_t *p_val_old_file = p_old_file;
+	boolean_t *p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || *p_val_old_file != *p_val_new_file) {
+		if (*p_val_main != *p_val_new_file)
+			log_config_value(p_key, "%s", *p_val_new_file == TRUE ? "TRUE" : "FALSE");
 		if (pfn)
-			pfn(p_subn, new);
-		if (*p_val1 && *p_val1 != *p_val2)
-			free(*p_val1);
-		if (*p_val2)
-			free(*p_val2);
-		*p_val1 = *p_val2 = new;
+			pfn(p_subn, p_val_new_file);
+		*p_val_main = *p_val_old_file = *p_val_new_file;
+	}
+	*p_old_file_parsed = *p_new_file_parsed;
+}
+
+static void opts_diff_charp(IN osm_subn_t *p_subn, IN const char *p_key,
+			    void *p_main, void *p_old_file, void *p_new_file,
+			    boolean_t *p_old_file_parsed, boolean_t *p_new_file_parsed,
+			    boolean_t compare_parsed, void (*pfn)(osm_subn_t *, void *))
+{
+	char **p_val_main = p_main;
+	char **p_val_old_file = p_old_file;
+	char **p_val_new_file = p_new_file;
+
+	if ((compare_parsed && *p_old_file_parsed != *p_new_file_parsed)
+	    || (*p_val_old_file && !*p_val_new_file)
+	    || (!*p_val_old_file && *p_val_new_file)
+	    || (*p_val_old_file
+		&& *p_val_new_file
+		&& strcmp(*p_val_old_file, *p_val_new_file))) {
+		if ((*p_val_main && !*p_val_new_file)
+		    || (!*p_val_main && *p_val_new_file)
+		    || (*p_val_main
+			&& *p_val_new_file
+			&& strcmp(*p_val_main, *p_val_new_file)))
+			log_config_value(p_key, "%s", *p_val_new_file);
+		if (pfn)
+			pfn(p_subn, *p_val_new_file);
+		if (*p_val_main)
+			free(*p_val_main);
+		if (*p_val_old_file)
+			free(*p_val_old_file);
+		if (*p_val_new_file) {
+			*p_val_main = strdup(*p_val_new_file);
+			*p_val_old_file = strdup(*p_val_new_file);
+		}
+		else {
+			*p_val_main = NULL;
+			*p_val_old_file = NULL;
+		}
 	}
+	*p_old_file_parsed = *p_new_file_parsed;
 }
 
 static const opt_rec_t opt_tbl[] = {
-	{ "guid", OPT_OFFSET(guid), opts_parse_net64, NULL, 0 },
-	{ "m_key", OPT_OFFSET(m_key), opts_parse_net64, NULL, 1 },
-	{ "sm_key", OPT_OFFSET(sm_key), opts_parse_net64, NULL, 1 },
-	{ "sa_key", OPT_OFFSET(sa_key), opts_parse_net64, NULL, 1 },
-	{ "subnet_prefix", OPT_OFFSET(subnet_prefix), opts_parse_net64, NULL, 1 },
-	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
-	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
-	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
-	{ "max_wire_smps2", OPT_OFFSET(max_wire_smps2), opts_parse_uint32, NULL, 1 },
-	{ "max_smps_timeout", OPT_OFFSET(max_smps_timeout), opts_parse_uint32, NULL, 1 },
-	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
-	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
-	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 0 },
-	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_parse_uint32, NULL, 0 },
-	{ "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fifo_timeout), opts_parse_uint32, NULL, 1 },
-	{ "sm_priority", OPT_OFFSET(sm_priority), opts_parse_uint8, opts_setup_sm_priority, 1 },
-	{ "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NULL, 1 },
-	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_parse_boolean, NULL, 1 },
-	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_parse_uint8, NULL, 1 },
-	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_parse_uint8, NULL, 1 },
-	{ "force_link_speed_ext", OPT_OFFSET(force_link_speed_ext), opts_parse_uint8, NULL, 1 },
-	{ "fdr10", OPT_OFFSET(fdr10), opts_parse_uint8, NULL, 1 },
-	{ "reassign_lids", OPT_OFFSET(reassign_lids), opts_parse_boolean, NULL, 1 },
-	{ "ignore_other_sm", OPT_OFFSET(ignore_other_sm), opts_parse_boolean, NULL, 1 },
-	{ "single_thread", OPT_OFFSET(single_thread), opts_parse_boolean, NULL, 0 },
-	{ "disable_multicast", OPT_OFFSET(disable_multicast), opts_parse_boolean, NULL, 1 },
-	{ "subnet_timeout", OPT_OFFSET(subnet_timeout), opts_parse_uint8, NULL, 1 },
-	{ "packet_life_time", OPT_OFFSET(packet_life_time), opts_parse_uint8, NULL, 1 },
-	{ "vl_stall_count", OPT_OFFSET(vl_stall_count), opts_parse_uint8, NULL, 1 },
-	{ "leaf_vl_stall_count", OPT_OFFSET(leaf_vl_stall_count), opts_parse_uint8, NULL, 1 },
-	{ "head_of_queue_lifetime", OPT_OFFSET(head_of_queue_lifetime), opts_parse_uint8, NULL, 1 },
-	{ "leaf_head_of_queue_lifetime", OPT_OFFSET(leaf_head_of_queue_lifetime), opts_parse_uint8, NULL, 1 },
-	{ "local_phy_errors_threshold", OPT_OFFSET(local_phy_errors_threshold), opts_parse_uint8, NULL, 1 },
-	{ "overrun_errors_threshold", OPT_OFFSET(overrun_errors_threshold), opts_parse_uint8, NULL, 1 },
-	{ "use_mfttop", OPT_OFFSET(use_mfttop), opts_parse_boolean, NULL, 1},
-	{ "sminfo_polling_timeout", OPT_OFFSET(sminfo_polling_timeout), opts_parse_uint32, opts_setup_sminfo_polling_timeout, 1 },
-	{ "polling_retry_number", OPT_OFFSET(polling_retry_number), opts_parse_uint32, NULL, 1 },
-	{ "force_heavy_sweep", OPT_OFFSET(force_heavy_sweep), opts_parse_boolean, NULL, 1 },
-	{ "port_prof_ignore_file", OPT_OFFSET(port_prof_ignore_file), opts_parse_charp, NULL, 0 },
-	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_parse_charp, NULL, 0 },
-	{ "dimn_ports_file", OPT_OFFSET(port_search_ordering_file), opts_parse_charp, NULL, 0 },
-	{ "port_search_ordering_file", OPT_OFFSET(port_search_ordering_file), opts_parse_charp, NULL, 0 },
-	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
-	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
-	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
-	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
-	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 0 },
-	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
-	{ "log_max_size", OPT_OFFSET(log_max_size), opts_parse_uint32, opts_setup_log_max_size, 1 },
-	{ "log_flags", OPT_OFFSET(log_flags), opts_parse_uint8, opts_setup_log_flags, 1 },
-	{ "force_log_flush", OPT_OFFSET(force_log_flush), opts_parse_boolean, opts_setup_force_log_flush, 1 },
-	{ "accum_log_file", OPT_OFFSET(accum_log_file), opts_parse_boolean, opts_setup_accum_log_file, 1 },
-	{ "partition_config_file", OPT_OFFSET(partition_config_file), opts_parse_charp, NULL, 0 },
-	{ "no_partition_enforcement", OPT_OFFSET(no_partition_enforcement), opts_parse_boolean, NULL, 1 },
-	{ "qos", OPT_OFFSET(qos), opts_parse_boolean, NULL, 1 },
-	{ "qos_policy_file", OPT_OFFSET(qos_policy_file), opts_parse_charp, NULL, 0 },
-	{ "dump_files_dir", OPT_OFFSET(dump_files_dir), opts_parse_charp, NULL, 0 },
-	{ "lid_matrix_dump_file", OPT_OFFSET(lid_matrix_dump_file), opts_parse_charp, NULL, 0 },
-	{ "lfts_file", OPT_OFFSET(lfts_file), opts_parse_charp, NULL, 0 },
-	{ "root_guid_file", OPT_OFFSET(root_guid_file), opts_parse_charp, NULL, 0 },
-	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_parse_charp, NULL, 0 },
-	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_parse_charp, NULL, 0 },
-	{ "port_shifting", OPT_OFFSET(port_shifting), opts_parse_boolean, NULL, 1 },
-	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_parse_uint32, NULL, 0 },
-	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
-	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
-	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
-	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
-	{ "sa_db_dump", OPT_OFFSET(sa_db_dump), opts_parse_boolean, NULL, 1 },
-	{ "torus_config", OPT_OFFSET(torus_conf_file), opts_parse_charp, NULL, 1 },
-	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_parse_boolean, NULL, 1 },
-	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_parse_boolean, NULL, 1 },
-	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_parse_boolean, NULL, 1 },
-	{ "daemon", OPT_OFFSET(daemon), opts_parse_boolean, NULL, 0 },
-	{ "sm_inactive", OPT_OFFSET(sm_inactive), opts_parse_boolean, NULL, 1 },
-	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_parse_boolean, NULL, 1 },
-	{ "use_optimized_slvl", OPT_OFFSET(use_optimized_slvl), opts_parse_boolean, NULL, 1 },
+	{ "guid", OPT_OFFSET(guid), opts_store_net64, opts_diff_net64, NULL, 0 },
+	{ "m_key", OPT_OFFSET(m_key), opts_store_net64, opts_diff_net64, NULL, 1 },
+	{ "sm_key", OPT_OFFSET(sm_key), opts_store_net64, opts_diff_net64, NULL, 1 },
+	{ "sa_key", OPT_OFFSET(sa_key), opts_store_net64, opts_diff_net64, NULL, 1 },
+	{ "subnet_prefix", OPT_OFFSET(subnet_prefix), opts_store_net64, opts_diff_net64, NULL, 1 },
+	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_store_net16, opts_diff_net16, NULL, 1 },
+	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "max_wire_smps2", OPT_OFFSET(max_wire_smps2), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "max_smps_timeout", OPT_OFFSET(max_smps_timeout), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "console", OPT_OFFSET(console), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "console_port", OPT_OFFSET(console_port), opts_store_uint16, opts_diff_uint16, NULL, 0 },
+	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_store_uint32, opts_diff_uint32, NULL, 0 },
+	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_store_uint32, opts_diff_uint32, NULL, 0 },
+	{ "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fifo_timeout), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "sm_priority", OPT_OFFSET(sm_priority), opts_store_uint8, opts_diff_uint8, opts_setup_sm_priority, 1 },
+	{ "lmc", OPT_OFFSET(lmc), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "force_link_speed_ext", OPT_OFFSET(force_link_speed_ext), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "fdr10", OPT_OFFSET(fdr10), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "reassign_lids", OPT_OFFSET(reassign_lids), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "ignore_other_sm", OPT_OFFSET(ignore_other_sm), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "single_thread", OPT_OFFSET(single_thread), opts_store_boolean, opts_diff_boolean, NULL, 0 },
+	{ "disable_multicast", OPT_OFFSET(disable_multicast), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "subnet_timeout", OPT_OFFSET(subnet_timeout), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "packet_life_time", OPT_OFFSET(packet_life_time), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "vl_stall_count", OPT_OFFSET(vl_stall_count), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "leaf_vl_stall_count", OPT_OFFSET(leaf_vl_stall_count), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "head_of_queue_lifetime", OPT_OFFSET(head_of_queue_lifetime), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "leaf_head_of_queue_lifetime", OPT_OFFSET(leaf_head_of_queue_lifetime), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "local_phy_errors_threshold", OPT_OFFSET(local_phy_errors_threshold), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "overrun_errors_threshold", OPT_OFFSET(overrun_errors_threshold), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "use_mfttop", OPT_OFFSET(use_mfttop), opts_store_boolean, opts_diff_boolean, NULL, 1},
+	{ "sminfo_polling_timeout", OPT_OFFSET(sminfo_polling_timeout), opts_store_uint32, opts_diff_uint32, opts_setup_sminfo_polling_timeout, 1 },
+	{ "polling_retry_number", OPT_OFFSET(polling_retry_number), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "force_heavy_sweep", OPT_OFFSET(force_heavy_sweep), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "port_prof_ignore_file", OPT_OFFSET(port_prof_ignore_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "dimn_ports_file", OPT_OFFSET(port_search_ordering_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "port_search_ordering_file", OPT_OFFSET(port_search_ordering_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "connect_roots", OPT_OFFSET(connect_roots), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_store_boolean, opts_diff_boolean, NULL, 0 },
+	{ "log_file", OPT_OFFSET(log_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "log_max_size", OPT_OFFSET(log_max_size), opts_store_uint32, opts_diff_uint32, opts_setup_log_max_size, 1 },
+	{ "log_flags", OPT_OFFSET(log_flags), opts_store_uint8, opts_diff_uint8, opts_setup_log_flags, 1 },
+	{ "force_log_flush", OPT_OFFSET(force_log_flush), opts_store_boolean, opts_diff_boolean, opts_setup_force_log_flush, 1 },
+	{ "accum_log_file", OPT_OFFSET(accum_log_file), opts_store_boolean, opts_diff_boolean, opts_setup_accum_log_file, 1 },
+	{ "partition_config_file", OPT_OFFSET(partition_config_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "no_partition_enforcement", OPT_OFFSET(no_partition_enforcement), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "qos", OPT_OFFSET(qos), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "qos_policy_file", OPT_OFFSET(qos_policy_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "dump_files_dir", OPT_OFFSET(dump_files_dir), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "lid_matrix_dump_file", OPT_OFFSET(lid_matrix_dump_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "lfts_file", OPT_OFFSET(lfts_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "root_guid_file", OPT_OFFSET(root_guid_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "port_shifting", OPT_OFFSET(port_shifting), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_store_uint32, opts_diff_uint32, NULL, 0 },
+	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_store_uint16, opts_diff_uint16, NULL, 0 },
+	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "sa_db_dump", OPT_OFFSET(sa_db_dump), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "torus_config", OPT_OFFSET(torus_conf_file), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "daemon", OPT_OFFSET(daemon), opts_store_boolean, opts_diff_boolean, NULL, 0 },
+	{ "sm_inactive", OPT_OFFSET(sm_inactive), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "use_optimized_slvl", OPT_OFFSET(use_optimized_slvl), opts_store_boolean, opts_diff_boolean, NULL, 1 },
 #ifdef ENABLE_OSM_PERF_MGR
-	{ "perfmgr", OPT_OFFSET(perfmgr), opts_parse_boolean, NULL, 0 },
-	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_parse_boolean, NULL, 0 },
-	{ "perfmgr_sweep_time_s", OPT_OFFSET(perfmgr_sweep_time_s), opts_parse_uint16, NULL, 0 },
-	{ "perfmgr_max_outstanding_queries", OPT_OFFSET(perfmgr_max_outstanding_queries), opts_parse_uint32, NULL, 0 },
-	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_parse_charp, NULL, 0 },
+	{ "perfmgr", OPT_OFFSET(perfmgr), opts_store_boolean, opts_diff_boolean, NULL, 0 },
+	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_store_boolean, opts_diff_boolean, NULL, 0 },
+	{ "perfmgr_sweep_time_s", OPT_OFFSET(perfmgr_sweep_time_s), opts_store_uint16, opts_diff_uint16, NULL, 0 },
+	{ "perfmgr_max_outstanding_queries", OPT_OFFSET(perfmgr_max_outstanding_queries), opts_store_uint32, opts_diff_uint32, NULL, 0 },
+	{ "event_db_dump_file", OPT_OFFSET(event_db_dump_file), opts_store_charp, opts_diff_charp, NULL, 0 },
 #endif				/* ENABLE_OSM_PERF_MGR */
-	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_parse_charp, NULL, 0 },
-	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_parse_charp, NULL, 0 },
-	{ "node_name_map_name", OPT_OFFSET(node_name_map_name), opts_parse_charp, NULL, 0 },
-	{ "qos_max_vls", OPT_OFFSET(qos_options.max_vls), opts_parse_uint32, NULL, 1 },
-	{ "qos_high_limit", OPT_OFFSET(qos_options.high_limit), opts_parse_int32, NULL, 1 },
-	{ "qos_vlarb_high", OPT_OFFSET(qos_options.vlarb_high), opts_parse_charp, NULL, 1 },
-	{ "qos_vlarb_low", OPT_OFFSET(qos_options.vlarb_low), opts_parse_charp, NULL, 1 },
-	{ "qos_sl2vl", OPT_OFFSET(qos_options.sl2vl), opts_parse_charp, NULL, 1 },
-	{ "qos_ca_max_vls", OPT_OFFSET(qos_ca_options.max_vls), opts_parse_uint32, NULL, 1 },
-	{ "qos_ca_high_limit", OPT_OFFSET(qos_ca_options.high_limit), opts_parse_int32, NULL, 1 },
-	{ "qos_ca_vlarb_high", OPT_OFFSET(qos_ca_options.vlarb_high), opts_parse_charp, NULL, 1 },
-	{ "qos_ca_vlarb_low", OPT_OFFSET(qos_ca_options.vlarb_low), opts_parse_charp, NULL, 1 },
-	{ "qos_ca_sl2vl", OPT_OFFSET(qos_ca_options.sl2vl), opts_parse_charp, NULL, 1 },
-	{ "qos_sw0_max_vls", OPT_OFFSET(qos_sw0_options.max_vls), opts_parse_uint32, NULL, 1 },
-	{ "qos_sw0_high_limit", OPT_OFFSET(qos_sw0_options.high_limit), opts_parse_int32, NULL, 1 },
-	{ "qos_sw0_vlarb_high", OPT_OFFSET(qos_sw0_options.vlarb_high), opts_parse_charp, NULL, 1 },
-	{ "qos_sw0_vlarb_low", OPT_OFFSET(qos_sw0_options.vlarb_low), opts_parse_charp, NULL, 1 },
-	{ "qos_sw0_sl2vl", OPT_OFFSET(qos_sw0_options.sl2vl), opts_parse_charp, NULL, 1 },
-	{ "qos_swe_max_vls", OPT_OFFSET(qos_swe_options.max_vls), opts_parse_uint32, NULL, 1 },
-	{ "qos_swe_high_limit", OPT_OFFSET(qos_swe_options.high_limit), opts_parse_int32, NULL, 1 },
-	{ "qos_swe_vlarb_high", OPT_OFFSET(qos_swe_options.vlarb_high), opts_parse_charp, NULL, 1 },
-	{ "qos_swe_vlarb_low", OPT_OFFSET(qos_swe_options.vlarb_low), opts_parse_charp, NULL, 1 },
-	{ "qos_swe_sl2vl", OPT_OFFSET(qos_swe_options.sl2vl), opts_parse_charp, NULL, 1 },
-	{ "qos_rtr_max_vls", OPT_OFFSET(qos_rtr_options.max_vls), opts_parse_uint32, NULL, 1 },
-	{ "qos_rtr_high_limit", OPT_OFFSET(qos_rtr_options.high_limit), opts_parse_int32, NULL, 1 },
-	{ "qos_rtr_vlarb_high", OPT_OFFSET(qos_rtr_options.vlarb_high), opts_parse_charp, NULL, 1 },
-	{ "qos_rtr_vlarb_low", OPT_OFFSET(qos_rtr_options.vlarb_low), opts_parse_charp, NULL, 1 },
-	{ "qos_rtr_sl2vl", OPT_OFFSET(qos_rtr_options.sl2vl), opts_parse_charp, NULL, 1 },
-	{ "enable_quirks", OPT_OFFSET(enable_quirks), opts_parse_boolean, NULL, 1 },
-	{ "no_clients_rereg", OPT_OFFSET(no_clients_rereg), opts_parse_boolean, NULL, 1 },
-	{ "prefix_routes_file", OPT_OFFSET(prefix_routes_file), opts_parse_charp, NULL, 0 },
-	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
-	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
-	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
-	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
-	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_parse_uint32, NULL, 1 },
+	{ "event_plugin_name", OPT_OFFSET(event_plugin_name), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "event_plugin_options", OPT_OFFSET(event_plugin_options), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "node_name_map_name", OPT_OFFSET(node_name_map_name), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "qos_max_vls", OPT_OFFSET(qos_options.max_vls), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "qos_high_limit", OPT_OFFSET(qos_options.high_limit), opts_store_int32, opts_diff_int32, NULL, 1 },
+	{ "qos_vlarb_high", OPT_OFFSET(qos_options.vlarb_high), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_vlarb_low", OPT_OFFSET(qos_options.vlarb_low), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_sl2vl", OPT_OFFSET(qos_options.sl2vl), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_ca_max_vls", OPT_OFFSET(qos_ca_options.max_vls), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "qos_ca_high_limit", OPT_OFFSET(qos_ca_options.high_limit), opts_store_int32, opts_diff_int32, NULL, 1 },
+	{ "qos_ca_vlarb_high", OPT_OFFSET(qos_ca_options.vlarb_high), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_ca_vlarb_low", OPT_OFFSET(qos_ca_options.vlarb_low), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_ca_sl2vl", OPT_OFFSET(qos_ca_options.sl2vl), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_sw0_max_vls", OPT_OFFSET(qos_sw0_options.max_vls), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "qos_sw0_high_limit", OPT_OFFSET(qos_sw0_options.high_limit), opts_store_int32, opts_diff_int32, NULL, 1 },
+	{ "qos_sw0_vlarb_high", OPT_OFFSET(qos_sw0_options.vlarb_high), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_sw0_vlarb_low", OPT_OFFSET(qos_sw0_options.vlarb_low), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_sw0_sl2vl", OPT_OFFSET(qos_sw0_options.sl2vl), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_swe_max_vls", OPT_OFFSET(qos_swe_options.max_vls), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "qos_swe_high_limit", OPT_OFFSET(qos_swe_options.high_limit), opts_store_int32, opts_diff_int32, NULL, 1 },
+	{ "qos_swe_vlarb_high", OPT_OFFSET(qos_swe_options.vlarb_high), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_swe_vlarb_low", OPT_OFFSET(qos_swe_options.vlarb_low), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_swe_sl2vl", OPT_OFFSET(qos_swe_options.sl2vl), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_rtr_max_vls", OPT_OFFSET(qos_rtr_options.max_vls), opts_store_uint32, opts_diff_uint32, NULL, 1 },
+	{ "qos_rtr_high_limit", OPT_OFFSET(qos_rtr_options.high_limit), opts_store_int32, opts_diff_int32, NULL, 1 },
+	{ "qos_rtr_vlarb_high", OPT_OFFSET(qos_rtr_options.vlarb_high), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_rtr_vlarb_low", OPT_OFFSET(qos_rtr_options.vlarb_low), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "qos_rtr_sl2vl", OPT_OFFSET(qos_rtr_options.sl2vl), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "enable_quirks", OPT_OFFSET(enable_quirks), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "no_clients_rereg", OPT_OFFSET(no_clients_rereg), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "prefix_routes_file", OPT_OFFSET(prefix_routes_file), opts_store_charp, opts_diff_charp, NULL, 0 },
+	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_store_boolean, opts_diff_boolean, NULL, 1 },
+	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "sm_sl", OPT_OFFSET(sm_sl), opts_store_uint8, opts_diff_uint8, NULL, 1 },
+	{ "log_prefix", OPT_OFFSET(log_prefix), opts_store_charp, opts_diff_charp, NULL, 1 },
+	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_store_uint32, opts_diff_uint32, NULL, 1 },
 	{0}
 };
 
@@ -597,7 +728,10 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 	}
 
 	subn_opt_destroy(&p_subn->opt);
-	free(p_subn->opt.file_opts);
+	subn_opt_destroy(p_subn->opt.old_file_opts);
+	subn_opt_destroy(p_subn->opt.new_file_opts);
+	free(p_subn->opt.old_file_opts);
+	free(p_subn->opt.new_file_opts);
 }
 
 ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
@@ -760,21 +894,13 @@ int is_mlnx_ext_port_info_supported(ib_net16_t devid)
 	return 0;
 }
 
-static void subn_init_qos_options(osm_qos_options_t *opt, osm_qos_options_t *f)
+static void subn_init_qos_options(osm_qos_options_t *opt)
 {
 	opt->max_vls = 0;
 	opt->high_limit = -1;
-	if (opt->vlarb_high)
-		free(opt->vlarb_high);
 	opt->vlarb_high = NULL;
-	if (opt->vlarb_low)
-		free(opt->vlarb_low);
 	opt->vlarb_low = NULL;
-	if (opt->sl2vl)
-		free(opt->sl2vl);
 	opt->sl2vl = NULL;
-	if (f)
-		memcpy(f, opt, sizeof(*f));
 }
 
 void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
@@ -884,11 +1010,11 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
 	p_opt->scatter_ports = OSM_DEFAULT_SCATTER_PORTS;
-	subn_init_qos_options(&p_opt->qos_options, NULL);
-	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
-	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
-	subn_init_qos_options(&p_opt->qos_swe_options, NULL);
-	subn_init_qos_options(&p_opt->qos_rtr_options, NULL);
+	subn_init_qos_options(&p_opt->qos_options);
+	subn_init_qos_options(&p_opt->qos_ca_options);
+	subn_init_qos_options(&p_opt->qos_sw0_options);
+	subn_init_qos_options(&p_opt->qos_swe_options);
+	subn_init_qos_options(&p_opt->qos_rtr_options);
 }
 
 static char *clean_val(char *val)
@@ -1270,7 +1396,8 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 	FILE *opts_file;
 	char *p_key, *p_val;
 	const opt_rec_t *r;
-	void *p_field1, *p_field2;
+	void *p_field;
+	boolean_t *p_parsed;
 
 	opts_file = fopen(file_name, "r");
 	if (!opts_file) {
@@ -1285,12 +1412,21 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 	cl_log_event("OpenSM", CL_LOG_INFO, line, NULL, 0);
 
 	p_opts->config_file = file_name;
-	if (!p_opts->file_opts && !(p_opts->file_opts = malloc(sizeof(*p_opts)))) {
+	if (!p_opts->old_file_opts && !(p_opts->old_file_opts = malloc(sizeof(*p_opts)))) {
 		fclose(opts_file);
 		return -1;
 	}
-	memcpy(p_opts->file_opts, p_opts, sizeof(*p_opts));
-	p_opts->file_opts->file_opts = NULL;
+	osm_subn_set_default_opt(p_opts->old_file_opts);
+	p_opts->old_file_opts->old_file_opts = NULL;
+	p_opts->old_file_opts->new_file_opts = NULL;
+
+	if (!p_opts->new_file_opts && !(p_opts->new_file_opts = malloc(sizeof(*p_opts)))) {
+		fclose(opts_file);
+		return -1;
+	}
+	osm_subn_set_default_opt(p_opts->new_file_opts);
+	p_opts->new_file_opts->old_file_opts = NULL;
+	p_opts->new_file_opts->new_file_opts = NULL;
 
 	while (fgets(line, 1023, opts_file) != NULL) {
 		/* get the first token */
@@ -1304,16 +1440,36 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
 			if (strcmp(r->name, p_key))
 				continue;
 
-			p_field1 = (void *)p_opts->file_opts + r->opt_offset;
-			p_field2 = (void *)p_opts + r->opt_offset;
-			/* don't call setup function first time */
-			r->parse_fn(NULL, p_key, p_val, p_field1, p_field2,
-				    NULL);
+			p_field = (void *)p_opts->new_file_opts + r->opt_offset;
+			p_parsed = (void *)p_opts->new_file_opts + r->parsed_offset;
+			r->store_fn(p_val, p_field, p_parsed);
 			break;
 		}
 	}
 	fclose(opts_file);
 
+	/* diff values from new file parse, compare to old file parse,
+ 	 * and store values appropriately if there are differences.
+ 	 *
+ 	 * Since this is the first time we're parsing, any non-defaults
+ 	 * in the config file will simply be loaded.
+ 	 */ 
+	for (r = opt_tbl; r->name; r++) {
+		void *p_field_main, *p_field_old_file, *p_field_new_file;
+		boolean_t *p_old_file_parsed, *p_new_file_parsed;
+
+		p_field_main = (void *)p_opts + r->opt_offset;
+		p_field_old_file = (void *)p_opts->old_file_opts + r->opt_offset;
+		p_field_new_file = (void *)p_opts->new_file_opts + r->opt_offset;
+		p_old_file_parsed = (void *)p_opts->old_file_opts + r->parsed_offset;
+		p_new_file_parsed = (void *)p_opts->new_file_opts + r->parsed_offset;
+		/* don't call setup function first time */
+		/* first time, don't compare parse history, we know it'll be different */
+		r->diff_fn(NULL, r->name, p_field_main, p_field_old_file,
+			   p_field_new_file, p_old_file_parsed, p_new_file_parsed, FALSE,
+			   NULL);
+	}
+
 	osm_subn_verify_config(p_opts);
 
 	return 0;
@@ -1326,7 +1482,8 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 	const opt_rec_t *r;
 	FILE *opts_file;
 	char *p_key, *p_val;
-	void *p_field1, *p_field2;
+	void *p_field;
+	boolean_t *p_parsed;
 
 	if (!p_opts->config_file)
 		return 0;
@@ -1341,16 +1498,9 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 		return -1;
 	}
 
-	subn_init_qos_options(&p_opts->qos_options,
-			      &p_opts->file_opts->qos_options);
-	subn_init_qos_options(&p_opts->qos_ca_options,
-			      &p_opts->file_opts->qos_ca_options);
-	subn_init_qos_options(&p_opts->qos_sw0_options,
-			      &p_opts->file_opts->qos_sw0_options);
-	subn_init_qos_options(&p_opts->qos_swe_options,
-			      &p_opts->file_opts->qos_swe_options);
-	subn_init_qos_options(&p_opts->qos_rtr_options,
-			      &p_opts->file_opts->qos_rtr_options);
+	/* destroy & reset new file options */
+	subn_opt_destroy(p_opts->new_file_opts);
+	osm_subn_set_default_opt(p_opts->new_file_opts);	
 
 	while (fgets(line, 1023, opts_file) != NULL) {
 		/* get the first token */
@@ -1364,15 +1514,32 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 			if (!r->can_update || strcmp(r->name, p_key))
 				continue;
 
-			p_field1 = (void *)p_opts->file_opts + r->opt_offset;
-			p_field2 = (void *)p_opts + r->opt_offset;
-			r->parse_fn(p_subn, p_key, p_val, p_field1, p_field2,
-				    r->setup_fn);
+			p_field = (void *)p_opts->new_file_opts + r->opt_offset;
+			p_parsed = (void *)p_opts->new_file_opts + r->parsed_offset;
+			r->store_fn(p_val, p_field, p_parsed);
 			break;
 		}
 	}
 	fclose(opts_file);
 
+	/* diff and copy over values to primary opt */
+	for (r = opt_tbl; r->name; r++) {
+		void *p_field_main, *p_field_old_file, *p_field_new_file;
+		boolean_t *p_old_file_parsed, *p_new_file_parsed;
+
+		if (!r->can_update)
+			continue;
+
+		p_field_main = (void *)p_opts + r->opt_offset;
+		p_field_old_file = (void *)p_opts->old_file_opts + r->opt_offset;
+		p_field_new_file = (void *)p_opts->new_file_opts + r->opt_offset;
+		p_old_file_parsed = (void *)p_opts->old_file_opts + r->parsed_offset;
+		p_new_file_parsed = (void *)p_opts->new_file_opts + r->parsed_offset;
+		r->diff_fn(p_subn, r->name, p_field_main, p_field_old_file,
+			   p_field_new_file, p_old_file_parsed, p_new_file_parsed, TRUE,
+			   r->setup_fn);
+	}
+
 	osm_subn_verify_config(p_opts);
 
 	parse_prefix_routes_file(p_subn);
-- 
1.7.1





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
