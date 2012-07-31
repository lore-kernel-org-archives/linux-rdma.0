From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/27] Sending SL2VL and VLARB SET MADs in distributed manner
Date: Tue, 31 Jul 2012 19:04:37 +0300
Message-ID: <1343750695-28063-9-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The algorithm is the following:
1. For each GUID the linked list of QoS MADs is created w/o sending the
   MADs.
2. These linked lists are combined into super-linked list. The nodes in
   the super-list are linked lists from Action 1.
3. Now I'm traversing the super-linked list until it is empty and
   removing the head items from the GUID QoS MAD lists and sending them
   over the wire.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_sm.h |  67 +++++++++++++++
 opensm/osm_qos.c        | 211 ++++++++++++++++++++++++++++++++++++------------
 opensm/osm_req.c        |  49 ++++++++---
 3 files changed, 263 insertions(+), 64 deletions(-)

diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
index 4c7b120..710d206 100644
--- a/include/opensm/osm_sm.h
+++ b/include/opensm/osm_sm.h
@@ -434,6 +434,73 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 *	The response from the node will be routed through the Dispatcher
 *	to the appropriate receive controller object.
 *********/
+
+/****f* OpenSM: SM/osm_send_req_mad
+* NAME
+*       osm_send_req_mad
+*
+* DESCRIPTION
+*	Starts the process to transmit a preallocated/predefined directed route
+*	Set() request.
+*
+* SYNOPSIS
+*/
+void osm_send_req_mad(IN osm_sm_t * sm, IN osm_madw_t *p_madw);
+/*
+* PARAMETERS
+*	sm
+*		[in] Pointer to an osm_sm_t object.
+*	p_madw
+*		[in] Pointer to a preallocated MAD buffer
+*
+*********/
+
+/***f* OpenSM: SM/osm_prepare_req_set
+* NAME
+*	osm_prepare_req_set
+*
+* DESCRIPTION
+*	Preallocate and fill a directed route Set() MAD w/o sending it.
+*
+* SYNOPSIS
+*/
+osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+				IN const uint8_t * p_payload,
+				IN size_t payload_size, IN ib_net16_t attr_id,
+				IN ib_net32_t attr_mod, IN cl_disp_msgid_t err_msg,
+				IN const osm_madw_context_t * p_context);
+/*
+* PARAMETERS
+*	sm
+*		[in] Pointer to an osm_sm_t object.
+*
+*	p_path
+*		[in] Pointer to the directed route path of the recipient.
+*
+*	p_payload
+*		[in] Pointer to the SMP payload to send.
+*
+*	payload_size
+*		[in] The size of the payload to be copied to the SMP data field.
+*
+*	attr_id
+*		[in] Attribute ID to request.
+*
+*	attr_mod
+*		[in] Attribute modifier for this request.
+*
+*	err_msg
+*		[in] Message id with which to post this MAD if an error occurs.
+*
+*	p_context
+*		[in] Mad wrapper context structure to be copied into the wrapper
+*		     context, and thus visible to the recipient of the response.
+*
+* RETURN VALUES
+*	Pointer the MAD buffer in case of success and NULL in case of failure.
+*
+*********/
+
 /****f* OpenSM: SM/osm_req_set
 * NAME
 *	osm_req_set
diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index 7342561..dd08ac0 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -61,12 +61,79 @@ struct qos_config {
 	ib_slvl_table_t sl2vl;
 };
 
-static void qos_build_config(struct qos_config *cfg, osm_qos_options_t * opt,
+typedef struct qos_mad_item {
+	cl_list_item_t list_item;
+	osm_madw_t *p_madw;
+} qos_mad_item_t;
+
+typedef struct qos_mad_list {
+	cl_list_item_t list_item;
+	cl_qlist_t port_mad_list;
+} qos_mad_list_t;
+
+static void qos_build_config(struct qos_config *cfg,
+			     osm_qos_options_t * opt,
 			     osm_qos_options_t * dflt);
 
 /*
  * QoS primitives
  */
