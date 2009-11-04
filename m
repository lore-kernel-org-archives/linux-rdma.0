From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm: Add support for optimized SLtoVLMappingTable
	programming
Date: Wed, 4 Nov 2009 09:40:07 -0500
Message-ID: <20091104144007.GB7316@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Optimized SLtoVLMappingTable programming reduces the number of MADs
needed from O(n**2) to O(n). See IBA 1.2.1 vol 1 p. 843 14.2.5.8
SLtoVLMappingTable.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Changed optimized programming flow in osm_qos to only call
sl2vl_update once per switch supporting this feature

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 0302f91..d345bbc 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -206,6 +206,7 @@ typedef struct osm_subn_opt {
 	boolean_t daemon;
 	boolean_t sm_inactive;
 	boolean_t babbling_port_policy;
+	boolean_t use_optimized_slvl;
 	osm_qos_options_t qos_options;
 	osm_qos_options_t qos_ca_options;
 	osm_qos_options_t qos_sw0_options;
@@ -433,6 +434,10 @@ typedef struct osm_subn_opt {
 *	babbling_port_policy
 *		OpenSM will enforce its "babbling" port policy.
 *
+*	use_optimized_slvl
+*		Use optimized SLtoVLMappingTable programming if
+*		device indicates it supports this.
+*
 *	perfmgr
 *		Enable or disable the performance manager
 *
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 08f9a60..617a86e 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -150,7 +151,7 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 
 static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 					  uint8_t in_port, uint8_t out_port,
-					  unsigned force_update,
+					  unsigned optimize, unsigned force_update,
 					  const ib_slvl_table_t * sl2vl_table)
 {
 	osm_madw_context_t context;
@@ -180,41 +181,47 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 	context.slvl_context.node_guid = osm_node_get_node_guid(p_node);
 	context.slvl_context.port_guid = osm_physp_get_port_guid(p);
 	context.slvl_context.set_method = TRUE;
-	attr_mod = in_port << 8 | out_port;
+	if (optimize)
+		/* wildcard both input and output ports */
+		attr_mod = 0x30000;
+	else
+		attr_mod = in_port << 8 | out_port;
 	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
 			   (uint8_t *) & tbl, sizeof(tbl),
 			   IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
 			   CL_DISP_MSGID_NONE, &context);
 }
 
-static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
+static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_physp_t * p0,
 				    osm_physp_t * p, uint8_t port_num,
-				    unsigned force_update,
+				    unsigned optimize, unsigned force_update,
 				    const struct qos_config *qcfg)
 {
 	ib_api_status_t status;
 	uint8_t i, num_ports;
-	osm_physp_t *p_physp;
+	osm_node_t *p_node;
 
-	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
+	p_node = osm_physp_get_node_ptr(p);
+	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
 		if (ib_port_info_get_vl_cap(&p->port_info) == 1) {
 			/* Check port 0's capability mask */
-			p_physp = p_port->p_physp;
-			if (!
-			    (p_physp->port_info.
-			     capability_mask & IB_PORT_CAP_HAS_SL_MAP))
+			if (!(p0->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
 				return IB_SUCCESS;
 		}
-		num_ports = osm_node_get_num_physp(osm_physp_get_node_ptr(p));
+		num_ports = osm_node_get_num_physp(p_node);
 	} else {
 		if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
 			return IB_SUCCESS;
 		num_ports = 1;
 	}
 
+	if (optimize)
+		return sl2vl_update_table(sm, p, 1, port_num, optimize,
+					  force_update, &qcfg->sl2vl);
+
 	for (i = 0; i < num_ports; i++) {
-		status = sl2vl_update_table(sm, p, i, port_num, force_update,
-					    &qcfg->sl2vl);
+		status = sl2vl_update_table(sm, p, i, port_num, optimize,
+					    force_update, &qcfg->sl2vl);
 		if (status != IB_SUCCESS)
 			return status;
 	}
@@ -222,22 +229,30 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
 	return IB_SUCCESS;
 }
 
-static int qos_physp_setup(osm_log_t * p_log, osm_sm_t * sm,
-			   osm_port_t * p_port, osm_physp_t * p,
-			   uint8_t port_num, unsigned force_update,
-			   const struct qos_config *qcfg)
+static int vlarb_physp_setup(osm_sm_t * sm, osm_physp_t * p, uint8_t port_num,
+			     unsigned force_update,
+			     const struct qos_config *qcfg)
 {
-	ib_api_status_t status;
-
 	/* OpVLs should be ok at this moment - just use it */
 
 	/* setup VL high limit on the physp later to be updated by link mgr */
 	p->vl_high_limit = qcfg->vl_high_limit;
 
 	/* setup VLArbitration */
-	status = vlarb_update(sm, p, port_num, force_update, qcfg);
+	return vlarb_update(sm, p, port_num, force_update, qcfg);
+}
+
+static int qos_physp_setup(osm_log_t * p_log, osm_sm_t * sm,
+			   osm_physp_t * p0, osm_physp_t * p,
+			   uint8_t port_num, unsigned force_update,
+			   const struct qos_config *qcfg)
+{
+	ib_api_status_t status;
+
+	/* setup VLArbitration */
+	status = vlarb_physp_setup(sm, p, port_num, force_update, qcfg);
 	if (status != IB_SUCCESS) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6202 : "
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6202: "
 			"failed to update VLArbitration tables "
 			"for port %" PRIx64 " #%d\n",
 			cl_ntoh64(p->port_guid), port_num);
@@ -245,9 +260,9 @@ static int qos_physp_setup(osm_log_t * p_log, osm_sm_t * sm,
 	}
 
 	/* setup SL2VL tables */
-	status = sl2vl_update(sm, p_port, p, port_num, force_update, qcfg);
+	status = sl2vl_update(sm, p0, p, port_num, 0, force_update, qcfg);
 	if (status != IB_SUCCESS) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6203 : "
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6203: "
 			"failed to update SL2VLMapping tables "
 			"for port %" PRIx64 " #%d\n",
 			cl_ntoh64(p->port_guid), port_num);
