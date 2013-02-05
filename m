From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_req.c: fix first sweep m_key search algorithm
Date: Tue,  5 Feb 2013 17:34:04 +0200
Message-ID: <1360078444-4835-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During the first sweep we don't have yet dest physp object

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_req.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 8ec4ac6..f9ffc81 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -93,7 +93,7 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		p_physp = p_sm_port->p_physp;
 	}
 
-	for (hop = 1; p_physp && hop <= p_path->hop_count; hop++) {
+	for (hop = 1; p_physp && hop < p_path->hop_count; hop++) {
 		p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
 		if (!p_physp)
 			break;
@@ -103,6 +103,8 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		p_node = osm_physp_get_node_ptr(p_physp);
 	}
 
+	p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
+
 	/* At this point, p_physp points at the outgoing physp on the
 	   last hop, or NULL if we don't know it.
 	*/
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