+
+static qos_mad_item_t *osm_qos_mad_create(IN osm_sm_t * sm,
+					  IN osm_physp_t * p,
+					  IN uint32_t data_size,
+					  IN uint8_t * p_data,
+					  IN ib_net16_t attr_id,
+					  IN uint32_t attr_mod)
+
+{
+	qos_mad_item_t *p_mad;
+	osm_madw_context_t context;
+	osm_madw_t *p_madw;
+	osm_node_t *p_node;
+
+	p_node = osm_physp_get_node_ptr(p);
+
+	switch (attr_id){
+	case IB_MAD_ATTR_SLVL_TABLE:
+		context.slvl_context.node_guid = osm_node_get_node_guid(p_node);
+		context.slvl_context.port_guid = osm_physp_get_port_guid(p);
+		context.slvl_context.set_method = TRUE;
+		break;
+	case IB_MAD_ATTR_VL_ARBITRATION:
+		context.vla_context.node_guid = osm_node_get_node_guid(p_node);
+		context.vla_context.port_guid = osm_physp_get_port_guid(p);
+		context.vla_context.set_method = TRUE;
+		break;
+	default:
+		return NULL;
+	}
+
+	p_mad = (qos_mad_item_t *) malloc(sizeof(*p_mad));
+	if (!p_mad)
+		return NULL;
+
+	memset(p_mad, 0, sizeof(*p_mad));
+
+	p_madw = osm_prepare_req_set(sm, osm_physp_get_dr_path_ptr(p),
+				     p_data, data_size,
+				     attr_id, cl_hton32(attr_mod),
+				     CL_DISP_MSGID_NONE, &context);
+
+	if (p_madw == NULL) {
+		free(p_mad);
+		return NULL;
+	}
+	p_mad->p_madw = p_madw;
+	return p_mad;
+}
+
+static void osm_qos_mad_delete(qos_mad_item_t ** p_item)
+{
+	free(*p_item);
+	*p_item = NULL;
+}
+
 static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 						osm_physp_t * p,
 						uint8_t port_num,
@@ -74,14 +141,13 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 						const ib_vl_arb_table_t *
 						table_block,
 						unsigned block_length,
-						unsigned block_num)
+						unsigned block_num,
+						cl_qlist_t *mad_list)
 {
 	ib_vl_arb_table_t block;
-	osm_madw_context_t context;
 	uint32_t attr_mod;
 	unsigned vl_mask, i;
-	ib_api_status_t status;
-
+	qos_mad_item_t *p_mad;
 	vl_mask = (1 << (ib_port_info_get_op_vls(&p->port_info) - 1)) - 1;
 
 	memset(&block, 0, sizeof(block));
@@ -94,28 +160,23 @@ static ib_api_status_t vlarb_update_table_block(osm_sm_t * sm,
 		    block_length * sizeof(block.vl_entry[0])))
 		return IB_SUCCESS;
 
-	context.vla_context.node_guid =
-	    osm_node_get_node_guid(osm_physp_get_node_ptr(p));
-	context.vla_context.port_guid = osm_physp_get_port_guid(p);
-	context.vla_context.set_method = TRUE;
 	attr_mod = ((block_num + 1) << 16) | port_num;
 
-	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
-			     (uint8_t *) & block, sizeof(block),
-			     IB_MAD_ATTR_VL_ARBITRATION, cl_hton32(attr_mod),
-			     CL_DISP_MSGID_NONE, &context);
-	if (status != IB_SUCCESS)
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6202 : "
-			"failed to update VLArbitration tables "
-			"for port %" PRIx64 " block %u\n",
-			cl_ntoh64(p->port_guid), block_num);
+	p_mad = osm_qos_mad_create(sm,p,sizeof(block),(uint8_t *) & block,
+				   IB_MAD_ATTR_VL_ARBITRATION, attr_mod);
 
-	return status;
+	if (!p_mad)
+		return IB_INSUFFICIENT_MEMORY;
+
+	cl_qlist_insert_tail(mad_list, &p_mad->list_item);
+
+	return IB_SUCCESS;
 }
 
 static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 				    uint8_t port_num, unsigned force_update,
