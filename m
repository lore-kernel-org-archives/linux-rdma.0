From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 06/10] OpenSM: dfsssp - add support for base/enhanced switch port
Date: Wed, 23 Jan 2013 01:40:49 +0900
Message-ID: <1358872849-16995-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

count SP0 as CA internally (with lmc support for enhanced SP0)

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |  246 +++++++++++++++++++++------------------------
 1 files changed, 113 insertions(+), 133 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 3e9bc31..31e4140 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1096,11 +1096,14 @@ static int dfsssp_build_graph(void *context)
 	dfsssp_ctx->adj_list = adj_list;
 	dfsssp_ctx->adj_list_size = adj_list_size;
 
-	/* count the total number of Hca / LIDs (for lmc>0) in the fabric */
+	/* count the total number of Hca / LIDs (for lmc>0) in the fabric;
+	   even include base/enhanced switch port 0; base SP0 will have lmc=0
+	 */
 	for (item = cl_qmap_head(port_tbl); item != cl_qmap_end(port_tbl);
 	     item = cl_qmap_next(item)) {
 		p_port = (osm_port_t *) item;
-		if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA) {
+		if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA ||
+		    osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_SWITCH) {
 			lmc = osm_port_get_lmc(p_port);
 			total_num_hca += (1 << lmc);
 		}
@@ -1130,6 +1133,10 @@ static int dfsssp_build_graph(void *context)
 		head = link;
 		head->next = NULL;
 
