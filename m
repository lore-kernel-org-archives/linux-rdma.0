From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/27] Fix SL2VL configuration
Date: Tue, 31 Jul 2012 19:04:38 +0300
Message-ID: <1343750695-28063-10-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set optimized SL2VL table only if node is maked as 'need_update'.
Set SL2VL tale for port that marked as 'need_update'.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index dd08ac0..ce48867 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -318,7 +318,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 			}
 
 		}
-		force_update = p->need_update || sm->p_subn->need_update;
+		force_update = node->sw->need_update || sm->p_subn->need_update;
 		if (sl2vl_update_table(sm, p0, 0, 0x30000, force_update,
 					&qcfg->sl2vl, port_mad_list))
 			ret = -1;
@@ -331,6 +331,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 			if (ib_port_info_get_port_state(&p->port_info) ==
 			    IB_LINK_DOWN)
 				continue;
+
+			force_update = p->need_update || force_update;
 			if (ib_port_info_get_op_vls(&p->port_info) !=
 			    common_op_vl &&
 			    sl2vl_update_table(sm, p, 0, 0x20000 | out,
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