-				    const struct qos_config *qcfg)
+				    const struct qos_config *qcfg,
+				    cl_qlist_t *mad_list)
 {
 	ib_api_status_t status = IB_SUCCESS;
 	ib_port_info_t *p_pi = &p->port_info;
@@ -127,7 +188,8 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 		if ((status = vlarb_update_table_block(sm, p, port_num,
 						       force_update,
 						       &qcfg->vlarb_low[0],
-						       len, 0)) != IB_SUCCESS)
+						       len, 0,
+						       mad_list)) != IB_SUCCESS)
 			return status;
 	}
 	if (p_pi->vl_arb_low_cap > IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK) {
@@ -135,7 +197,8 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 		if ((status = vlarb_update_table_block(sm, p, port_num,
 						       force_update,
 						       &qcfg->vlarb_low[1],
-						       len, 1)) != IB_SUCCESS)
+						       len, 1,
+						       mad_list)) != IB_SUCCESS)
 			return status;
 	}
 	if (p_pi->vl_arb_high_cap > 0) {
@@ -144,7 +207,8 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 		if ((status = vlarb_update_table_block(sm, p, port_num,
 						       force_update,
 						       &qcfg->vlarb_high[0],
-						       len, 2)) != IB_SUCCESS)
+						       len, 2,
+						       mad_list)) != IB_SUCCESS)
 			return status;
 	}
 	if (p_pi->vl_arb_high_cap > IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK) {
@@ -152,7 +216,8 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 		if ((status = vlarb_update_table_block(sm, p, port_num,
 						       force_update,
 						       &qcfg->vlarb_high[1],
-						       len, 3)) != IB_SUCCESS)
+						       len, 3,
+						       mad_list)) != IB_SUCCESS)
 			return status;
 	}
 
@@ -162,15 +227,14 @@ static ib_api_status_t vlarb_update(osm_sm_t * sm, osm_physp_t * p,
 static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 					  uint8_t in_port, uint32_t attr_mod,
 					  unsigned force_update,
-					  const ib_slvl_table_t * sl2vl_table)
+					  const ib_slvl_table_t * sl2vl_table,
+					  cl_qlist_t *mad_list)
 {
-	osm_madw_context_t context;
 	ib_slvl_table_t tbl, *p_tbl;
-	osm_node_t *p_node = osm_physp_get_node_ptr(p);
-	ib_api_status_t status;
 	unsigned vl_mask;
 	uint8_t vl1, vl2;
 	int i;
+	qos_mad_item_t *p_mad;
 
 	vl_mask = (1 << (ib_port_info_get_op_vls(&p->port_info) - 1)) - 1;
 
@@ -188,23 +252,19 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 	    !memcmp(p_tbl, &tbl, sizeof(tbl)))
 		return IB_SUCCESS;
 
-	context.slvl_context.node_guid = osm_node_get_node_guid(p_node);
-	context.slvl_context.port_guid = osm_physp_get_port_guid(p);
-	context.slvl_context.set_method = TRUE;
-	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
-			     (uint8_t *) & tbl, sizeof(tbl),
-			     IB_MAD_ATTR_SLVL_TABLE, cl_hton32(attr_mod),
-			     CL_DISP_MSGID_NONE, &context);
-	if (status != IB_SUCCESS)
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 6203 : "
-			"failed to update SL2VLMapping tables "
-			"for port %" PRIx64 ", attr_mod 0x%x\n",
-			cl_ntoh64(p->port_guid), attr_mod);
-	return status;
+	p_mad = osm_qos_mad_create(sm, p, sizeof(tbl), (uint8_t *) & tbl,
+				   IB_MAD_ATTR_SLVL_TABLE, attr_mod);
+	if (!p_mad)
+		return IB_INSUFFICIENT_MEMORY;
+
+	cl_qlist_insert_tail(mad_list, &p_mad->list_item);
+	return IB_SUCCESS;
 }
 
 static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
-			      const struct qos_config *qcfg)
+			      const struct qos_config *qcfg,
+			      cl_qlist_t *port_mad_list)
+
 {
 	osm_physp_t *p0, *p;
 	unsigned force_update;
@@ -227,7 +287,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 			continue;
 		force_update = p->need_update || sm->p_subn->need_update;
 		p->vl_high_limit = qcfg->vl_high_limit;
-		if (vlarb_update(sm, p, p->port_num, force_update, qcfg))
+		if (vlarb_update(sm, p, p->port_num, force_update, qcfg,
+				 port_mad_list))
 			ret = -1;
 	}
 
