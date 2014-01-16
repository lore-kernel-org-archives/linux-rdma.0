From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_prtn_config.c: Some changes to osm_prtn_config_parse_file
Date: Thu, 16 Jan 2014 11:18:50 -0500
Message-ID: <52D8066A.3070109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 48c9f436d6c85d32d2748ba4c2756e2736bc5e7e Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 16 Jan 2014 18:15:02 +0200
Subject: [PATCH] osm_prtn_config.c: Some changes to
 osm_prtn_config_parse_file

in terms of deciding when partition file is valid or not and
hence when to fallback to default partition configuration.

Improvements to commit 5a97c782a4b4f968c2d964c371decec5083f8499
    Try default partition config if parsing partitions.conf fails

Specific changes are:
break out of global while on a parsing failure
change is_parse_success to int from boolean and reverse logic setting this
also, detect whether there is at least one valid partition parsed

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn_config.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 9bad7a7..100282a 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -697,7 +697,7 @@ done:
 }
 
 /**
- * @return -1 on error, 0 on success
+ * @return 1 on error, 0 on success
  */
 int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 			       const char *file_name)
@@ -706,7 +706,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 	struct part_conf *conf = NULL;
 	FILE *file;
 	int lineno;
-	boolean_t is_parse_success;
+	int is_parse_success;
 
 	file = fopen(file_name, "r");
 	if (!file) {
@@ -718,7 +718,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 	lineno = 0;
 
-	is_parse_success = FALSE;
+	is_parse_success = 0;
 
 	while (fgets(line, sizeof(line) - 1, file) != NULL) {
 		char *q, *p = line;
@@ -730,8 +730,6 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 		q = strchr(p, '#');
 		if (q)
 			*q = '\0';
-		else
-			is_parse_success = TRUE;
 
 		do {
 			int len;
@@ -749,7 +747,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 					"PARSE ERROR: line %d: "
 					"internal: cannot create config\n",
 					lineno);
-				is_parse_success = FALSE;
+				is_parse_success = -1;
 				break;
 			}
 
@@ -759,10 +757,12 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 			len = parse_part_conf(conf, p, lineno);
 			if (len < 0) {
-				is_parse_success = FALSE;
+				is_parse_success = -1;
 				break;
 			}
 
+			is_parse_success = 1;
+
 			p += len;
 
 			if (q) {
@@ -770,12 +770,12 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 				conf = NULL;
 			}
 		} while (q);
+
+		if (is_parse_success == -1)
+			break;
 	}
 
 	fclose(file);
 
-	if (is_parse_success)
-		return 0;
-	else
-		return -1;
+	return (is_parse_success == 1) ? 0 : 1;
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
