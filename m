From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_qos.c: split switch external and end ports setup
Date: Tue, 5 Jan 2010 13:10:32 +0200
Message-ID: <20100105111032.GN26940@me>
References: <20091201194110.GA26753@comcast.net>
 <20100104170141.GK26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100104170141.GK26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This splits QoS related port parameters setup over switch external ports
and end ports. Such separation leaves us with simpler code and saves
some repeated flows in case of switch external ports (actually required
per switch and not per port).

Another advantages: Optimized Sl2VL Mapping procedure can be implemented
easier using this model. A low level port QoS related parameters setup
infrastructure is ready for supporting per port QoS related configuration
(which hopefully will be implemented some days).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_qos.c |  137 +++++++++++++++++++++--------------------------
 1 files changed, 61 insertions(+), 76 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index afeaa11..f54e995 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -77,6 +77,7 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 	osm_madw_context_t context;
 	uint32_t attr_mod;
 	unsigned vl_mask, i;
+	ib_api_status_t status;
 
 	vl_mask = (1 << (ib_port_info_get_op_vls(&p->port_info) - 1)) - 1;
 
@@ -96,10 +97,17 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 	context.vla_context.set_method = TRUE;
 	attr_mod = ((block_num + 1) << 16) | port_num;
 
-	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
-			   (uint8_t *) & block, sizeof(block),
-			   IB_MAD_ATTR_VL_ARBITRATION, cl_hton32(attr_mod),
-			   CL_DISP_MSGID_NONE, &context);
+	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
+			     (uint8_t *) & block, sizeof(block),
+			     IB_MAD_ATTR_VL_ARBITRATION, cl_hton32(attr_mod),
+			     CL_DISP_MSGID_NONE, &context);
+	if (status != IB_SUCCESS)
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6202 : "
+			"failed to update VLArbitration tables "
+			"for port %" PRIx64 " block %u\n",
+			cl_ntoh64(p->port_guid), block_num);
+
+	return status;
 }
 
 static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
@@ -157,6 +165,7 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 	ib_slvl_table_t tbl, *p_tbl;
 	osm_node_t *p_node = osm_physp_get_node_ptr(p);
 	uint32_t attr_mod;
+	ib_api_status_t status;
 	unsigned vl_mask;
 	uint8_t vl1, vl2;
 	int i;
@@ -181,70 +190,65 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 	context.slvl_context.port_guid = osm_physp_get_port_guid(p);
 	context.slvl_context.set_method = TRUE;
 	attr_mod = in_port << 8 | out_port;
-	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
-			   (uint8_t *) & tbl, sizeof(tbl),
-			   IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
-			   CL_DISP_MSGID_NONE, &context);
+	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
+			     (uint8_t *) & tbl, sizeof(tbl),
+			     IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
+			     CL_DISP_MSGID_NONE, &context);
+	if (status != IB_SUCCESS)
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6203 : "
+			"failed to update SL2VLMapping tables "
+			"for port %" PRIx64 "i, attr_mod 0x%x\n",
+			cl_ntoh64(p->port_guid), attr_mod);
+	return status;
 }
 
-static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
-				    osm_physp_t * p, uint8_t port_num,
-				    unsigned force_update,
-				    const struct qos_config *qcfg)
+static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
+			      const struct qos_config *qcfg)
 {
-	ib_api_status_t status;
-	uint8_t i, num_ports;
-	ib_port_info_t *pi = &p_port->p_physp->port_info;
-
-	if (!(pi->capability_mask & IB_PORT_CAP_HAS_SL_MAP))
-		return IB_SUCCESS;
+	osm_physp_t *p0, *p;
+	unsigned force_update;
+	unsigned num_ports = osm_node_get_num_physp(node);
+	int ret = 0;
+	unsigned i, j;
 
-	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH)
-		num_ports = osm_node_get_num_physp(osm_physp_get_node_ptr(p));
-	else
-		num_ports = 1;
+	for (i = 1; i < num_ports; i++) {
+		p = osm_node_get_physp_ptr(node, i);
+		force_update = p->need_update || sm->p_subn->need_update;
+		p->vl_high_limit = qcfg->vl_high_limit;
+		if (vlarb_update(sm, p, p->port_num, force_update, qcfg))
+			ret = -1;
+	}
 
