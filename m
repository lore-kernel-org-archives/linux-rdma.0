From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_perfmgr.c: Eliminate compile warning
Date: Tue, 31 Jul 2012 02:44:43 -0400
Message-ID: <50177EDB.70409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


osm_perfmgr_db.c: In function perfmgr_db_delete_inactive:
osm_perfmgr_db.c:218: warning: guid_list may be used uninitialized in this function

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index fdf3660..98b587d 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -215,7 +215,7 @@ perfmgr_db_delete_inactive(perfmgr_db_t * db, unsigned *cnt)
 	perfmgr_db_err_t rc = PERFMGR_EVENT_DB_SUCCESS;
 	int i = 0;
 	int num = 0;
-	uint64_t * guid_list;
+	uint64_t * guid_list = NULL;
 	cl_map_item_t * p_map_item = cl_qmap_head(&db->pc_data);
 
 	if (p_map_item == cl_qmap_end(&db->pc_data)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
