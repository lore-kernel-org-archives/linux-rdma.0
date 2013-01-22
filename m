From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 07/10] OpenSM: dfsssp - change the port traversal for sssp
Date: Wed, 23 Jan 2013 01:41:07 +0900
Message-ID: <1358872867-17022-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

There are some really rare cases were the sssp part of dfsssp routing
will produce a suboptimal path assignment, therefore some links will be
oversubscribed and some others will be undersubscribed with paths;
-> this results in a bad balancing for Hca<->Hca traffic.
The last patch (adding SP0 support) made the situation even worse.

This patch returns the focus to Hca<->Hca traffic balancing, again.
Previously, the ports for the dijkstra loop have been choosen 'randomly',
i.e. obtained by the order of p_subn->port_guid_tbl.
Now we process all ports (Hca) of one switch, first, until we proceed
with the next switch. Besides that, we sort the switches.
The switches will be sorted in descending order with respect to the
number of attached Hca.

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |  136 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 31e4140..b82d8c8 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1013,6 +1013,72 @@ ERROR:
 /**********************************************************************
  **********************************************************************/
 
+/************ helper functions to generate an ordered list of ports ***
+ ************ (functions copied from osm_ucast_mgr.c and modified) ****
+ **********************************************************************/
+static void add_sw_endports_to_order_list(osm_switch_t * sw,
+					  osm_ucast_mgr_t * m)
+{
+	osm_port_t *port;
+	osm_physp_t *p;
+	int i;
+
+	for (i = 1; i < sw->num_ports; i++) {
+		p = osm_node_get_physp_ptr(sw->p_node, i);
+		if (p && p->p_remote_physp && !p->p_remote_physp->p_node->sw) {
+			port = osm_get_port_by_guid(m->p_subn,
+						    p->p_remote_physp->
+						    port_guid);
+			if (!port)
+				continue;
+			cl_qlist_insert_tail(&m->port_order_list,
+					     &port->list_item);
+		}
+	}
+}
+
+static void add_guid_to_order_list(uint64_t guid, osm_ucast_mgr_t * m)
+{
+	osm_port_t *port = osm_get_port_by_guid(m->p_subn, cl_hton64(guid));
+
+	if (!port) {
+		 OSM_LOG(m->p_log, OSM_LOG_DEBUG,
+			 "port guid not found: 0x%016" PRIx64 "\n", guid);
+	}
+
+	cl_qlist_insert_tail(&m->port_order_list, &port->list_item);
+}
+
+/* compare function of #Hca attached to a switch for stdlib qsort */
+static int cmp_num_hca(const void * l1, const void * l2)
+{
+	vertex_t *sw1 = *((vertex_t **) l1);
+	vertex_t *sw2 = *((vertex_t **) l2);
+	uint32_t num_hca1 = 0, num_hca2 = 0;
+
+	if (sw1)
+		num_hca1 = sw1->num_hca;
+	if (sw2)
+		num_hca2 = sw2->num_hca;
+
+	if (num_hca1 > num_hca2)
+		return -1;
+	else if (num_hca1 < num_hca2)
+		return 1;
+	else
+		return 0;
+}
+
+/* use stdlib to sort the switch array depending on num_hca */
+static inline void sw_list_sort_by_num_hca(vertex_t ** sw_list,
+					   uint32_t sw_list_size)
+{
+	qsort(sw_list, sw_list_size, sizeof(vertex_t *), cmp_num_hca);
+}
+
+/**********************************************************************
+ **********************************************************************/
+
 static void dfsssp_print_graph(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
 			       uint32_t size)
 {
@@ -1172,7 +1238,7 @@ static int dfsssp_build_graph(void *context)
 					link = head;
 					head = head->next;
 					free(link);
-                                }
+				}
 				return 1;
 			}
 			link = link->next;
@@ -1919,7 +1985,12 @@ static int dfsssp_do_dijkstra_routing(void *context)
 	vertex_t *adj_list = (vertex_t *) dfsssp_ctx->adj_list;
 	uint32_t adj_list_size = dfsssp_ctx->adj_list_size;
 
