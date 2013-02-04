From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Fix unranked nodes bug in FTree
Date: Mon,  4 Feb 2013 15:20:05 +0200
Message-ID: <1359984011-30753-4-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case that nodes were unranked (for example: nodes which all their ports are unhealthy)
sm crashed, therefore we need to remove from the ftree structure unranked switches and hca's
which are connected only to unranked switches.

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c | 217 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 176 insertions(+), 41 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index d58fff1..8363bd2 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -556,18 +556,21 @@ static ftree_sw_t *sw_create(IN ftree_fabric_t * p_ftree,
 					   sizeof(ftree_port_group_t *));
 	if (p_sw->down_port_groups == NULL)
 		goto FREE_P_SW;
+	memset(p_sw->down_port_groups, 0, ports_num * sizeof(ftree_port_group_t *));
 
 	p_sw->up_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
 	if (p_sw->up_port_groups == NULL)
 		goto FREE_DOWN;
+	memset(p_sw->up_port_groups, 0, ports_num * sizeof(ftree_port_group_t *));
 
 	p_sw->sibling_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
 	if (p_sw->sibling_port_groups == NULL)
 		goto FREE_UP;
+	memset(p_sw->sibling_port_groups, 0, ports_num * sizeof(ftree_port_group_t *));
 
 	/* initialize lft buffer */
 	memset(p_osm_sw->new_lft, OSM_NO_PATH, p_osm_sw->lft_size);
@@ -807,6 +810,8 @@ static ftree_hca_t *hca_create(IN osm_node_t * p_osm_node)
 		free(p_hca);
 		return NULL;
 	}
+	memset(p_hca->up_port_groups, 0, osm_node_get_num_physp(p_hca->p_osm_node) *
+	       sizeof(ftree_port_group_t *));
 	p_hca->up_port_groups_num = 0;
 	return p_hca;
 }
@@ -1757,11 +1762,11 @@ static boolean_t fabric_validate_topology(IN ftree_fabric_t * p_ftree)
 		p_sw = p_next_sw;
 		p_next_sw = (ftree_sw_t *) cl_qmap_next(&p_sw->map_item);
 
-		if (!reference_sw_arr[p_sw->rank]) {
+		if (!reference_sw_arr[p_sw->rank])
 			/* This is the first switch in the current level that
 			   we're checking - use it as a reference */
 			reference_sw_arr[p_sw->rank] = p_sw;
-		} else {
+		else {
 			/* compare this switch properties to the reference switch */
 
 			if (reference_sw_arr[p_sw->rank]->up_port_groups_num !=
@@ -3254,7 +3259,8 @@ static void sw_reverse_rank(IN cl_map_item_t * const p_map_item,
 {
 	ftree_fabric_t *p_ftree = (ftree_fabric_t *) context;
 	ftree_sw_t *p_sw = (ftree_sw_t * const)p_map_item;
-	p_sw->rank = p_ftree->max_switch_rank - p_sw->rank;
+	if (p_sw->rank != 0xFFFFFFFF)
+		p_sw->rank = p_ftree->max_switch_rank - p_sw->rank;
 }
 
 /***************************************************
@@ -3517,7 +3523,8 @@ struct rank_root_cxt {
 	ftree_fabric_t *fabric;
 	cl_list_t *list;
 };
-
+/***************************************************
+ ***************************************************/
 static int rank_root_sw_by_guid(void *cxt, uint64_t guid, char *p)
 {
 	struct rank_root_cxt *c = cxt;
@@ -3538,53 +3545,63 @@ static int rank_root_sw_by_guid(void *cxt, uint64_t guid, char *p)
 
 	return 0;
 }
-
-static int fabric_rank_from_roots(IN ftree_fabric_t * p_ftree)
+/***************************************************
+ ***************************************************/
+static boolean_t fabric_load_roots(IN ftree_fabric_t * p_ftree,
+				   IN cl_list_t* p_ranking_bfs_list)
 {
 	struct rank_root_cxt context;
+	unsigned num_roots;
+
+	if (p_ranking_bfs_list) {
+		cl_list_init(p_ranking_bfs_list, 10);
+
+		/* Rank all the roots and add them to list */
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
+			"Fetching root nodes from file %s\n",
+			p_ftree->p_osm->subn.opt.root_guid_file);
+
+		context.fabric = p_ftree;
+		context.list = p_ranking_bfs_list;
+		if (parse_node_map(p_ftree->p_osm->subn.opt.root_guid_file,
+				   rank_root_sw_by_guid, &context)) {
+			return FALSE;
+		}
+
+		num_roots = cl_list_count(p_ranking_bfs_list);
+		if (!num_roots) {
+			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_ERROR, "ERR AB25: "
+				"No valid roots supplied\n");
+			return FALSE;
+		}
+
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
+			"Ranked %u valid root switches\n", num_roots);
+	}
+	return TRUE;
+}
+/***************************************************
+ ***************************************************/
+static int fabric_rank_from_roots(IN ftree_fabric_t * p_ftree,
+				  IN cl_list_t* p_ranking_bfs_list)
+{
 	osm_node_t *p_osm_node;
 	osm_node_t *p_remote_osm_node;
 	osm_physp_t *p_osm_physp;
 	ftree_sw_t *p_sw;
 	ftree_sw_t *p_remote_sw;
-	cl_list_t ranking_bfs_list;
 	int res = 0;
-	unsigned num_roots;
 	unsigned max_rank = 0;
 	unsigned i;
 
 	OSM_LOG_ENTER(&p_ftree->p_osm->log);
-	cl_list_init(&ranking_bfs_list, 10);
-
-	/* Rank all the roots and add them to list */
-	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
-		"Fetching root nodes from file %s\n",
-		p_ftree->p_osm->subn.opt.root_guid_file);
-
-	context.fabric = p_ftree;
-	context.list = &ranking_bfs_list;
-	if (parse_node_map(p_ftree->p_osm->subn.opt.root_guid_file,
-			   rank_root_sw_by_guid, &context)) {
-		res = -1;
-		goto Exit;
-	}
 
-	num_roots = cl_list_count(&ranking_bfs_list);
-	if (!num_roots) {
-		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_ERROR, "ERR AB25: "
-			"No valid roots supplied\n");
+	if (!p_ranking_bfs_list) {
 		res = -1;
 		goto Exit;
 	}
-
-	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
-		"Ranked %u valid root switches\n", num_roots);
-
-	/* Now the list has all the roots.
-	   BFS the subnet and update rank on all the switches. */
-
-	while (!cl_is_list_empty(&ranking_bfs_list)) {
-		p_sw = (ftree_sw_t *) cl_list_remove_head(&ranking_bfs_list);
+	while (!cl_is_list_empty(p_ranking_bfs_list)) {
+		p_sw = (ftree_sw_t *) cl_list_remove_head(p_ranking_bfs_list);
 		p_osm_node = p_sw->p_osm_sw->p_node;
 
 		/* note: skipping port 0 on switches */
@@ -3615,7 +3632,7 @@ static int fabric_rank_from_roots(IN ftree_fabric_t * p_ftree)
 					sw_get_guid_ho(p_remote_sw),
 					p_remote_sw->rank);
 				max_rank = p_remote_sw->rank;
-				cl_list_insert_tail(&ranking_bfs_list,
+				cl_list_insert_tail(p_ranking_bfs_list,
 						    p_remote_sw);
 			}
 		}
