From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_state_mgr.c: Clear first time sweep even after
 subnet error
Date: Mon, 10 Mar 2014 11:21:51 -0400
Message-ID: <531DD88F.3030802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date: Wed, 24 Nov 2010 11:18:44 +0200

Clear first time sweep even after subnet initialization error.
Wait sweep interval between heavy sweeps after subnet init error.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 1872f31..baeff05 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1156,6 +1156,10 @@ static void do_sweep(osm_sm_t * sm)
 	osm_remote_sm_t *p_remote_sm;
 	unsigned config_parsed = 0;
 
+	/* after subnet initialization error, run heavy sweep */
+	if (sm->p_subn->subnet_initialization_error)
+		sm->p_subn->force_heavy_sweep = TRUE;
+
 	if (sm->p_subn->force_heavy_sweep) {
 		if (osm_subn_rescan_conf_files(sm->p_subn) < 0)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 331A: "
@@ -1526,6 +1530,7 @@ repeat_discovery:
 
 	/* in any case we zero this flag */
 	sm->p_subn->coming_out_of_standby = FALSE;
+	sm->p_subn->first_time_master_sweep = FALSE;
 
 	/* If there were errors - then the subnet is not really up */
 	if (sm->p_subn->subnet_initialization_error == TRUE) {
@@ -1537,7 +1542,6 @@ repeat_discovery:
 		sm->p_subn->need_update = 0;
 		osm_dump_all(sm->p_subn->p_osm);
 		state_mgr_up_msg(sm);
-		sm->p_subn->first_time_master_sweep = FALSE;
 
 		if (OSM_LOG_IS_ACTIVE_V2(sm->p_log, OSM_LOG_VERBOSE) ||
 		    sm->p_subn->opt.sa_db_dump)
@@ -1554,8 +1558,7 @@ repeat_discovery:
 
 	/* if we got a signal to force heavy sweep or errors
 	 * in the middle of the sweep - try another sweep. */
-	if (sm->p_subn->force_heavy_sweep
-	    || sm->p_subn->subnet_initialization_error)
+	if (sm->p_subn->force_heavy_sweep)
 		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 
 	/* Write a new copy of our persistent guid2mkey database */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
