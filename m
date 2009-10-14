From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: Cosmetic changes
Date: Wed, 14 Oct 2009 16:01:24 -0400
Message-ID: <20091014200124.GA18516@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 77e0b94..0ee689c 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -351,7 +351,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 /**********************************************************************
   This is part of the recursive function to compute the paths in the
-  spanning tree that eminate from this switch.  On input, the p_list
+  spanning tree that emanate from this switch.  On input, the p_list
   contains the group members that must be routed from this switch.
 **********************************************************************/
 static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
@@ -368,7 +368,7 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 	mlid_ho = cl_ntoh16(osm_mgrp_get_mlid(p_mgrp));
 
 	/*
-	   For Multicast Groups, we want not to count on previous
+	   For Multicast Groups, we don't want to count on previous
 	   configurations - since we can easily generate a storm
 	   by loops.
 	 */
@@ -396,8 +396,8 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A03: "
 				"Error routing MLID 0x%X through switch 0x%"
 				PRIx64 "\n"
-				"\t\t\t\tNo multicast paths from this switch for port "
-				"with LID %u\n", mlid_ho, node_guid_ho,
+				"\t\t\t\tNo multicast paths from this switch "
+				"for port with LID %u\n", mlid_ho, node_guid_ho,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 
@@ -411,8 +411,8 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A04: "
 				"Error routing MLID 0x%X through switch 0x%"
 				PRIx64 "\n"
-				"\t\t\t\tNo multicast paths from this switch to port "
-				"with LID %u\n", mlid_ho, node_guid_ho,
+				"\t\t\t\tNo multicast paths from this switch "
+				"to port with LID %u\n", mlid_ho, node_guid_ho,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 
@@ -613,8 +613,8 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 		osm_mcast_tbl_set(p_tbl, mlid_ho, i);
 		if (i == 0) {
 			/* This means we are adding the switch to the MC group.
-			   We do not need to continue looking at the remote port, just
-			   needed to add the port to the table */
+			   We do not need to continue looking at the remote
+			   port, just needed to add the port to the table */
 			CL_ASSERT(count == 1);
 
 			p_wobj = (osm_mcast_work_obj_t *)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
