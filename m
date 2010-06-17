From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv4][RESEND] opensm/PerfMgr: Better redirection support
Date: Thu, 17 Jun 2010 12:03:35 -0400
Message-ID: <20100617160335.GA10884@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Handle PKey and QPN redirection information
GID redirection handling remains

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
Changes since v3:
Rebased

Changes since v2:
Use OpenSM DB rather than vendor layer for local port number and PKeys
Change most log levels from ERROR to VERBOSE
Redirection info validity now determined by single flag
validate_redir_pkey returns pkey index or -1 rather than boolean
Removed redir_ prefixes

Changes since v1:
Added include of osm_helper.h to osm_perfmgr.c

diff --git a/opensm/include/opensm/osm_perfmgr.h b/opensm/include/opensm/osm_perfmgr.h
index c26c141..34925e8 100644
--- a/opensm/include/opensm/osm_perfmgr.h
+++ b/opensm/include/opensm/osm_perfmgr.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2007 The Regents of the University of California.
  * Copyright (c) 2007-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -90,11 +90,17 @@ typedef enum {
 	PERFMGR_SWEEP_SUSPENDED
 } osm_perfmgr_sweep_state_t;
 
-/* Redirection information */
-typedef struct redir {
-	ib_net16_t redir_lid;
-	ib_net32_t redir_qp;
-} redir_t;
+typedef struct monitored_port {
+	uint16_t pkey_ix;
+	ib_net16_t orig_lid;
+	boolean_t redirection;
+	boolean_t valid;
+	/* Redirection fields from ClassPortInfo */
+	ib_gid_t gid;
+	ib_net16_t lid;
+	ib_net16_t pkey;
+	ib_net32_t qp;
+} monitored_port_t;
 
 /* Node to store information about nodes being monitored */
 typedef struct monitored_node {
@@ -104,7 +110,7 @@ typedef struct monitored_node {
 	boolean_t esp0;
 	char *name;
 	uint32_t num_ports;
-	redir_t redir_port[1];	/* redirection on a per port basis */
+	monitored_port_t port[1];
 } monitored_node_t;
 
 struct osm_opensm;
@@ -134,6 +140,8 @@ typedef struct osm_perfmgr {
 	uint32_t max_outstanding_queries;
 	cl_qmap_t monitored_map;	/* map the nodes being tracked */
 	monitored_node_t *remove_list;
+	ib_net64_t port_guid;
+	int16_t local_port;
 } osm_perfmgr_t;
 /*
 * FIELDS
diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr.c
index 398b463..d86e1c6 100644
--- a/opensm/opensm/osm_perfmgr.c
+++ b/opensm/opensm/osm_perfmgr.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2007 The Regents of the University of California.
  * Copyright (c) 2007-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -64,6 +64,7 @@
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_opensm.h>
+#include <opensm/osm_helper.h>
 
 #define PERFMGR_INITIAL_TID_VALUE 0xcafe
 
@@ -194,6 +195,7 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 	uint8_t port = context->perfmgr_context.port;
 	cl_map_item_t *p_node;
 	monitored_node_t *p_mon_node;
+	ib_net16_t orig_lid;
 
 	OSM_LOG_ENTER(pm->log);
 
@@ -225,9 +227,11 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 				p_mon_node->num_ports);
 			goto Exit;
 		}
-		/* Clear redirection info */
-		p_mon_node->redir_port[port].redir_lid = 0;
-		p_mon_node->redir_port[port].redir_qp = 0;
+		/* Clear redirection info for this port except orig_lid */
+		orig_lid = p_mon_node->port[port].orig_lid;
+		memset(&p_mon_node->port[port], 0, sizeof(monitored_port_t));
+		p_mon_node->port[port].orig_lid = orig_lid;
+		p_mon_node->port[port].valid = TRUE;
 		cl_plock_release(&pm->osm->lock);
 	}
 
@@ -256,7 +260,7 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
 		goto Exit;
 	}
 
