From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey_mgr.c: Change log message to reflect used
 rather than max blocks
Date: Mon, 04 Apr 2011 15:11:44 -0400
Message-ID: <4D9A17F0.8020703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Eliminate no longer needed variable

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index ce50f27..92f8f2b 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -386,7 +386,6 @@ static int pkey_mgr_update_peer_port(osm_log_t *
p_log, osm_sm_t * sm,
 	const osm_pkey_tbl_t *p_pkey_tbl;
 	osm_pkey_tbl_t *p_peer_pkey_tbl;
 	uint16_t block_index;
-	uint16_t num_of_blocks;
 	uint16_t peer_max_blocks;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_pkey_table_t empty_block;
@@ -404,13 +403,12 @@ static int pkey_mgr_update_peer_port(osm_log_t *
p_log, osm_sm_t * sm,

 	p_pkey_tbl = osm_physp_get_pkey_tbl(p_physp);
 	p_peer_pkey_tbl = &peer->pkeys;
-	num_of_blocks = osm_pkey_tbl_get_num_blocks(p_pkey_tbl);
 	peer_max_blocks = pkey_mgr_get_physp_max_blocks(peer);
 	if (peer_max_blocks < p_pkey_tbl->used_blocks) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
-			"Not enough pkey entries (%u < %u) on switch 0x%016"
+			"Not enough pkey blocks (%u < %u used) on switch 0x%016"
 			PRIx64 " port %u (%s). Clearing Enforcement bit\n",
-			peer_max_blocks, num_of_blocks,
+			peer_max_blocks, p_pkey_tbl->used_blocks,
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
 			osm_physp_get_port_num(peer),
 			p_node->print_desc);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
