From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 06/06] opensm/perfmgr: fix access to shared sweep_state
 variable
Date: Thu, 21 Feb 2013 13:33:55 -0800
Message-ID: <20130221133355.158ee182f61e6f0c55683328@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h |    1 +
 opensm/osm_perfmgr.c         |   23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 3fa42d5..947a3db 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -137,6 +137,7 @@ typedef struct osm_perfmgr {
 	cl_disp_reg_handle_t pc_disp_h;
 	osm_perfmgr_state_t state;
 	osm_perfmgr_sweep_state_t sweep_state;
+	cl_spinlock_t lock;
 	uint16_t sweep_time_s;
 	perfmgr_db_t *db;
 	atomic32_t outstanding_queries;	/* this along with sig_query */
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index eb0c4f9..45ce219 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -433,11 +433,22 @@ static ib_api_status_t perfmgr_send_mad(osm_perfmgr_t *perfmgr,
 		cl_atomic_inc(&(perfmgr->outstanding_queries));
 		while (perfmgr->outstanding_queries >
 		       (int32_t)perfmgr->max_outstanding_queries) {
+			cl_spinlock_acquire(&perfmgr->lock);
 			perfmgr->sweep_state = PERFMGR_SWEEP_SUSPENDED;
+			cl_spinlock_release(&perfmgr->lock);
 			cl_event_wait_on(&perfmgr->sig_query, EVENT_NO_TIMEOUT,
 					 TRUE);
+
+			cl_spinlock_acquire(&perfmgr->lock);
+			if (perfmgr->sweep_state == PERFMGR_SWEEP_SUSPENDED) {
+				perfmgr->sweep_state = PERFMGR_SWEEP_ACTIVE;
+				cl_spinlock_release(&perfmgr->lock);
+			} else {
+				cl_spinlock_release(&perfmgr->lock);
+				OSM_LOG(perfmgr->log, OSM_LOG_ERROR, "ERR 54FF: "
+					"PM was NOT in Suspended state???\n");
+			}
 		}
-		perfmgr->sweep_state = PERFMGR_SWEEP_ACTIVE;
 	}
 	return (status);
 }
@@ -982,11 +993,15 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	if (pm->state != PERFMGR_STATE_ENABLED)
 		return;
 
+	cl_spinlock_acquire(&pm->lock);
 	if (pm->sweep_state == PERFMGR_SWEEP_ACTIVE ||
-	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED)
+	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED) {
+		cl_spinlock_release(&pm->lock);
 		return;
+	}
 
 	pm->sweep_state = PERFMGR_SWEEP_ACTIVE;
+	cl_spinlock_release(&pm->lock);
 
 	if (pm->subn->sm_state == IB_SMINFO_STATE_STANDBY ||
 	    pm->subn->sm_state == IB_SMINFO_STATE_NOTACTIVE)
@@ -1045,7 +1060,9 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	clear_mad_stats();
 #endif
 
+	cl_spinlock_acquire(&pm->lock);
 	pm->sweep_state = PERFMGR_SWEEP_SLEEP;
+	cl_spinlock_release(&pm->lock);
 }
 
 /**********************************************************************
@@ -1777,6 +1794,8 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 	pm->trans_id = PERFMGR_INITIAL_TID_VALUE;
 	pm->state =
 	    p_opt->perfmgr ? PERFMGR_STATE_ENABLED : PERFMGR_STATE_DISABLE;
+	pm->sweep_state = PERFMGR_SWEEP_SLEEP;
+	cl_spinlock_init(&pm->lock);
 	pm->sweep_time_s = p_opt->perfmgr_sweep_time_s;
 	pm->max_outstanding_queries = p_opt->perfmgr_max_outstanding_queries;
 	pm->ignore_cas = p_opt->perfmgr_ignore_cas;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
