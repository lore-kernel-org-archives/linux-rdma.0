From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH] opensm: accept looonnng partition.conf lines
Date: Mon, 24 Jan 2011 11:36:15 -0800
Message-ID: <20110124193615.GP10691@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Sometimes we use partition.conf files with so many entries that 
the 1K buffer currently used by osm_prtn_config_parse_file() is 
too small. Use getline() to avoid that.

Signed-off-by: <akepner-sJ/iWh9BUns@public.gmane.org>
---
 opensm/opensm/osm_prtn_config.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

---

diff --git a/opensm/opensm/osm_prtn_config.c b/opensm/opensm/osm_prtn_config.c
index 0d02597..34676ef 100644
--- a/opensm/opensm/osm_prtn_config.c
+++ b/opensm/opensm/osm_prtn_config.c
@@ -400,7 +400,9 @@ skip_header:
 int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 			       const char *file_name)
 {
-	char line[1024];
+	char *line = NULL;
+	ssize_t llen;
+	size_t n;
 	struct part_conf *conf = NULL;
 	FILE *file;
 	int lineno;
@@ -415,7 +417,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 	lineno = 0;
 
-	while (fgets(line, sizeof(line) - 1, file) != NULL) {
+	while ((llen = getline(&line, &n, file)) != -1) {
 		char *q, *p = line;
 
 		lineno++;
@@ -463,6 +465,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 		} while (q);
 	}
 
+	free(line);
+
 	fclose(file);
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