-	bind_info.port_guid = port_guid;
+	bind_info.port_guid = pm->port_guid = port_guid;
 	bind_info.mad_class = IB_MCLASS_PERF;
 	bind_info.class_version = 1;
 	bind_info.is_responder = FALSE;
@@ -309,24 +313,14 @@ static ib_net32_t get_qp(monitored_node_t * mon_node, uint8_t port)
 	ib_net32_t qp = IB_QP1;
 
 	if (mon_node && mon_node->num_ports && port < mon_node->num_ports &&
-	    mon_node->redir_port[port].redir_lid &&
-	    mon_node->redir_port[port].redir_qp)
-		qp = mon_node->redir_port[port].redir_qp;
+	    mon_node->port[port].redirection && mon_node->port[port].qp)
+		qp = mon_node->port[port].qp;
 
 	return qp;
 }
 
-/**********************************************************************
- * Given a node, a port, and an optional monitored node,
- * return the appropriate lid to query that port
- **********************************************************************/
-static ib_net16_t get_lid(osm_node_t * p_node, uint8_t port,
-			  monitored_node_t * mon_node)
+static ib_net16_t get_base_lid(osm_node_t * p_node, uint8_t port)
 {
-	if (mon_node && mon_node->num_ports && port < mon_node->num_ports &&
-	    mon_node->redir_port[port].redir_lid)
-		return mon_node->redir_port[port].redir_lid;
-
 	switch (p_node->node_info.node_type) {
 	case IB_NODE_TYPE_CA:
 	case IB_NODE_TYPE_ROUTER:
@@ -339,12 +333,26 @@ static ib_net16_t get_lid(osm_node_t * p_node, uint8_t port,
 }
 
 /**********************************************************************
+ * Given a node, a port, and an optional monitored node,
+ * return the lid appropriate to query that port
+ **********************************************************************/
+static ib_net16_t get_lid(osm_node_t * p_node, uint8_t port,
+			  monitored_node_t * mon_node)
+{
+	if (mon_node && mon_node->num_ports && port < mon_node->num_ports &&
+	    mon_node->port[port].lid)
+		return mon_node->port[port].lid;
+
+	return get_base_lid(p_node, port);
+}
+
+/**********************************************************************
  * Form and send the Port Counters MAD for a single port.
  **********************************************************************/
 static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 					   ib_net16_t dest_lid,
-					   ib_net32_t dest_qp, uint8_t port,
-					   uint8_t mad_method,
+					   ib_net32_t dest_qp, uint16_t pkey_ix,
+					   uint8_t port, uint8_t mad_method,
 					   osm_madw_context_t * p_context)
 {
 	ib_api_status_t status = IB_SUCCESS;
@@ -383,8 +391,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 	p_madw->mad_addr.addr_type.gsi.remote_qp = dest_qp;
 	p_madw->mad_addr.addr_type.gsi.remote_qkey =
 	    cl_hton32(IB_QP1_WELL_KNOWN_Q_KEY);
-	/* FIXME what about other partitions */
-	p_madw->mad_addr.addr_type.gsi.pkey_ix = 0;
+	p_madw->mad_addr.addr_type.gsi.pkey_ix = pkey_ix;
 	p_madw->mad_addr.addr_type.gsi.service_level = 0;
 	p_madw->mad_addr.addr_type.gsi.global_route = FALSE;
 	p_madw->resp_expected = TRUE;
@@ -420,6 +427,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 	osm_perfmgr_t *pm = (osm_perfmgr_t *) context;
 	monitored_node_t *mon_node = NULL;
 	uint32_t num_ports;
+	int port;
 
 	OSM_LOG_ENTER(pm->log);
 
@@ -428,7 +436,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 		/* if not already in map add it */
 		num_ports = osm_node_get_num_physp(node);
 		mon_node = malloc(sizeof(*mon_node) +
-				  sizeof(redir_t) * num_ports);
+				  sizeof(monitored_port_t) * num_ports);
 		if (!mon_node) {
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C06: "
 				"malloc failed: not handling node %s"
@@ -437,7 +445,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 			goto Exit;
 		}
 		memset(mon_node, 0,
-		       sizeof(*mon_node) + sizeof(redir_t) * num_ports);
+		       sizeof(*mon_node) + sizeof(monitored_port_t) * num_ports);
 		mon_node->guid = node_guid;
 		mon_node->name = strdup(node->print_desc);
 		mon_node->num_ports = num_ports;
