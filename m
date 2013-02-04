From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Changed #if to #ifdef when using ENABLE_OSM_PERF_MGR_PROFILE
Date: Mon,  4 Feb 2013 15:20:04 +0200
Message-ID: <1359984011-30753-3-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If some plugins include opensm/osm_madw.h, ENABLE_OSM_PERF_MGR_PROFILE
might be undefined and using #if will cause cause compilation error.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_madw.h |  2 +-
 opensm/osm_perfmgr.c      | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/opensm/osm_madw.h b/include/opensm/osm_madw.h
index afc3680..c450a1d 100644
--- a/include/opensm/osm_madw.h
+++ b/include/opensm/osm_madw.h
@@ -334,7 +334,7 @@ typedef struct osm_perfmgr_context {
 	uint64_t node_guid;
 	uint16_t port;
 	uint8_t mad_method;	/* was this a get or a set */
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	struct timeval query_start;
 #endif
 } osm_perfmgr_context_t;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index d8f933e..5207245 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -70,7 +70,7 @@
 
 #define PERFMGR_INITIAL_TID_VALUE 0xcafe
 
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 struct {
 	double fastest_us;
 	double slowest_us;
@@ -557,7 +557,7 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 		mad_context.perfmgr_context.node_guid = node_guid;
 		mad_context.perfmgr_context.port = port;
 		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_GET;
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 		gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
 #endif
 		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
@@ -800,7 +800,7 @@ _exit:
  **********************************************************************/
 void osm_perfmgr_process(osm_perfmgr_t * pm)
 {
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	struct timeval before, after;
 #endif
 
@@ -835,7 +835,7 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 		CL_PLOCK_RELEASE(pm->sm->p_lock);
 	}
 
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	gettimeofday(&before, NULL);
 #endif
 	/* With the global lock held, collect the node guids */
@@ -853,7 +853,7 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	/* clean out any nodes found to be removed during the sweep */
 	remove_marked_nodes(pm);
 
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	/* spin on outstanding queries */
 	while (pm->outstanding_queries > 0)
 		cl_event_wait_on(&pm->sig_sweep, 1000, TRUE);
@@ -1333,7 +1333,7 @@ static void pc_recv_process(void *context, void *data)
 
 	perfmgr_check_overflow(pm, p_mon_node, pkey_ix, port, wire_read);
 
-#if ENABLE_OSM_PERF_MGR_PROFILE
+#ifdef ENABLE_OSM_PERF_MGR_PROFILE
 	do {
 		struct timeval proc_time;
 		gettimeofday(&proc_time, NULL);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
