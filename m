From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_db_files.c: Add osm_db_domain_init failure handling
 into test program
Date: Thu, 12 Sep 2013 09:44:23 -0400
Message-ID: <5231C537.3070102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, improve error 6100 log message

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 9219722..10389da 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -162,7 +162,8 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 
 	p_db_imp = malloc(sizeof(osm_db_imp_t));
 	if (!p_db_imp) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6100: No memory.\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6100: "
+			"Failed to allocate db memory\n");
 		return -1;
 	}
 
@@ -668,6 +669,10 @@ int main(int argc, char **argv)
 	}
 
 	p_dbd = osm_db_domain_init(&db, "lid_by_guid");
+	if (!p_dbd) {
+		printf("db domain init failed\n");
+		exit(1);
+	}
 
 	if (osm_db_restore(p_dbd)) {
 		printf("failed to restore\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