@@ -445,6 +453,11 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
 		mon_node->esp0 = (node->sw &&
 				  ib_switch_info_is_enhanced_port0(&node->sw->
 								   switch_info));
+		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
+			mon_node->port[port].orig_lid = get_base_lid(node, port);
+			mon_node->port[port].valid = TRUE;
+		}
+
 		cl_qmap_insert(&pm->monitored_map, node_guid,
 			       (cl_map_item_t *) mon_node);
 	}
@@ -501,6 +514,9 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 		if (!osm_node_get_physp_ptr(node, port))
 			continue;
 
+		if (!mon_node->port[port].valid)
+			continue;
+
 		lid = get_lid(node, port, mon_node);
 		if (lid == 0) {
 			OSM_LOG(pm->log, OSM_LOG_DEBUG, "WARN: node 0x%" PRIx64
@@ -521,8 +537,10 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
 			PRIx64 " port %d (lid %u) (%s)\n", node_guid, port,
 			cl_ntoh16(lid), node->print_desc);
-		status = perfmgr_send_pc_mad(pm, lid, remote_qp, port,
-					     IB_MAD_METHOD_GET, &mad_context);
+		status = perfmgr_send_pc_mad(pm, lid, remote_qp,
+					     mon_node->port[port].pkey_ix,
+					     port, IB_MAD_METHOD_GET,
+					     &mad_context);
 		if (status != IB_SUCCESS)
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C09: "
 				"Failed to issue port counter query for node 0x%"
@@ -769,6 +787,24 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	    pm->subn->sm_state == IB_SMINFO_STATE_NOTACTIVE)
 		perfmgr_discovery(pm->subn->p_osm);
 
+	/* if redirection enabled, determine local port */
+	if (pm->subn->opt.perfmgr_redir && pm->local_port == -1) {
+		osm_node_t *p_node;
+		osm_port_t *p_port;
+
+		CL_PLOCK_ACQUIRE(pm->sm->p_lock);
+		p_port = osm_get_port_by_guid(pm->subn, pm->port_guid);
+		if (p_port) {
+			p_node = p_port->p_node;
+			CL_ASSERT(p_node);
+			pm->local_port =
+			    ib_node_info_get_local_port_num(&p_node->node_info);
+		} else
+			OSM_LOG(pm->log, OSM_LOG_ERROR,
+				"ERR 4C87: No PerfMgr port object\n");
+		CL_PLOCK_RELEASE(pm->sm->p_lock);
+	}
+
 #if ENABLE_OSM_PERF_MGR_PROFILE
 	gettimeofday(&before, NULL);
 #endif
