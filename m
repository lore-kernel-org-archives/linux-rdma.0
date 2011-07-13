From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: perfmgr only run sweep timer when enabled.
Date: Tue, 12 Jul 2011 18:09:31 -0700
Message-ID: <20110712180931.671ce7c5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h |    7 +++++--
 opensm/osm_perfmgr.c         |    6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 34925e8..67c0ce4 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -167,8 +167,11 @@ inline static void osm_perfmgr_set_state(osm_perfmgr_t * p_perfmgr,
 					 osm_perfmgr_state_t state)
 {
 	p_perfmgr->state = state;
-	if (state == PERFMGR_STATE_ENABLED)
-		osm_sm_signal(p_perfmgr->sm, OSM_SIGNAL_PERFMGR_SWEEP);
+	if (state == PERFMGR_STATE_ENABLED) {
+		cl_timer_start(&p_perfmgr->sweep_timer, p_perfmgr->sweep_time_s * 1000);
+	} else {
+		cl_timer_stop(&p_perfmgr->sweep_timer);
+	}
 }
 
 inline static osm_perfmgr_state_t osm_perfmgr_get_state(osm_perfmgr_t * perfmgr)
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index cb1329e..ded5a5e 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -860,8 +860,7 @@ static void perfmgr_sweep(void *arg)
 {
 	osm_perfmgr_t *pm = arg;
 
-	if (pm->state == PERFMGR_STATE_ENABLED)
-		osm_sm_signal(pm->sm, OSM_SIGNAL_PERFMGR_SWEEP);
+	osm_sm_signal(pm->sm, OSM_SIGNAL_PERFMGR_SWEEP);
 	cl_timer_start(&pm->sweep_timer, pm->sweep_time_s * 1000);
 }
 
@@ -1380,7 +1379,8 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 
 	init_monitored_nodes(pm);
 
-	cl_timer_start(&pm->sweep_timer, pm->sweep_time_s * 1000);
+	if (pm->state == PERFMGR_STATE_ENABLED)
+		cl_timer_start(&pm->sweep_timer, pm->sweep_time_s * 1000);
 
 	status = IB_SUCCESS;
 Exit:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
