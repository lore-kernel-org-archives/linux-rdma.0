From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_cache.c: fix potential seg fault
Date: Tue, 7 Sep 2010 17:54:34 +0300
Message-ID: <4C86522A.8090005@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix potential seg fault when NULL is returned

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_ucast_cache.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
index c611c38..be15508 100644
--- a/opensm/opensm/osm_ucast_cache.c
+++ b/opensm/opensm/osm_ucast_cache.c
@@ -931,6 +931,14 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)

 		p_cache_sw = cache_get_sw(p_mgr, lid_ho);
 		CL_ASSERT(p_cache_sw);
+		if (!p_cache_sw) {
+			/* something is wrong - forget about cache */
+			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+				"ERR AD04: no cached switch with lid %u - "
+				"clearing cache\n", lid_ho);
+			osm_ucast_cache_invalidate(p_mgr);
+			goto Exit;
+		}

 		if (!cache_sw_is_leaf(p_cache_sw)) {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
