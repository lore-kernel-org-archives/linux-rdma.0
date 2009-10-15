From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_cache: reduce OSM_LOG_INFO debug printouts
Date: Fri, 16 Oct 2009 00:00:10 +0200
Message-ID: <20091015220010.GL20210@me>
References: <20091015133639.GB8041@comcast.net>
 <20091015192647.GF20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091015192647.GF20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Convert debug log messages to use OSM_LOG_DEBUG level (instead of
OSM_LOG_INFO), add cache invalidation verbose message (OSM_LOG_VERBOSE
level).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_ucast_cache.c |   91 +++++++++++++++++----------------------
 1 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
index 31a5333..4700c5f 100644
--- a/opensm/opensm/osm_ucast_cache.c
+++ b/opensm/opensm/osm_ucast_cache.c
@@ -256,8 +256,8 @@ cache_check_link_change(osm_ucast_mgr_t * p_mgr,
 	     p_physp_1->p_remote_physp->p_remote_physp) ||
 	    (p_physp_2->p_remote_physp &&
 	     p_physp_2->p_remote_physp->p_remote_physp)) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Link location change discovered - cache is invalid\n");
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+			"Link location change discovered\n");
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
@@ -281,27 +281,26 @@ static void cache_remove_port(osm_ucast_mgr_t * p_mgr, uint16_t lid_ho,
 
 	p_cache_sw = cache_get_sw(p_mgr, lid_ho);
 	if (!p_cache_sw) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Found uncached switch/link (lid %u, port %u) - "
-			"cache is invalid\n", lid_ho, port_num);
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+			"Found uncached switch/link (lid %u, port %u)\n",
+			lid_ho, port_num);
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
 
 	if (port_num >= p_cache_sw->num_ports ||
 	    !p_cache_sw->ports[port_num].remote_lid_ho) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Found uncached switch link (lid %u, port %u) - "
-			"cache is invalid\n", lid_ho, port_num);
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+			"Found uncached switch link (lid %u, port %u)\n",
+			lid_ho, port_num);
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
 
 	if (p_cache_sw->ports[port_num].remote_lid_ho != remote_lid_ho) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 			"Remote lid change on switch lid %u, port %u "
-			"(was %u, now %u) - cache is invalid\n",
-			lid_ho, port_num,
+			"(was %u, now %u)\n", lid_ho, port_num,
 			p_cache_sw->ports[port_num].remote_lid_ho,
 			remote_lid_ho);
 		osm_ucast_cache_invalidate(p_mgr);
@@ -310,9 +309,9 @@ static void cache_remove_port(osm_ucast_mgr_t * p_mgr, uint16_t lid_ho,
 
 	if ((p_cache_sw->ports[port_num].is_leaf && !is_ca) ||
 	    (!p_cache_sw->ports[port_num].is_leaf && is_ca)) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Remote node type change on switch lid %u, port %u - "
-			"cache is invalid\n", lid_ho, port_num);
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+			"Remote node type change on switch lid %u, port %u\n",
+			lid_ho, port_num);
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
@@ -406,7 +405,6 @@ void osm_ucast_cache_invalidate(osm_ucast_mgr_t * p_mgr)
 	cache_switch_t *p_next_sw;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
-	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG, "Invalidating unicast cache\n");
 
 	if (!p_mgr->cache_valid)
 		goto Exit;
@@ -421,6 +419,8 @@ void osm_ucast_cache_invalidate(osm_ucast_mgr_t * p_mgr)
 		cache_sw_destroy(p_sw);
 	}
 	cl_qmap_remove_all(&p_mgr->cache_sw_tbl);
+
+	OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE, "Unicast Cache Invalidated.\n");
 Exit:
 	OSM_LOG_EXIT(p_mgr->p_log);
 }
@@ -563,9 +563,9 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 				 *    then its port should have is_new flag on.
 				 */
 				if (p_sw->need_update == 2) {
-					OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-						"New switch found (lid %u) - "
-						"cache is invalid\n", lid_ho);
+					OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+						"New switch found (lid %u)\n",
+						lid_ho);
 					osm_ucast_cache_invalidate(p_mgr);
 					goto Exit;
 				}
@@ -580,9 +580,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 						   additional link that it
 						   didn't have before */
 						OSM_LOG(p_mgr->p_log,
-							OSM_LOG_INFO,
-							"New switch/link found (lid %u) - "
-							"cache is invalid\n",
+							OSM_LOG_DEBUG,
+							"New switch/link found (lid %u)\n",
 							remote_lid_ho);
 						osm_ucast_cache_invalidate
 						    (p_mgr);
