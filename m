From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 1/2] Redundant remove() function call during db file
 generation
Date: Wed, 13 Nov 2013 11:29:51 -0500
Message-ID: <5283A8FF.6010001@dev.mellanox.co.il>
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
 opensm/osm_db_files.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 75b58cd..348385f 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -45,6 +45,7 @@
 
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <errno.h>
 #include <stdlib.h>
 #include <string.h>
 #include <opensm/osm_file_ids.h>
@@ -480,8 +481,8 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
 	p_file = fopen(p_tmp_file_name, "w");
 	if (!p_file) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6107: "
-			"Failed to open the db file:%s for writing\n",
-			p_domain_imp->file_name);
+			"Failed to open the db file:%s for writing: err:%s\n",
+			p_domain_imp->file_name, strerror(errno));
 		status = 1;
 		goto Exit;
 	}
@@ -489,19 +490,11 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
 	st_foreach(p_domain_imp->p_hash, dump_tbl_entry, (st_data_t) p_file);
 	fclose(p_file);
 
-	/* move the domain file */
-	status = remove(p_domain_imp->file_name);
-	if (status) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6109: "
-			"Failed to remove file:%s (err:%u)\n",
-			p_domain_imp->file_name, status);
-	}
-
 	status = rename(p_tmp_file_name, p_domain_imp->file_name);
 	if (status) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6108: "
-			"Failed to rename the db file to:%s (err:%u)\n",
-			p_domain_imp->file_name, status);
+			"Failed to rename the db file to:%s (err:%s)\n",
+			p_domain_imp->file_name, strerror(errno));
 	}
 Exit:
 	cl_spinlock_release(&p_domain_imp->lock);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
