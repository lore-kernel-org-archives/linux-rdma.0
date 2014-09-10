From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_state_mgr.c: Avoid ucast cache invalidation due
 to errors during initialization
Date: Wed, 10 Sep 2014 12:44:03 -0400
Message-ID: <54107FD3.5030801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 106159d..42d13bb 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1228,12 +1228,11 @@ static void do_sweep(osm_sm_t * sm)
 	}
 
 	/*
-	 * Unicast cache should be invalidated if there were errors
-	 * during initialization or if subnet re-route is requested.
+	 * Unicast cache should be invalidated when subnet re-route is
+	 * requested, and when OpenSM comes out of standby state.
 	 */
 	if (sm->p_subn->opt.use_ucast_cache &&
-	    (sm->p_subn->subnet_initialization_error ||
-	     sm->p_subn->force_reroute || sm->p_subn->coming_out_of_standby))
+	    (sm->p_subn->force_reroute || sm->p_subn->coming_out_of_standby))
 		osm_ucast_cache_invalidate(&sm->ucast_mgr);
 
 	/*
@@ -1458,9 +1457,12 @@ repeat_discovery:
 	 */
 
 	if (!sm->ucast_mgr.cache_valid ||
-	    osm_ucast_cache_process(&sm->ucast_mgr))
-		if (osm_ucast_mgr_process(&sm->ucast_mgr))
+	    osm_ucast_cache_process(&sm->ucast_mgr)) {
+		if (osm_ucast_mgr_process(&sm->ucast_mgr)) {
+			osm_ucast_cache_invalidate(&sm->ucast_mgr);
 			return;
+		}
+	}
 
 	osm_qos_setup(sm->p_subn->p_osm);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
