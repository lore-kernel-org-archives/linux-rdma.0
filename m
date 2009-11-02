From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] opensm SA DB dump/restore: added option to load SA DB
 once
Date: Mon, 02 Nov 2009 12:42:39 +0200
Message-ID: <4AEEB79F.9030404@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added option to load SA DB once: 'sa_db_load_once'.
This will cause OSM to load SA DB once during first master
heavy sweep, and then OSM will move to the usual SA mode.

The option is not exposed through OSM command line,
but only through options file.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    5 +++++
 opensm/opensm/osm_sa.c             |   20 +++++++++++++++++++-
 opensm/opensm/osm_subnet.c         |    7 +++++++
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 0302f91..871a833 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -200,6 +200,7 @@ typedef struct osm_subn_opt {
 	char *ids_guid_file;
 	char *guid_routing_order_file;
 	char *sa_db_file;
+	boolean_t sa_db_load_once;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
@@ -411,6 +412,10 @@ typedef struct osm_subn_opt {
 *	sa_db_file
 *		Name of the SA database file.
 *
+*	sa_db_load_once
+*		When TRUE causes sa_db_file to be loaded only at the
+*		first master sweep.
+*
 *	exit_on_fatal
 *		If TRUE (default) - SM will exit on fatal subnet initialization
 *		issues.
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 4988dec..a5eb796 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -924,6 +924,12 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		return 0;
 	}

+	if (p_osm->subn.opt.sa_db_load_once && !p_osm->subn.first_time_master_sweep) {
+		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
+			"Not first sweep - skip SA DB restore\n");
+		return 0;
+	}
+
 	file = fopen(file_name, "r");
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 4C02: "
@@ -932,6 +938,10 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		return -1;
 	}

+	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
+		"Restoring SA DB from file \'%s\'\n",
+		file_name);
+
 	lineno = 0;

 	while (fgets(line, sizeof(line) - 1, file) != NULL) {
@@ -1108,7 +1118,15 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		}
 	}

-	if (!rereg_clients)
+	/*
+	 * If restoring SA DB is required only once, SM should go
+	 * into the usual mode right after that, which means that
+	 * client re-registration should be required even after
+	 * the restore - there is a chance that OSM died right after
+	 * some MCMember joined MCast group, and his membership
+	 * didn't make it into the SA DB file.
+	 */
+	if (!p_osm->subn.opt.sa_db_load_once && !rereg_clients)
 		p_osm->subn.opt.no_clients_rereg = TRUE;

 _error:
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index dde83e1..e9cfe9c 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -348,6 +348,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
+	{ "sa_db_load_once", OPT_OFFSET(sa_db_load_once), opts_parse_boolean, NULL, 1 },
 	{ "do_mesh_analysis", OPT_OFFSET(do_mesh_analysis), opts_parse_boolean, NULL, 1 },
 	{ "exit_on_fatal", OPT_OFFSET(exit_on_fatal), opts_parse_boolean, NULL, 1 },
 	{ "honor_guid2lid_file", OPT_OFFSET(honor_guid2lid_file), opts_parse_boolean, NULL, 1 },
@@ -766,6 +767,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
 	p_opt->sa_db_file = NULL;
+	p_opt->sa_db_load_once = FALSE;
 	p_opt->do_mesh_analysis = FALSE;
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->enable_quirks = FALSE;
@@ -1478,6 +1480,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);

 	fprintf(out,
+		"# If TRUE causes SA database to be loaded only at\n"
+		"# the first master sweep\nsa_db_load_once %s\n\n",
+		p_opts->sa_db_load_once ? "TRUE" : "FALSE");
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
