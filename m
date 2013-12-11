From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mcast_mgr.c: removed mcast_mgr_purge_tree_node
 due to code duplication
Date: Wed, 11 Dec 2013 14:15:36 -0500
Message-ID: <52A8B9D8.90706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Removed mcast_mgr_purge_tree_node from osm_mcast_mgr.c and replaced the
calls to it, with calls to osm_mtree_destroy.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index ed14330..ea2a32a 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -133,29 +133,12 @@ void osm_mcast_drop_port_list(cl_qlist_t * list)
 				      cl_qlist_remove_head(list));
 }
 
-/**********************************************************************
- Recursively remove nodes from the tree
- *********************************************************************/
-static void mcast_mgr_purge_tree_node(IN osm_mtree_node_t * p_mtn)
-{
-	uint8_t i;
-
-	for (i = 0; i < p_mtn->max_children; i++) {
-		if (p_mtn->child_array[i] &&
-		    (p_mtn->child_array[i] != OSM_MTREE_LEAF))
-			mcast_mgr_purge_tree_node(p_mtn->child_array[i]);
-		p_mtn->child_array[i] = NULL;
-	}
-
-	free(p_mtn);
-}
-
 void osm_purge_mtree(osm_sm_t * sm, IN osm_mgrp_box_t * mbox)
 {
 	OSM_LOG_ENTER(sm->p_log);
 
 	if (mbox->root)
-		mcast_mgr_purge_tree_node(mbox->root);
+		osm_mtree_destroy(mbox->root);
 	mbox->root = NULL;
 
 	OSM_LOG_EXIT(sm->p_log);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
