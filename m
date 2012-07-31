From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm: Remove unused per_module_logging option
Date: Tue, 31 Jul 2012 02:44:12 -0400
Message-ID: <50177EBC.9050001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 683204b..2321ecb 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -265,7 +265,6 @@ typedef struct osm_subn_opt {
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
-	boolean_t per_module_logging;
 	char *per_module_logging_file;
 } osm_subn_opt_t;
 /*
@@ -541,10 +540,6 @@ typedef struct osm_subn_opt {
 *		When not zero, randomize best possible ports chosen
 *		for a route. The value is used as a random key seed.
 *
-*	per_module_logging
-*		Enable/disable the per module logging feature.
-*		Default is disabled.
-*
 *	per_module_logging_file
 *		File name of per module logging configuration.
 *
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 789092f..0c58a25 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -338,29 +338,25 @@ static void loglevel_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 
 static void permodlog_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 {
-	fprintf(out, "Per module logging is %sabled\n",
-		p_osm->subn.opt.per_module_logging ? "en" : "dis");
-	if (p_osm->subn.opt.per_module_logging) {
-		FILE *fp;
-		char buf[1024];
-
-		fp = fopen(p_osm->subn.opt.per_module_logging_file, "r");
-		if (!fp) {
-			if (errno == ENOENT)
-				return;
-			fprintf(out, "fopen(%s) failed: %s\n",
-				p_osm->subn.opt.per_module_logging_file,
-				strerror(errno));
-			return;
-		}
+	FILE *fp;
+	char buf[1024];
 
-		fprintf(out, "Per module logging file: %s\n",
-			p_osm->subn.opt.per_module_logging_file);
-		while (fgets(buf, sizeof buf, fp) != NULL)
-			fprintf(out, "%s", buf);
-		fclose(fp);
-		fprintf(out, "\n");
+	fp = fopen(p_osm->subn.opt.per_module_logging_file, "r");
+	if (!fp) {
+		if (errno == ENOENT)
+			return;
+		fprintf(out, "fopen(%s) failed: %s\n",
+			p_osm->subn.opt.per_module_logging_file,
+			strerror(errno));
+		return;
 	}
+
+	fprintf(out, "Per module logging file: %s\n",
+		p_osm->subn.opt.per_module_logging_file);
+	while (fgets(buf, sizeof buf, fp) != NULL)
+		fprintf(out, "%s", buf);
+	fclose(fp);
+	fprintf(out, "\n");
 }
 
 static void priority_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index ccaa47c..363c68f 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -531,7 +531,6 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
 	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
-	{ "per_module_logging", OPT_OFFSET(per_module_logging), opts_parse_boolean, NULL, 1 },
 	{ "per_module_logging_file", OPT_OFFSET(per_module_logging_file), opts_parse_charp, NULL, 0 },
 	{0}
 };
@@ -1040,7 +1039,6 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
-	p_opt->per_module_logging = FALSE;
 	p_opt->per_module_logging_file = strdup(OSM_DEFAULT_PER_MOD_LOGGING_CONF_FILE);
 	subn_init_qos_options(&p_opt->qos_options, NULL);
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
@@ -2063,8 +2061,6 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"log_max_size %lu\n\n"
 		"# If TRUE will accumulate the log over multiple OpenSM sessions\n"
 		"accum_log_file %s\n\n"
-		"# Per module logging\n"
-		"per_module_logging %s\n\n"
 		"# Per module logging configuration file\n"
 		"# Each line in config file contains <module_name><separator><log_flags>\n"
 		"# where module_name is file name including .c\n"
@@ -2098,7 +2094,6 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->log_file,
 		p_opts->log_max_size,
 		p_opts->accum_log_file ? "TRUE" : "FALSE",
-		p_opts->per_module_logging ? "TRUE" : "FALSE",
 		p_opts->per_module_logging_file,
 		p_opts->dump_files_dir,
 		p_opts->enable_quirks ? "TRUE" : "FALSE",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