@@ -3629,7 +3646,6 @@ static int fabric_rank_from_roots(IN ftree_fabric_t * p_ftree)
 	p_ftree->max_switch_rank = max_rank;
 
 Exit:
-	cl_list_destroy(&ranking_bfs_list);
 	OSM_LOG_EXIT(&p_ftree->p_osm->log);
 	return res;
 }				/* fabric_rank_from_roots() */
@@ -3678,18 +3694,50 @@ Exit:
 }				/* fabric_rank_from_hcas() */
 
 /***************************************************
+ * After ranking from HCA's we want to re-rank using
+ * the roots
  ***************************************************/
+static int fabric_rerank_using_root(IN ftree_fabric_t * p_ftree,
+				    IN cl_list_t* p_ranking_bfs_list)
+{
+	ftree_sw_t *p_sw = NULL;
+	ftree_sw_t *p_next_sw;
+	int res;
+
+	OSM_LOG_ENTER(&p_ftree->p_osm->log);
+	cl_list_init(p_ranking_bfs_list, 10);
 
+	p_next_sw = (ftree_sw_t *) cl_qmap_head(&p_ftree->sw_tbl);
+	while (p_next_sw != (ftree_sw_t *) cl_qmap_end(&p_ftree->sw_tbl)) {
+		p_sw = p_next_sw;
+		p_next_sw = (ftree_sw_t *) cl_qmap_next(&p_sw->map_item);
+		if (p_sw->rank == 0)
+			cl_list_insert_tail(p_ranking_bfs_list, p_sw);
+		else
+			p_sw->rank = 0xFFFFFFFF;
+	}
+	res = fabric_rank_from_roots(p_ftree, p_ranking_bfs_list);
+	OSM_LOG_EXIT(&p_ftree->p_osm->log);
+	return res;
+}
+/***************************************************
+ ***************************************************/
 static int fabric_rank(IN ftree_fabric_t * p_ftree)
 {
-	int res = 0;
+	int res = -1;
+	cl_list_t ranking_bfs_list;
 
 	OSM_LOG_ENTER(&p_ftree->p_osm->log);
 
-	if (fabric_roots_provided(p_ftree))
-		res = fabric_rank_from_roots(p_ftree);
-	else
+	if (fabric_roots_provided(p_ftree)){
+		if (fabric_load_roots(p_ftree, &ranking_bfs_list))
+			res = fabric_rank_from_roots(p_ftree, &ranking_bfs_list);
+	}
+	else {
 		res = fabric_rank_from_hcas(p_ftree);
+		if (!res)
+			res = fabric_rerank_using_root(p_ftree, &ranking_bfs_list);
+	}
 
 	if (res)
 		goto Exit;
@@ -3698,6 +3746,7 @@ static int fabric_rank(IN ftree_fabric_t * p_ftree)
 		"FatTree max switch rank is %u\n", p_ftree->max_switch_rank);
 
 Exit:
