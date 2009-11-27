From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c Changed log level
Date: Fri, 27 Nov 2009 14:16:56 +0100
Message-ID: <4B0FD148.2000604@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Using INFO instead of SYS whenever ftree decides to fallback to another algorithm,
and VERBOSE instead of INFO some places where the same info is displayed at INFO
level in fabric_dump_general_info()

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 76b1d6a..e1effd0 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -3586,7 +3586,7 @@ static int fabric_rank(IN ftree_fabric_t * p_ftree)
 	if (res)
 		goto Exit;
 
-	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_INFO,
+	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"FatTree max switch rank is %u\n", p_ftree->max_switch_rank);
 
 Exit:
@@ -3644,7 +3644,7 @@ static void fabric_set_leaf_rank(IN ftree_fabric_t * p_ftree)
 		p_ftree->leaf_switch_rank = p_sw->rank;
 	}
 
-	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_INFO,
+	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"FatTree leaf switch rank is %u\n", p_ftree->leaf_switch_rank);
 	OSM_LOG_EXIT(&p_ftree->p_osm->log);
 }				/* fabric_set_leaf_rank() */
@@ -3772,7 +3772,7 @@ static int construct_fabric(IN void *context)
 	fabric_clear(p_ftree);
 
 	if (p_ftree->p_osm->subn.opt.lmc > 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"LMC > 0 is not supported by fat-tree routing.\n"
 			"Falling back to default routing\n");
 		status = -1;
@@ -3780,7 +3780,7 @@ static int construct_fabric(IN void *context)
 	}
 
 	if (cl_qmap_count(&p_ftree->p_osm->subn.sw_guid_tbl) < 2) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric has %u switches - topology is not fat-tree.\n"
 			"Falling back to default routing\n",
 			cl_qmap_count(&p_ftree->p_osm->subn.sw_guid_tbl));
@@ -3790,7 +3790,7 @@ static int construct_fabric(IN void *context)
 
 	if ((cl_qmap_count(&p_ftree->p_osm->subn.node_guid_tbl) -
 	     cl_qmap_count(&p_ftree->p_osm->subn.sw_guid_tbl)) < 2) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric has %u nodes (%u switches) - topology is not fat-tree.\n"
 			"Falling back to default routing\n",
 			cl_qmap_count(&p_ftree->p_osm->subn.node_guid_tbl),
@@ -3807,7 +3807,7 @@ static int construct_fabric(IN void *context)
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"Populating FatTree Switch and CA tables\n");
 	if (fabric_populate_nodes(p_ftree) != 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric topology is not fat-tree - "
 			"falling back to default routing\n");
 		status = -1;
@@ -3817,7 +3817,7 @@ static int construct_fabric(IN void *context)
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"Reading guid files provided by user\n");
 	if (fabric_read_guid_files(p_ftree) != 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Failed reading guid files - "
 			"falling back to default routing\n");
 		status = -1;
@@ -3825,8 +3825,8 @@ static int construct_fabric(IN void *context)
 	}
 
 	if (cl_qmap_count(&p_ftree->hca_tbl) < 2) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
-			"Fabric has %u CAa - topology is not fat-tree.\n"
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
+			"Fabric has %u CAs - topology is not fat-tree.\n"
 			"Falling back to default routing\n",
 			cl_qmap_count(&p_ftree->hca_tbl));
 		status = -1;
@@ -3839,7 +3839,7 @@ static int construct_fabric(IN void *context)
 	   whole tree rank after filling ports and marking CNs. */
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE, "Ranking FatTree\n");
 	if (fabric_rank(p_ftree) != 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Failed ranking the tree\n");
 		status = -1;
 		goto Exit;
@@ -3853,12 +3853,12 @@ static int construct_fabric(IN void *context)
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"Populating CA & switch ports\n");
 	if (fabric_populate_ports(p_ftree) != 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric topology is not a fat-tree\n");
 		status = -1;
 		goto Exit;
 	} else if (p_ftree->cn_num == 0) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric has no valid compute nodes\n");
 		status = -1;
 		goto Exit;
@@ -3870,7 +3870,7 @@ static int construct_fabric(IN void *context)
 
 	if (fabric_get_rank(p_ftree) > FAT_TREE_MAX_RANK ||
 	    fabric_get_rank(p_ftree) < FAT_TREE_MIN_RANK) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric rank is %u (should be between %u and %u)\n",
 			fabric_get_rank(p_ftree), FAT_TREE_MIN_RANK,
 			FAT_TREE_MAX_RANK);
@@ -3883,7 +3883,7 @@ static int construct_fabric(IN void *context)
 	   As a by-product, this function also runs basic topology
 	   validation - it checks that all the CNs are at the same rank. */
 	if (fabric_mark_leaf_switches(p_ftree)) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric topology is not a fat-tree\n");
 		status = -1;
 		goto Exit;
@@ -3901,7 +3901,7 @@ static int construct_fabric(IN void *context)
 	   switches at the same leaf rank w/o CNs, if this is the order of indexing.
 	   In any case, the first and the last switches in the array are REAL leafs. */
 	if (fabric_create_leaf_switch_array(p_ftree)) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric topology is not a fat-tree\n");
 		status = -1;
 		goto Exit;
@@ -3921,7 +3921,7 @@ static int construct_fabric(IN void *context)
 	   guid file hasn't been provided by user */
 	if (!fabric_roots_provided(p_ftree) &&
 	    !fabric_validate_topology(p_ftree)) {
-		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
+		osm_log(&p_ftree->p_osm->log, OSM_LOG_INFO,
 			"Fabric topology is not a fat-tree\n");
 		status = -1;
 		goto Exit;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
