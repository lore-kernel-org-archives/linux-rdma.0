From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH opensm 2/2] Try default parition config if parsing the
 partitions.conf failed
Date: Thu, 17 Oct 2013 13:10:52 +0200
Message-ID: <20131017111052.177713.67832.stgit@fsdevel2>
References: <20131017111041.177713.61634.stgit@fsdevel2>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131017111041.177713.61634.stgit@fsdevel2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If partitions.conf is for some reasons invalid or empty, try again
with the default configuration.

This will re-use the default configuration created by prtn_make_default(),
but osm_prtn_make_new() will automatically overwrite the initial default.

Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 opensm/osm_prtn.c        |   11 ++++++++++-
 opensm/osm_prtn_config.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index e76e2e1..4db7e7a 100644
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
@@ -421,6 +425,11 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 		}
 	}
 
+	if (is_config && is_wrong_config) {
+		is_config = FALSE;
+		goto retry_default;
+	}
+
 _err:
 	return status;
 }
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 8f4a673..e916582 100644
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
+	boolean_t is_parse_success = FALSE;
 
 	file = fopen(file_name, "r");
 	if (!file) {
@@ -753,6 +757,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 				break;
 			}
 
+			is_parse_success = TRUE;
+
 			p += len;
 
 			if (q) {
@@ -764,5 +770,8 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 
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
