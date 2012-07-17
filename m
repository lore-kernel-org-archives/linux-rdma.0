From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr/console: add 'pm sweep'
Date: Tue, 17 Jul 2012 11:50:41 -0700
Message-ID: <20120717115041.5c196342cc2ce83cf1bbb8d7@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

NOTE: The following applies after previous Performance Manager patches posted to the list.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |    8 +++++++-
 opensm/osm_perfmgr.c |    7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 789092f..261cea4 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -242,13 +242,16 @@ static void help_perfmgr(FILE * out, int detail)
 		"perfmgr(pm) [enable|disable\n"
 		"             |clear_counters|dump_counters|print_counters(pc)|print_errors(pe)\n"
 		"             |set_rm_nodes|clear_rm_nodes|clear_inactive\n"
-		"             |dump_redir|clear_redir|sweep_time[seconds]]\n");
+		"             |dump_redir|clear_redir\n"
+		"             |sweep|sweep_time[seconds]]\n");
 	if (detail) {
 		fprintf(out,
 			"perfmgr -- print the performance manager state\n");
 		fprintf(out,
 			"   [enable|disable] -- change the perfmgr state\n");
 		fprintf(out,
+			"   [sweep] -- Initiate a sweep of the fabric\n");
+		fprintf(out,
 			"   [sweep_time] -- change the perfmgr sweep time (requires [seconds] option)\n");
 		fprintf(out,
 			"   [clear_counters] -- clear the counters stored\n");
@@ -1523,6 +1526,9 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 					"sweep_time requires a time period "
 					"(in seconds) to be specified\n");
 			}
+		} else if (strcmp(p_cmd, "sweep") == 0) {
+			osm_sm_signal(&p_osm->sm, OSM_SIGNAL_PERFMGR_SWEEP);
+			fprintf(out, "sweep initiated...\n");
 		} else {
 			fprintf(out, "\"%s\" option not found\n", p_cmd);
 		}
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 3b36ef6..4b9b2a0 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -802,6 +802,12 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	if (pm->state != PERFMGR_STATE_ENABLED)
 		return;
 
+	if (pm->sweep_state == PERFMGR_SWEEP_ACTIVE ||
+	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED)
+		return;
+
+	pm->sweep_state = PERFMGR_SWEEP_ACTIVE;
+
 	if (pm->subn->sm_state == IB_SMINFO_STATE_STANDBY ||
 	    pm->subn->sm_state == IB_SMINFO_STATE_NOTACTIVE)
 		perfmgr_discovery(pm->subn->p_osm);
@@ -827,7 +833,6 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 #if ENABLE_OSM_PERF_MGR_PROFILE
 	gettimeofday(&before, NULL);
 #endif
-	pm->sweep_state = PERFMGR_SWEEP_ACTIVE;
 	/* With the global lock held, collect the node guids */
 	/* FIXME we should be able to track SA notices
 	 * and not have to sweep the node_guid_tbl each pass
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
