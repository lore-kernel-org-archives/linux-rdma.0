From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V4 02/07] opensm/perfmgr: clean up: break out redirect
 processing from pc_recv_process
Date: Thu, 28 Feb 2013 17:05:26 -0800
Message-ID: <20130228170526.97fbdd98d3dd8dd747dd5673@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Changes from V1:
	Cleaned up processing when CPI redirect is invalid

Changes from V2:
	cpi_valid should not be set to false when redirect is invalid
	If CPI is a redirection only set cpi_valid if the redirection was valid
		(Also set cpi_valid on all ports for a switch)

Changes from V3:
	Reissue original query on redirect if query_cpi is not enabled

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |  240 ++++++++++++++++++++++++-------------------------
 1 files changed, 118 insertions(+), 122 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index b19933e..b507408 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1266,6 +1266,112 @@ Exit:
 	return pkey_ix;
 }
 
+static boolean_t handle_redirect(osm_perfmgr_t *pm,
+			    ib_class_port_info_t *cpi,
+			    monitored_node_t *p_mon_node,
+			    uint8_t port,
+			    osm_madw_context_t *mad_context)
+{
+	char gid_str[INET6_ADDRSTRLEN];
+	ib_api_status_t status;
+	boolean_t valid = TRUE;
+	int16_t pkey_ix = 0;
+	uint8_t mad_method;
+
+	OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+		"Redirection to LID %u GID %s QP 0x%x received\n",
+		cl_ntoh16(cpi->redir_lid),
+		inet_ntop(AF_INET6, cpi->redir_gid.raw, gid_str,
+			  sizeof gid_str), cl_ntoh32(cpi->redir_qp));
+
+	if (!pm->subn->opt.perfmgr_redir) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+			"Redirection requested but disabled\n");
+		valid = FALSE;
+	}
+
+	/* valid redirection ? */
+	if (cpi->redir_lid == 0) {
+		if (!ib_gid_is_notzero(&cpi->redir_gid)) {
+			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+				"Invalid redirection "
+				"(both redirect LID and GID are zero)\n");
+			valid = FALSE;
+		}
+	}
+	if (cpi->redir_qp == 0) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQP\n");
+		valid = FALSE;
+	}
+	if (cpi->redir_pkey == 0) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectP_Key\n");
+		valid = FALSE;
+	}
+	if (cpi->redir_qkey != IB_QP1_WELL_KNOWN_Q_KEY) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQ_Key\n");
+		valid = FALSE;
+	}
+
+	pkey_ix = validate_redir_pkey(pm, cpi->redir_pkey);
+	if (pkey_ix == -1) {
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+			"Index for Pkey 0x%x not found\n",
+			cl_ntoh16(cpi->redir_pkey));
+		valid = FALSE;
+	}
+
+	if (cpi->redir_lid == 0) {
+		/* GID redirection: get PathRecord information */
+		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
+			"GID redirection not currently supported\n");
+		goto Exit;
+	}
+
+	if (!valid)
+		goto Exit;
+
+	/* LID redirection support (easier than GID redirection) */
+	cl_plock_acquire(&pm->osm->lock);
+	p_mon_node->port[port].redirection = TRUE;
+	p_mon_node->port[port].valid = valid;
+	memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
+	       sizeof(ib_gid_t));
+	p_mon_node->port[port].lid = cpi->redir_lid;
+	p_mon_node->port[port].qp = cpi->redir_qp;
+	p_mon_node->port[port].pkey = cpi->redir_pkey;
+	if (pkey_ix != -1)
+		p_mon_node->port[port].pkey_ix = pkey_ix;
+	cl_plock_release(&pm->osm->lock);
+
+	/* either */
+	if (pm->query_cpi)
+	{
+		/* issue a CPI query to the redirected location */
+		mad_method = IB_MAD_METHOD_GET;
+		p_mon_node->port[port].cpi_valid = FALSE;
+		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
+						cpi->redir_qp, pkey_ix,
+						port, mad_context,
+						0); /* FIXME SL != 0 */
+	} else {
+		/* reissue the original query to the redirected location */
+		mad_method = mad_context->perfmgr_context.mad_method;
+		status = perfmgr_send_pc_mad(pm, cpi->redir_lid, cpi->redir_qp,
+						pkey_ix, port,
+						mad_method,
+						mad_context,
+						0); /* FIXME SL != 0 */
+	}
+	if (status != IB_SUCCESS)
+		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
+			"Failed to send redirected MAD "
+			"with method 0x%x for node %s "
+			"(NodeGuid 0x%" PRIx64 ") port %d\n",
+			mad_method, p_mon_node->name, p_mon_node->guid, port);
+Exit:
+	return (valid);
+}
+
 /**********************************************************************
  * The dispatcher uses a thread pool which will call this function when
  * there is a thread available to process the mad received on the wire.
@@ -1284,8 +1390,6 @@ static void pc_recv_process(void *context, void *data)
 	perfmgr_db_data_cnt_reading_t data_reading;
 	cl_map_item_t *p_node;
 	monitored_node_t *p_mon_node;
-	int16_t pkey_ix = 0;
-	boolean_t valid = TRUE;
 	ib_class_port_info_t *cpi = NULL;
 
 	OSM_LOG_ENTER(pm->log);
@@ -1323,10 +1427,17 @@ static void pc_recv_process(void *context, void *data)
 
 	/* capture CLASS_PORT_INFO data */
 	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
+		boolean_t cpi_valid = TRUE;
+
 		cpi = (ib_class_port_info_t *) &
 		    (osm_madw_get_perfmgt_mad_ptr(p_madw)->data);
 
