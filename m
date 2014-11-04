From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mcast_mgr.c: Add MLID to error 0A06 log message
Date: Tue, 04 Nov 2014 12:46:55 -0500
Message-ID: <5459110F.70009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add MLID to error 0A06 log message in the function mcast_mgr_purge_list

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index fe73695..8ed2d8f 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -462,7 +462,7 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * list)
+static void mcast_mgr_purge_list(osm_sm_t * sm, uint16_t mlid, cl_qlist_t * list)
 {
 	if (OSM_LOG_IS_ACTIVE_V2(sm->p_log, OSM_LOG_ERROR)) {
 		osm_mcast_work_obj_t *wobj;
@@ -471,8 +471,8 @@ static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * list)
 		     i = cl_qlist_next(i)) {
 			wobj = cl_item_obj(i, wobj, list_item);
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A06: "
-				"Unable to route for port 0x%" PRIx64 "\n",
-				cl_ntoh64(osm_port_get_guid(wobj->p_port)));
+				"Unable to route MLID 0x%X for port 0x%" PRIx64 "\n",
+				mlid, cl_ntoh64(osm_port_get_guid(wobj->p_port)));
 		}
 	}
 	osm_mcast_drop_port_list(list);
@@ -523,7 +523,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A21: "
 			"Maximal hops number is reached for MLID 0x%x."
 			" Break processing\n", mlid_ho);
-		mcast_mgr_purge_list(sm, p_list);
+		mcast_mgr_purge_list(sm, mlid_ho, p_list);
 		goto Exit;
 	}
 
@@ -543,7 +543,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 		/*
 		   Deallocate all the work objects on this branch of the tree.
 		 */
-		mcast_mgr_purge_list(sm, p_list);
+		mcast_mgr_purge_list(sm, mlid_ho, p_list);
 		goto Exit;
 	}
 
@@ -559,7 +559,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 		/*
 		   Deallocate all the work objects on this branch of the tree.
 		 */
-		mcast_mgr_purge_list(sm, p_list);
+		mcast_mgr_purge_list(sm, mlid_ho, p_list);
 		goto Exit;
 	}
 
@@ -576,7 +576,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 	if (list_array == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A16: "
 			"Unable to allocate list array\n");
-		mcast_mgr_purge_list(sm, p_list);
+		mcast_mgr_purge_list(sm, mlid_ho, p_list);
 		osm_mtree_destroy(p_mtn);
 		p_mtn = NULL;
 		goto Exit;
@@ -670,7 +670,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 				mlid_ho, cl_ntoh64(node_guid), i);
 
 			/* Free memory */
-			mcast_mgr_purge_list(sm, p_port_list);
+			mcast_mgr_purge_list(sm, mlid_ho, p_port_list);
 
 			/* Invalidate ucast cache */
 			if (sm->ucast_mgr.p_subn->opt.use_ucast_cache &&
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
