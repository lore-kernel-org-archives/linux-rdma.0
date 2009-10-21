From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_cache.c: Eliminate unneeded define
Date: Wed, 21 Oct 2009 08:50:27 -0400
Message-ID: <20091021125026.GA18250@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Also, cosmetic change to OSM_LOG message

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
index 4700c5f..09bbf33 100644
--- a/opensm/opensm/osm_ucast_cache.c
+++ b/opensm/opensm/osm_ucast_cache.c
@@ -59,8 +59,6 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_port.h>
 
-#define CACHE_SW_PORTS 36
-
 typedef struct cache_port {
 	boolean_t is_leaf;
 	uint16_t remote_lid_ho;
@@ -420,7 +418,7 @@ void osm_ucast_cache_invalidate(osm_ucast_mgr_t * p_mgr)
 	}
 	cl_qmap_remove_all(&p_mgr->cache_sw_tbl);
 
-	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE, "Unicast Cache Invalidated.\n");
+	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE, "Unicast cache invalidated\n");
 Exit:
 	OSM_LOG_EXIT(p_mgr->p_log);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