@@ -932,8 +968,8 @@ static int counter_overflow_32(ib_net32_t val)
  * MAD to the port.
  **********************************************************************/
 static void perfmgr_check_overflow(osm_perfmgr_t * pm,
-				   monitored_node_t * mon_node, uint8_t port,
-				   ib_port_counters_t * pc)
+				   monitored_node_t * mon_node, int16_t pkey_ix,
+				   uint8_t port, ib_port_counters_t * pc)
 {
 	osm_madw_context_t mad_context;
 	ib_api_status_t status;
@@ -960,6 +996,9 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 		osm_node_t *p_node = NULL;
 		ib_net16_t lid = 0;
 
+		if (!mon_node->port[port].valid)
+			goto Exit;
+
 		osm_log(pm->log, OSM_LOG_VERBOSE,
 			"PerfMgr: Counter overflow: %s (0x%" PRIx64
 			") port %d; clearing counters\n",
@@ -984,8 +1023,9 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 		mad_context.perfmgr_context.port = port;
 		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_SET;
 		/* clear port counters */
-		status = perfmgr_send_pc_mad(pm, lid, remote_qp, port,
-					     IB_MAD_METHOD_SET, &mad_context);
+		status = perfmgr_send_pc_mad(pm, lid, remote_qp, pkey_ix,
+					     port, IB_MAD_METHOD_SET,
+					     &mad_context);
 		if (status != IB_SUCCESS)
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C11: "
 				"Failed to send clear counters MAD for %s (0x%"
@@ -1043,6 +1083,64 @@ static void perfmgr_log_events(osm_perfmgr_t * pm,
 			time_diff, mon_node->name, mon_node->guid, port);
 }
 
+static int16_t validate_redir_pkey(osm_perfmgr_t *pm, ib_net16_t pkey)
+{
+	int16_t pkey_ix = -1;
+	osm_port_t *p_port;
+	osm_pkey_tbl_t *p_pkey_tbl;
+	ib_net16_t *p_orig_pkey;
+	uint16_t block;
+	uint8_t index;
+
+	OSM_LOG_ENTER(pm->log);
+
+	CL_PLOCK_ACQUIRE(pm->sm->p_lock);
+	p_port = osm_get_port_by_guid(pm->subn, pm->port_guid);
+	if (!p_port) {
+		CL_PLOCK_RELEASE(pm->sm->p_lock);		
+		OSM_LOG(pm->log, OSM_LOG_ERROR,
+			"ERR 4C1E: No PerfMgr port object\n");
+		goto Exit;
+	}
+	if (p_port->p_physp && osm_physp_is_valid(p_port->p_physp)) {
+		p_pkey_tbl = &p_port->p_physp->pkeys;
+		if (!p_pkey_tbl) {
+			CL_PLOCK_RELEASE(pm->sm->p_lock);
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+				"No PKey table found for PerfMgr port\n");
+			goto Exit;
+		}
+		p_orig_pkey = cl_map_get(&p_pkey_tbl->keys,
+					 ib_pkey_get_base(pkey));
+		if (!p_orig_pkey) {
+			CL_PLOCK_RELEASE(pm->sm->p_lock);
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+				"PKey 0x%x not found for PerfMgr port\n",
+				cl_ntoh16(pkey));
+			goto Exit;
+		}
+		if (osm_pkey_tbl_get_block_and_idx(p_pkey_tbl, p_orig_pkey,
+						   &block, &index) == IB_SUCCESS) {
+			CL_PLOCK_RELEASE(pm->sm->p_lock);
+			pkey_ix = block * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + index;
+		} else {
+			CL_PLOCK_RELEASE(pm->sm->p_lock);
+			OSM_LOG(pm->log, OSM_LOG_ERROR, 
+				"ERR 0x4C1F: Failed to obtain P_Key 0x%04x "
+				"block and index for PerfMgr port\n",
+				cl_ntoh16(pkey));
+		}
+	} else {
+		CL_PLOCK_RELEASE(pm->sm->p_lock);
+		OSM_LOG(pm->log, OSM_LOG_ERROR,
+			"ERR 4C20: Local PerfMgt port physp invalid\n");
+	}
+
+Exit:
+	OSM_LOG_EXIT(pm->log);
+	return pkey_ix;
+}
+
 /**********************************************************************
  * The dispatcher uses a thread pool which will call this function when
  * there is a thread available to process the mad received on the wire.
@@ -1061,6 +1159,8 @@ static void pc_recv_process(void *context, void *data)
 	perfmgr_db_data_cnt_reading_t data_reading;
 	cl_map_item_t *p_node;
 	monitored_node_t *p_mon_node;
+	int16_t pkey_ix = 0;
+	boolean_t valid = TRUE;
 
 	OSM_LOG_ENTER(pm->log);
 
@@ -1084,7 +1184,8 @@ static void pc_recv_process(void *context, void *data)
 		  p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO);
 
 	/* Response could also be redirection (IBM eHCA PMA does this) */
