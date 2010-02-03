From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: fix memory leak
Date: Wed, 3 Feb 2010 13:00:22 +0200
Message-ID: <20100203110022.GA26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Memory leak is possible in case of port list allocation failure. Fix
this by proper cleanup.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index dce9f2b..d7267e4 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -549,6 +549,8 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A16: "
 			"Unable to allocate list array\n");
 		mcast_mgr_purge_list(sm, p_list);
+		osm_mtree_destroy(p_mtn);
+		p_mtn = NULL;
 		goto Exit;
 	}
 
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
