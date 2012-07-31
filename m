From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/27] Fixes in SL2VL table distribution algorithm
Date: Tue, 31 Jul 2012 19:04:36 +0300
Message-ID: <1343750695-28063-8-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

SL2VL and VLARB table shouldn't be sent to DOWN ports

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos.c | 49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index 429660b..7342561 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -212,7 +212,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	int ret = 0;
 	unsigned in, out;
-	uint8_t op_vl1;
+	uint8_t op_vl, common_op_vl = 0, max_num = 0;
+	uint8_t op_vl_arr[15];
 
 	/*
 	 * Do nothing unless the most recent routing attempt was successful.
@@ -222,6 +223,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 
 	for (out = 1; out < num_ports; out++) {
 		p = osm_node_get_physp_ptr(node, out);
+		if (ib_port_info_get_port_state(&p->port_info) == IB_LINK_DOWN)
+			continue;
 		force_update = p->need_update || sm->p_subn->need_update;
 		p->vl_high_limit = qcfg->vl_high_limit;
 		if (vlarb_update(sm, p, p->port_num, force_update, qcfg))
@@ -234,19 +237,43 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 
 	if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
 	    sm->p_subn->opt.use_optimized_slvl && !re->update_sl2vl) {
-		p = osm_node_get_physp_ptr(node, 1);
-		op_vl1 = ib_port_info_get_op_vls(&p->port_info);
+
+		/* we should find the op_vl that is used by majority of ports */
+		memset(&op_vl_arr[0], 0, sizeof(op_vl_arr));
+		p0 = osm_node_get_physp_ptr(node, 1);
+
+		for (out = 1; out < num_ports; out++) {
+			p = osm_node_get_physp_ptr(node, out);
+			if (ib_port_info_get_port_state(&p->port_info) ==
+			    IB_LINK_DOWN)
+				continue;
+			op_vl = ib_port_info_get_op_vls(&p->port_info);
+			op_vl_arr[op_vl]++;
+			if (op_vl_arr[op_vl] > max_num){
+				max_num = op_vl_arr[op_vl];
+				common_op_vl = op_vl;
+				/* remember the port with most common op_vl */
+				p0 = p;
+			}
+
+		}
 		force_update = p->need_update || sm->p_subn->need_update;
-		if (sl2vl_update_table(sm, p, 0, 0x30000, force_update,
+		if (sl2vl_update_table(sm, p0, 0, 0x30000, force_update,
 					&qcfg->sl2vl))
 			ret = -1;
-		/* overwrite default ALL configuration if port's
-		   op_vl is different */
-		for (out = 2; out < num_ports; out++) {
+		/*
+		 * Overwrite default ALL configuration if port's
+		 * op_vl is different.
+		 */
+		for (out = 1; out < num_ports; out++) {
 			p = osm_node_get_physp_ptr(node, out);
-			if (ib_port_info_get_op_vls(&p->port_info) != op_vl1 &&
-			    sl2vl_update_table(sm, p, 0, 0x20000 | out, force_update,
-						&qcfg->sl2vl))
+			if (ib_port_info_get_port_state(&p->port_info) ==
+			    IB_LINK_DOWN)
+				continue;
+			if (ib_port_info_get_op_vls(&p->port_info) !=
+			    common_op_vl &&
+			    sl2vl_update_table(sm, p, 0, 0x20000 | out,
+					       force_update, &qcfg->sl2vl))
 				ret = -1;
 		}
 		return ret;
@@ -256,6 +283,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	out = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
 	for (; out < num_ports; out++) {
 		p = osm_node_get_physp_ptr(node, out);
+		if (ib_port_info_get_port_state(&p->port_info) == IB_LINK_DOWN)
+			continue;
 		force_update = p->need_update || sm->p_subn->need_update;
 		/* go over all in ports */
 		for (in = 0; in < num_ports; in++) {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
