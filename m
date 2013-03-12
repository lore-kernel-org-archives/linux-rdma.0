From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Fix issues causing const warnings for strings
Date: Tue, 12 Mar 2013 09:45:23 -0400
Message-ID: <513F3173.4080908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/complib/Makefile.am b/complib/Makefile.am
index 3ee90e8..360deab 100644
--- a/complib/Makefile.am
+++ b/complib/Makefile.am
@@ -9,7 +9,7 @@ else
 DBGFLAGS = -g
 endif
 
-libosmcomp_la_CFLAGS = -Wall $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
+libosmcomp_la_CFLAGS = -Wall -Wwrite-strings $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
 
 if HAVE_LD_VERSION_SCRIPT
     libosmcomp_version_script = -Wl,--version-script=$(srcdir)/libosmcomp.map
diff --git a/complib/cl_nodenamemap.c b/complib/cl_nodenamemap.c
index f47ad40..8ac88cd 100644
--- a/complib/cl_nodenamemap.c
+++ b/complib/cl_nodenamemap.c
@@ -74,7 +74,7 @@ static int map_name(void *cxt, uint64_t guid, char *p)
 	return 0;
 }
 
-nn_map_t *open_node_name_map(char *node_name_map)
+nn_map_t *open_node_name_map(const char *node_name_map)
 {
 	nn_map_t *map;
 	char linebuf[PARSE_NODE_MAP_BUFLEN + 1];
diff --git a/include/complib/cl_nodenamemap.h b/include/complib/cl_nodenamemap.h
index 97984b1..bfe290b 100644
--- a/include/complib/cl_nodenamemap.h
+++ b/include/complib/cl_nodenamemap.h
@@ -54,7 +54,7 @@ typedef cl_qmap_t nn_map_t;
  * Node name map interface.
  * It is OK to pass NULL for the node_name_map[_fp] parameters.
  */
-nn_map_t *open_node_name_map(char *node_name_map);
+nn_map_t *open_node_name_map(const char *node_name_map);
 void  close_node_name_map(nn_map_t *map);
 char *remap_node_name(nn_map_t *map, uint64_t target_guid, char *nodedesc);
 	/* NOTE: parameter "nodedesc" may be modified here. */
diff --git a/include/opensm/osm_db.h b/include/opensm/osm_db.h
index d05bfa0..05332c0 100644
--- a/include/opensm/osm_db.h
+++ b/include/opensm/osm_db.h
@@ -212,7 +212,7 @@ int osm_db_init(IN osm_db_t * p_db, IN struct osm_log * p_log);
 *
 * SYNOPSIS
 */
-osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name);
+osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN const char *domain_name);
 /*
 * PARAMETERS
 *
diff --git a/libvendor/Makefile.am b/libvendor/Makefile.am
index 22f7a08..a4dc229 100644
--- a/libvendor/Makefile.am
+++ b/libvendor/Makefile.am
@@ -11,7 +11,7 @@ INCLUDES = $(OSMV_INCLUDES)
 
 lib_LTLIBRARIES = libosmvendor.la
 
-libosmvendor_la_CFLAGS = -Wall $(DBGFLAGS)
+libosmvendor_la_CFLAGS = -Wall -Wwrite-strings $(DBGFLAGS)
 
 if HAVE_LD_VERSION_SCRIPT
     libosmvendor_version_script = -Wl,--version-script=$(srcdir)/libosmvendor.map
diff --git a/opensm/Makefile.am b/opensm/Makefile.am
index 7fd6bc6..ff9489b 100644
--- a/opensm/Makefile.am
+++ b/opensm/Makefile.am
@@ -1,7 +1,7 @@
 
 INCLUDES = $(OSMV_INCLUDES)
 
-AM_CFLAGS = -Wall $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
+AM_CFLAGS = -Wall -Wwrite-strings $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
 
 lib_LTLIBRARIES = libopensm.la
 
diff --git a/opensm/main.c b/opensm/main.c
index 1a061a8..db5429a 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -718,7 +718,7 @@ int main(int argc, char *argv[])
 	optind = 0;		/* reset command line */
 
 	if (!config_file)
