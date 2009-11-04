From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3 v2] opensm SA DB dump/restore: added option to dump SA
 DB on every sweep
Date: Wed, 04 Nov 2009 13:00:44 +0200
Message-ID: <4AF15EDC.5000700@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added option to dump SA DB at every sweep (both heavy
and light): 'sa_db_dump'.
The option is not exposed through OSM command line,
but only through options file.

[v2 - no changes, just rebased to the current head]

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    5 +++++
 opensm/opensm/osm_state_mgr.c      |    5 ++++-
 opensm/opensm/osm_subnet.c         |    8 ++++++++
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 871a833..7bc59f8 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -201,6 +201,7 @@ typedef struct osm_subn_opt {
 	char *guid_routing_order_file;
 	char *sa_db_file;
 	boolean_t sa_db_load_once;
+	boolean_t sa_db_dump;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
@@ -416,6 +417,10 @@ typedef struct osm_subn_opt {
 *		When TRUE causes sa_db_file to be loaded only at the
 *		first master sweep.
 *
+*	sa_db_dump
+*		When TRUE causes OpenSM to dump SA DB at the end of every
+*		light sweep regardless the current verbosity level.
+*
 *	exit_on_fatal
 *		If TRUE (default) - SM will exit on fatal subnet initialization
 *		issues.
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 4303d6e..9bca7e0 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1078,6 +1078,8 @@ static void do_sweep(osm_sm_t * sm)
 		if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 			return;
 		if (!sm->p_subn->force_heavy_sweep) {
+			if (sm->p_subn->opt.sa_db_dump)
+				osm_sa_db_file_dump(sm->p_subn->p_osm);
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"LIGHT SWEEP COMPLETE");
 			return;
@@ -1342,7 +1344,8 @@ _repeat_discovery:
 		state_mgr_up_msg(sm);
 		sm->p_subn->first_time_master_sweep = FALSE;

-		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE))
+		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE) ||
+		    sm->p_subn->opt.sa_db_dump)
 			osm_sa_db_file_dump(sm->p_subn->p_osm);
 	}

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index b0ffddd..47cd7d9 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -349,6 +349,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_load_once", OPT_OFFSET(sa_db_load_once), opts_parse_boolean, NULL, 1 },
+	{ "sa_db_dump", OPT_OFFSET(sa_db_dump), opts_parse_boolean, NULL, 1 },
 	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_parse_boolean, NULL, 1 },
 	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_parse_boolean, NULL, 1 },
 	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_parse_boolean, NULL, 1 },
@@ -748,6 +749,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->guid_routing_order_file = NULL;
 	p_opt->sa_db_file = NULL;
 	p_opt->sa_db_load_once = FALSE;
+	p_opt->sa_db_dump = FALSE;
 	p_opt->do_mesh_analysis = FALSE;
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->enable_quirks = FALSE;
@@ -1453,6 +1455,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->sa_db_load_once ? "TRUE" : "FALSE");

 	fprintf(out,
+		"# If TRUE causes OpenSM to dump SA database at the end of\n"
+		"# every light sweep, regardless of the verbosity level\n"
+		"sa_db_dump %s\n\n",
+		p_opts->sa_db_dump ? "TRUE" : "FALSE");
+
+	fprintf(out,
 		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
 		"# SM priority used for deciding who is the master\n"
 		"# Range goes from 0 (lowest priority) to 15 (highest).\n"
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
