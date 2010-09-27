From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree: When roots are not connected,
	update hop count but not lft
Date: Mon, 27 Sep 2010 09:32:14 -0400
Message-ID: <20100927133214.GA1267@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When roots are not connected, neither hops nor lfts are updated for
root switch port 0s. This causes a problem for multicast (looping) where
switch port 0s can join.

Solution proposed by Yevgeny is to treat this as updn does and update the
hop count but not new_lft.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 88ea344..d74ba66 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -3012,8 +3012,10 @@ static void fabric_route_roots(IN ftree_fabric_t * p_ftree)
 				"through port %u\n",
 				tuple_to_str(p_sw->tuple), lid, port_num);
 
-			/* set local lft */
-			p_sw->p_osm_sw->new_lft[lid] = port_num;
+			if (p_ftree->p_osm->subn.opt.connect_roots) {
+				/* set local lft */
+				p_sw->p_osm_sw->new_lft[lid] = port_num;
+			}
 
 			/*
 			 * Set local min hop table.
@@ -4061,12 +4063,10 @@ static int do_routing(IN void *context)
 		"Filling switch forwarding tables for switch-to-switch paths\n");
 	fabric_route_to_switches(p_ftree);
 
-	if (p_ftree->p_osm->subn.opt.connect_roots) {
-		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
-			"Connecting switches that are unreachable within "
-			"Up/Down rules\n");
-		fabric_route_roots(p_ftree);
-	}
+	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
+		"Connecting switches that are unreachable within "
+		"Up/Down rules\n");
+	fabric_route_roots(p_ftree);
 
 	/* for each switch, set its fwd table */
 	cl_qmap_apply_func(&p_ftree->sw_tbl, set_sw_fwd_table, (void *)p_ftree);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