-	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
+	if (p_mad->status & IB_MAD_STATUS_REDIRECT &&
+	    p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
 		char gid_str[INET6_ADDRSTRLEN];
 		ib_class_port_info_t *cpi =
 		    (ib_class_port_info_t *) &
@@ -1097,17 +1198,46 @@ static void pc_recv_process(void *context, void *data)
 			inet_ntop(AF_INET6, cpi->redir_gid.raw, gid_str,
 				  sizeof gid_str), cl_ntoh32(cpi->redir_qp));
 
-		/* LID or GID redirection ? */
-		/* For GID redirection, need to get PathRecord from SA */
+		if (!pm->subn->opt.perfmgr_redir) {
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+				"Redirection requested but disabled\n");
+			valid = FALSE;
+		}
+
+		/* valid redirection ? */
 		if (cpi->redir_lid == 0) {
+			if (!ib_gid_is_notzero(&cpi->redir_gid)) {
+				OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+					"Invalid redirection "
+					"(both redirect LID and GID are zero)\n");
+				valid = FALSE;
+			}
+		}
+		if (cpi->redir_qp == 0) {
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQP\n");
+			valid = FALSE;
+		}
+		if (cpi->redir_pkey == 0) {
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectP_Key\n");
+			valid = FALSE;
+		}
+		if (cpi->redir_qkey != IB_QP1_WELL_KNOWN_Q_KEY) {
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQ_Key\n");
+			valid = FALSE;
+		}
+
+		pkey_ix = validate_redir_pkey(pm, cpi->redir_pkey);
+		if (pkey_ix == -1) {
 			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-				"GID redirection not currently implemented!\n");
-			goto Exit;
+				"Index for Pkey 0x%x not found\n",
+				cl_ntoh16(cpi->redir_pkey));
+			valid = FALSE;
 		}
 
-		if (!pm->subn->opt.perfmgr_redir) {
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C16: "
-				"redirection requested but disabled\n");
+		if (cpi->redir_lid == 0) {
+			/* GID redirection: get PathRecord information */
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+				"GID redirection not currently supported\n");
 			goto Exit;
 		}
 
@@ -1122,13 +1252,24 @@ static void pc_recv_process(void *context, void *data)
 				p_mon_node->num_ports);
 			goto Exit;
 		}
-		p_mon_node->redir_port[port].redir_lid = cpi->redir_lid;
-		p_mon_node->redir_port[port].redir_qp = cpi->redir_qp;
+		p_mon_node->port[port].redirection = TRUE;
+		p_mon_node->port[port].valid = valid;
+		memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
+		       sizeof(ib_gid_t));
+		p_mon_node->port[port].lid = cpi->redir_lid;
+		p_mon_node->port[port].qp = cpi->redir_qp;
+		p_mon_node->port[port].pkey = cpi->redir_pkey;
+		if (pkey_ix != -1)
+			p_mon_node->port[port].pkey_ix = pkey_ix;
 		cl_plock_release(&pm->osm->lock);
 
+		if (!valid)
+			goto Exit;
+
 		/* Finally, reissue the query to the redirected location */
 		status = perfmgr_send_pc_mad(pm, cpi->redir_lid, cpi->redir_qp,
-					     port, mad_context->perfmgr_context.
+					     pkey_ix, port,
+					     mad_context->perfmgr_context.
 					     mad_method, mad_context);
 		if (status != IB_SUCCESS)
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C14: "
@@ -1163,7 +1304,7 @@ static void pc_recv_process(void *context, void *data)
 		perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
 	}
 
-	perfmgr_check_overflow(pm, p_mon_node, port, wire_read);
+	perfmgr_check_overflow(pm, p_mon_node, pkey_ix, port, wire_read);
 
 #if ENABLE_OSM_PERF_MGR_PROFILE
 	do {
@@ -1208,6 +1349,7 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 	pm->sweep_time_s = p_opt->perfmgr_sweep_time_s;
 	pm->max_outstanding_queries = p_opt->perfmgr_max_outstanding_queries;
 	pm->osm = osm;
+	pm->local_port = -1;
 
 	status = cl_timer_init(&pm->sweep_timer, perfmgr_sweep, pm);
 	if (status != IB_SUCCESS)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
