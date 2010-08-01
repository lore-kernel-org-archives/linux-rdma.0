From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Fix sl2vl configuration
Date: Sun, 01 Aug 2010 12:36:20 +0300
Message-ID: <4C554014.7080603@gmail.com>
References: <4C505A39.4020201@gmail.com> <1280428154.4816.51.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280428154.4816.51.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the patch according to Jim's comments
Changed i,j to in,out to make code readable

For non-optimal sl2vl configuration in and out ports were reversed.
For optimal sl2vl added override of default ALL settting with port's
sl2vl when operational VL was other than the default port.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_qos.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index a571370..0ebcfdf 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -208,10 +208,11 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	unsigned force_update;
 	unsigned num_ports = osm_node_get_num_physp(node);
 	int ret = 0;
-	unsigned i, j;
+	unsigned in, out;
+	uint8_t op_vl1;
 
-	for (i = 1; i < num_ports; i++) {
-		p = osm_node_get_physp_ptr(node, i);
+	for (out = 1; out < num_ports; out++) {
+		p = osm_node_get_physp_ptr(node, out);
 		force_update = p->need_update || sm->p_subn->need_update;
 		p->vl_high_limit = qcfg->vl_high_limit;
 		if (vlarb_update(sm, p, p->port_num, force_update, qcfg))
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
+		for (out = 2; out < num_ports; out++) {
+			p = osm_node_get_physp_ptr(node, out);
+			if (ib_port_info_get_op_vls(&p->port_info) != op_vl1 && 
+			    sl2vl_update_table(sm, p, 0, 0x20000 | out, force_update,
+						&qcfg->sl2vl))
+				ret = -1;
+		}
+		return ret;
 	}
 
-	for (i = 0; i < num_ports; i++) {
-		p = osm_node_get_physp_ptr(node, i);
+	/* non optimized sl2vl configuration */
+	out = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
+	for (; out < num_ports; out++) {
+		p = osm_node_get_physp_ptr(node, out);
 		force_update = p->need_update || sm->p_subn->need_update;
-		j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
-		for (; j < num_ports; j++)
-			if (sl2vl_update_table(sm, p, i, i << 8 | j,
+		/* go over all in ports */
+		for (in = 0; in < num_ports; in++)
+			if (sl2vl_update_table(sm, p, in, in << 8 | out,
 					       force_update, &qcfg->sl2vl))
 				ret = -1;
 	}
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
