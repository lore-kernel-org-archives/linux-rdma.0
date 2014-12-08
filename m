From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/osm_perfmgr.c: Output remote port on perfmgr error
	counter log messages
Date: Mon, 08 Dec 2014 10:39:12 -0800
Message-ID: <1418063952.20566.44.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Outputting the remote node and port aids in servicing the fabric more
quickly for system administrators.  In addition, it aids in fabric
monitoring efforts that scan the log.

Example output before this patch:

perfmgr_log_errors: ERR 543C: VL15Dropped : 17 : node "ibcore1 L101" (NodeGUID: 0x66a02e8001313) : port 11

Example output wth this patch:

perfmgr_log_errors: ERR 543C: VL15Dropped : 17 : node "ibcore1 L101" (NodeGUID: 0x66a02e8001313) : port 11 connected to "hype355 qib0" (NodeGUID: 0x40ed770000751100) : port 1

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h |    5 +++
 opensm/osm_perfmgr.c         |   59 +++++++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 44a278d..ec12eb6 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -105,6 +105,11 @@ typedef struct monitored_port {
 	/* ClassPortInfo fields */
 	boolean_t cpi_valid;
 	ib_net16_t cap_mask;
+	/* Remote end connected to */
+	boolean_t remote_valid;
+	uint64_t remote_guid;
+	char *remote_name;
+	uint8_t remote_port;
 } monitored_port_t;
 
 /* Node to store information about nodes being monitored */
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index d3fa1f7..4ab654b 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -144,6 +144,7 @@ static void remove_marked_nodes(osm_perfmgr_t * pm)
 {
 	while (pm->remove_list) {
 		monitored_node_t *next = pm->remove_list->next;
+		int port;
 
 		cl_qmap_remove_item(&pm->monitored_map,
 				    (cl_map_item_t *) (pm->remove_list));
@@ -155,6 +156,14 @@ static void remove_marked_nodes(osm_perfmgr_t * pm)
 
 		if (pm->remove_list->name)
 			free(pm->remove_list->name);
+
+		for (port = pm->remove_list->esp0 ? 0 : 1;
+		     port < pm->remove_list->num_ports;
+		     port++) {
+			if (pm->remove_list->port[port].remote_name)
+				free(pm->remove_list->port[port].remote_name);
+		}
+
 		free(pm->remove_list);
 		pm->remove_list = next;
 	}
@@ -554,11 +563,24 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 				  ib_switch_info_is_enhanced_port0(&node->sw->
 								   switch_info));
 		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
-			mon_node->port[port].orig_lid = 0;
-			mon_node->port[port].valid = FALSE;
-			if (osm_physp_is_valid(&node->physp_table[port])) {
-				mon_node->port[port].orig_lid = get_base_lid(node, port);
-				mon_node->port[port].valid = TRUE;
+			monitored_port_t *mon_port = &mon_node->port[port];
+			osm_physp_t *p_physp = &node->physp_table[port];
+			osm_physp_t *p_remote_physp = p_physp->p_remote_physp;
+
+			mon_port->orig_lid = 0;
+			mon_port->valid = FALSE;
+			if (osm_physp_is_valid(p_physp)) {
+				mon_port->orig_lid = get_base_lid(node, port);
+				mon_port->valid = TRUE;
+			}
+			mon_port->remote_valid = FALSE;
+			mon_port->remote_name = NULL;
+			if (p_remote_physp && osm_physp_is_valid(p_remote_physp)) {
+				osm_node_t *p_remote_node = p_remote_physp->p_node;
+				mon_port->remote_valid = TRUE;
+				mon_port->remote_guid = p_remote_node->node_info.node_guid;
+				mon_port->remote_name = strdup(p_remote_node->print_desc);
+				mon_port->remote_port = p_remote_physp->port_num;
 			}
 		}
 
@@ -1429,13 +1451,26 @@ static void perfmgr_log_errors(osm_perfmgr_t * pm,
 	}
 
 #define LOG_ERR_CNT(errname, errnum, counter_name) \
-	if (reading->counter_name > prev_read.counter_name) \
-		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR %s: " \
-			"%s : %" PRIu64 " : node " \
-			"\"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u\n", \
-			errnum, errname, \
-			reading->counter_name - prev_read.counter_name, \
-			mon_node->name, mon_node->guid, port);
+	if (reading->counter_name > prev_read.counter_name) { \
+		if (mon_node->port[port].remote_valid == TRUE) \
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR %s: " \
+				"%s : %" PRIu64 " : node " \
+				"\"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u " \
+				"connected to \"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u\n", \
+				errnum, errname, \
+				reading->counter_name - prev_read.counter_name, \
+				mon_node->name, mon_node->guid, port, \
+				mon_node->port[port].remote_name, \
+				mon_node->port[port].remote_guid, \
+				mon_node->port[port].remote_port); \
+		else \
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR %s: " \
+				"%s : %" PRIu64 " : node " \
+				"\"%s\" (NodeGUID: 0x%" PRIx64 ") : port %u\n", \
+				errnum, errname, \
+				reading->counter_name - prev_read.counter_name, \
+				mon_node->name, mon_node->guid, port); \
+	}
 
 	LOG_ERR_CNT("SymbolErrorCounter",           "5431", symbol_err_cnt);
 	LOG_ERR_CNT("LinkErrorRecoveryCounter",     "5432", link_err_recover);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
