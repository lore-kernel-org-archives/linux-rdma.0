From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: configure multicast only once during sweep
Date: Thu, 6 Jan 2011 18:39:05 +0200
Message-ID: <4D25F029.1080005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[PATCH] configure multicast only once during sweep

opensm performed multicast configuration twice during sweep by calling
two different function that are very similar.
remove osm_mcast_mgr_process() which had a bug and didn't clear mlid bit
after configuration and rename osm_mcast_mgr_process_mgroups()
to osm_mcast_mgr_process()

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |   46 +----------------------------------------
 opensm/opensm/osm_state_mgr.c |    3 +-
 2 files changed, 2 insertions(+), 47 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index e42070d..9e15f2c 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1081,54 +1081,11 @@ static int alloc_mfts(osm_sm_t * sm)
 	return 0;
 }
 
-int osm_mcast_mgr_process(osm_sm_t * sm)
-{
-	int i, ret = 0;
-
-	OSM_LOG_ENTER(sm->p_log);
-
-	/* While holding the lock, iterate over all the established
-	   multicast groups, servicing each in turn.
-	   Then, download the multicast tables to the switches. */
-	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
-
-	/* If there are no switches in the subnet we have nothing to do. */
-	if (cl_qmap_count(&sm->p_subn->sw_guid_tbl) == 0) {
-		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
-			"No switches in subnet. Nothing to do\n");
-		goto exit;
-	}
-
-	if (alloc_mfts(sm)) {
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-			"ERR 0A07: alloc_mfts failed\n");
-		ret = -1;
-		goto exit;
-	}
-
-	for (i = 0; i <= sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
-	     i++)
-		if (sm->p_subn->mboxes[i] || sm->mlids_req[i])
-			mcast_mgr_process_mlid(sm, i + IB_LID_MCAST_START_HO);
-
-	memset(sm->mlids_req, 0, sm->mlids_req_max);
-	sm->mlids_req_max = 0;
-
-	ret = mcast_mgr_set_mftables(sm);
-
-exit:
-	CL_PLOCK_RELEASE(sm->p_lock);
-
-	OSM_LOG_EXIT(sm->p_log);
-
-	return ret;
-}
-
 /**********************************************************************
   This is the function that is invoked during idle time to handle the
   process request for mcast groups where join/leave/delete was required.
  **********************************************************************/
-int osm_mcast_mgr_process_mgroups(osm_sm_t * sm)
+int osm_mcast_mgr_process(osm_sm_t * sm)
 {
 	int ret = 0;
 	unsigned i;
@@ -1158,7 +1115,6 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * sm)
 		mcast_mgr_process_mlid(sm, i + IB_LID_MCAST_START_HO);
 	}
 
-	memset(sm->mlids_req, 0, sm->mlids_req_max);
 	sm->mlids_req_max = 0;
 
 	ret = mcast_mgr_set_mftables(sm);
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 68841f8..ff94cfe 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -69,7 +69,6 @@ extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
 extern int osm_pkey_mgr_process(IN osm_opensm_t * p_osm);
 extern int osm_mcast_mgr_process(IN osm_sm_t * sm);
-extern int osm_mcast_mgr_process_mgroups(IN osm_sm_t * sm);
 extern int osm_link_mgr_process(IN osm_sm_t * sm, IN uint8_t state);
 
 static void state_mgr_up_msg(IN const osm_sm_t * sm)
@@ -1415,7 +1414,7 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
 	if (sm->p_subn->sm_state != IB_SMINFO_STATE_MASTER)
 		return;
 	if (!sm->p_subn->opt.disable_multicast) {
-		osm_mcast_mgr_process_mgroups(sm);
+		osm_mcast_mgr_process(sm);
 		wait_for_pending_transactions(&sm->p_subn->p_osm->stats);
 	}
 }
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
