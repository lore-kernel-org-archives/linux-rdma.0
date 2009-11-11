From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: fix return value on alloc_mfts()
 failures
Date: Wed, 11 Nov 2009 20:33:17 +0200
Message-ID: <20091111183317.GX7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When alloc_mfts() fails and multicast routing calculation interrupted
return -1 value to a caller.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 105e905..7bd7add 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1066,6 +1066,7 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
 	if (alloc_mfts(sm)) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"ERR 0A07: alloc_mfts failed\n");
+		ret = -1;
 		goto exit;
 	}
 
@@ -1110,6 +1111,7 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * sm)
 	if (alloc_mfts(sm)) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"ERR 0A09: alloc_mfts failed\n");
+		ret = -1;
 		goto exit;
 	}
 
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
