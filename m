From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/5] opensm: Resend LFTs/VLArb/SL2VL MADs in case of error
Date: Mon,  3 Feb 2014 13:05:16 +0200
Message-ID: <1391425516-14462-5-git-send-email-alexne@mellanox.com>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are several MADs that we only SET during the sweep (and never
GET).
Zero the stored block, so in case the MAD will end up with error,
we will resend it during the next sweep.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos.c       |   13 +++++++++++++
 opensm/osm_ucast_mgr.c |    7 +++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index a301803..473e3c8 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -183,6 +183,13 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 	if (!p_mad)
 		return IB_INSUFFICIENT_MEMORY;
 
+	/*
+	 * Zero the stored VL Arbitration block, so in case the MAD will
+	 * end up with error, we will resend it in the next sweep.
+	 */
+	memset(&p->vl_arb[block_num], 0,
+	       block_length * sizeof(block.vl_entry[0]));
+
 	cl_qlist_insert_tail(mad_list, &p_mad->list_item);
 
 	return IB_SUCCESS;
@@ -272,6 +279,12 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 	if (!p_mad)
 		return IB_INSUFFICIENT_MEMORY;
 
+	/*
+	 * Zero the stored SL2VL block, so in case the MAD will
+	 * end up with error, we will resend it in the next sweep.
+	 */
+	memset(p_tbl, 0, sizeof(tbl));
+
 	cl_qlist_insert_tail(mad_list, &p_mad->list_item);
 	return IB_SUCCESS;
 }
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 8194307..c8a7360 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1002,6 +1002,13 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 		    IB_SMP_DATA_SIZE))
 		return 0;
 
+	/*
+	 * Zero the stored LFT block, so in case the MAD will end up
+	 * with error, we will resend it in the next sweep.
+	 */
+	memset(p_sw->lft + block_id_ho * IB_SMP_DATA_SIZE, OSM_NO_PATH,
+	       IB_SMP_DATA_SIZE);
+
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 		"Writing FT block %u to switch 0x%" PRIx64 "\n", block_id_ho,
 		cl_ntoh64(context.lft_context.node_guid));
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
