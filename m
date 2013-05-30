From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 2/2] OpenSM: DFSSSP - workaround for better VL balancing
Date: Thu, 30 May 2013 11:22:30 +0900
Message-ID: <1369880550-3031-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, DFSSSP maps the src/dest paths statically to certain VLs.
Especially for deadlock-free topologies this can result in an
unfair balancing. Some VLs within one link might be overused,
which results in slower bandwidth for some src/dest pairs.

The fix changes the VL assignment in two ways: first we balance the
number of paths per VL; and second we randomly assign the VL
as long as this doesn't violate the deadlock-freedom.

1) The balancing splits the paths across available free VLs, so that
the maximal number of paths per VL is minimized. We save the number
of VLs for each deadlock-free channel dependency graph. E.g. for
8 VLs, paths per CDG: {14,5,1} => balanced VLs: {{3,3,3,3,2},{3,2},1}
we have 5 VLs to choose from for CDG(0), two for CDG(1) and
one for CDG(2).

2) get_dfsssp_sl(...) will use the information of (1) to randomly
assign the VL for one src/dest pair within the possible number of
VLs. E.g. for a src/dest pair of CDG(0) we have 5 VLs to choose from,
therefore VL := baseVL + rand()%5

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |  131 +++++++++++++++++++++++++++++++--------------
 1 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 98c3f7c..7aecc24 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -133,6 +133,7 @@ typedef struct dfsssp_context {
 	vertex_t *adj_list;
 	uint32_t adj_list_size;
 	vltable_t *srcdest2vl_table;
+	uint8_t *vl_split_count;
 } dfsssp_context_t;
 
 /**************** set initial values for structs **********************
@@ -1722,8 +1723,9 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	cl_map_item_t *item1 = NULL, *item2 = NULL;
 	osm_port_t *src_port = NULL, *dest_port = NULL;
 
-	uint32_t i = 0, err = 0;
-	uint8_t test_vl = 0, vl_avail = 0, vl_needed = 1;
+	uint32_t i = 0, j = 0, err = 0;
+	uint8_t vl = 0, test_vl = 0, vl_avail = 0, vl_needed = 1;
+	double most_avg_paths = 0.0;
 	cdg_node_t **cdg = NULL, *start_here = NULL, *cycle = NULL;
 	cdg_link_t *weakest_link = NULL;
 	uint32_t srcdest = 0;
@@ -2004,43 +2006,56 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
 		"Balancing the paths on the available Virtual Lanes\n");
 
-	/* balancing virtual lanes, but avoid additional cycle check -> balancing suboptimal;
+	/* optimal balancing virtual lanes, under condition: no additional cycle checks;
 	   sl/vl != 0 might be assigned to loopback packets (i.e. slid/dlid on the
 	   same port for lmc>0), but thats no problem, see IBAS 10.2.2.3
 	 */
-	if (vl_needed == 1) {
-		from = 0;
-		count = paths_per_vl[0] / vl_avail;
-		for (to = 1; to < vl_avail; to++) {
-			vltable_change_vl(srcdest2vl_table, from, to, count);
-			paths_per_vl[from] -= count;
-			paths_per_vl[to] += count;
-		}
-	} else if (vl_needed < vl_avail) {
-		split_count = (uint8_t *) malloc(vl_needed * sizeof(uint8_t));
-		if (!split_count) {
-			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
-				"ERR AD24: cannot allocate memory for split_count, skip balancing\n");
-		} else {
-			memset(split_count, 0, vl_needed * sizeof(uint8_t));
-			for (i = vl_needed; i < vl_avail; i++)
-				split_count[(i - vl_needed) % vl_needed]++;
-
-			to = vl_needed;
-			for (from = 0; from < vl_needed; from++) {
-				count =
-				    paths_per_vl[from] / (split_count[from] +
-							  1);
-				for (i = 0; i < split_count[from]; i++) {
-					vltable_change_vl(srcdest2vl_table,
-							  from, to, count);
-					paths_per_vl[from] -= count;
-					paths_per_vl[to] += count;
-					to++;
+	split_count = (uint8_t *) calloc(vl_avail, sizeof(uint8_t));
+	if (!split_count) {
+		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+			"ERR AD24: cannot allocate memory for split_count, skip balancing\n");
+		goto ERROR;
+	}
+	/* initial state: paths for VLs won't be separated */
+	for (i = 0; i < ((vl_needed < vl_avail) ? vl_needed : vl_avail); i++)
+		split_count[i] = 1;
+	dfsssp_ctx->vl_split_count = split_count;
+	/* balancing is necessary if we have empty VLs */
+	if (vl_needed < vl_avail) {
+		/* split paths of VLs until we find an equal distribution */
+		for (i = vl_needed; i < vl_avail; i++) {
+			/* find VL with most paths in it */
+			vl = 0;
+			most_avg_paths = 0.0;
+			for (test_vl = 0; test_vl < vl_needed; test_vl++) {
+				if (most_avg_paths <
+				    ((double)paths_per_vl[test_vl] /
+				    split_count[test_vl])) {
+					vl = test_vl;
+					most_avg_paths =
+						(double)paths_per_vl[test_vl] /
+						split_count[test_vl];
 				}
 			}
-
-			free(split_count);
+			split_count[vl]++;
+		}
+		/* change the VL assignment depending on split_count for
+		   all VLs except VL 0
+		 */
+		for (from = vl_needed - 1; from > 0; from--) {
+			/* how much space needed for others? */
+			to = 0;
+			for (i = 0; i < from; i++)
+				to += split_count[i];
+			count = paths_per_vl[from];
+			vltable_change_vl(srcdest2vl_table, from, to, count);
+			/* change also the information within the split_count
+			   array; this is important for fast calculation later
+			 */
+			split_count[to] = split_count[from];
+			split_count[from] = 0;
+			paths_per_vl[to] = paths_per_vl[from];
+			paths_per_vl[from] = 0;
 		}
 	} else if (vl_needed > vl_avail) {
 		/* routing not possible, a further development would be the LASH-TOR approach (update: LASH-TOR isn't possible, there is a mistake in the theory) */
@@ -2058,11 +2073,18 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	}
 	if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_INFO)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Paths per VL (after balancing):\n");
-		for (i = 0; i < vl_avail; i++)
+			"Approx. #paths per VL (after balancing):\n");
+		j = 0;
+		count = 1; /* to prevent div. by 0 */
+		for (i = 0; i < vl_avail; i++) {
+			if (split_count[i] > 0) {
+				j = i;
+				count = split_count[i];
+			}
 			OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 				"   %" PRIu32 ". lane: %" PRIu64 "\n", i,
-				paths_per_vl[i]);
+				paths_per_vl[j] / count);
+		}
 	}
 
 	free(paths_per_vl);
