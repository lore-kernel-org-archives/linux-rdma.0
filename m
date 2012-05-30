From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_dfsssp.c: Use osm_log_is_active
Date: Wed, 30 May 2012 10:00:47 -0400
Message-ID: <4FC6280F.6080105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than osm_log_get_level to determine whether log level is active.
Log level is bit mask so >= doesn't always work properly.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 1e3ade1..3b7b83a 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1185,7 +1185,7 @@ static int dfsssp_build_graph(void *context)
 		}
 	}
 	/* print the discovered graph */
-	if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_DEBUG)
+	if (osm_log_is_active(p_mgr->p_log, OSM_LOG_DEBUG))
 		dfsssp_print_graph(p_mgr, adj_list, adj_list_size);
 
 	dfsssp_ctx->adj_list = adj_list;
@@ -1814,7 +1814,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 		"Virtual Lanes needed: %" PRIu8 "\n", vl_needed);
-	if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_INFO) {
+	if (osm_log_is_active(p_mgr->p_log, OSM_LOG_INFO)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 			"Paths per VL (before balancing):\n");
 		for (i = 0; i < vl_avail; i++)
@@ -1869,7 +1869,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 		goto ERROR;
 	}
 	/* else { no balancing } */
-	if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_INFO) {
+	if (osm_log_is_active(p_mgr->p_log, OSM_LOG_INFO)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 			"Virtual Lanes per src/dest combination after balancing:\n");
 		vltable_print(p_mgr, srcdest2vl_table);
@@ -1958,8 +1958,8 @@ static int dfsssp_do_dijkstra_routing(void *context)
 					     port, lid);
 				if (err)
 					return err;
-				if (osm_log_get_level(p_mgr->p_log) >=
-				    OSM_LOG_DEBUG)
+				if (osm_log_is_active(p_mgr->p_log,
+				    OSM_LOG_DEBUG))
 					print_routes(p_mgr, adj_list,
 						     adj_list_size, port);
 
@@ -1974,8 +1974,8 @@ static int dfsssp_do_dijkstra_routing(void *context)
 				update_weights(p_mgr, adj_list, adj_list_size,
 					       port);
 
-				if (osm_log_get_level(p_mgr->p_log) >=
-				    OSM_LOG_DEBUG)
+				if (osm_log_is_active(p_mgr->p_log,
+				    OSM_LOG_DEBUG))
 					dfsssp_print_graph(p_mgr, adj_list,
 							   adj_list_size);
 			}
@@ -1998,7 +1998,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 			    dijkstra(p_mgr, adj_list, adj_list_size, port, lid);
 			if (err)
 				return err;
-			if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_DEBUG)
+			if (osm_log_is_active(p_mgr->p_log, OSM_LOG_DEBUG))
 				print_routes(p_mgr, adj_list, adj_list_size,
 					     port);
 
@@ -2010,7 +2010,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 			/* add weights for calculated routes to adjust the weights for the next cycle */
 			update_weights(p_mgr, adj_list, adj_list_size, port);
 
-			if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_DEBUG)
+			if (osm_log_is_active(p_mgr->p_log, OSM_LOG_DEBUG))
 				dfsssp_print_graph(p_mgr, adj_list,
 						   adj_list_size);
 		}
@@ -2032,7 +2032,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 	}
 
 	/* print the new_lft for each switch after routing is done */
-	if (osm_log_get_level(p_mgr->p_log) >= OSM_LOG_DEBUG) {
+	if (osm_log_is_active(p_mgr->p_log, OSM_LOG_DEBUG)) {
 		for (item = cl_qmap_head(sw_tbl); item != cl_qmap_end(sw_tbl);
 		     item = cl_qmap_next(item)) {
 			sw = (osm_switch_t *) item;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