@@ -267,6 +282,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	uint32_t num_physp;
 	osm_physp_t *p_physp;
 	osm_node_t *p_node;
+	osm_switch_t *p_sw;
 	unsigned force_update;
 	int ret = 0;
 	uint8_t i;
@@ -290,6 +306,44 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	/* read QoS policy config file */
 	osm_qos_parse_policy_file(&p_osm->subn);
 
+	/* loop on switches that support optimized SL2VL programming first */
+	p_tbl = &p_osm->subn.sw_guid_tbl;
+	p_next = cl_qmap_head(p_tbl);
+	while (p_next != cl_qmap_end(p_tbl)) {
+		p_sw = (osm_switch_t *) p_next;
+		p_next = cl_qmap_next(p_next);
+
+		if (ib_switch_info_get_opt_sl2vlmapping(&p_sw->switch_info) &&
+		    p_osm->subn.opt.use_optimized_slvl) {
+			p_physp = osm_node_get_physp_ptr(p_sw->p_node, 1);
+			num_physp = osm_node_get_num_physp(p_sw->p_node);
+			force_update = p_osm->subn.need_update;
+			for (i = 1; i < num_physp; i++) {
+				p_physp = osm_node_get_physp_ptr(p_sw->p_node, i);
+				if (!p_physp)
+					continue;
+				if (vlarb_physp_setup(&p_osm->sm, p_physp, i,
+						      p_physp->need_update ||
+						      p_osm->subn.need_update,
+						      &swe_config))
+					ret = -1;
+				force_update |= p_physp->need_update;
+			}
+			if (sl2vl_update(&p_osm->sm,
+					 osm_node_get_physp_ptr(p_sw->p_node, 0),
+					 p_physp, i, 1, force_update,
+					 &swe_config)) {
+				OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 6204: "
+					"failed to update optimized SL2VLMapping"
+					" tables for port %" PRIx64 " #%d\n",
+					cl_ntoh64(p_physp->port_guid), i);
+				ret = -1;
+			}
+		}
+	}
+
+	/* now, loop on ports skipping the external ports of switches
+	   that support optimized SL2VL programming */
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
 	while (p_next != cl_qmap_end(p_tbl)) {
@@ -298,6 +352,11 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 
 		p_node = p_port->p_node;
 		if (p_node->sw) {
+			/* skip switches with optimized SL2VL mapping
+			   programming since already done */
+			if (ib_switch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) &&
+			    p_osm->subn.opt.use_optimized_slvl)
+				goto check_port0;
 			num_physp = osm_node_get_num_physp(p_node);
 			for (i = 1; i < num_physp; i++) {
 				p_physp = osm_node_get_physp_ptr(p_node, i);
@@ -306,10 +365,11 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 				force_update = p_physp->need_update ||
 				    p_osm->subn.need_update;
 				if (qos_physp_setup(&p_osm->log, &p_osm->sm,
-						    p_port, p_physp, i,
+						    p_port->p_physp, p_physp, i,
 						    force_update, &swe_config))
 					ret = -1;
 			}
+check_port0:
 			/* skip base port 0 */
 			if (!ib_switch_info_is_enhanced_port0
 			    (&p_node->sw->switch_info))
@@ -326,8 +386,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 			continue;
 
 		force_update = p_physp->need_update || p_osm->subn.need_update;
-		if (qos_physp_setup(&p_osm->log, &p_osm->sm, p_port, p_physp,
-				    0, force_update, cfg))
+		if (qos_physp_setup(&p_osm->log, &p_osm->sm, p_port->p_physp,
+				    p_physp, 0, force_update, cfg))
 			ret = -1;
 	}
 
diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_slvl_map_rcv.c
index 4f75690..e6873f4 100644
--- a/opensm/opensm/osm_slvl_map_rcv.c
+++ b/opensm/opensm/osm_slvl_map_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -70,7 +71,9 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 	osm_slvl_context_t *p_context;
 	ib_net64_t port_guid;
 	ib_net64_t node_guid;