@@ -2382,6 +2404,7 @@ static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
 	dfsssp_context_t *dfsssp_ctx = (dfsssp_context_t *) context;
 	osm_port_t *src_port, *dest_port;
 	vltable_t *srcdest2vl_table = NULL;
+	uint8_t *vl_split_count = NULL;
 	osm_ucast_mgr_t *p_mgr = NULL;
 	int32_t res = 0;
 
@@ -2389,6 +2412,7 @@ static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
 	    && dfsssp_ctx->routing_type == OSM_ROUTING_ENGINE_TYPE_DFSSSP) {
 		p_mgr = (osm_ucast_mgr_t *) dfsssp_ctx->p_mgr;
 		srcdest2vl_table = (vltable_t *) (dfsssp_ctx->srcdest2vl_table);
+		vl_split_count = (uint8_t *) (dfsssp_ctx->vl_split_count);
 	}
 	else
 		return hint_for_default_sl;
@@ -2406,9 +2430,20 @@ static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
 
 	res = vltable_get_vl(srcdest2vl_table, slid, dlid);
 
-	if (res > -1)
-		return (uint8_t) res;
-	else
+	/* we will randomly distribute the traffic over multiple VLs if
+	   necessary for good balancing; therefore vl_split_count provides
+	   the number of VLs to use for certain traffic
+	 */
+	if (res > -1) {
+		if (vl_split_count[res] > 1){res+=rand()%(vl_split_count[res]);printf("r: %u\n",res);fflush(stdout);
+			return (uint8_t) res;
+//			return (uint8_t) (res + rand()%(vl_split_count[res]));
+		}
+		else{
+			printf("r: %u\n",res);fflush(stdout);
+			return (uint8_t) res;
+		}
+	} else
 		return hint_for_default_sl;
 }
 
@@ -2426,6 +2461,7 @@ static dfsssp_context_t *dfsssp_context_create(osm_opensm_t * p_osm,
 		dfsssp_ctx->p_mgr = (osm_ucast_mgr_t *) & (p_osm->sm.ucast_mgr);
 		dfsssp_ctx->adj_list = NULL;
 		dfsssp_ctx->srcdest2vl_table = NULL;
+		dfsssp_ctx->vl_split_count = NULL;
 	} else {
 		OSM_LOG(p_osm->sm.ucast_mgr.p_log, OSM_LOG_ERROR,
 			"ERR AD04: cannot allocate memory for dfsssp_ctx in dfsssp_context_create\n");
@@ -2455,9 +2491,17 @@ static void dfsssp_context_destroy(void *context)
 	dfsssp_ctx->adj_list = NULL;
 	dfsssp_ctx->adj_list_size = 0;
 
-	/* free srcdest2vl table (can be done because, dfsssp_context_destroy is called after osm_get_dfsssp_sl) */
+	/* free srcdest2vl table and the split count information table
+	   (can be done, because dfsssp_context_destroy is called after
+	    osm_get_dfsssp_sl)
+	 */
 	vltable_dealloc(&(dfsssp_ctx->srcdest2vl_table));
 	dfsssp_ctx->srcdest2vl_table = NULL;
+
+	if (dfsssp_ctx->vl_split_count) {
+		free(dfsssp_ctx->vl_split_count);
+		dfsssp_ctx->vl_split_count = NULL;
+	}
 }
 
 static void delete(void *context)
@@ -2486,6 +2530,11 @@ int osm_ucast_dfsssp_setup(struct osm_routing_engine *r, osm_opensm_t * p_osm)
 	r->path_sl = get_dfsssp_sl;
 	r->destroy = delete;
 
+	/* we initialize with the current time to achieve a 'good' randomized
+	   assignment in get_dfsssp_sl(...)
+	 */
+	srand(time(NULL));
+
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