@@ -600,9 +599,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 								 (p_remote_physp));
 					if (p_remote_port->is_new) {
 						OSM_LOG(p_mgr->p_log,
-							OSM_LOG_INFO,
-							"New CA/RTR found (lid %u) - "
-							"cache is invalid\n",
+							OSM_LOG_DEBUG,
+							"New CA/RTR found (lid %u)\n",
 							remote_lid_ho);
 						osm_ucast_cache_invalidate
 						    (p_mgr);
@@ -626,9 +624,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 				     remote_node_type == IB_NODE_TYPE_SWITCH) ||
 				    (!p_cache_sw->ports[port_num].is_leaf &&
 				     remote_node_type != IB_NODE_TYPE_SWITCH)) {
-					OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-						"Remote node type change on switch lid %u, port %u - "
-						"cache is invalid\n",
+					OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+						"Remote node type change on switch lid %u, port %u\n",
 						lid_ho, port_num);
 					osm_ucast_cache_invalidate(p_mgr);
 					goto Exit;
@@ -636,9 +633,9 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 
 				if (p_cache_sw->ports[port_num].remote_lid_ho !=
 				    remote_lid_ho) {
-					OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
+					OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 						"Remote lid change on switch lid %u, port %u"
-						"(was %u, now %u) - cache is invalid\n",
+						"(was %u, now %u)\n",
 						lid_ho, port_num,
 						p_cache_sw->ports[port_num].
 						remote_lid_ho, remote_lid_ho);
@@ -696,9 +693,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 
 		if (p_cache_sw->dropped) {
 			if (!cache_sw_is_leaf(p_cache_sw)) {
-				OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-					"Missing non-leaf switch (lid %u) - "
-					"cache is invalid\n",
+				OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+					"Missing non-leaf switch (lid %u)\n",
 					cache_sw_get_base_lid_ho(p_cache_sw));
 				osm_ucast_cache_invalidate(p_mgr);
 				goto Exit;
@@ -731,9 +727,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 							 remote_lid_ho);
 
 			if (!p_remote_cache_sw || !p_remote_cache_sw->dropped) {
-				OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-					"Switch lid %u, port %u: missing link to existing switch - "
-					"cache is invalid\n",
+				OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+					"Switch lid %u, port %u: missing link to existing switch\n",
 					cache_sw_get_base_lid_ho(p_cache_sw),
 					port_num);
 				osm_ucast_cache_invalidate(p_mgr);
@@ -741,9 +736,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 			}
 
 			if (!cache_sw_is_leaf(p_remote_cache_sw)) {
-				OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-					"Switch lid %u, port %u: missing link to non-leaf switch - "
-					"cache is invalid\n",
+				OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+					"Switch lid %u, port %u: missing link to non-leaf switch\n",
 					cache_sw_get_base_lid_ho(p_cache_sw),
 					port_num);
 				osm_ucast_cache_invalidate(p_mgr);
@@ -761,9 +755,8 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 			 */
 			if (cache_sw_is_leaf(p_cache_sw) &&
 			    cache_sw_is_leaf(p_remote_cache_sw)) {
-				OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-					"Switch lid %u, port %u: missing leaf-2-leaf link - "
-					"cache is invalid\n",
+				OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+					"Switch lid %u, port %u: missing leaf-2-leaf link\n",
 					cache_sw_get_base_lid_ho(p_cache_sw),
 					port_num);
 				osm_ucast_cache_invalidate(p_mgr);
@@ -808,8 +801,7 @@ void osm_ucast_cache_check_new_link(osm_ucast_mgr_t * p_mgr,
 
 	if (osm_node_get_type(p_node_1) != IB_NODE_TYPE_SWITCH &&
 	    osm_node_get_type(p_node_2) != IB_NODE_TYPE_SWITCH) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Found CA/RTR-2-CA/RTR link - cache is invalid\n");
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG, "Found CA-2-CA link\n");
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
@@ -875,8 +867,7 @@ void osm_ucast_cache_add_link(osm_ucast_mgr_t * p_mgr,
 
 	if (osm_node_get_type(p_node_1) != IB_NODE_TYPE_SWITCH &&
 	    osm_node_get_type(p_node_2) != IB_NODE_TYPE_SWITCH) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-			"Dropping CA-2-CA link - cache invalid\n");
+		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG, "Dropping CA-2-CA link\n");
 		osm_ucast_cache_invalidate(p_mgr);
 		goto Exit;
 	}
@@ -993,9 +984,8 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 		CL_ASSERT(p_cache_sw);
 
 		if (!cache_sw_is_leaf(p_cache_sw)) {
-			OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-				"Dropped non-leaf switch (lid %u) - "
-				"cache is invalid\n", lid_ho);
+			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+				"Dropped non-leaf switch (lid %u)\n", lid_ho);
 			osm_ucast_cache_invalidate(p_mgr);
 			goto Exit;
 		}
@@ -1003,9 +993,8 @@ void osm_ucast_cache_add_node(osm_ucast_mgr_t * p_mgr, osm_node_t * p_node)
 		p_cache_sw->dropped = TRUE;
 
 		if (!p_node->sw->num_hops || !p_node->sw->hops) {
-			OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-				"No LID matrices for switch lid %u - "
-				"cache is invalid\n", lid_ho);
+			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
+				"No LID matrices for switch lid %u\n", lid_ho);
 			osm_ucast_cache_invalidate(p_mgr);
 			goto Exit;
 		}
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
