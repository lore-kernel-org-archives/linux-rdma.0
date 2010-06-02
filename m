From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/osm_perfmgr.c: Remove unnecessary lock reference
 from Performance Manager object
Date: Tue, 1 Jun 2010 18:37:14 -0700
Message-ID: <20100601183714.3de4e8c1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 22 Dec 2008 11:03:59 -0800
Subject: [PATCH] opensm/osm_perfmgr.c: Remove unnecessary lock reference from Performance Manager object


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/include/opensm/osm_perfmgr.h |    1 -
 opensm/opensm/osm_perfmgr.c         |   25 ++++++++++++-------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/opensm/include/opensm/osm_perfmgr.h b/opensm/include/opensm/osm_perfmgr.h
index 108b691..c26c141 100644
--- a/opensm/include/opensm/osm_perfmgr.h
+++ b/opensm/include/opensm/osm_perfmgr.h
@@ -119,7 +119,6 @@ typedef struct osm_perfmgr {
 	struct osm_opensm *osm;
 	osm_subn_t *subn;
 	osm_sm_t *sm;
-	cl_plock_t *lock;
 	osm_log_t *log;
 	osm_mad_pool_t *mad_pool;
 	atomic32_t trans_id;
diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr.c
index 1952d05..398b463 100644
--- a/opensm/opensm/osm_perfmgr.c
+++ b/opensm/opensm/osm_perfmgr.c
@@ -214,10 +214,10 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 
 	if (pm->subn->opt.perfmgr_redir && p_madw->status == IB_TIMEOUT) {
 		/* First, find the node in the monitored map */
-		cl_plock_acquire(pm->lock);
+		cl_plock_acquire(&pm->osm->lock);
 		/* Now, validate port number */
 		if (port >= p_mon_node->num_ports) {
-			cl_plock_release(pm->lock);
+			cl_plock_release(&pm->osm->lock);
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C16: "
 				"Invalid port num %u for %s (GUID 0x%016"
 				PRIx64 ") num ports %u\n", port,
@@ -228,7 +228,7 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 		/* Clear redirection info */
 		p_mon_node->redir_port[port].redir_lid = 0;
 		p_mon_node->redir_port[port].redir_qp = 0;
-		cl_plock_release(pm->lock);
+		cl_plock_release(&pm->osm->lock);
 	}
 
 Exit:
@@ -469,7 +469,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 
 	OSM_LOG_ENTER(pm->log);
 
-	cl_plock_acquire(pm->lock);
+	cl_plock_acquire(&pm->osm->lock);
 	node = osm_get_node_by_guid(pm->subn, cl_hton64(mon_node->guid));
 	if (!node) {
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
@@ -531,7 +531,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 				node->print_desc);
 	}
 Exit:
-	cl_plock_release(pm->lock);
+	cl_plock_release(&pm->osm->lock);
 	OSM_LOG_EXIT(pm->log);
 }
 
@@ -778,9 +778,9 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	 * and not have to sweep the node_guid_tbl each pass
 	 */
 	OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Gathering PerfMgr stats\n");
-	cl_plock_acquire(pm->lock);
+	cl_plock_acquire(&pm->osm->lock);
 	cl_qmap_apply_func(&pm->subn->node_guid_tbl, collect_guids, pm);
-	cl_plock_release(pm->lock);
+	cl_plock_release(&pm->osm->lock);
 
 	/* then for each node query their counters */
 	cl_qmap_apply_func(&pm->monitored_map, perfmgr_query_counters, pm);
@@ -965,11 +965,11 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
 			") port %d; clearing counters\n",
 			mon_node->name, mon_node->guid, port);
 
-		cl_plock_acquire(pm->lock);
+		cl_plock_acquire(&pm->osm->lock);
 		p_node =
 		    osm_get_node_by_guid(pm->subn, cl_hton64(mon_node->guid));
 		lid = get_lid(p_node, port, mon_node);
-		cl_plock_release(pm->lock);
+		cl_plock_release(&pm->osm->lock);
 		if (lid == 0) {
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 4C0C: "
 				"Failed to clear counters for %s (0x%"
@@ -1112,10 +1112,10 @@ static void pc_recv_process(void *context, void *data)
 		}
 
 		/* LID redirection support (easier than GID redirection) */
-		cl_plock_acquire(pm->lock);
+		cl_plock_acquire(&pm->osm->lock);
 		/* Now, validate port number */
 		if (port >= p_mon_node->num_ports) {
-			cl_plock_release(pm->lock);
+			cl_plock_release(&pm->osm->lock);
 			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C13: "
 				"Invalid port num %d for GUID 0x%016"
 				PRIx64 " num ports %d\n", port, node_guid,
@@ -1124,7 +1124,7 @@ static void pc_recv_process(void *context, void *data)
 		}
 		p_mon_node->redir_port[port].redir_lid = cpi->redir_lid;
 		p_mon_node->redir_port[port].redir_qp = cpi->redir_qp;
-		cl_plock_release(pm->lock);
+		cl_plock_release(&pm->osm->lock);
 
 		/* Finally, reissue the query to the redirected location */
 		status = perfmgr_send_pc_mad(pm, cpi->redir_lid, cpi->redir_qp,
@@ -1203,7 +1203,6 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 	pm->mad_pool = &osm->mad_pool;
 	pm->vendor = osm->p_vendor;
 	pm->trans_id = PERFMGR_INITIAL_TID_VALUE;
-	pm->lock = &osm->lock;
 	pm->state =
 	    p_opt->perfmgr ? PERFMGR_STATE_ENABLED : PERFMGR_STATE_DISABLE;
 	pm->sweep_time_s = p_opt->perfmgr_sweep_time_s;
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
