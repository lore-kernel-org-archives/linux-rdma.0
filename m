From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] Fix ucast cache crash, when switch doesn't have valid
 phys ports
Date: Sat, 19 May 2012 23:12:37 +0300
Message-ID: <20120519201237.GH2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 820273a..9b6ed0d 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -940,9 +940,9 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 		 */
 
 		p_cache_sw = cache_get_sw(p_mgr, lid_ho);
-		CL_ASSERT(p_cache_sw);
 
-		if (!cache_sw_is_leaf(p_cache_sw)) {
+		/* p_cache_sw could be NULL if it has no remote phys ports */
+		if (!p_cache_sw || !cache_sw_is_leaf(p_cache_sw)) {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 				"Dropped non-leaf switch (lid %u)\n", lid_ho);
 			osm_ucast_cache_invalidate(p_mgr);
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