-	for (i = 0; i < num_ports; i++) {
-		status = sl2vl_update_table(sm, p, i, port_num, force_update,
-					    &qcfg->sl2vl);
-		if (status != IB_SUCCESS)
-			return status;
+	p0 = osm_node_get_physp_ptr(node, 0);
+	if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
+		return ret;
+
+	for (i = 1; i < num_ports; i++) {
+		p = osm_node_get_physp_ptr(node, i);
+		force_update = p->need_update || sm->p_subn->need_update;
+		for (j = 0; j < num_ports; j++)
+			if (sl2vl_update_table(sm, p, i, j, force_update,
+					       &qcfg->sl2vl))
+				ret = -1;
 	}
 
-	return IB_SUCCESS;
+	return ret;
 }
 
-static int qos_physp_setup(osm_log_t * p_log, osm_sm_t * sm,
-			   osm_port_t * p_port, osm_physp_t * p,
-			   uint8_t port_num, unsigned force_update,
-			   const struct qos_config *qcfg)
+static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
+			     const struct qos_config *qcfg)
 {
-	ib_api_status_t status;
+	unsigned force_update = p->need_update || sm->p_subn->need_update;
 
-	/* OpVLs should be ok at this moment - just use it */
-
-	/* setup VL high limit on the physp later to be updated by link mgr */
 	p->vl_high_limit = qcfg->vl_high_limit;
-
-	/* setup VLArbitration */
-	status = vlarb_update(sm, p, port_num, force_update, qcfg);
-	if (status != IB_SUCCESS) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6202 : "
-			"failed to update VLArbitration tables "
-			"for port %" PRIx64 " #%d\n",
-			cl_ntoh64(p->port_guid), port_num);
+	if (vlarb_update(sm, p, 0, force_update, qcfg))
 		return -1;
-	}
 
-	/* setup SL2VL tables */
-	status = sl2vl_update(sm, p_port, p, port_num, force_update, qcfg);
-	if (status != IB_SUCCESS) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6203 : "
-			"failed to update SL2VLMapping tables "
-			"for port %" PRIx64 " #%d\n",
-			cl_ntoh64(p->port_guid), port_num);
+	if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
+		return 0;
+
+	if (sl2vl_update_table(sm, p, 0, 0, force_update, &qcfg->sl2vl))
 		return -1;
-	}
 
 	return 0;
 }
@@ -256,12 +260,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	cl_qmap_t *p_tbl;
 	cl_map_item_t *p_next;
 	osm_port_t *p_port;
-	uint32_t num_physp;
-	osm_physp_t *p_physp;
 	osm_node_t *p_node;
-	unsigned force_update;
 	int ret = 0;
-	uint8_t i;
 
 	if (!p_osm->subn.opt.qos)
 		return 0;
@@ -290,18 +290,9 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 
 		p_node = p_port->p_node;
 		if (p_node->sw) {
-			num_physp = osm_node_get_num_physp(p_node);
-			for (i = 1; i < num_physp; i++) {
-				p_physp = osm_node_get_physp_ptr(p_node, i);
-				if (!p_physp)
-					continue;
-				force_update = p_physp->need_update ||
-				    p_osm->subn.need_update;
-				if (qos_physp_setup(&p_osm->log, &p_osm->sm,
-						    p_port, p_physp, i,
-						    force_update, &swe_config))
-					ret = -1;
-			}
+			if (qos_extports_setup(&p_osm->sm, p_node, &swe_config))
+				ret = -1;
+
 			/* skip base port 0 */
 			if (!ib_switch_info_is_enhanced_port0
 			    (&p_node->sw->switch_info))
@@ -313,13 +304,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 		else
 			cfg = &ca_config;
 
-		p_physp = p_port->p_physp;
-		if (!p_physp)
-			continue;
-
-		force_update = p_physp->need_update || p_osm->subn.need_update;
-		if (qos_physp_setup(&p_osm->log, &p_osm->sm, p_port, p_physp,
-				    0, force_update, cfg))
+		if (qos_endport_setup(&p_osm->sm, p_port->p_physp, cfg))
 			ret = -1;
 	}
 
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
