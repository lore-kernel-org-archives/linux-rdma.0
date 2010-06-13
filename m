From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: Allow connectivity between switches in up down and
 fat tree
Date: Sun, 13 Jun 2010 16:57:39 +0300
Message-ID: <4C14E3D3.4070601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify option connect_roots to connect_switches and allow connectivity
between all switches (not only root nodes) in up down and fat tree routing algorithms

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    6 +++---
 opensm/man/opensm.8.in             |    6 +++---
 opensm/opensm/main.c               |    8 ++++----
 opensm/opensm/osm_subnet.c         |   10 +++++-----
 opensm/opensm/osm_ucast_ftree.c    |    2 +-
 opensm/opensm/osm_ucast_updn.c     |    6 ++----
 6 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 95a635c..9ef4c9e 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -193,7 +193,7 @@ typedef struct osm_subn_opt {
 	boolean_t sweep_on_trap;
 	char *routing_engine_names;
 	boolean_t use_ucast_cache;
-	boolean_t connect_roots;
+	boolean_t connect_switches;
 	char *lid_matrix_dump_file;
 	char *lfts_file;
 	char *root_guid_file;
@@ -388,8 +388,8 @@ typedef struct osm_subn_opt {
 *	routing_engine_names
 *		Name of routing engine(s) to use.
 *
-*	connect_roots
-*		The option which will enforce root to root connectivity with
+*	connect_switches
+*		The option which will enforce all switch connectivity with
 *		up/down and fat-tree routing engines (even if this violates
 *		"pure" deadlock free up/down or fat-tree algorithm)
 *
diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 9053611..e530320 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -18,7 +18,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-do_mesh_analysis]
 [\-\-lash_start_vl <vl number>]
 [\-A | \-\-ucast_cache]
-[\-z | \-\-connect_roots]
+[\-z | \-\-connect_switches]
 [\-M <file name> | \-\-lid_matrix_file <file name>]
 [\-U <file name> | \-\-lfts_file <file name>]
 [\-S | \-\-sadb_file <file name>]
@@ -172,9 +172,9 @@ is host reboot, which otherwise would cause two full routing
 recalculations: one when the host goes down, and the other when
 the host comes back online.
 .TP
-\fB\-z\fR, \fB\-\-connect_roots\fR
+\fB\-z\fR, \fB\-\-connect_switches\fR
 This option enforces routing engines (up/down and
-fat-tree) to make connectivity between root switches and in
+fat-tree) to make connectivity between all switches and in
 this way to be fully IBA complaint. In many cases this can
 violate "pure" deadlock free algorithm, so use it carefully.
 .TP
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 0093aa7..95f4432 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -185,7 +185,7 @@ static void show_usage(void)
 	       "          Defaults to 0.\n");
 	printf("--sm_sl <sl number>\n"
 	       "          Sets the SL to use to communicate with the SM/SA. Defaults to 0.\n\n");
-	printf("--connect_roots, -z\n"
+	printf("--connect_switches, -z\n"
 	       "          This option enforces routing engines (up/down and \n"
 	       "          fat-tree) to make connectivity between root switches\n"
 	       "          and in this way be IBA compliant. In many cases,\n"
@@ -587,7 +587,7 @@ int main(int argc, char *argv[])
 		{"smkey", 1, NULL, 'k'},
 		{"routing_engine", 1, NULL, 'R'},
 		{"ucast_cache", 0, NULL, 'A'},
-		{"connect_roots", 0, NULL, 'z'},
+		{"connect_switches", 0, NULL, 'z'},
 		{"lid_matrix_file", 1, NULL, 'M'},
 		{"lfts_file", 1, NULL, 'U'},
 		{"sadb_file", 1, NULL, 'S'},
@@ -887,8 +887,8 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'z':
-			opt.connect_roots = TRUE;
-			printf(" Connect roots option is on\n");
+			opt.connect_switches = TRUE;
+			printf(" Connect switches option is on\n");
 			break;
 
 		case 'A':
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index d5c5ab2..054df50 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -330,7 +330,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
 	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
 	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
-	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
+	{ "connect_switches", OPT_OFFSET(connect_switches), opts_parse_boolean, NULL, 1 },
 	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 0 },
 	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
 	{ "log_max_size", OPT_OFFSET(log_max_size), opts_parse_uint32, opts_setup_log_max_size, 1 },
@@ -741,7 +741,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->sweep_on_trap = TRUE;
 	p_opt->use_ucast_cache = FALSE;
 	p_opt->routing_engine_names = NULL;
-	p_opt->connect_roots = FALSE;
+	p_opt->connect_switches = FALSE;
 	p_opt->lid_matrix_dump_file = NULL;
 	p_opt->lfts_file = NULL;
 	p_opt->root_guid_file = NULL;
@@ -1401,9 +1401,9 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->routing_engine_names : null_str);
 
 	fprintf(out,
-		"# Connect roots (use FALSE if unsure)\n"
-		"connect_roots %s\n\n",
-		p_opts->connect_roots ? "TRUE" : "FALSE");
+		"# Connect switches (use FALSE if unsure)\n"
+		"connect_switches %s\n\n",
+		p_opts->connect_switches ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"# Use unicast routing cache (use FALSE if unsure)\n"
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 88ea344..8842073 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -4061,7 +4061,7 @@ static int do_routing(IN void *context)
 		"Filling switch forwarding tables for switch-to-switch paths\n");
 	fabric_route_to_switches(p_ftree);
 
-	if (p_ftree->p_osm->subn.opt.connect_roots) {
+	if (p_ftree->p_osm->subn.opt.connect_switches) {
 		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 			"Connecting switches that are unreachable within "
 			"Up/Down rules\n");
diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index 164c6f4..7619711 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -314,9 +314,7 @@ static int updn_set_min_hop_table(IN updn_t * p_updn)
 	     item = cl_qmap_next(item)) {
 		p_sw = (osm_switch_t *)item;
 		/* Clear Min Hop Table */
-		if (p_subn->opt.connect_roots)
-			updn_clear_non_root_hops(p_updn, p_sw);
-		else
+		if (!p_subn->opt.connect_switches)
 			osm_switch_clear_hops(p_sw);
 	}
 
@@ -596,7 +594,7 @@ static int updn_lid_matrices(void *ctx)
 			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR : "
 				"cannot parse root guids file \'%s\'\n",
 				p_updn->p_osm->subn.opt.root_guid_file);
-		if (p_updn->p_osm->subn.opt.connect_roots &&
+		if (p_updn->p_osm->subn.opt.connect_switches &&
 		    p_updn->num_roots > 1)
 			osm_ucast_mgr_build_lid_matrices(&p_updn->p_osm->sm.ucast_mgr);
 	} else {
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
