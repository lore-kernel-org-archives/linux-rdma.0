From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATYCH opensm 2/2] Only rewrite db files during heavy sweep when
 there is a real change
Date: Wed, 13 Nov 2013 11:30:01 -0500
Message-ID: <5283A909.2010801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_db_files.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 348385f..aaed986 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -92,6 +92,7 @@ typedef struct osm_db_domain_imp {
 	char *file_name;
 	st_table *p_hash;
 	cl_spinlock_t lock;
+	boolean_t dirty;
 } osm_db_domain_imp_t;
 /*
  * FIELDS
@@ -268,6 +269,7 @@ osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name)
 	/* initialize the hash table object */
 	p_domain_imp->p_hash = st_init_strtable();
 	CL_ASSERT(p_domain_imp->p_hash != NULL);
+	p_domain_imp->dirty = FALSE;
 
 	p_domain->p_db = p_db;
 	cl_list_insert_tail(&p_db->domains, p_domain);
@@ -463,13 +465,17 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
 {
 	osm_log_t *p_log = p_domain->p_db->p_log;
 	osm_db_domain_imp_t *p_domain_imp;
-	FILE *p_file;
+	FILE *p_file = NULL;
 	int status = 0;
-	char *p_tmp_file_name;
+	char *p_tmp_file_name = NULL;
 
 	OSM_LOG_ENTER(p_log);
 
 	p_domain_imp = (osm_db_domain_imp_t *) p_domain->p_domain_imp;
+
+	if (p_domain_imp->dirty == FALSE)
+		goto Exit;
+
 	p_tmp_file_name = malloc(sizeof(char) *
 				 (strlen(p_domain_imp->file_name) + 8));
 	strcpy(p_tmp_file_name, p_domain_imp->file_name);
@@ -495,7 +501,9 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6108: "
 			"Failed to rename the db file to:%s (err:%s)\n",
 			p_domain_imp->file_name, strerror(errno));
+		goto Exit;
 	}
+	p_domain_imp->dirty = FALSE;
 Exit:
 	cl_spinlock_release(&p_domain_imp->lock);
 	free(p_tmp_file_name);
@@ -579,6 +587,9 @@ int osm_db_update(IN osm_db_domain_t * p_domain, IN char *p_key, IN char *p_val)
 			"Key:%s previously exists in:%s with value:%s\n",
 			p_key, p_domain_imp->file_name, p_prev_val);
 		p_new_key = p_key;
+		/* same key, same value - nothing to update */
+		if (p_prev_val && !strcmp(p_val, p_prev_val))
+			goto Exit;
 	} else {
 		/* need to allocate the key */
 		p_new_key = malloc(sizeof(char) * (strlen(p_key) + 1));
@@ -595,6 +606,9 @@ int osm_db_update(IN osm_db_domain_t * p_domain, IN char *p_key, IN char *p_val)
 	if (p_prev_val)
 		free(p_prev_val);
 
+	p_domain_imp->dirty = TRUE;
+
+Exit:
 	cl_spinlock_release(&p_domain_imp->lock);
 
 	return 0;
@@ -622,6 +636,7 @@ int osm_db_delete(IN osm_db_domain_t * p_domain, IN char *p_key)
 		} else {
 			free(p_key);
 			free(p_prev_val);
+			p_domain_imp->dirty = TRUE;
 			res = 0;
 		}
 	} else {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
