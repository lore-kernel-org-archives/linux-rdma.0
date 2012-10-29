From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] opensm: Fix signed vs unsigned int comparison
Date: Mon, 29 Oct 2012 16:44:59 -0700
Message-ID: <1351554299.25353.20.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_congestion_control.c |    2 +-
 opensm/osm_perfmgr.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 7f1c8fa..b5d9cdb 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -526,7 +526,7 @@ static void cc_poller_send(osm_congestion_control_t *p_cc,
 	if (status == IB_SUCCESS) {
 		cl_atomic_inc(&p_cc->outstanding_mads_on_wire);
 		if (p_cc->outstanding_mads_on_wire >
-		    p_opt->cc_max_outstanding_mads)
+		    (int32_t)p_opt->cc_max_outstanding_mads)
 			cl_event_wait_on(&p_cc->sig_mads_on_wire_continue,
 					 EVENT_NO_TIMEOUT,
 					 TRUE);
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index ee2392c..98b4c07 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -420,7 +420,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 		/* pause thread if there are too many outstanding requests */
 		cl_atomic_inc(&(perfmgr->outstanding_queries));
 		if (perfmgr->outstanding_queries >
-		    perfmgr->max_outstanding_queries) {
+		    (int32_t)perfmgr->max_outstanding_queries) {
 			perfmgr->sweep_state = PERFMGR_SWEEP_SUSPENDED;
 			cl_event_wait_on(&perfmgr->sig_query, EVENT_NO_TIMEOUT,
 					 TRUE);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
