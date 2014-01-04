From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 opensm] Try default partition config if parsing partitions.conf
 fails
Date: Sat, 04 Jan 2014 12:37:59 -0500
Message-ID: <52C846F7.6080806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>

If partitions.conf is for some reason invalid or empty, try again
with the default configuration.

This will re-use the default configuration created by prtn_make_default(),
but osm_prtn_make_new() will automatically overwrite the initial default.

Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change from v1:
Based on Berd's original patch for this, this modifies
osm_prtn_config_parse_file determination of is_parse_success
to handle more cases than original proposed patch.

diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index e76e2e1..bd0ac67 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -376,6 +376,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 	struct stat statbuf;
 	const char *file_name;
 	boolean_t is_config = TRUE;
+	boolean_t is_wrong_config = FALSE;
 	ib_api_status_t status = IB_SUCCESS;
 	cl_map_item_t *p_next;
 	osm_prtn_t *p;
@@ -389,6 +390,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 		is_config = FALSE;
 	}
 
+retry_default:
 	/* clean up current port maps */
 	p_next = cl_qmap_head(&p_subn->prtn_pkey_tbl);
 	while (p_next != cl_qmap_end(&p_subn->prtn_pkey_tbl)) {
@@ -404,9 +406,11 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 	if (status != IB_SUCCESS)
 		goto _err;
 
-	if (is_config && osm_prtn_config_parse_file(p_log, p_subn, file_name))
+	if (is_config && osm_prtn_config_parse_file(p_log, p_subn, file_name)) {
 		OSM_LOG(p_log, OSM_LOG_VERBOSE, "Partition configuration "
 			"was not fully processed\n");
+		is_wrong_config = TRUE;
+	}
 
 	/* and now clean up empty partitions */
 	p_next = cl_qmap_head(&p_subn->prtn_pkey_tbl);
@@ -421,6 +425,13 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 		}
 	}
 
+	if (is_config && is_wrong_config) {
+		OSM_LOG(p_log, OSM_LOG_ERROR, "Partition configuration "
+			"in error; retrying with default config\n");
+		is_config = FALSE;
+		goto retry_default;
+	}
+
 _err:
 	return status;
 }
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 8f4a673..9bad7a7 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -696,6 +696,9 @@ done:
 	return len;
 }
 
+/**
+ * @return -1 on error, 0 on success
+ */
 int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 			       const char *file_name)
 {
@@ -703,6 +706,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 	struct part_conf *conf = NULL;
 	FILE *file;
 	int lineno;
+	boolean_t is_parse_success;
 
 	file = fopen(file_name, "r");
 	if (!file) {
@@ -714,6 +718,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 	lineno = 0;
 
+	is_parse_success = FALSE;
+
 	while (fgets(line, sizeof(line) - 1, file) != NULL) {
 		char *q, *p = line;
 
@@ -724,6 +730,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 		q = strchr(p, '#');
 		if (q)
 			*q = '\0';
+		else
+			is_parse_success = TRUE;
 
 		do {
 			int len;
@@ -741,6 +749,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 					"PARSE ERROR: line %d: "
 					"internal: cannot create config\n",
 					lineno);
+				is_parse_success = FALSE;
 				break;
 			}
 
@@ -750,6 +759,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 			len = parse_part_conf(conf, p, lineno);
 			if (len < 0) {
+				is_parse_success = FALSE;
 				break;
 			}
 
@@ -764,5 +774,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
 	fclose(file);
 
-	return 0;
+	if (is_parse_success)
+		return 0;
+	else
+		return -1;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
