From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 1/1] OpenSM: dfsssp - add missing and change existing return values
Date: Wed, 31 Jul 2013 15:04:06 +0900
Message-ID: <1375250646-22892-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

a) this patch sets the 'err' variable correclty for the function
   dfsssp_remove_deadlocks() for the case, that the error occurs within
   the function and not within a subroutine
b) the functions dfsssp_build_graph() and dfsssp_do_dijkstra_routing()
   now return -1 instead of 1 to indicate an error to be in compliance
   with the implementation of ucast_mgr_route() in osm_ucast_mgr.c

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index a08e44b..321fffd 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1158,7 +1158,7 @@ static int dfsssp_build_graph(void *context)
 	if (!adj_list) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 			"ERR AD02: cannot allocate memory for adj_list\n");
-		return 1;
+		goto ERROR;
 	}
 	for (i = 0; i < adj_list_size; i++)
 		set_default_vertex(&adj_list[i]);
@@ -1198,7 +1198,7 @@ static int dfsssp_build_graph(void *context)
 			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 				"ERR AD03: cannot allocate memory for a link\n");
 			dfsssp_context_destroy(context);
-			return 1;
+			goto ERROR;
 		}
 		head = link;
 		head->next = NULL;
@@ -1243,7 +1243,7 @@ static int dfsssp_build_graph(void *context)
 					head = head->next;
 					free(link);
 				}
-				return 1;
+				goto ERROR;
 			}
 			link = link->next;
 			set_default_link(link);
@@ -1277,6 +1277,9 @@ static int dfsssp_build_graph(void *context)
 
 	OSM_LOG_EXIT(p_mgr->p_log);
 	return 0;
+
+ERROR:
+	return -1;
 }
 
 static void print_routes(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
@@ -1891,6 +1894,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 				if (!weakest_link) {
 					OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 						"ERR AD27: something went wrong in get_weakest_link_in_cycle(...)\n");
+					err = 1;
 					goto ERROR;
 				}
 
@@ -2012,6 +2016,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 	if (!split_count) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 			"ERR AD24: cannot allocate memory for split_count, skip balancing\n");
+		err = 1;
 		goto ERROR;
 	}
 	/* initial state: paths for VLs won't be separated */
@@ -2060,6 +2065,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 			"ERR AD25: Not enough VL available (avail=%d, needed=%d); Stop dfsssp routing!\n",
 			vl_avail, vl_needed);
+		err = 1;
 		goto ERROR;
 	}
 	/* else { no balancing } */
@@ -2161,7 +2167,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 	if (!sw_list) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 			"ERR AD29: cannot allocate memory for sw_list in dfsssp_do_dijkstra_routing\n");
-		return 1;
+		goto ERROR;
 	}
 	memset(sw_list, 0, sw_list_size * sizeof(vertex_t *));
 
@@ -2197,7 +2203,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 				"ERR AD31: corrupted sw_list array in dfsssp_do_dijkstra_routing\n");
 			free(sw_list);
-			return 1;
+			goto ERROR;
 		}
 	}
 
@@ -2240,7 +2246,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 			err =
 			    dijkstra(p_mgr, adj_list, adj_list_size, port, lid);
 			if (err)
-				return err;
+				goto ERROR;
 			if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_DEBUG))
 				print_routes(p_mgr, adj_list, adj_list_size,
 					     port);
@@ -2249,7 +2255,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 			err =
 			    update_lft(p_mgr, adj_list, adj_list_size, port, lid);
 			if (err)
-				return err;
+				goto ERROR;
 
 			/* add weights for calculated routes to adjust the weights for the next cycle */
 			update_weights(p_mgr, adj_list, adj_list_size);
@@ -2268,14 +2274,14 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		/* remove potential deadlocks by assigning different virtual lanes to src/dest paths and balance the lanes */
 		err = dfsssp_remove_deadlocks(dfsssp_ctx);
 		if (err)
-			return err;
+			goto ERROR;
 	} else if (dfsssp_ctx->routing_type == OSM_ROUTING_ENGINE_TYPE_SSSP) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 			"SSSP routing specified -> skipping deadlock removal thru dfsssp_remove_deadlocks(...)\n");
 	} else {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 			"ERR AD28: wrong routing engine specified in dfsssp_ctx\n");
-		return 1;
+		goto ERROR;
 	}
 
 	/* print the new_lft for each switch after routing is done */
@@ -2300,6 +2306,9 @@ static int dfsssp_do_dijkstra_routing(void *context)
 
 	OSM_LOG_EXIT(p_mgr->p_log);
 	return 0;
+
+ERROR:
+	return -1;
 }
 
 /* meta function which calls subfunctions for finding the optimal switch
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