+		/* add SP0 to number of CA conneted to a switch */
+		lmc = osm_node_get_lmc(sw->p_node, 0);
+		adj_list[i].num_hca += (1 << lmc);
+
 		/* iterate over all ports in the switch, start with port 1 (port 0 is a managment port) */
 		for (port = 1; port < sw->num_ports; port++) {
 			/* get the node behind the port */
@@ -1381,12 +1388,9 @@ static int dijkstra(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
    from the last dijsktra step
 */
 static int update_lft(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
-		      uint32_t adj_list_size, osm_port_t * p_port)
+		      uint32_t adj_list_size, osm_port_t * p_port, uint16_t lid)
 {
 	uint32_t i = 0;
-	int32_t index = -1;
-	uint64_t guid;
-	uint16_t lid = 0;
 	uint8_t port = 0;
 	uint8_t hops = 0;
 	osm_switch_t *p_sw = NULL;
@@ -1396,34 +1400,7 @@ static int update_lft(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
-	if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_SWITCH) {
-		/* we have to search for the right switch, with it's lid to update the LFT */
-		guid = cl_ntoh64(osm_node_get_node_guid(p_port->p_node));
-		for (i = 0; i < adj_list_size; i++) {
-			if (adj_list[i].guid == guid) {
-				index = i;
-				break;
-			}
-		}
-	} else {
-		/* update the routing to a Hca -> index 0 contains the Hca */
-		index = 0;
-	}
-
-	if (index >= 0) {
-		lid = adj_list[index].lid;
-	} else {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
-			"ERR AD06: cannot find port in adj_list to run update_lft\n");
-		return 1;
-	}
-
 	for (i = 1; i < adj_list_size; i++) {
-		/* for each switch the port to the 'self'lid is the managment port (=0) */
-		adj_list[i].sw->new_lft[adj_list[i].lid] = 0;
-		/* the hop count to to the 'self'lid is 0 for each switch */
-		osm_switch_set_hops(adj_list[i].sw, adj_list[i].lid, 0, 0);
-
 		/* if no route goes thru this switch -> cycle */
 		if (!(adj_list[i].used_link))
 			continue;
@@ -1498,7 +1475,7 @@ static int update_lft(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
    of paths on this link
 */
 static void update_weights(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
-			   uint32_t adj_list_size, osm_port_t * port)
+			   uint32_t adj_list_size)
 {
 	uint32_t i = 0, j = 0;
 	uint32_t additional_weight = 0;
@@ -1509,11 +1486,7 @@ static void update_weights(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
 		/* if no route goes thru this switch -> cycle */
 		if (!(adj_list[i].used_link))
 			continue;
-		/* if the source of dijkstra was a Hca -> add num_hca for the weight, else a weight of 1 */
-		if (osm_node_get_type(port->p_node) == IB_NODE_TYPE_CA)
-			additional_weight = adj_list[i].num_hca;
-		else
-			additional_weight = 1;
+		additional_weight = adj_list[i].num_hca;
 
 		j = i;
 		while (adj_list[j].used_link) {
@@ -1596,6 +1569,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	uint64_t *paths_per_vl = NULL;
 	uint64_t from = 0, to = 0, count = 0;
 	uint8_t *split_count = NULL;
+	uint8_t ntype = 0;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
@@ -1624,11 +1598,18 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 		cdg[i] = NULL;
 
 	count = 0;
-	/* count all ports (also multiple LIDs) of type CA for size of VL table */
+	/* count all ports (also multiple LIDs) of type CA or SP0 for size of VL table */
 	for (item1 = cl_qmap_head(port_tbl); item1 != cl_qmap_end(port_tbl);
 	     item1 = cl_qmap_next(item1)) {
 		dest_port = (osm_port_t *) item1;
-		if (osm_node_get_type(dest_port->p_node) == IB_NODE_TYPE_CA) {
+		ntype = osm_node_get_type(dest_port->p_node);
+		if (ntype == IB_NODE_TYPE_CA || ntype == IB_NODE_TYPE_SWITCH) {
+			/* only SP0 with SLtoVLMapping support will be processed */
+			if (ntype == IB_NODE_TYPE_SWITCH
+			    && !(dest_port->p_physp->port_info.capability_mask
+			    & IB_PORT_CAP_HAS_SL_MAP))
+				continue;
+
 			lmc = osm_port_get_lmc(dest_port);
 			count += (1 << lmc);
 		}
@@ -1646,7 +1627,14 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	for (item1 = cl_qmap_head(port_tbl); item1 != cl_qmap_end(port_tbl);
 	     item1 = cl_qmap_next(item1)) {
 		dest_port = (osm_port_t *) item1;
-		if (osm_node_get_type(dest_port->p_node) == IB_NODE_TYPE_CA) {
+		ntype = osm_node_get_type(dest_port->p_node);
+		if (ntype == IB_NODE_TYPE_CA || ntype == IB_NODE_TYPE_SWITCH) {
+			/* only SP0 with SLtoVLMapping support will be processed */
+			if (ntype == IB_NODE_TYPE_SWITCH
+			    && !(dest_port->p_physp->port_info.capability_mask
+			    & IB_PORT_CAP_HAS_SL_MAP))
+				continue;
+
 			osm_port_get_lid_range_ho(dest_port, &min_lid_ho,
 						  &max_lid_ho);
 			for (dlid = min_lid_ho; dlid <= max_lid_ho; dlid++, i++)
@@ -1657,53 +1645,60 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	vltable_sort_lids(srcdest2vl_table);
 
 	test_vl = 0;
-	/* fill cdg[0] with routes from each src/dest port combination for all Hca in the subnet */
+	/* fill cdg[0] with routes from each src/dest port combination for all Hca/SP0 in the subnet */
 	for (item1 = cl_qmap_head(port_tbl); item1 != cl_qmap_end(port_tbl);
 	     item1 = cl_qmap_next(item1)) {
 		dest_port = (osm_port_t *) item1;
-		if (osm_node_get_type(dest_port->p_node) == IB_NODE_TYPE_CA) {
-
-			for (item2 = cl_qmap_head(port_tbl);
-			     item2 != cl_qmap_end(port_tbl);
-			     item2 = cl_qmap_next(item2)) {
-				src_port = (osm_port_t *) item2;
-				if (osm_node_get_type(src_port->p_node) ==
-				    IB_NODE_TYPE_CA && src_port != dest_port) {
-
-					/* iterate over LIDs of src and dest port */
-					osm_port_get_lid_range_ho(src_port,
-								  &min_lid_ho,
-								  &max_lid_ho);
-					for (slid = min_lid_ho;
-					     slid <= max_lid_ho; slid++) {
-						osm_port_get_lid_range_ho
-						    (dest_port, &min_lid_ho2,
-						     &max_lid_ho2);
-						for (dlid = min_lid_ho2;
-						     dlid <= max_lid_ho2;
-						     dlid++) {
-
-							/* try to add the path to cdg[0] */
-							err =
-							    update_channel_dep_graph
-							    (&(cdg[test_vl]),
-							     src_port, slid,
-							     dest_port, dlid);
-							if (err) {
-								OSM_LOG(p_mgr->
-									p_log,
-									OSM_LOG_ERROR,
-									"ERR AD14: cannot allocate memory for cdg node or link in update_channel_dep_graph(...)\n");
-								goto ERROR;
-							}
-							/* add the <s,d> kombination / coresponding virtual lane to the VL table */
-							vltable_insert
-							    (srcdest2vl_table,
-							     slid, dlid,
-							     test_vl);
-							paths_per_vl[test_vl]++;
+		ntype = osm_node_get_type(dest_port->p_node);
+		if ((ntype != IB_NODE_TYPE_CA && ntype != IB_NODE_TYPE_SWITCH)
+		    || !(dest_port->p_physp->port_info.capability_mask
+		    & IB_PORT_CAP_HAS_SL_MAP))
+			continue;
 
+		for (item2 = cl_qmap_head(port_tbl);
+		     item2 != cl_qmap_end(port_tbl);
+		     item2 = cl_qmap_next(item2)) {
+			src_port = (osm_port_t *) item2;
+			ntype = osm_node_get_type(src_port->p_node);
+			if ((ntype != IB_NODE_TYPE_CA
+			    && ntype != IB_NODE_TYPE_SWITCH)
+			    || !(src_port->p_physp->port_info.capability_mask
+			    & IB_PORT_CAP_HAS_SL_MAP))
+				continue;
+
+			if (src_port != dest_port) {
+				/* iterate over LIDs of src and dest port */
+				osm_port_get_lid_range_ho(src_port, &min_lid_ho,
+							  &max_lid_ho);
+				for (slid = min_lid_ho; slid <= max_lid_ho;
+				     slid++) {
+					osm_port_get_lid_range_ho
+					    (dest_port, &min_lid_ho2,
+					     &max_lid_ho2);
+					for (dlid = min_lid_ho2;
+					     dlid <= max_lid_ho2;
+					     dlid++) {
+
+						/* try to add the path to cdg[0] */
+						err =
+						    update_channel_dep_graph
+						    (&(cdg[test_vl]),
+						     src_port, slid,
+						     dest_port, dlid);
+						if (err) {
+							OSM_LOG(p_mgr->
+								p_log,
+								OSM_LOG_ERROR,
+								"ERR AD14: cannot allocate memory for cdg node or link in update_channel_dep_graph(...)\n");
+							goto ERROR;
 						}
+						/* add the <s,d> kombination / coresponding virtual lane to the VL table */
+						vltable_insert
+						    (srcdest2vl_table,
+						     slid, dlid,
+						     test_vl);
+						paths_per_vl[test_vl]++;
+
 					}
 
 				}
@@ -1833,7 +1828,10 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
 		"Balancing the paths on the available Virtual Lanes\n");
 
-	/* balancing virtual lanes, but avoid additional cycle check -> balancing suboptimal */
+	/* balancing virtual lanes, but avoid additional cycle check -> balancing suboptimal;
+	   sl/vl != 0 might be assigned to loopback packets (i.e. slid/dlid on the
+	   same port for lmc>0), but thats no problem, see IBAS 10.2.2.3
+	 */
 	if (vl_needed == 1) {
 		from = 0;
 		count = paths_per_vl[0] / vl_avail;
@@ -1928,6 +1926,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 	osm_port_t *port = NULL;
 	uint32_t i = 0, err = 0;
 	uint16_t lid = 0, min_lid_ho = 0, max_lid_ho = 0;
+	uint8_t lmc = 0;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
@@ -1939,68 +1938,48 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		sw = (osm_switch_t *) item;
 		/* initialize LIDs in buffer to invalid port number */
 		memset(sw->new_lft, OSM_NO_PATH, sw->max_lid_ho + 1);
+		/* initialize LFT and hop count for bsp0/esp0 of the switch */
+		min_lid_ho = cl_ntoh16(osm_node_get_base_lid(sw->p_node, 0));
+		lmc = osm_node_get_lmc(sw->p_node, 0);
+		for (i = min_lid_ho; i < min_lid_ho + (1 << lmc); i++) {
+			/* for each switch the port to the 'self'lid is the managment port 0 */
+			sw->new_lft[i] = 0;
+			/* the hop count to the 'self'lid is 0 for each switch */
+			osm_switch_set_hops(sw, i, 0, 0);
+		}
 	}
 
-	/* do the routing for the each Hca in the subnet */
+	/* do the routing for the each Hca in the subnet and each switch
+	   in the subnet (to add the routes to base/enhanced SP0)
+	 */
 	for (item = cl_qmap_head(port_tbl); item != cl_qmap_end(port_tbl);
 	     item = cl_qmap_next(item)) {
 		port = (osm_port_t *) item;
 
-		/* if behind port is a Hca -> calculate shortest path with dijkstra from node to all switches/Hca */
+		/* calculate shortest path with dijkstra from node to all switches/Hca */
 		if (osm_node_get_type(port->p_node) == IB_NODE_TYPE_CA) {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 				"Processing Hca with GUID 0x%" PRIx64 "\n",
 				cl_ntoh64(osm_node_get_node_guid
 					  (port->p_node)));
-
-			/* distribute the LID range across the ports that can reach those LIDs
-			   to have disjoint paths for one destination port with lmc>0
-			 */
-			osm_port_get_lid_range_ho(port, &min_lid_ho,
-						  &max_lid_ho);
-			for (lid = min_lid_ho; lid <= max_lid_ho; lid++) {
-				/* do dijkstra from this Hca/LID to each switch */
-				err =
-				    dijkstra(p_mgr, adj_list, adj_list_size,
-					     port, lid);
-				if (err)
-					return err;
-				if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log,
-				    OSM_LOG_DEBUG))
-					print_routes(p_mgr, adj_list,
-						     adj_list_size, port);
-
-				/* make an update for the linear forwarding tables of the switches */
-				err =
-				    update_lft(p_mgr, adj_list, adj_list_size,
-					       port);
-				if (err)
-					return err;
-
-				/* add weights for calculated routes to adjust the weights for the next cycle */
-				update_weights(p_mgr, adj_list, adj_list_size,
-					       port);
-
-				if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log,
-				    OSM_LOG_DEBUG))
-					dfsssp_print_graph(p_mgr, adj_list,
-							   adj_list_size);
-			}
-		}
-	}
-	/* do the routing for the each switch in the subnet to add the routes from switch to switch */
-	for (item = cl_qmap_head(port_tbl); item != cl_qmap_end(port_tbl);
-	     item = cl_qmap_next(item)) {
-		port = (osm_port_t *) item;
-
-		if (osm_node_get_type(port->p_node) == IB_NODE_TYPE_SWITCH) {
+		} else if (osm_node_get_type(port->p_node) == IB_NODE_TYPE_SWITCH) {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 				"Processing switch with GUID 0x%" PRIx64 "\n",
 				cl_ntoh64(osm_node_get_node_guid
 					  (port->p_node)));
+		} else {
+			/* we don't handle routers, in case they show up */
+			continue;
+		}
 
-			lid = cl_ntoh16(osm_node_get_base_lid(port->p_node, 0));
-			/* do dijkstra from this switch to each switch */
+		/* distribute the LID range across the ports that can reach those LIDs
+		   to have disjoint paths for one destination port with lmc>0;
+		   for switches with bsp0: min=max; with esp0: max>min if lmc>0
+		 */
+		osm_port_get_lid_range_ho(port, &min_lid_ho,
+					  &max_lid_ho);
+		for (lid = min_lid_ho; lid <= max_lid_ho; lid++) {
+			/* do dijkstra from this Hca/LID/SP0 to each switch */
 			err =
 			    dijkstra(p_mgr, adj_list, adj_list_size, port, lid);
 			if (err)
@@ -2010,12 +1989,13 @@ static int dfsssp_do_dijkstra_routing(void *context)
 					     port);
 
 			/* make an update for the linear forwarding tables of the switches */
-			err = update_lft(p_mgr, adj_list, adj_list_size, port);
+			err =
+			    update_lft(p_mgr, adj_list, adj_list_size, port, lid);
 			if (err)
 				return err;
 
 			/* add weights for calculated routes to adjust the weights for the next cycle */
-			update_weights(p_mgr, adj_list, adj_list_size, port);
+			update_weights(p_mgr, adj_list, adj_list_size);
 
 			if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_DEBUG))
 				dfsssp_print_graph(p_mgr, adj_list,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