-	uint8_t out_port_num, in_port_num;
+	uint32_t attr_mod;
+	uint8_t out_port_num, in_port_num, startinport, startoutport,
+		endinport, endoutport;
 
 	CL_ASSERT(sm);
 
@@ -109,6 +112,9 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 		    (uint8_t) cl_ntoh32(p_smp->attr_mod & 0xFF000000);
 		in_port_num =
 		    (uint8_t) cl_ntoh32((p_smp->attr_mod & 0x00FF0000) << 8);
+		attr_mod = cl_ntoh32(p_smp->attr_mod);
+		if (attr_mod & 0x30000)
+			goto opt_sl2vl;
 		p_physp = osm_node_get_physp_ptr(p_node, out_port_num);
 	} else {
 		p_physp = p_port->p_physp;
@@ -121,7 +127,7 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 	   all we want is to update the subnet.
 	 */
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-		"Got SLtoVL get response in_port_num %u out_port_num %u with "
+		"Received SLtoVL GetResp in_port_num %u out_port_num %u with "
 		"GUID 0x%" PRIx64 " for parent node GUID 0x%" PRIx64 ", TID 0x%"
 		PRIx64 "\n", in_port_num, out_port_num, cl_ntoh64(port_guid),
 		cl_ntoh64(node_guid), cl_ntoh64(p_smp->trans_id));
@@ -140,6 +146,39 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 				out_port_num, p_slvl_tbl, OSM_LOG_DEBUG);
 
 	osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_port_num);
+	goto Exit;
+
+opt_sl2vl:
+	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+		"Received optimized SLtoVL get response in_port_num %u "
+		"out_port_num %u with GUID 0x%" PRIx64 " for parent node GUID "
+		"0x%" PRIx64 ", TID 0x%" PRIx64 "\n", in_port_num, out_port_num,
+		cl_ntoh64(port_guid), cl_ntoh64(node_guid),
+		cl_ntoh64(p_smp->trans_id));
+
+	osm_dump_slvl_map_table(sm->p_log, port_guid, in_port_num,
+				out_port_num, p_slvl_tbl, OSM_LOG_DEBUG);
+
+	if (attr_mod & 0x10000) {
+		startoutport = ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info) ? 0 : 1;
+		endoutport = osm_node_get_num_physp(p_node);
+	} else
+		endoutport = startoutport = out_port_num;
+	if (attr_mod & 0x20000) {
+		startinport = ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info) ? 0 : 1;
+		endinport = osm_node_get_num_physp(p_node);
+	} else
+		endinport = startinport = in_port_num;
+
+	for (out_port_num = startoutport; out_port_num < endoutport;
+	     out_port_num++) {
+		p_physp = osm_node_get_physp_ptr(p_node, out_port_num);
+		if (!p_physp)
+			continue;
+		for (in_port_num = startinport; in_port_num < endinport;
+		     in_port_num++)
+			osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_port_num);
+	}
 
 Exit:
 	cl_plock_release(sm->p_lock);
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index cac5e94..ef08071 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -354,6 +354,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "daemon", OPT_OFFSET(daemon), opts_parse_boolean, NULL, 0 },
 	{ "sm_inactive", OPT_OFFSET(sm_inactive), opts_parse_boolean, NULL, 1 },
 	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_parse_boolean, NULL, 1 },
+	{ "use_optimized_slvl", OPT_OFFSET(use_optimized_slvl), opts_parse_boolean, NULL, 1 },
 #ifdef ENABLE_OSM_PERF_MGR
 	{ "perfmgr", OPT_OFFSET(perfmgr), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_parse_boolean, NULL, 0 },
@@ -707,6 +708,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->daemon = FALSE;
 	p_opt->sm_inactive = FALSE;
 	p_opt->babbling_port_policy = FALSE;
+	p_opt->use_optimized_slvl = FALSE;
 #ifdef ENABLE_OSM_PERF_MGR
 	p_opt->perfmgr = FALSE;
 	p_opt->perfmgr_redir = TRUE;
@@ -1493,10 +1495,13 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# SM Inactive\n"
 		"sm_inactive %s\n\n"
 		"# Babbling Port Policy\n"
-		"babbling_port_policy %s\n\n",
+		"babbling_port_policy %s\n\n"
+		"# Use Optimized SLtoVLMapping programming if supported by device\n"
+		"use_optimized_slvl %s\n\n",
 		p_opts->daemon ? "TRUE" : "FALSE",
 		p_opts->sm_inactive ? "TRUE" : "FALSE",
-		p_opts->babbling_port_policy ? "TRUE" : "FALSE");
+		p_opts->babbling_port_policy ? "TRUE" : "FALSE",
+		p_opts->use_optimized_slvl ? "TRUE" : "FALSE");
 
 #ifdef ENABLE_OSM_PERF_MGR
 	fprintf(out,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