-	cl_qmap_t *port_tbl = &p_mgr->p_subn->port_guid_tbl;	/* 1 managment port per switch + 1 or 2 ports for each Hca */
+	vertex_t **sw_list = NULL;
+	uint32_t sw_list_size = 0;
+	uint64_t guid = 0;
+	cl_qlist_t *qlist = NULL;
+	cl_list_item_t *qlist_item = NULL;
+
 	cl_qmap_t *sw_tbl = &p_mgr->p_subn->sw_guid_tbl;
 	cl_map_item_t *item = NULL;
 	osm_switch_t *sw = NULL;
@@ -1949,12 +2020,64 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		}
 	}
 
+	/* we need an intermediate array of pointers to switches in adj_list;
+	   this array will be sorted in respect to num_hca (descending)
+	 */
+	sw_list_size = adj_list_size - 1;
+	sw_list = (vertex_t **)malloc(sw_list_size * sizeof(vertex_t *));
+	if (!sw_list) {
+		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+			"ERR AD29: cannot allocate memory for sw_list in dfsssp_do_dijkstra_routing\n");
+		return 1;
+	}
+	memset(sw_list, 0, sw_list_size * sizeof(vertex_t *));
+
+	/* fill the array with references to the 'real' sw in adj_list */
+	for (i = 0; i < sw_list_size; i++)
+		sw_list[i] = &(adj_list[i + 1]);
+
+	/* sort the sw_list in descending order */
+	sw_list_sort_by_num_hca(sw_list, sw_list_size);
+
+	/* if we mix Hca and SP0 during the dijkstra routing, we might end up
+	   in rare cases with a bad balancing for Hca<->Hca connections, i.e.
+	   some inter-switch links get oversubscribed with paths
+	 */
+	cl_qlist_init(&p_mgr->port_order_list);
+	/* add Hca ports first to ensure good Hca<->Hca balancing */
+	for (i = 0; i < adj_list_size - 1; i++) {
+		if (sw_list[i] && sw_list[i]->sw) {
+			sw = (osm_switch_t *)(sw_list[i]->sw);
+			add_sw_endports_to_order_list(sw, p_mgr);
+		} else {
+			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+				"ERR AD30: corrupted sw_list array in dfsssp_do_dijkstra_routing\n");
+		}
+	}
+	/* add SP0 afterwards with have lower priority for balancing */
+	for (i = 0; i < sw_list_size; i++) {
+		if (sw_list[i] && sw_list[i]->sw) {
+			sw = (osm_switch_t *)(sw_list[i]->sw);
+			guid = cl_ntoh64(osm_node_get_node_guid(sw->p_node));
+			add_guid_to_order_list(guid, p_mgr);
+		} else {
+			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+				"ERR AD31: corrupted sw_list array in dfsssp_do_dijkstra_routing\n");
+			return 1;
+		}
+	}
+
+	/* the intermediate array lived long enough */
+	free(sw_list);
+
 	/* do the routing for the each Hca in the subnet and each switch
 	   in the subnet (to add the routes to base/enhanced SP0)
 	 */
-	for (item = cl_qmap_head(port_tbl); item != cl_qmap_end(port_tbl);
-	     item = cl_qmap_next(item)) {
-		port = (osm_port_t *) item;
+	qlist = &p_mgr->port_order_list;
+	for (qlist_item = cl_qlist_head(qlist);
+	     qlist_item != cl_qlist_end(qlist);
+	     qlist_item = cl_qlist_next(qlist_item)) {
+		port = (osm_port_t *)cl_item_obj(qlist_item, port, list_item);
 
 		/* calculate shortest path with dijkstra from node to all switches/Hca */
 		if (osm_node_get_type(port->p_node) == IB_NODE_TYPE_CA) {
@@ -2003,6 +2126,9 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		}
 	}
 
+	/* ordered port list not needed after the dijkstra step */
+	cl_qlist_remove_all(&p_mgr->port_order_list);
+
 	/* try deadlock removal only for the dfsssp routing (not for the sssp case, which is a subset of the dfsssp algorithm) */
 	if (dfsssp_ctx->routing_type == OSM_ROUTING_ENGINE_TYPE_DFSSSP) {
 		/* remove potential deadlocks by assigning different virtual lanes to src/dest paths and balance the lanes */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
