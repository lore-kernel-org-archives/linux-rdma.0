From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] osmtest/osmtest.c: Minor reordering of code in, osmtest_write_all_path_recs
Date: Thu, 07 Mar 2013 07:48:00 -0500
Message-ID: <51388C80.1070208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmtest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 7e55db6..9dd0b98 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -2238,9 +2238,6 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
-	p_tbl = &p_osmt->exp_subn.node_guid_tbl;
-	p_dst_node = (node_t *) cl_qmap_head(p_tbl);
-
 	result = fprintf(fh, "#\n" "# Path Records\n" "#\n");
 	if (result < 0) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0026: "
@@ -2249,6 +2246,9 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 		goto Exit;
 	}
 
+	p_tbl = &p_osmt->exp_subn.node_guid_tbl;
+	p_dst_node = (node_t *) cl_qmap_head(p_tbl);
+
 	while (p_dst_node != (node_t *) cl_qmap_end(p_tbl)) {
 
 		OSM_LOG(&p_osmt->log, OSM_LOG_DEBUG,"Source : lid = 0x%d type = %d\n",
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
