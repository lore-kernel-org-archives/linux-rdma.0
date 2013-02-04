From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Add physp_p discovery count support
Date: Mon,  4 Feb 2013 15:20:11 +0200
Message-ID: <1359984011-30753-10-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the cases below, we won't have updated PortInfo information between one
of the link ports. In that case we must drop the link.

1. When receive timeouts for PortInfoGet MADs.
2. When port becomes LinkUp during a discovery, when link's peer is
   discovered first in DOWN state.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_node.h  |  6 ++++++
 opensm/osm_drop_mgr.c      | 47 ++++++++++++++++++++++++++++++++++++++++++++--
 opensm/osm_node.c          |  9 +++++++++
 opensm/osm_node_info_rcv.c | 13 +++++++++++++
 opensm/osm_port_info_rcv.c | 11 +++++++++--
 opensm/osm_state_mgr.c     |  2 ++
 6 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/include/opensm/osm_node.h b/include/opensm/osm_node.h
index 482ed89..dd1c5f9 100644
--- a/include/opensm/osm_node.h
+++ b/include/opensm/osm_node.h
@@ -102,6 +102,7 @@ typedef struct osm_node {
 	uint32_t discovery_count;
 	uint32_t physp_tbl_size;
 	char *print_desc;
+	uint8_t *physp_discovered;
 	osm_physp_t physp_table[1];
 } osm_node_t;
 /*
@@ -133,6 +134,11 @@ typedef struct osm_node {
 *	print_desc
 *		A printable version of the node description.
 *
+*	physp_discovered
+*		Array of physp_discovered objects for all ports of this node.
+*		Each object indiactes whether the port has been discovered
+*		during the sweep or not. 1 means that the port had been discovered.
+*
 *	phsyp_table
 *		Array of physical port objects belonging to this node.
 *		Index is contiguous by local port number.
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 5e5f1b1..b309273 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -378,9 +378,11 @@ static boolean_t drop_mgr_process_node(osm_sm_t * sm, IN osm_node_t * p_node)
 static void drop_mgr_check_node(osm_sm_t * sm, IN osm_node_t * p_node)
 {
 	ib_net64_t node_guid;
-	osm_physp_t *p_physp;
+	osm_physp_t *p_physp, *p_remote_physp;
+	osm_node_t *p_remote_node;
 	osm_port_t *p_port;
 	ib_net64_t port_guid;
+	uint8_t port_num, remote_port_num;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -428,7 +430,7 @@ static void drop_mgr_check_node(osm_sm_t * sm, IN osm_node_t * p_node)
 		goto Exit;
 	}
 
-	if (p_port->discovery_count == 0) {
+	if (!p_node->physp_discovered[0]) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Node 0x%016" PRIx64 " port has discovery count zero\n",
 			cl_ntoh64(node_guid));
@@ -437,6 +439,47 @@ static void drop_mgr_check_node(osm_sm_t * sm, IN osm_node_t * p_node)
 		goto Exit;
 	}
 
+	/*
+	 * Unlink all ports that havn't been discovered during the last sweep.
+	 * Optimization: Skip the check if discovered all the ports of the switch.
+	 */
+	if (p_port->discovery_count < p_node->physp_tbl_size) {
+		for (port_num = 1; port_num < p_node->physp_tbl_size; port_num++) {
+			if (!p_node->physp_discovered[port_num]) {
+				p_physp = osm_node_get_physp_ptr(p_node, port_num);
+				if (!p_physp)
+					continue;
+				p_remote_physp = osm_physp_get_remote(p_physp);
+				if (!p_remote_physp)
+					continue;
+
+				p_remote_node =
+				    osm_physp_get_node_ptr(p_remote_physp);
+				remote_port_num =
+				    osm_physp_get_port_num(p_remote_physp);
+
+				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+					"Unlinking local node 0x%" PRIx64
+					", port %u"
+					"\n\t\t\t\tand remote node 0x%" PRIx64
+					", port %u\n due to missing PortInfo",
+					cl_ntoh64(osm_node_get_node_guid
+						  (p_node)), port_num,
+					cl_ntoh64(osm_node_get_node_guid
+						  (p_remote_node)),
+					remote_port_num);
+
+				if (sm->ucast_mgr.cache_valid)
+					osm_ucast_cache_add_link(&sm->ucast_mgr,
+								 p_physp,
+								 p_remote_physp);
+
+				osm_node_unlink(p_node, (uint8_t) port_num,
+						p_remote_node,
+						(uint8_t) remote_port_num);
+			}
+		}
+	}
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
 	return;
