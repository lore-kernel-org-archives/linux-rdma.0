From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/5] opensm: When allowing both pkeys, on a switch external,
 (peer) port eliminate limited pkey when full pkey with same base is present
Date: Tue, 22 Nov 2011 15:23:52 -0500
Message-ID: <4ECC04D8.7020800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey_mgr.c    |   26 +++++++++++++++++++++++++-
 opensm/osm_prtn_config.c |    6 ++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 2fff373..6c2a735 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -548,6 +548,25 @@ static int update_peer_block(osm_log_t * p_log, osm_sm_t * sm,
 	return ret;
 }
 
+static int new_pkey_exists(osm_pkey_tbl_t * p_pkey_tbl, ib_net16_t pkey)
+{
+	uint16_t num_blocks;
+	uint16_t block_index;
+	ib_pkey_table_t *block;
+	uint16_t pkey_idx;
+
+	num_blocks = (uint16_t) cl_ptr_vector_get_size(&p_pkey_tbl->new_blocks);
+	for (block_index = 0; block_index < num_blocks; block_index++) {
+		block = osm_pkey_tbl_new_block_get(p_pkey_tbl, block_index);
+		for (pkey_idx = 0; pkey_idx < IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+		     pkey_idx++) {
+			if (block->pkey_entry[pkey_idx] == pkey)
+				return 1;
+		}
+	}
+	return 0;
+}
+
 static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 				     const osm_subn_t * p_subn,
 				     const osm_port_t * const p_port,
@@ -563,7 +582,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	uint16_t last_index;
 	ib_pkey_table_t new_peer_block;
 	uint16_t pkey_idx, peer_pkey_idx;
-	ib_net16_t pkey;
+	ib_net16_t pkey, full_pkey;
 	int ret = 0, loop_exit = 0;
 
 	p_physp = p_port->p_physp;
@@ -598,6 +617,11 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 			pkey = block->pkey_entry[pkey_idx];
 			if (ib_pkey_is_invalid(pkey))
 				continue;
+			if (!ib_pkey_is_full_member(pkey)) {
+				full_pkey = pkey | IB_PKEY_TYPE_MASK;
+				if (new_pkey_exists(&p_physp->pkeys, full_pkey))
+					continue;
+			}
 			new_peer_block.pkey_entry[peer_pkey_idx] = pkey;
 			if (peer_block_idx >= peer_max_blocks) {
 				loop_exit = 1;
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 4c4c3a5..996128d 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -207,7 +207,8 @@ static int partition_add_all(struct part_conf *conf, osm_prtn_t * p,
 	if (membership != LIMITED &&
 	    osm_prtn_add_all(conf->p_log, conf->p_subn, p, type, TRUE) != IB_SUCCESS)
 		return -1;
-	if (membership != FULL &&
+	if ((membership == LIMITED ||
+	     (membership == BOTH && conf->p_subn->opt.allow_both_pkeys)) &&
 	    osm_prtn_add_all(conf->p_log, conf->p_subn, p, type, FALSE) != IB_SUCCESS)
 		return -1;
 	return 0;
@@ -261,7 +262,8 @@ static int partition_add_port(unsigned lineno, struct part_conf *conf,
 	    osm_prtn_add_port(conf->p_log, conf->p_subn, p,
 			      cl_hton64(guid), TRUE) != IB_SUCCESS)
 		return -1;
-	if (membership != FULL &&
+	if ((membership == LIMITED ||
+	    (membership == BOTH && conf->p_subn->opt.allow_both_pkeys)) &&
 	    osm_prtn_add_port(conf->p_log, conf->p_subn, p,
 			      cl_hton64(guid), FALSE) != IB_SUCCESS)
 		return -1;
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
