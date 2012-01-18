From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm: fixed description in osm_routing_engine
Date: Wed, 18 Jan 2012 20:16:22 +0200
Message-ID: <20120118181622.GA6228@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changed delete to destroy in osm_routing_engine struct description.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_opensm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 8f4113a..6509d6e 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -173,8 +173,8 @@ struct osm_routing_engine {
 *		The callback for building the spanning tree for multicast
 *		forwarding, called per MLID.
 *
-*	delete
-*		The delete method, may be used for routing engine
+*	destroy
+*		The destroy method, may be used for routing engine
 *		internals cleanup.
 *
 *	next
-- 
1.7.7.5

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
