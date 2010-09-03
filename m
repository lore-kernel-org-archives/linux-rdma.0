From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 18/18] opensm: Cause status of unicast routing
 attempt to propogate to callers of osm_ucast_mgr_process().
Date: Fri,  3 Sep 2010 10:43:14 -0600
Message-ID: <1283532194-27112-19-git-send-email-jaschut@sandia.gov>
References: <1283532194-27112-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283532194-27112-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If unicast routing fails, there is no point to continuing with fabric bring-up.
Just restart a new heavy sweep instead.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_state_mgr.c |   12 +++++++++---
 opensm/opensm/osm_ucast_mgr.c |   14 +++++++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index bb60636..1befbfe 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1142,7 +1142,11 @@ static void do_sweep(osm_sm_t * sm)
 		/* Re-program the switches fully */
 		sm->p_subn->ignore_existing_lfts = TRUE;
 
-		osm_ucast_mgr_process(&sm->ucast_mgr);
+		if (osm_ucast_mgr_process(&sm->ucast_mgr)) {
+			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
+					"REROUTE FAILED");
+			return;
+		}
 		osm_qos_setup(sm->p_subn->p_osm);
 
 		/* Reset flag */
@@ -1313,12 +1317,14 @@ repeat_discovery:
 			"LID ASSIGNMENT COMPLETE - STARTING SWITCH TABLE CONFIG");
 
 	/*
-	 * Proceed with unicast forwarding table configuration.
+	 * Proceed with unicast forwarding table configuration; if it fails
+	 * return early to wait for a trap or the next sweep interval.
 	 */
 
 	if (!sm->ucast_mgr.cache_valid ||
 	    osm_ucast_cache_process(&sm->ucast_mgr))
-		osm_ucast_mgr_process(&sm->ucast_mgr);
+		if (osm_ucast_mgr_process(&sm->ucast_mgr))
+			return;
 
 	osm_qos_setup(sm->p_subn->p_osm);
 
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index f5a715f..85495eb 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -1069,6 +1069,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	osm_opensm_t *p_osm;
 	struct osm_routing_engine *p_routing_eng;
 	cl_qmap_t *p_sw_guid_tbl;
+	int failed = 0;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
@@ -1087,7 +1088,8 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 
 	p_osm->routing_engine_used = NULL;
 	while (p_routing_eng) {
-		if (!ucast_mgr_route(p_routing_eng, p_osm))
+		failed = ucast_mgr_route(p_routing_eng, p_osm);
+		if (!failed)
 			break;
 		p_routing_eng = p_routing_eng->next;
 	}
@@ -1098,9 +1100,11 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 		struct osm_routing_engine *r = p_osm->default_routing_engine;
 
 		r->build_lid_matrices(r->context);
-		r->ucast_build_fwd_tables(r->context);
-		p_osm->routing_engine_used = r;
-		osm_ucast_mgr_set_fwd_tables(p_mgr);
+		failed = r->ucast_build_fwd_tables(r->context);
+		if (!failed) {
+			p_osm->routing_engine_used = r;
+			osm_ucast_mgr_set_fwd_tables(p_mgr);
+		}
 	}
 
 	if (p_osm->routing_engine_used) {
@@ -1120,7 +1124,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 Exit:
 	CL_PLOCK_RELEASE(p_mgr->p_lock);
 	OSM_LOG_EXIT(p_mgr->p_log);
-	return 0;
+	return failed;
 }
 
 static int ucast_build_lid_matrices(void *context)
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