@@ -259,7 +320,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 		}
 		force_update = p->need_update || sm->p_subn->need_update;
 		if (sl2vl_update_table(sm, p0, 0, 0x30000, force_update,
-					&qcfg->sl2vl))
+					&qcfg->sl2vl, port_mad_list))
 			ret = -1;
 		/*
 		 * Overwrite default ALL configuration if port's
@@ -273,7 +334,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 			if (ib_port_info_get_op_vls(&p->port_info) !=
 			    common_op_vl &&
 			    sl2vl_update_table(sm, p, 0, 0x20000 | out,
-					       force_update, &qcfg->sl2vl))
+					       force_update, &qcfg->sl2vl,
+					       port_mad_list))
 				ret = -1;
 		}
 		return ret;
@@ -298,7 +360,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 				port_sl2vl = &routing_sl2vl;
 			}
 			if (sl2vl_update_table(sm, p, in, in << 8 | out,
-					       force_update, port_sl2vl))
+					       force_update, port_sl2vl,
+					       port_mad_list))
 				ret = -1;
 		}
 	}
@@ -307,7 +370,8 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 }
 
 static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
-			     const struct qos_config *qcfg, int vlarb_only)
+			     const struct qos_config *qcfg, int vlarb_only,
+			     cl_qlist_t *port_mad_list)
 {
 	unsigned force_update = p->need_update || sm->p_subn->need_update;
 	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
@@ -315,7 +379,7 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 	ib_slvl_table_t routing_sl2vl;
 
 	p->vl_high_limit = qcfg->vl_high_limit;
-	if (vlarb_update(sm, p, 0, force_update, qcfg))
+	if (vlarb_update(sm, p, 0, force_update, qcfg, port_mad_list))
 		return -1;
 	if (vlarb_only)
 		return 0;
@@ -328,7 +392,8 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 		re->update_sl2vl(re->context, p, 0, 0, &routing_sl2vl);
 		port_sl2vl = &routing_sl2vl;
 	}
-	if (sl2vl_update_table(sm, p, 0, 0, force_update, port_sl2vl))
+	if (sl2vl_update_table(sm, p, 0, 0, force_update, port_sl2vl,
+			       port_mad_list))
 		return -1;
 
 	return 0;
@@ -344,6 +409,9 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	osm_node_t *p_node;
 	int ret = 0;
 	int vlarb_only;
+	qos_mad_list_t *p_list, *p_list_next;
+	qos_mad_item_t *p_port_mad;
+	cl_qlist_t qos_mad_list;
 
 	if (!p_osm->subn.opt.qos)
 		return 0;
@@ -359,11 +427,12 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	qos_build_config(&rtr_config, &p_osm->subn.opt.qos_rtr_options,
 			 &p_osm->subn.opt.qos_options);
 
+	cl_qlist_init(&qos_mad_list);
+
 	cl_plock_excl_acquire(&p_osm->lock);
 
 	/* read QoS policy config file */
 	osm_qos_parse_policy_file(&p_osm->subn);
-
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
 	while (p_next != cl_qmap_end(p_tbl)) {
@@ -371,15 +440,24 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 		p_port = (osm_port_t *) p_next;
 		p_next = cl_qmap_next(p_next);
 
+		p_list = (qos_mad_list_t *) malloc(sizeof(*p_list));
+		if (!p_list)
+			return -1;
+
+		memset(p_list, 0, sizeof(*p_list));
+
+		cl_qlist_init(&p_list->port_mad_list);
+
 		p_node = p_port->p_node;
 		if (p_node->sw) {
-			if (qos_extports_setup(&p_osm->sm, p_node, &swe_config))
+			if (qos_extports_setup(&p_osm->sm, p_node, &swe_config,
+					       &p_list->port_mad_list))
 				ret = -1;
 
 			/* skip base port 0 */
 			if (!ib_switch_info_is_enhanced_port0
 			    (&p_node->sw->switch_info))
-				continue;
+				goto Continue;
 
 			if (ib_switch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) &&
 			    p_osm->sm.p_subn->opt.use_optimized_slvl &&
@@ -394,8 +472,35 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 			cfg = &ca_config;
 
 		if (qos_endport_setup(&p_osm->sm, p_port->p_physp, cfg,
-				      vlarb_only))
+				      vlarb_only, &p_list->port_mad_list))
+
 			ret = -1;
