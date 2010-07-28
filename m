From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: Fix sl2vl configuration
Date: Wed, 28 Jul 2010 19:26:33 +0300
Message-ID: <4C505A39.4020201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Subject: [PATCH] Fix sl2vl configuration

For non-optimized sl2vl configuration in and out ports were reversed.
For optimal sl2vl added override of default ALL settting with port's
sl2vl when operational VL was other than the default port.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_qos.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index a571370..de0ae23 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -182,7 +182,7 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 		tbl.raw_vl_by_sl[i] = (vl1 << 4) | vl2;
 	}
 
-	if (!force_update && (p_tbl = osm_physp_get_slvl_tbl(p, in_port)) &&
+	if (!force_update && in_port && (p_tbl = osm_physp_get_slvl_tbl(p, in_port)) &&
 	    !memcmp(p_tbl, &tbl, sizeof(tbl)))
 		return IB_SUCCESS;
 
@@ -209,6 +209,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	unsigned num_ports = osm_node_get_num_physp(node);
 	int ret = 0;
 	unsigned i, j;
+	uint8_t op_vl1;
 
 	for (i = 1; i < num_ports; i++) {
 		p = osm_node_get_physp_ptr(node, i);
@@ -225,17 +226,31 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
 	    sm->p_subn->opt.use_optimized_slvl) {
 		p = osm_node_get_physp_ptr(node, 1);
+		op_vl1 = ib_port_info_get_op_vls(&p->port_info);
 		force_update = p->need_update || sm->p_subn->need_update;
-		return sl2vl_update_table(sm, p, 1, 0x30000, force_update,
-					  &qcfg->sl2vl);
+		if (sl2vl_update_table(sm, p, 0, 0x30000, force_update,
+					&qcfg->sl2vl))
+			ret = -1;
+		/* overwrite default ALL configuration if port's
+		   op_vl is different */
+		for (i = 2; i < num_ports; i++) {
+			p = osm_node_get_physp_ptr(node, i);
+			if (ib_port_info_get_op_vls(&p->port_info) != op_vl1 && 
+			    sl2vl_update_table(sm, p, 0, 0x20000 | i, force_update,
+						&qcfg->sl2vl))
+				ret = -1;
+		}
+		return ret;
 	}
 
-	for (i = 0; i < num_ports; i++) {
+	/* non optimized sl2vl configuration */
+	i = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
+	for (; i < num_ports; i++) {
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
 		j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
 		for (; j < num_ports; j++)
-			if (sl2vl_update_table(sm, p, i, i << 8 | j,
+			if (sl2vl_update_table(sm, p, j, j << 8 | i,
 					       force_update, &qcfg->sl2vl))
 				ret = -1;
 	}
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
