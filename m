From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_ftree.c: Fix memory leak in ftree fabric_rank
Date: Mon, 24 Feb 2014 07:52:48 -0500
Message-ID: <530B40A0.2090804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Rafi Wiener <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Memory leak is due to double cl_list_init calls.
It happens when OpenSM cannot parse root guids file.

Also, cosmetic formatting change

Signed-off-by: Rafi Wiener <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index ee37e79..f646bd0 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3555,7 +3555,6 @@ static boolean_t fabric_load_roots(IN ftree_fabric_t * p_ftree,
 	unsigned num_roots;
 
 	if (p_ranking_bfs_list) {
-		cl_list_init(p_ranking_bfs_list, 10);
 
 		/* Rank all the roots and add them to list */
 		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
@@ -3709,7 +3708,6 @@ static int fabric_rerank_using_root(IN ftree_fabric_t * p_ftree,
 	int res;
 
 	OSM_LOG_ENTER(&p_ftree->p_osm->log);
-	cl_list_init(p_ranking_bfs_list, 10);
 
 	p_next_sw = (ftree_sw_t *) cl_qmap_head(&p_ftree->sw_tbl);
 	while (p_next_sw != (ftree_sw_t *) cl_qmap_end(&p_ftree->sw_tbl)) {
@@ -3732,10 +3730,11 @@ static int fabric_rank(IN ftree_fabric_t * p_ftree)
 	cl_list_t ranking_bfs_list;
 
 	OSM_LOG_ENTER(&p_ftree->p_osm->log);
+	cl_list_init(&ranking_bfs_list, 10);
 
 	if (fabric_roots_provided(p_ftree) &&
 	    fabric_load_roots(p_ftree, &ranking_bfs_list))
-			res = fabric_rank_from_roots(p_ftree, &ranking_bfs_list);
+		res = fabric_rank_from_roots(p_ftree, &ranking_bfs_list);
 	else {
 		res = fabric_rank_from_hcas(p_ftree);
 		if (!res)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
