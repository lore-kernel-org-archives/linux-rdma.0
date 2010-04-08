From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/4] opensm: added 2 options: dump PRs and filename
Date: Thu, 08 Apr 2010 16:29:20 +0300
Message-ID: <4BBDDA30.6090302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schut <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |   10 ++++++++++
 opensm/opensm/osm_subnet.c         |   14 ++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 3970e98..8d7182b 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -201,6 +201,8 @@ typedef struct osm_subn_opt {
 	char *guid_routing_order_file;
 	char *sa_db_file;
 	boolean_t sa_db_dump;
+	boolean_t path_rec_dump;
+	char *path_rec_file;
 	boolean_t do_mesh_analysis;
 	boolean_t exit_on_fatal;
 	boolean_t honor_guid2lid_file;
@@ -418,6 +420,14 @@ typedef struct osm_subn_opt {
 *		When TRUE causes OpenSM to dump SA DB at the end of every
 *		light sweep regardless the current verbosity level.
 *
+*	path_rec_file
+*		Name of the PathRecords dump file.
+*
+*	path_rec_dump
+*		When TRUE causes OpenSM to dump PathRecords for all the
+*		CA-2-CA paths at the end of every heavy sweep, regardless
+*		of the verbosity level.
+*
 *	exit_on_fatal
 *		If TRUE (default) - SM will exit on fatal subnet initialization
 *		issues.
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index e4126bc..c87ed2a 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -757,6 +757,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->guid_routing_order_file = NULL;
 	p_opt->sa_db_file = NULL;
 	p_opt->sa_db_dump = FALSE;
+	p_opt->path_rec_file = NULL;
+	p_opt->path_rec_dump = FALSE;
 	p_opt->do_mesh_analysis = FALSE;
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->enable_quirks = FALSE;
@@ -1464,6 +1466,18 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->sa_db_dump ? "TRUE" : "FALSE");

 	fprintf(out,
+		"# PathRecords dump file name\n"
+		"path_rec_file %s\n\n",
+		p_opts->path_rec_file ? p_opts->path_rec_file : null_str);
+
+	fprintf(out,
+		"# If TRUE causes OpenSM to dump PathRecords for all the\n"
+		"# CA-2-CA paths at the end of every heavy sweep, regardless\n"
+		"# of the verbosity level\n"
+		"path_rec_dump %s\n\n",
+		p_opts->path_rec_dump ? "TRUE" : "FALSE");
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
