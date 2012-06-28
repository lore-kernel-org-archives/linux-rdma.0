From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_ucast_cache.c: Fix crash when ucast cache
 is invalidated after updating one of the switches
Date: Thu, 28 Jun 2012 13:10:33 -0400
Message-ID: <4FEC9009.8010804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 28f2b44..bae7a51 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -316,8 +316,6 @@ cache_restore_ucast_info(osm_ucast_mgr_t * p_mgr,
 		free(p_sw->new_lft);
 	p_sw->new_lft = p_cache_sw->lft;
 	p_cache_sw->lft = NULL;
-	p_sw->lft_size = (p_sw->max_lid_ho / IB_SMP_DATA_SIZE + 1)
-			 * IB_SMP_DATA_SIZE;
 
 	p_sw->num_hops = p_cache_sw->num_hops;
 	p_cache_sw->num_hops = 0;
@@ -976,6 +974,7 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 			/* no LFT buffer, so we use the switch's LFT */
 			p_cache_sw->lft = p_node->sw->lft;
 			p_node->sw->lft = NULL;
+			p_node->sw->lft_size = 0;
 		}
 		p_cache_sw->max_lid_ho = p_node->sw->max_lid_ho;
 	} else {
@@ -1005,6 +1004,7 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
 	cl_qmap_t *tbl = &p_mgr->p_subn->sw_guid_tbl;
 	cl_map_item_t *item;
 	osm_switch_t *p_sw;
+	uint16_t lft_size;
 
 	if (!p_mgr->p_subn->opt.use_ucast_cache)
 		return 1;
@@ -1026,10 +1026,12 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
 				   switch, but the LFT needs to be updated anyway */
 				p_sw->new_lft = p_sw->lft;
 
-
-			p_sw->lft = malloc(p_sw->lft_size);
+			lft_size = (p_sw->max_lid_ho / IB_SMP_DATA_SIZE + 1)
+				   * IB_SMP_DATA_SIZE;
+			p_sw->lft = malloc(lft_size);
 			if (!p_sw->lft)
 				return IB_INSUFFICIENT_MEMORY;
+			p_sw->lft_size = lft_size;
 			memset(p_sw->lft, OSM_NO_PATH, p_sw->lft_size);
 		}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
