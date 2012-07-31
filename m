From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 19/27] Fix crash in ucast cache when ucast cache invalidates after updating one of the switches
Date: Tue, 31 Jul 2012 19:04:47 +0300
Message-ID: <1343750695-28063-19-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
Changes since v2:
	Sets p_sw->lft_size = 0 in osm_ucast_cache_add_node()

Changes since v1:
	Sets p_sw->lft_size only after successful malloc()
---
 opensm/osm_ucast_cache.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 701b8a8..fc28be7 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -318,8 +318,6 @@ cache_restore_ucast_info(osm_ucast_mgr_t * p_mgr,
 		free(p_sw->new_lft);
 	p_sw->new_lft = p_cache_sw->lft;
 	p_cache_sw->lft = NULL;
-	p_sw->lft_size = (p_sw->max_lid_ho / IB_SMP_DATA_SIZE + 1)
-			 * IB_SMP_DATA_SIZE;
 
 	p_sw->num_hops = p_cache_sw->num_hops;
 	p_cache_sw->num_hops = 0;
@@ -978,6 +976,7 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 			/* no LFT buffer, so we use the switch's LFT */
 			p_cache_sw->lft = p_node->sw->lft;
 			p_node->sw->lft = NULL;
+			p_node->sw->lft_size = 0;
 		}
 		p_cache_sw->max_lid_ho = p_node->sw->max_lid_ho;
 	} else {
@@ -1007,6 +1006,7 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
 	cl_qmap_t *tbl = &p_mgr->p_subn->sw_guid_tbl;
 	cl_map_item_t *item;
 	osm_switch_t *p_sw;
+	uint16_t lft_size;
 
 	if (!p_mgr->p_subn->opt.use_ucast_cache)
 		return 1;
@@ -1028,10 +1028,12 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
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
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
