From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_ucast_cache.c: fix crash in ucast cache when
 switch with lid 0 dropped
Date: Sat, 19 May 2012 23:11:12 +0300
Message-ID: <20120519201112.GF2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SM crashes when newly discovered switch, dropped during the discovery loop before it gets lid assignment.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_cache.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index c611c38..6e46191 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -897,6 +897,14 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 
 		lid_ho = cl_ntoh16(osm_node_get_base_lid(p_node, 0));
 
+		if (!lid_ho) {
+			OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
+				"Skip caching. Switch dropped before "
+				"it gets a valid lid.\n");
+			osm_ucast_cache_invalidate(p_mgr);
+			goto Exit;
+		}
+
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 			"Caching dropped switch lid %u\n", lid_ho);
 
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