-		config_file = OSM_DEFAULT_CONFIG_FILE;
+		config_file = strdup(OSM_DEFAULT_CONFIG_FILE);
 
 	osm_subn_set_default_opt(&opt);
 
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index c393ce6..0f80bdb 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -62,7 +62,7 @@
 extern void osm_update_node_desc(IN osm_opensm_t *osm);
 
 struct command {
-	char *name;
+	const char *name;
 	void (*help_function) (FILE * out, int detail);
 	void (*parse_function) (char **p_last, osm_opensm_t * p_osm,
 				FILE * out);
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 9f338f3..bea3b05 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -108,7 +108,7 @@ typedef struct osm_db_domain_imp {
  * SYNOPSIS
  */
 typedef struct osm_db_imp {
-	char *db_dir_name;
+	const char *db_dir_name;
 } osm_db_imp_t;
 /*
  * FIELDS
@@ -206,7 +206,7 @@ err:
 	return 1;
 }
 
-osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name)
+osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN const char *domain_name)
 {
 	osm_db_domain_t *p_domain;
 	osm_db_domain_imp_t *p_domain_imp;
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 00a29d0..443030f 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -370,7 +370,7 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 	osm_node_t *p_nbnode;
 	osm_physp_t *p_physp, *p_default_physp, *p_rphysp;
 	uint8_t link_speed_act;
-	char *link_speed_act_str;
+	const char *link_speed_act_str;
 
 	if (!p_node->node_info.num_ports)
 		return;
@@ -493,8 +493,8 @@ static void dump_sl2vl_tbl(cl_map_item_t * item, FILE * file, void *cxt)
 	ib_slvl_table_t *p_tbl;
 	int i, n;
 	char buf[1024];
-	char * header_line =	"#in out : 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15";
-	char * separator_line = "#--------------------------------------------------------";
+	const char * header_line =	"#in out : 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15";
+	const char * separator_line = "#--------------------------------------------------------";
 
 	if (!num_ports)
 		return;
diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index 2b7efe6..327a89a 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -62,7 +62,7 @@ static int log_exit_count = 0;
 #include <unistd.h>
 #include <complib/cl_timer.h>
 
-static char *month_str[] = {
+static const char *month_str[] = {
 	"Jan",
 	"Feb",
 	"Mar",
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index d17315f..92e1a39 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -733,7 +733,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 
 static void dump_hr_dc(FILE *fp, uint64_t val64, int data)
 {
-	char *unit = "";
+	const char *unit = "";
 	uint64_t tmp = val64;
 	float val = 0.0;
 	int ui = 0;
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 7a1f31c..b52e227 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -92,7 +92,7 @@ pkey_mgr_process_physical_port(IN osm_log_t * p_log,
 	osm_node_t *p_node = osm_physp_get_node_ptr(p_physp);
 	osm_pkey_tbl_t *p_pkey_tbl;
 	ib_net16_t *p_orig_pkey;
-	char *stat = NULL;
+	const char *stat = NULL;
 	osm_pending_pkey_t *p_pending;
 
 	p_pkey_tbl = &p_physp->pkeys;
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 873fb55..391e38c 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -748,7 +748,7 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 
 static osm_qos_level_t *__qos_policy_get_qos_level_by_name(
 		const osm_qos_policy_t * p_qos_policy,
-		char *name)
+		const char *name)
 {
 	osm_qos_level_t *p_qos_level = NULL;
 	cl_list_iterator_t list_iterator;
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index b926fe0..8139f1a 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -1547,7 +1547,7 @@ bool link_tswitches(struct torus *t, int cdir,
 	int p;
 	struct port_grp *pg0, *pg1;
 	struct f_switch *f_sw0, *f_sw1;
-	char *cdir_name = "unknown";
+	const char *cdir_name = "unknown";
 	unsigned port_cnt;
 	int success = false;
 
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 99d6981..864e161 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -277,7 +277,7 @@ static inline boolean_t tuple_assigned(IN ftree_tuple_t tuple)
 
 #define FTREE_TUPLE_BUFFERS_NUM 6
 
-static char *tuple_to_str(IN ftree_tuple_t tuple)
+static const char *tuple_to_str(IN ftree_tuple_t tuple)
 {
 	static char buffer[FTREE_TUPLE_BUFFERS_NUM][FTREE_TUPLE_BUFF_LEN];
 	static uint8_t ind = 0;
@@ -1269,7 +1269,7 @@ static void fabric_dump_hca_ordering(IN ftree_fabric_t * p_ftree)
 
 	char path[1024];
 	FILE *p_hca_ordering_file;
-	char *filename = "opensm-ftree-ca-order.dump";
+	const char *filename = "opensm-ftree-ca-order.dump";
 
 	snprintf(path, sizeof(path), "%s/%s",
 		 p_ftree->p_osm->subn.opt.dump_files_dir, filename);
diff --git a/osmeventplugin/Makefile.am b/osmeventplugin/Makefile.am
index 79e3d55..28feedb 100644
--- a/osmeventplugin/Makefile.am
+++ b/osmeventplugin/Makefile.am
@@ -10,7 +10,7 @@ else
 DBGFLAGS = -g
 endif
 
-libosmeventplugin_la_CFLAGS = -Wall $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
+libosmeventplugin_la_CFLAGS = -Wall -Wwrite-strings $(DBGFLAGS) -D_XOPEN_SOURCE=600 -D_BSD_SOURCE=1
 
 if HAVE_LD_VERSION_SCRIPT
     libosmeventplugin_version_script = -Wl,--version-script=$(srcdir)/libosmeventplugin.map
diff --git a/osmtest/Makefile.am b/osmtest/Makefile.am
index 4c68852..f222a7c 100644
--- a/osmtest/Makefile.am
+++ b/osmtest/Makefile.am
@@ -13,7 +13,7 @@ osmtest_SOURCES = main.c osmtest.c osmt_service.c osmt_slvl_vl_arb.c \
 if OSMV_VAPI
 osmtest_SOURCES += osmt_mtl_regular_qp.c
 endif
-osmtest_CFLAGS = -Wall $(DBGFLAGS)
+osmtest_CFLAGS = -Wall -Wwrite-strings $(DBGFLAGS)
 osmtest_LDADD = -L../complib -losmcomp -L../libvendor -losmvendor -L../opensm -lopensm $(OSMV_LDADD)
 
 EXTRA_DIST = $(srcdir)/include/osmt_inform.h \
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
