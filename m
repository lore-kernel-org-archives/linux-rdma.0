From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: Cosmetic changes
Date: Thu, 4 Feb 2010 09:27:28 -0500
Message-ID: <20100204142728.GA14122@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Fix some commentary typos
Remove osm_ from static routine names

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 19d0593..37ff120 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -195,7 +195,7 @@ static void mcast_mgr_build_switch_map(osm_sm_t * sm,
 				cl_qmap_insert(p_mcast_member_sw_tbl, port_guid, &remote_sw->mgrp_item);
 				/* New element in the table */
 				if (p_port->p_node->sw)
-					/* the switch is MC memeber */
+					/* the switch is MC member */
 					remote_sw->is_mc_member = 1;
 				else
 					/* for others - update MC count */
@@ -229,8 +229,8 @@ static void mcast_mgr_destroy_switch_map(osm_sm_t * sm,
  of the group HCAs
  **********************************************************************/
 #ifdef OSM_VENDOR_INTF_ANAFA
-static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t * m,
-					    const osm_switch_t * this_sw)
+static float mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t * m,
+					const osm_switch_t * this_sw)
 {
 	float avg_hops = 0;
 	uint32_t hops = 0;
@@ -254,7 +254,7 @@ static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t * m,
 		num_ports += sw->num_of_mcm + sw->is_mc_member;
 	}
 
-	/* We should be here if there aren't any ports in the group. */
+	/* We shouldn't be here if there aren't any ports in the group. */
 	CL_ASSERT(num_ports);
 
 	avg_hops = (float)(hops / num_ports);
@@ -263,8 +263,8 @@ static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t * m,
 	return avg_hops;
 }
 #else
-static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qmap_t * m,
-					    const osm_switch_t * this_sw)
+static float mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qmap_t * m,
+					const osm_switch_t * this_sw)
 {
 	uint32_t max_hops = 0, hops;
 	uint16_t lid;
@@ -322,9 +322,9 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 			continue;
 
 #ifdef OSM_VENDOR_INTF_ANAFA
-		hops = osm_mcast_mgr_compute_avg_hops(sm, &mgrp_sw_map, p_sw);
+		hops = mcast_mgr_compute_avg_hops(sm, &mgrp_sw_map, p_sw);
 #else
-		hops = osm_mcast_mgr_compute_max_hops(sm, &mgrp_sw_map, p_sw);
+		hops = mcast_mgr_compute_max_hops(sm, &mgrp_sw_map, p_sw);
 #endif
 
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
@@ -352,7 +352,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 }
 
 /**********************************************************************
-   This function returns the existing or optimal root swtich for the tree.
+   This function returns the existing or optimal root switch for the tree.
 **********************************************************************/
 static osm_switch_t *mcast_mgr_find_root_switch(osm_sm_t * sm, cl_qlist_t *list)
 {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
