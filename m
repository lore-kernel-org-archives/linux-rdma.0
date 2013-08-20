From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_db_files.c : Fix resource leak guid2lid parser
Date: Tue, 20 Aug 2013 12:31:50 -0400
Message-ID: <521399F6.3040209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

leaks the storage that "p_accum_val" and "p_key" points to.

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 0d8f36c..513cf85 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -272,7 +272,7 @@ int osm_db_restore(IN osm_db_domain_t * p_domain)
 	boolean_t before_key;
 	char *p_first_word, *p_rest_of_line, *p_last;
 	char *p_key = NULL;
-	char *p_prev_val, *p_accum_val = NULL;
+	char *p_prev_val = NULL, *p_accum_val = NULL;
 	char *endptr = NULL;
 	unsigned int line_num;
 
@@ -371,12 +371,18 @@ int osm_db_restore(IN osm_db_domain_t * p_domain)
 				if (st_lookup(p_domain_imp->p_hash,
 					      (st_data_t) p_key,
 					      (void *)&p_prev_val)) {
+					/* if previously used we ignore this guid */
 					OSM_LOG(p_log, OSM_LOG_ERROR,
 						"ERR 6106: "
 						"Key:%s already exists in:%s with value:%s."
 						" Removing it\n", p_key,
 						p_domain_imp->file_name,
 						p_prev_val);
+						free(p_key);
+						p_key = NULL;
+						free(p_accum_val);
+						p_accum_val = NULL;
+						continue;
 				} else {
 					p_prev_val = NULL;
 				}
@@ -391,6 +397,10 @@ int osm_db_restore(IN osm_db_domain_t * p_domain)
 					OSM_LOG(p_log, OSM_LOG_ERROR,
 						"ERR 610B: "
 						"Key:%s is invalid\n", p_key);
+						free(p_key);
+						p_key = NULL;
+						free(p_accum_val);
+						p_accum_val = NULL;
 				} else {
 					/* store our key and value */
 					st_insert(p_domain_imp->p_hash,
@@ -404,6 +414,7 @@ int osm_db_restore(IN osm_db_domain_t * p_domain)
 						     strlen(sLine) + 1);
 				strcpy(p_accum_val, p_prev_val);
 				free(p_prev_val);
+				p_prev_val = NULL;
 				strcat(p_accum_val, sLine);
 			}
 		}		/* in key */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