+	cl_list_destroy(&ranking_bfs_list);
 	OSM_LOG_EXIT(&p_ftree->p_osm->log);
 	return res;
 }				/* fabric_rank() */
@@ -3869,7 +3918,92 @@ Exit:
 
 /***************************************************
  ***************************************************/
+/* Get HCA and switch node, check if this node is the
+ * Only switch that this HCA is connected to */
+static boolean_t has_one_remote_switch(IN ftree_fabric_t *p_ftree,
+				       IN ftree_hca_t *p_hca,
+				       IN osm_node_t* p_node)
+{
+	boolean_t found_other_sw = FALSE;
+	osm_physp_t *p_physp, *p_remote_physp;
+	int i = 1;
+	int ports_num;
+
+	ports_num = osm_node_get_num_physp(p_hca->p_osm_node);
+	while (!found_other_sw && (i < ports_num)) {
+		p_physp = osm_node_get_physp_ptr(p_hca->p_osm_node, i);
+		if (p_physp){
+			p_remote_physp = p_physp->p_remote_physp;
+			if (p_remote_physp && (p_remote_physp->p_node!=p_node))
+				/* Found connection to sw that is not p_node */
+				found_other_sw = TRUE;
+		}
+		i++;
+	}
+
+	return (!found_other_sw);
+}
+
+/***************************************************
+ ***************************************************/
+/* Get a Sw and remove all depended HCA's, meaning all
+ * HCA's which this is the only switch they are connected
+ * to	*/
+static int remove_depended_hca(IN ftree_fabric_t *p_ftree, IN ftree_sw_t *p_sw)
+{
+	ftree_hca_t *p_hca;
+	int counter = 0;
+	int port_num;
+	osm_physp_t* physp;
+	osm_node_t* sw_node;
+	uint64_t remote_hca_guid;
+
+	sw_node = p_sw->p_osm_sw->p_node;
+	for (port_num = 0; port_num < sw_node->physp_tbl_size; port_num++) {
+		physp = osm_node_get_physp_ptr(sw_node, port_num);
+		if (physp && physp->p_remote_physp) {
+			if (osm_node_get_type(physp->p_remote_physp->p_node) == IB_NODE_TYPE_CA) {
+				remote_hca_guid =
+				    osm_node_get_node_guid(physp->p_remote_physp->p_node);
+				p_hca = fabric_get_hca_by_guid(p_ftree, remote_hca_guid);
+				if (p_hca && has_one_remote_switch(p_ftree, p_hca, sw_node)) {
+					cl_qmap_remove_item(&p_ftree->hca_tbl, &p_hca->map_item);
+					hca_destroy(p_hca);
+					counter++;
+				}
+			}
+		}
+	}
+	return counter;
+}
+/***************************************************
+ ***************************************************/
+static void fabric_remove_unranked_sw(IN ftree_fabric_t *p_ftree)
+{
+	ftree_sw_t *p_sw = NULL;
+	ftree_sw_t *p_next_sw;
+	int removed_hca;
+	int count = 0;
 
+	p_next_sw = (ftree_sw_t *) cl_qmap_head(&p_ftree->sw_tbl);
+	while (p_next_sw != (ftree_sw_t *) cl_qmap_end(&p_ftree->sw_tbl)) {
+		p_sw = p_next_sw;
+		p_next_sw = (ftree_sw_t *) cl_qmap_next(&p_sw->map_item);
+		if (!sw_ranked(p_sw)) {
+			cl_qmap_remove_item(&p_ftree->sw_tbl,&p_sw->map_item);
+			removed_hca = remove_depended_hca(p_ftree, p_sw);
+			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
+				"Removing Unranked sw 0x%" PRIx64 " (with %d dependent hca's)\n",
+				sw_get_guid_ho(p_sw),removed_hca);
+			sw_destroy(p_ftree, p_sw);
+			count++;
+		}
+	}
+	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
+		"Removed %d invalid switches\n", count);
+}
+/***************************************************
+ ***************************************************/
 static int construct_fabric(IN void *context)
 {
 	ftree_fabric_t *p_ftree = context;
@@ -3952,6 +4086,7 @@ static int construct_fabric(IN void *context)
 		status = -1;
 		goto Exit;
 	}
+	fabric_remove_unranked_sw(p_ftree);
 
 	/* For each hca and switch, construct array of ports.
 	   This is done after the whole FatTree data structure is ready,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