diff --git a/opensm/osm_node.c b/opensm/osm_node.c
index fc71e0f..c2ee7a4 100644
--- a/opensm/osm_node.c
+++ b/opensm/osm_node.c
@@ -99,6 +99,12 @@ osm_node_t *osm_node_new(IN const osm_madw_t * p_madw)
 	p_node->node_info = *p_ni;
 	p_node->physp_tbl_size = size + 1;
 
+	p_node->physp_discovered = malloc(sizeof(uint8_t) * p_node->physp_tbl_size);
+	if (!p_node->physp_discovered) {
+		free(p_node);
+		return NULL;
+	}
+	memset(p_node->physp_discovered, 0, sizeof(uint8_t) * p_node->physp_tbl_size);
 	/*
 	   Construct Physical Port objects owned by this Node.
 	   Then, initialize the Physical Port through with we
@@ -136,6 +142,9 @@ static void node_destroy(IN osm_node_t * p_node)
 	/* cleanup printable node_desc field */
 	if (p_node->print_desc)
 		free(p_node->print_desc);
+
+	/* cleanup physp_discovered array */
+	free(p_node->physp_discovered);
 }
 
 void osm_node_delete(IN OUT osm_node_t ** p_node)
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 0187d45..cb96f29 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -172,6 +172,19 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 		goto _exit;
 	}
 
+	p_physp = osm_node_get_physp_ptr(p_node, port_num);
+	/*
+	 * If the link went UP, after we already discovered it, we shouldn't
+	 * set the link between the ports and resweep.
+	 */
+	if (osm_physp_get_port_state(p_physp) == IB_LINK_DOWN &&
+	    p_node->physp_discovered[port_num]) {
+		/* Link down on another side. Don't create a link*/
+		p_node->physp_discovered[port_num] = 0;
+		sm->p_subn->force_heavy_sweep = TRUE;
+		goto _exit;
+	}
+
 	if (osm_node_has_any_link(p_node, port_num) &&
 	    sm->p_subn->force_heavy_sweep == FALSE &&
 	    (!p_ni_context->dup_count ||
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 1a5ee87..fdd3a02 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -630,16 +630,23 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		    (ib_port_info_get_port_state(p_pi) == IB_LINK_INIT ||
 		     p_physp->need_update > 1) ? 1 : 0;
 
+		p_node->physp_discovered[port_num] = 1;
+
 		switch (osm_node_get_type(p_node)) {
 		case IB_NODE_TYPE_CA:
 		case IB_NODE_TYPE_ROUTER:
-			p_port->discovery_count++;
+			if (!p_node->physp_discovered[port_num]) {
+				p_port->discovery_count++;
+				p_node->physp_discovered[port_num] = 1;
+			}
 			pi_rcv_process_ca_or_router_port(sm, p_node, p_physp,
 							 p_pi);
 			break;
 		case IB_NODE_TYPE_SWITCH:
-			if (port_num == 0)
+			if (!p_node->physp_discovered[port_num]) {
 				p_port->discovery_count++;
+				p_node->physp_discovered[port_num] = 1;
+			}
 			pi_rcv_process_switch_port(sm, p_node, p_physp, p_pi);
 			break;
 		default:
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 3dc51e3..8229b06 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -97,6 +97,8 @@ static void state_mgr_reset_node_count(IN cl_map_item_t * p_map_item,
 	osm_node_t *p_node = (osm_node_t *) p_map_item;
 
 	p_node->discovery_count = 0;
+
+	memset(p_node->physp_discovered, 0, sizeof(uint8_t) * p_node->physp_tbl_size);
 }
 
 static void state_mgr_reset_port_count(IN cl_map_item_t * p_map_item,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