-		if (pm->query_cpi) {
+		/* Response could be redirection (IBM eHCA PMA does this) */
+		if (p_mad->status & IB_MAD_STATUS_REDIRECT)
+			cpi_valid = handle_redirect(pm, cpi, p_mon_node, port,
+							mad_context);
+
+		if (pm->query_cpi && cpi_valid) {
 			cl_plock_acquire(&pm->osm->lock);
 			if (p_mon_node->node_type == IB_NODE_TYPE_SWITCH) {
 				int i = 0;
@@ -1334,133 +1445,17 @@ static void pc_recv_process(void *context, void *data)
 				     i < p_mon_node->num_ports;
 				     i++) {
 					p_mon_node->port[i].cap_mask = cpi->cap_mask;
-					p_mon_node->port[i].cpi_valid = TRUE;
+					p_mon_node->port[i].cpi_valid = cpi_valid;
 				}
 			} else {
 				p_mon_node->port[port].cap_mask = cpi->cap_mask;
-				p_mon_node->port[port].cpi_valid = TRUE;
-			}
-			cl_plock_release(&pm->osm->lock);
-		}
-	}
-
-	/* Response could also be redirection (IBM eHCA PMA does this) */
-	if (p_mad->status & IB_MAD_STATUS_REDIRECT) {
-		char gid_str[INET6_ADDRSTRLEN];
-		ib_api_status_t status;
-		uint8_t mad_method;
-
-		CL_ASSERT(cpi); /* Redirect should have returned CPI
-					(processed in previous block) */
-
-		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-			"Redirection to LID %u GID %s QP 0x%x received\n",
-			cl_ntoh16(cpi->redir_lid),
-			inet_ntop(AF_INET6, cpi->redir_gid.raw, gid_str,
-				  sizeof gid_str), cl_ntoh32(cpi->redir_qp));
-
-		if (!pm->subn->opt.perfmgr_redir) {
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-				"Redirection requested but disabled\n");
-			valid = FALSE;
-		}
-
-		/* valid redirection ? */
-		if (cpi->redir_lid == 0) {
-			if (!ib_gid_is_notzero(&cpi->redir_gid)) {
-				OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-					"Invalid redirection "
-					"(both redirect LID and GID are zero)\n");
-				valid = FALSE;
+				p_mon_node->port[port].cpi_valid = cpi_valid;
 			}
-		}
-		if (cpi->redir_qp == 0) {
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQP\n");
-			valid = FALSE;
-		}
-		if (cpi->redir_pkey == 0) {
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectP_Key\n");
-			valid = FALSE;
-		}
-		if (cpi->redir_qkey != IB_QP1_WELL_KNOWN_Q_KEY) {
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQ_Key\n");
-			valid = FALSE;
-		}
-
-		pkey_ix = validate_redir_pkey(pm, cpi->redir_pkey);
-		if (pkey_ix == -1) {
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-				"Index for Pkey 0x%x not found\n",
-				cl_ntoh16(cpi->redir_pkey));
-			valid = FALSE;
-		}
-
-		if (cpi->redir_lid == 0) {
-			/* GID redirection: get PathRecord information */
-			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
-				"GID redirection not currently supported\n");
-			goto Exit;
-		}
-
-		/* LID redirection support (easier than GID redirection) */
-		cl_plock_acquire(&pm->osm->lock);
-		/* Now, validate port number */
-		if (port >= p_mon_node->num_ports) {
 			cl_plock_release(&pm->osm->lock);
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5413: "
-				"Invalid port num %d for GUID 0x%016"
-				PRIx64 " num ports %d\n", port, node_guid,
-				p_mon_node->num_ports);
-			goto Exit;
 		}
-		p_mon_node->port[port].redirection = TRUE;
-		p_mon_node->port[port].valid = valid;
-		memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
-		       sizeof(ib_gid_t));
-		p_mon_node->port[port].lid = cpi->redir_lid;
-		p_mon_node->port[port].qp = cpi->redir_qp;
-		p_mon_node->port[port].pkey = cpi->redir_pkey;
-		if (pkey_ix != -1)
-			p_mon_node->port[port].pkey_ix = pkey_ix;
-		cl_plock_release(&pm->osm->lock);
-
-		if (!valid)
-			goto Exit;
-
-		/* either */
-		if (pm->query_cpi)
-		{
-			/* issue a CPI query to the redirected location */
-			mad_method = IB_MAD_METHOD_GET;
-			p_mon_node->port[port].cpi_valid = FALSE;
-			status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
-							cpi->redir_qp, pkey_ix,
-							port, mad_context,
-							0); /* FIXME SL != 0 */
-		} else {
-			/* reissue the original query to the redirected location */
-			mad_method = mad_context->perfmgr_context.mad_method,
-			status = perfmgr_send_pc_mad(pm, cpi->redir_lid, cpi->redir_qp,
-							pkey_ix, port,
-							mad_method,
-							mad_context,
-							0); /* FIXME SL != 0 */
-		}
-		if (status != IB_SUCCESS)
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
-				"Failed to send redirected MAD "
-				"with method 0x%x for node %s "
-				"(NodeGuid 0x%" PRIx64 ") port %d\n",
-				mad_method, p_mon_node->name, node_guid, port);
 		goto Exit;
 	}
 
-	/* ClassPortInfo needed to process optional Redirection
-	 * now exit normally
-	 */
-	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO)
-		goto Exit;
-
 	perfmgr_db_fill_err_read(wire_read, &err_reading);
 	/* FIXME separate query for extended counters if they are supported
 	 * on the port.
@@ -1486,7 +1481,8 @@ static void pc_recv_process(void *context, void *data)
 		perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
 	}
 
-	perfmgr_check_overflow(pm, p_mon_node, pkey_ix, port, wire_read);
+	perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
+			       port, wire_read);
 
 #ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	do {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