+Continue:
+		/* if MAD list is not empty, add it to the global MAD list */
+		if (cl_qlist_count(&p_list->port_mad_list)) {
+			cl_qlist_insert_tail(&qos_mad_list, &p_list->list_item);
+		} else {
+			free(p_list);
+		}
+	}
+	while (cl_qlist_count(&qos_mad_list)) {
+		p_list_next = (qos_mad_list_t *) cl_qlist_head(&qos_mad_list);
+		while (p_list_next !=
+			(qos_mad_list_t *) cl_qlist_end(&qos_mad_list)) {
+			p_list = p_list_next;
+			p_list_next = (qos_mad_list_t *)
+				      cl_qlist_next(&p_list->list_item);
+			/* next MAD to send*/
+			p_port_mad = (qos_mad_item_t *)
+				     cl_qlist_remove_head(&p_list->port_mad_list);
+			osm_send_req_mad(&p_osm->sm, p_port_mad->p_madw);
+			osm_qos_mad_delete(&p_port_mad);
+			/* remove the QoS MAD from global MAD list */
+			if (cl_qlist_count(&p_list->port_mad_list) == 0) {
+				cl_qlist_remove_item(&qos_mad_list, &p_list->list_item);
+				free(p_list);
+			}
+		}
 	}
 
 	cl_plock_release(&p_osm->lock);
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 2532f9c..8780134 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -129,15 +129,14 @@ Exit:
 /**********************************************************************
   The plock MAY or MAY NOT be held before calling this function.
 **********************************************************************/
-ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
-			    IN const uint8_t * p_payload,
-			    IN size_t payload_size,
-			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
-			    IN cl_disp_msgid_t err_msg,
-			    IN const osm_madw_context_t * p_context)
+osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+				IN const uint8_t * p_payload,
+				IN size_t payload_size,
+				IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+				IN cl_disp_msgid_t err_msg,
+				IN const osm_madw_context_t * p_context)
 {
-	osm_madw_t *p_madw;
-	ib_api_status_t status = IB_SUCCESS;
+	osm_madw_t *p_madw = NULL;
 	ib_net64_t tid;
 
 	CL_ASSERT(sm);
@@ -159,7 +158,6 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 	if (p_madw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"ERR 1102: Unable to acquire MAD\n");
-		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
 	}
 
@@ -191,10 +189,39 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 
 	memcpy(osm_madw_get_smp_ptr(p_madw)->data, p_payload, payload_size);
 
-	osm_vl15_post(sm->p_vl15, p_madw);
-
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
+	return p_madw;
+}
+
+void osm_send_req_mad(IN osm_sm_t * sm, IN osm_madw_t *p_madw)
+{
+	CL_ASSERT(p_madw);
+	CL_ASSERT(sm);
+
+	osm_vl15_post(sm->p_vl15, p_madw);
+}
+
+/**********************************************************************
+  The plock MAY or MAY NOT be held before calling this function.
+**********************************************************************/
+ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
+                            IN const uint8_t * p_payload,
+                            IN size_t payload_size,
+                            IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+                            IN cl_disp_msgid_t err_msg,
+                            IN const osm_madw_context_t * p_context)
+{
+	osm_madw_t *p_madw;
+	ib_api_status_t status = IB_SUCCESS;
+
+	p_madw = osm_prepare_req_set(sm, p_path, p_payload, payload_size,attr_id,
+				     attr_mod, err_msg, p_context);
+	if (p_madw == NULL)
+		status = IB_INSUFFICIENT_RESOURCES;
+	else
+		osm_send_req_mad(sm, p_madw);
+
 	return status;
 }
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
