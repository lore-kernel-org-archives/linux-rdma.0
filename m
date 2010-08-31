From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_pkey_mgr.c: Eliminate unneeded parameter from
	pkey_mgr_get_physp_max_blocks API
Date: Tue, 31 Aug 2010 14:21:33 -0400
Message-ID: <20100831182133.GB4718@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Fixed formatting errors detected by checkpatch

diff --git a/opensm/opensm/osm_pkey_mgr.c b/opensm/opensm/osm_pkey_mgr.c
index f2e0cc3..1e98c82 100644
--- a/opensm/opensm/osm_pkey_mgr.c
+++ b/opensm/opensm/osm_pkey_mgr.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
@@ -59,8 +59,7 @@
   rest of the ports (NodeInfo).
 */
 static uint16_t
-pkey_mgr_get_physp_max_blocks(IN const osm_subn_t * p_subn,
-			      IN const osm_physp_t * p_physp)
+pkey_mgr_get_physp_max_blocks(IN const osm_physp_t * p_physp)
 {
 	osm_node_t *p_node = osm_physp_get_node_ptr(p_physp);
 	uint16_t num_pkeys = 0;
@@ -272,8 +271,7 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	p_node = osm_physp_get_node_ptr(p_physp);
 	p_pkey_tbl = &p_physp->pkeys;
 	num_of_blocks = osm_pkey_tbl_get_num_blocks(p_pkey_tbl);
-	max_num_of_blocks =
-	    pkey_mgr_get_physp_max_blocks(sm->p_subn, p_physp);
+	max_num_of_blocks = pkey_mgr_get_physp_max_blocks(p_physp);
 	if (p_pkey_tbl->max_blocks > max_num_of_blocks) {
 		OSM_LOG(p_log, OSM_LOG_INFO,
 			"Max number of blocks reduced from %u to %u "
@@ -408,7 +406,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	p_pkey_tbl = osm_physp_get_pkey_tbl(p_physp);
 	p_peer_pkey_tbl = &peer->pkeys;
 	num_of_blocks = osm_pkey_tbl_get_num_blocks(p_pkey_tbl);
-	peer_max_blocks = pkey_mgr_get_physp_max_blocks(p_subn, peer);
+	peer_max_blocks = pkey_mgr_get_physp_max_blocks(peer);
 	if (peer_max_blocks < p_pkey_tbl->used_blocks) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
 			"Not enough pkey entries (%u < %u) on switch 0x%016"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
