From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/11] opensm/osm_pkey_mgr.c: Move clearing of empty_block
 after any "early" returns
Date: Fri, 01 Apr 2011 14:37:28 -0400
Message-ID: <4D961B68.80509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 612130c..ce50f27 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -263,12 +263,12 @@ static int pkey_mgr_update_port(osm_log_t * p_log,
osm_sm_t * sm,
 	ib_pkey_table_t empty_block;
 	int ret = 0;

-	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
-
 	p_physp = p_port->p_physp;
 	if (!p_physp)
 		return FALSE;

+	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
+
 	p_node = osm_physp_get_node_ptr(p_physp);
 	p_pkey_tbl = &p_physp->pkeys;
 	num_of_blocks = osm_pkey_tbl_get_num_blocks(p_pkey_tbl);
@@ -392,8 +392,6 @@ static int pkey_mgr_update_peer_port(osm_log_t *
p_log, osm_sm_t * sm,
 	ib_pkey_table_t empty_block;
 	int ret = 0;

-	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
-
 	p_physp = p_port->p_physp;
 	if (!p_physp)
 		return -1;
@@ -426,6 +424,8 @@ static int pkey_mgr_update_peer_port(osm_log_t *
p_log, osm_sm_t * sm,
 	if (enforce == FALSE)
 		return ret;

+	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
+
 	p_peer_pkey_tbl->used_blocks = p_pkey_tbl->used_blocks;
 	for (block_index = 0; block_index < p_pkey_tbl->used_blocks;
 	     block_index++) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
