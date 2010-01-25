From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_qos.c: Eliminate unneeded endport SL to VL
	setup
Date: Mon, 25 Jan 2010 15:22:48 -0500
Message-ID: <20100125202247.GA9197@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


when using optimized programming and it's supported by the switch

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Add in update of vlarb tables for port 0 when optimized but no SL to VL
tables needed to be configured on that port

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index f814ea8..218e128 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -243,13 +243,15 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 }
 
 static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
-			     const struct qos_config *qcfg)
+			     const struct qos_config *qcfg, int vlarb_only)
 {
 	unsigned force_update = p->need_update || sm->p_subn->need_update;
 
 	p->vl_high_limit = qcfg->vl_high_limit;
 	if (vlarb_update(sm, p, 0, force_update, qcfg))
 		return -1;
+	if (vlarb_only)
+		return 0;
 
 	if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
 		return 0;
@@ -269,6 +271,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	osm_port_t *p_port;
 	osm_node_t *p_node;
 	int ret = 0;
+	int vlarb_only;
 
 	if (!p_osm->subn.opt.qos)
 		return 0;
@@ -292,6 +295,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
 	while (p_next != cl_qmap_end(p_tbl)) {
+		vlarb_only = 0;
 		p_port = (osm_port_t *) p_next;
 		p_next = cl_qmap_next(p_next);
 
@@ -305,13 +309,20 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 			    (&p_node->sw->switch_info))
 				continue;
 
+			if (ib_switch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) &&
+			    p_osm->sm.p_subn->opt.use_optimized_slvl &&
+			    !memcmp(&swe_config.sl2vl, &sw0_config.sl2vl,
+				    sizeof(swe_config.sl2vl)))
+				vlarb_only = 1;
+
 			cfg = &sw0_config;
 		} else if (osm_node_get_type(p_node) == IB_NODE_TYPE_ROUTER)
 			cfg = &rtr_config;
 		else
 			cfg = &ca_config;
 
-		if (qos_endport_setup(&p_osm->sm, p_port->p_physp, cfg))
+		if (qos_endport_setup(&p_osm->sm, p_port->p_physp, cfg,
+				      vlarb_only))
 			ret = -1;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
