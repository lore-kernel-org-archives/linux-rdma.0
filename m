From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 2/5] osm_state_mgr.c: Remove new_lft buffers cleanup
Date: Thu, 08 Jan 2015 07:49:47 -0500
Message-ID: <54AE7CEB.6060404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Removed code that cleans switch->new_lft buffers after routing.
Change is required in order to enable OpenSM to use new_lft buffers for
SA queries and unicast routing dump files.

new_lft buffers are automatically reallocated (if needed) and set to
0xFF when calling ucast_mgr_process.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 1fda3f6..976a691 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1127,7 +1127,7 @@ Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static void cleanup_switch(cl_map_item_t * item, void *log)
+static void check_switch_lft(cl_map_item_t * item, void *log)
 {
 	osm_switch_t *sw = (osm_switch_t *) item;
 
@@ -1139,10 +1139,6 @@ static void cleanup_switch(cl_map_item_t * item, void *log)
 			   "LFT of switch 0x%016" PRIx64 " (%s) is not up to date\n",
 			   cl_ntoh64(sw->p_node->node_info.node_guid),
 			   sw->p_node->print_desc);
-	else {
-		free(sw->new_lft);
-		sw->new_lft = NULL;
-	}
 }
 
 int wait_for_pending_transactions(osm_stats_t * stats)
@@ -1490,9 +1486,6 @@ repeat_discovery:
 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
 
-	/* cleanup switch lft buffers */
-	cl_qmap_apply_func(&sm->p_subn->sw_guid_tbl, cleanup_switch, sm->p_log);
-
 	/* We are done setting all LFTs so clear the ignore existing.
 	 * From now on, as long as we are still master, we want to
 	 * take into account these lfts. */
@@ -1559,6 +1552,10 @@ repeat_discovery:
 	 */
 	state_mgr_report_new_ports(sm);
 
+	/* check switch lft buffers assignments */
+	cl_qmap_apply_func(&sm->p_subn->sw_guid_tbl, check_switch_lft,
+			   sm->p_log);
+
 	/* in any case we zero this flag */
 	sm->p_subn->coming_out_of_standby = FALSE;
 	sm->p_subn->first_time_master_sweep = FALSE;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
