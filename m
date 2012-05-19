From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] opensm/osm_ucast_cache.c: fix crash in osm_ucast_mgr
Date: Sat, 19 May 2012 23:11:57 +0300
Message-ID: <20120519201157.GG2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When leaf switch returns, the SM crashed when trying to retrieve lft block
usually p_sw->lft is allocated during the routing calculation.
If use_ucast_cache TRUE and cache is valid the SM skips the routing calculation
and uses the cached lft. In this case p_sw->lft was null.
FIX: allocate p_sw->lft if it is null (cached switch that returns).

Signed-off-by: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 6e46191..820273a 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -316,6 +316,8 @@ cache_restore_ucast_info(osm_ucast_mgr_t * p_mgr,
 		free(p_sw->new_lft);
 	p_sw->new_lft = p_cache_sw->lft;
 	p_cache_sw->lft = NULL;
+	p_sw->lft_size = (p_sw->max_lid_ho / IB_SMP_DATA_SIZE + 1)
+			 * IB_SMP_DATA_SIZE;
 
 	p_sw->num_hops = p_cache_sw->num_hops;
 	p_cache_sw->num_hops = 0;
@@ -1018,10 +1020,13 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
 	     item = cl_qmap_next(item)) {
 		p_sw = (osm_switch_t *) item;
 
-		if (p_sw->need_update && !p_sw->new_lft) {
-			/* no new routing was recently calculated for this
-			   switch, but the LFT needs to be updated anyway */
-			p_sw->new_lft = p_sw->lft;
+		if (p_sw->need_update) {
+			if (!p_sw->new_lft)
+				/* no new routing was recently calculated for this
+				   switch, but the LFT needs to be updated anyway */
+				p_sw->new_lft = p_sw->lft;
+
+
 			p_sw->lft = malloc(p_sw->lft_size);
 			if (!p_sw->lft)
 				return IB_INSUFFICIENT_MEMORY;
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
