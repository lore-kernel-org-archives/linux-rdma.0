From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] PerfMgr: Eliminate no longer used sig_sweep variable
Date: Wed, 28 May 2014 16:01:07 -0400
Message-ID: <53864083.2060305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


sig_sweep was mostly neutered back in 2007.

Code in osm_perfmgr.c:osm_perfmgr_process is problematic
if max_outstanding_queries is exceeded as nothing signals
sig_sweep event anymore. Remove this as this code is no
longer needed.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 93e57a6..ab02c26 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -125,7 +125,6 @@ struct osm_opensm;
 *  be manipulated only through the provided functions.
 */
 typedef struct osm_perfmgr {
-	cl_event_t sig_sweep;
 	cl_timer_t sweep_timer;
 	struct osm_opensm *osm;
 	osm_subn_t *subn;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 2db9585..1c0ed46 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1071,10 +1071,6 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	remove_marked_nodes(pm);
 
 #ifdef ENABLE_OSM_PERF_MGR_PROFILE
-	/* spin on outstanding queries */
-	while (pm->outstanding_queries > 0)
-		cl_event_wait_on(&pm->sig_sweep, 1000, TRUE);
-
 	gettimeofday(&after, NULL);
 	diff_time(&before, &after, &after);
 	osm_log_v2(pm->log, OSM_LOG_INFO, FILE_ID,
@@ -1876,8 +1872,6 @@ ib_api_status_t osm_perfmgr_init(osm_perfmgr_t * pm, osm_opensm_t * osm,
 
 	memset(pm, 0, sizeof(*pm));
 
-	cl_event_construct(&pm->sig_sweep);
-	cl_event_init(&pm->sig_sweep, FALSE);
 	pm->subn = &osm->subn;
 	pm->sm = &osm->sm;
 	pm->log = &osm->log;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
