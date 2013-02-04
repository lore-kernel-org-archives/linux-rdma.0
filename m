From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Revert "opensm/osm_ucast_ftree: When roots are not connected, update hop count but not lft"
Date: Mon,  4 Feb 2013 15:20:08 +0200
Message-ID: <1359984011-30753-7-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This reverts commit 81dade3aeb1d5c80472a4f9fef55e9916bb38d3a.

The patch causes crashes in fat-tree routing and it's replaced by the
following patch.

Signed-off-by: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 8363bd2..c81e7a3 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3038,10 +3038,8 @@ static void fabric_route_roots(IN ftree_fabric_t * p_ftree)
 				"through port %u\n",
 				tuple_to_str(p_sw->tuple), lid, port_num);
 
-			if (p_ftree->p_osm->subn.opt.connect_roots) {
-				/* set local lft */
-				p_sw->p_osm_sw->new_lft[lid] = port_num;
-			}
+			/* set local lft */
+			p_sw->p_osm_sw->new_lft[lid] = port_num;
 
 			/*
 			 * Set local min hop table.
@@ -4221,10 +4219,12 @@ static int do_routing(IN void *context)
 		"Filling switch forwarding tables for switch-to-switch paths\n");
 	fabric_route_to_switches(p_ftree);
 
-	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
-		"Connecting switches that are unreachable within "
-		"Up/Down rules\n");
-	fabric_route_roots(p_ftree);
+	if (p_ftree->p_osm->subn.opt.connect_roots) {
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
+			"Connecting switches that are unreachable within "
+			"Up/Down rules\n");
+		fabric_route_roots(p_ftree);
+	}
 
 	/* for each switch, set its fwd table */
 	cl_qmap_apply_func(&p_ftree->sw_tbl, set_sw_fwd_table, (void *)p_ftree);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
