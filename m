From: Vangelis <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: [PATCH] Removed *p_ftree from function *sw_create().
Date: Thu,  4 Jun 2015 14:12:51 +0200
Message-ID: <1433419971-29067-1-git-send-email-vangelis@simula.no>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vangelis <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ftree_fabric_t *p_ftree is not used anywhere in OpenSM's function sw_create().
---
 opensm/osm_ucast_ftree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index f646bd0..3699d95 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -528,8 +528,7 @@ static void port_group_add_port(IN ftree_port_group_t * p_group,
  **
  ***************************************************/
 
-static ftree_sw_t *sw_create(IN ftree_fabric_t * p_ftree,
-			     IN osm_switch_t * p_osm_sw)
+static ftree_sw_t *sw_create(IN osm_switch_t * p_osm_sw)
 {
 	ftree_sw_t *p_sw;
 	uint8_t ports_num;
@@ -1089,7 +1088,7 @@ static void fabric_add_sw(ftree_fabric_t * p_ftree, osm_switch_t * p_osm_sw)
 
 	CL_ASSERT(osm_node_get_type(p_osm_sw->p_node) == IB_NODE_TYPE_SWITCH);
 
-	p_sw = sw_create(p_ftree, p_osm_sw);
+	p_sw = sw_create(p_osm_sw);
 	if (!p_sw)
 		return;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
