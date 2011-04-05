From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port,
 better last block handling
Date: Tue, 05 Apr 2011 14:05:05 -0400
Message-ID: <4D9B59D1.9010209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


PKey table capacities are not required to be multiples of the PKey table block
size (32 entries of 16 pkeys).

Current code could enable partition enforcement on the peer switch port
even if the last partition table block were truncated. In this case, it's
better to disable partition enforcement on those ports.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 92f8f2b..f6bc9d1 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -375,6 +375,29 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	return ret;
 }
 
+static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
+				     const osm_pkey_tbl_t * p_pkey_tbl)
+{
+	ib_pkey_table_t *last_block;
+	uint16_t index, last_index = 0;
+
+	last_block = osm_pkey_tbl_new_block_get(p_pkey_tbl,
+						p_pkey_tbl->used_blocks - 1);
+
+	if (p_pkey_tbl->used_blocks == p_pkey_tbl->max_blocks)
+		last_index = cl_ntoh16(p_port->p_node->node_info.partition_cap) % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+	if (last_index == 0)
+		last_index = IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+	index = last_index;
+	do {
+		index--;
+		if (!ib_pkey_is_invalid(last_block->pkey_entry[index]))
+			break;
+	} while (index != 0);
+
+	return index;
+}
+
 static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 				     const osm_subn_t * p_subn,
 				     const osm_port_t * const p_port,
@@ -387,6 +410,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	osm_pkey_tbl_t *p_peer_pkey_tbl;
 	uint16_t block_index;
 	uint16_t peer_max_blocks;
+	uint16_t last_index;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_pkey_table_t empty_block;
 	int ret = 0;
@@ -414,6 +437,22 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 			p_node->print_desc);
 		enforce = FALSE;
 		ret = -1;
+	} else if (peer_max_blocks == p_pkey_tbl->used_blocks) {
+		/* Is last used pkey index beyond switch peer port capacity ? */
+		last_index = (peer_max_blocks - 1) * IB_NUM_PKEY_ELEMENTS_IN_BLOCK +
+			     last_used_pkey_index(p_port, p_pkey_tbl);
+		if (cl_ntoh16(p_node->sw->switch_info.enforce_cap) <= last_index) {
+			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0507: "
+				"Not enough pkey entries (%u <= %u) on switch 0x%016"
+				PRIx64 " port %u (%s). Clearing Enforcement bit\n",
+				cl_ntoh16(p_node->sw->switch_info.enforce_cap),
+				last_index,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				osm_physp_get_port_num(peer),
+				p_node->print_desc);
+			enforce = FALSE;
+			ret = -1;
+		}
 	}
 
 	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
