From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 01/10] DFSSSP: fix a memory leak in dfsssp_build_graph
Date: Wed, 23 Jan 2013 01:38:18 +0900
Message-ID: <1358872698-16850-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

If the graph could not be build correctly and DFSSSP returns an error, then not all allocated memory was freed.

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index ffc317f..ff525ea 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1093,6 +1093,9 @@ static int dfsssp_build_graph(void *context)
 	for (i = 0; i < adj_list_size; i++)
 		set_default_vertex(&adj_list[i]);
 
+	dfsssp_ctx->adj_list = adj_list;
+	dfsssp_ctx->adj_list_size = adj_list_size;
+
 	/* count the total number of Hca / LIDs (for lmc>0) in the fabric */
 	for (item = cl_qmap_head(port_tbl); item != cl_qmap_end(port_tbl);
 	     item = cl_qmap_next(item)) {
@@ -1190,9 +1193,6 @@ static int dfsssp_build_graph(void *context)
 	if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_DEBUG))
 		dfsssp_print_graph(p_mgr, adj_list, adj_list_size);
 
-	dfsssp_ctx->adj_list = adj_list;
-	dfsssp_ctx->adj_list_size = adj_list_size;
-
 	OSM_LOG_EXIT(p_mgr->p_log);
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
