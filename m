From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm: Support (null) being specified for per_module_logging_file
 option
Date: Tue, 31 Jul 2012 05:13:37 -0400
Message-ID: <5017A1C1.4000203@dev.mellanox.co.il>
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
Note that this patch follows previous patch to "Remove unused per_module_logging option"

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 0c58a25..b0f7f48 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -341,22 +341,24 @@ static void permodlog_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 	FILE *fp;
 	char buf[1024];
 
-	fp = fopen(p_osm->subn.opt.per_module_logging_file, "r");
-	if (!fp) {
-		if (errno == ENOENT)
+	if (p_osm->subn.opt.per_module_logging_file != NULL) {
+		fp = fopen(p_osm->subn.opt.per_module_logging_file, "r");
+		if (!fp) {
+			if (errno == ENOENT)
+				return;
+			fprintf(out, "fopen(%s) failed: %s\n",
+				p_osm->subn.opt.per_module_logging_file,
+				strerror(errno));
 			return;
-		fprintf(out, "fopen(%s) failed: %s\n",
-			p_osm->subn.opt.per_module_logging_file,
-			strerror(errno));
-		return;
-	}
+		}
 
-	fprintf(out, "Per module logging file: %s\n",
-		p_osm->subn.opt.per_module_logging_file);
-	while (fgets(buf, sizeof buf, fp) != NULL)
-		fprintf(out, "%s", buf);
-	fclose(fp);
-	fprintf(out, "\n");
+		fprintf(out, "Per module logging file: %s\n",
+			p_osm->subn.opt.per_module_logging_file);
+		while (fgets(buf, sizeof buf, fp) != NULL)
+			fprintf(out, "%s", buf);
+		fclose(fp);
+		fprintf(out, "\n");
+	}
 }
 
 static void priority_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 3e4e55f..4c69a6f 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1522,6 +1522,9 @@ static ib_api_status_t parse_per_mod_logging_file(IN osm_subn_t * p_subn)
 
 	osm_reset_log_per_module(log);
 
+	if (p_subn->opt.per_module_logging_file == NULL)
+		return IB_SUCCESS;
+
 	fp = fopen(p_subn->opt.per_module_logging_file, "r");
 	if (!fp) {
 		if (errno == ENOENT)
@@ -2406,7 +2409,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->log_file,
 		p_opts->log_max_size,
 		p_opts->accum_log_file ? "TRUE" : "FALSE",
-		p_opts->per_module_logging_file,
+		p_opts->per_module_logging_file ?
+			p_opts->per_module_logging_file : null_str,
 		p_opts->dump_files_dir,
 		p_opts->enable_quirks ? "TRUE" : "FALSE",
 		p_opts->no_clients_rereg ? "TRUE" : "FALSE",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
