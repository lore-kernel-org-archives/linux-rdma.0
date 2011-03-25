From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/4] opensm/perfmgr: clean up: break out redirect processing
 from pc_recv_process
Date: Thu, 24 Mar 2011 18:20:49 -0700
Message-ID: <20110324182049.184fffca.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 8 Mar 2011 13:54:17 -0800
Subject: [PATCH] opensm/perfmgr: clean up: break out redirect processing from pc_recv_process

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |  193 +++++++++++++++++++++++++------------------------
 1 files changed, 98 insertions(+), 95 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 87ddee8..31e61b1 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1237,6 +1237,95 @@ Exit:
 	return pkey_ix;
 }
 
+static void handle_redirect(osm_perfmgr_t *pm,
+			    ib_class_port_info_t *cpi,
+			    monitored_node_t *p_mon_node,
+			    uint8_t port,
+			    osm_madw_context_t *mad_context)
+{
+	char gid_str[INET6_ADDRSTRLEN];
+	ib_api_status_t status;
+	boolean_t valid = TRUE;
+	int16_t pkey_ix = 0;
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
+		return;
+	}
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
+	if (valid) {
+		/* Finally, issue a CPI query to the redirected location */
+		cl_plock_acquire(&pm->osm->lock);
+		p_mon_node->port[port].cpi_valid = FALSE;
+		cl_plock_release(&pm->osm->lock);
+		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
+					      cpi->redir_qp, pkey_ix,
+					      port, mad_context);
+		if (status != IB_SUCCESS)
+			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C14: "
+				"Failed to send redirected CPI MAD "
+				"for node %s (0x%" PRIx64 ") port %d\n",
+				p_mon_node->name, p_mon_node->guid, port);
+	}
+}
+
 /**********************************************************************
  * The dispatcher uses a thread pool which will call this function when
  * there is a thread available to process the mad received on the wire.
@@ -1255,8 +1344,6 @@ static void pc_recv_process(void *context, void *data)
 	perfmgr_db_data_cnt_reading_t data_reading;
 	cl_map_item_t *p_node;
 	monitored_node_t *p_mon_node;
-	int16_t pkey_ix = 0;
-	boolean_t valid = TRUE;
 	ib_class_port_info_t *cpi = NULL;
 
 	OSM_LOG_ENTER(pm->log);
@@ -1308,114 +1395,29 @@ static void pc_recv_process(void *context, void *data)
 			p_mon_node->port[port].cpi_valid = TRUE;
 		}
 		cl_plock_release(&pm->osm->lock);
-	}
-
-	/* Response could also be redirection (IBM eHCA PMA does this) */
-	if (p_mad->status & IB_MAD_STATUS_REDIRECT) {
-		char gid_str[INET6_ADDRSTRLEN];
-		ib_api_status_t status;
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
-			}
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
 
-		if (!valid)
-			goto Exit;
+		/* Response could also be redirection (IBM eHCA PMA does this) */
+		if (p_mad->status & IB_MAD_STATUS_REDIRECT)
+			handle_redirect(pm, cpi, p_mon_node, port,
+					mad_context);
 
-		/* Finally, issue a CPI query to the redirected location */
-		p_mon_node->port[port].cpi_valid = FALSE;
-		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
-					      cpi->redir_qp, pkey_ix,
-					      port, mad_context);
-		if (status != IB_SUCCESS)
-			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C14: "
-				"Failed to send redirected CPI MAD "
-				"for node %s (0x%" PRIx64 ") port %d\n",
-				p_mon_node->name, node_guid, port);
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
 	 */
 	perfmgr_db_fill_data_cnt_read_pc(wire_read, &data_reading);
 
+	/* log any critical events from this reading */
+	perfmgr_log_events(pm, p_mon_node, port, &err_reading);
+
 	/* detect an out of band clear on the port */
 	if (mad_context->perfmgr_context.mad_method != IB_MAD_METHOD_SET)
 		perfmgr_check_oob_clear(pm, p_mon_node, port, &err_reading,
 					&data_reading);
 
-	/* log any critical events from this reading */
-	perfmgr_log_events(pm, p_mon_node, port, &err_reading);
-
 	if (mad_context->perfmgr_context.mad_method == IB_MAD_METHOD_GET) {
 		perfmgr_db_add_err_reading(pm->db, node_guid, port,
 					   &err_reading);
@@ -1426,7 +1428,8 @@ static void pc_recv_process(void *context, void *data)
 		perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
 	}
 
-	perfmgr_check_overflow(pm, p_mon_node, pkey_ix, port, wire_read);
+	perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
+			       port, wire_read);
 
 #if ENABLE_OSM_PERF_MGR_PROFILE
 	do {
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
