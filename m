From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port,
 initialize p_peer_pkey_tbl later in flow
Date: Tue, 05 Apr 2011 14:04:59 -0400
Message-ID: <4D9B59CB.9080102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Closer to where initially used

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 92f8f2b..78e8f83 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -402,7 +402,6 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 		return 0;
 
 	p_pkey_tbl = osm_physp_get_pkey_tbl(p_physp);
-	p_peer_pkey_tbl = &peer->pkeys;
 	peer_max_blocks = pkey_mgr_get_physp_max_blocks(peer);
 	if (peer_max_blocks < p_pkey_tbl->used_blocks) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
@@ -424,6 +423,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 
 	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
 
+	p_peer_pkey_tbl = &peer->pkeys;
 	p_peer_pkey_tbl->used_blocks = p_pkey_tbl->used_blocks;
 	for (block_index = 0; block_index < p_pkey_tbl->used_blocks;
 	     block_index++) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
