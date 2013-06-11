From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/6] Fix shift pattern support in FTREE routing for native
 ftree topologies
Date: Tue, 11 Jun 2013 14:13:52 -0400
Message-ID: <51B768E0.3000704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 7c21c145e228cab52670819a22478fba409efb6c Mon Sep 17 00:00:00 2001
From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 3 Jun 2013 11:44:01 +0300
Subject: [PATCH 5/6] Fix shift pattern support in FTREE routing for native
 ftree topologies

Fix DUMMY nodes support broken by patch b12ab3afc186fa798c26907fbdf02a4667a6ce29

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |  167 +++++++++++++++++++---------------------------
 1 files changed, 69 insertions(+), 98 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index decfc82..9b47c74 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -1982,7 +1982,7 @@ static inline uint32_t find_lowest_loaded_group_on_sw(ftree_sw_t * p_sw)
  * When both port groups are equally loaded, it picks the one whom
  * remote switch down ports are least loaded.
  * This way, it prefers the switch from where it will be easier to go down (creating upward routes).
- * If both are equal, it picks the bigger GUID to be deterministic.
+ * If both are equal, it picks the lowest INDEX to be deterministic.
  */
 static inline int port_group_compare_load_down(const ftree_port_group_t * p1,
 					       const ftree_port_group_t * p2)
@@ -2003,12 +2003,21 @@ static inline int port_group_compare_load_down(const ftree_port_group_t * p1,
 		if (temp > 0)
 			return 1;
 	} while (0);
-	/* If they are both equal, choose the biggest GUID */
-	if (p1->remote_port_guid > p2->remote_port_guid)
-		return 1;
-
-	return -1;
+	/* If they are both equal, choose the lowest index */
+	return compare_port_groups_by_remote_switch_index(&p1, &p2);
+}
 
+static inline int port_group_compare_load_up(const ftree_port_group_t * p1,
+                                             const ftree_port_group_t * p2)
+{
+        int temp = p1->counter_up - p2->counter_up;
+        if (temp > 0)
+                return 1;
+        if (temp < 0)
+                return -1;
+
+        /* If they are both equal, choose the lowest index */
+        return compare_port_groups_by_remote_switch_index (&p1,&p2);
 }
 
 /*
@@ -2044,8 +2053,8 @@ bubble_sort_up(ftree_port_group_t ** p_group_array, uint32_t nmemb)
 		/* Comparing elements j and j-1 */
 		for (j = 1; j < (nmemb - i); j++) {
 			/* If they are the wrong way around */
-			if (p_group_array[j]->counter_up <
-			    p_group_array[j - 1]->counter_up) {
+			if (port_group_compare_load_up(p_group_array[j],
+						       p_group_array[j - 1]) < 0) {
 				/* We invert them */
 				tmp = p_group_array[j - 1];
 				p_group_array[j - 1] = p_group_array[j];
@@ -2076,13 +2085,12 @@ bubble_sort_siblings(ftree_port_group_t ** p_group_array, uint32_t nmemb)
 		/* Comparing elements j and j-1 */
 		for (j = 1; j < (nmemb - i); j++) {
 			/* If they are the wrong way around */
-			if (p_group_array[j]->counter_up <
-			    p_group_array[j - 1]->counter_up) {
+			if (port_group_compare_load_up(p_group_array[j],
+						       p_group_array[j - 1]) < 0) {
 				/* We invert them */
 				tmp = p_group_array[j - 1];
 				p_group_array[j - 1] = p_group_array[j];
 				p_group_array[j] = tmp;
-
 			}
 		}
 	}
@@ -2150,7 +2158,6 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 				   IN ftree_sw_t * p_sw,
 				   IN ftree_sw_t * p_prev_sw,
 				   IN uint16_t target_lid,
-				   IN boolean_t is_real_lid,
 				   IN boolean_t is_main_path,
 				   IN boolean_t is_target_a_sw,
 				   IN uint8_t current_hops)
@@ -2166,9 +2173,6 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 	boolean_t routed = 0;
 	uint8_t least_hops;
 
-	/* we shouldn't enter here if both real_lid and main_path are false */
-	CL_ASSERT(is_real_lid || is_main_path);
-
 	/* if there is no down-going ports */
 	if (p_sw->down_port_groups_num == 0)
 		return FALSE;
@@ -2183,7 +2187,7 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 	for (k = 0;
 	     k <
 	     (p_sw->down_port_groups_num +
-	      (is_real_lid ? p_sw->sibling_port_groups_num : 0)); k++) {
+	      ((target_lid != 0) ? p_sw->sibling_port_groups_num : 0)); k++) {
 
 		if (k < p_sw->down_port_groups_num) {
 			p_group = p_sw->down_port_groups[k];
@@ -2249,13 +2253,13 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 
 		/* Four possible cases:
 		 *
-		 *  1. is_real_lid == TRUE && is_main_path == TRUE:
+		 *  1. is_main_path == TRUE:
 		 *      - going DOWN(TRUE,TRUE) through ALL the groups
 		 *         + promoting port counter
 		 *         + setting path in remote switch fwd tbl
 		 *         + setting hops in remote switch on all the ports of each group
 		 *
-		 *  2. is_real_lid == TRUE && is_main_path == FALSE:
+		 *  2. is_main_path == FALSE:
 		 *      - going DOWN(TRUE,FALSE) through ALL the groups but only if
 		 *        the remote (lower) switch hasn't been already configured
 		 *        for this target LID (or with a longer path)
@@ -2263,39 +2267,27 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 		 *         + setting path in remote switch fwd tbl if it hasn't been set yet
 		 *         + setting hops in remote switch on all the ports of each group
 		 *           if it hasn't been set yet
-		 *
-		 *  3. is_real_lid == FALSE && is_main_path == TRUE:
-		 *      - going DOWN(FALSE,TRUE) through ALL the groups
-		 *         + promoting port counter
-		 *         + NOT setting path in remote switch fwd tbl
-		 *         + NOT setting hops in remote switch
-		 *
-		 *  4. is_real_lid == FALSE && is_main_path == FALSE:
-		 *      - illegal state - we shouldn't get here
 		 */
 
-		/* setting fwd tbl port only if this is real LID */
-		if (is_real_lid) {
-			p_remote_sw->p_osm_sw->new_lft[target_lid] =
+		/* setting fwd tbl port only */
+		p_remote_sw->p_osm_sw->new_lft[target_lid] =
 			    p_min_port->remote_port_num;
-			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 				"Switch %s: set path to CA LID %u through port %u\n",
 				tuple_to_str(p_remote_sw->tuple),
 				target_lid, p_min_port->remote_port_num);
 
-			/* On the remote switch that is pointed by the p_group,
-			   set hops for ALL the ports in the remote group. */
+		/* On the remote switch that is pointed by the p_group,
+			set hops for ALL the ports in the remote group. */
 
-			set_hops_on_remote_sw(p_group, target_lid,
-					      current_hops + 1, is_target_a_sw);
-		}
+		set_hops_on_remote_sw(p_group, target_lid,
+				      current_hops + 1, is_target_a_sw);
 
 		/* Recursion step:
 		   Assign upgoing ports by stepping down, starting on REMOTE switch */
 		routed = fabric_route_upgoing_by_going_down(p_ftree, p_remote_sw,	/* remote switch - used as a route-upgoing alg. start point */
 							    NULL,	/* prev. position - NULL to mark that we went down and not up */
 							    target_lid,	/* LID that we're routing to */
-							    is_real_lid,	/* whether the target LID is real or dummy */
 							    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
 							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    current_hops + 1);	/* Number of hops done to this point */
@@ -2337,7 +2329,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 				   IN ftree_sw_t * p_sw,
 				   IN ftree_sw_t * p_prev_sw,
 				   IN uint16_t target_lid,
-				   IN boolean_t is_real_lid,
 				   IN boolean_t is_main_path,
 				   IN boolean_t is_target_a_sw,
 				   IN uint16_t reverse_hop_credit,
@@ -2355,14 +2346,11 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 	boolean_t created_route = FALSE;
 	boolean_t routed = FALSE;
 
-	/* we shouldn't enter here if both real_lid and main_path are false */
-	CL_ASSERT(is_real_lid || is_main_path);
 
 	/* Assign upgoing ports by stepping down, starting on THIS switch */
 	created_route = fabric_route_upgoing_by_going_down(p_ftree, p_sw,	/* local switch - used as a route-upgoing alg. start point */
 							   p_prev_sw,	/* switch that we went up from (NULL means that we went down) */
 							   target_lid,	/* LID that we're routing to */
-							   is_real_lid,	/* whether this target LID is real or dummy */
 							   is_main_path,	/* whether this path to HCA should by tracked by counters */
 							   is_target_a_sw,	/* Whether target lid is a switch or not */
 							   current_hops);	/* Number of hops done up to this point */
@@ -2390,7 +2378,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 				created_route |= fabric_route_downgoing_by_going_up(p_ftree, p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
 										    p_sw,	/* this switch - prev. position switch for the function */
 										    target_lid,	/* LID that we're routing to */
-										    is_real_lid,	/* whether this target LID is real or dummy */
 										    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
 										    is_target_a_sw,	/* Whether target lid is a switch or not */
 										    reverse_hop_credit - 1,	/* Remaining reverse_hops allowed */
@@ -2432,7 +2419,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 
 	/* Four possible cases:
 	 *
-	 *  1. is_real_lid == TRUE && is_main_path == TRUE:
+	 *  1. is_main_path == TRUE:
 	 *      - going UP(TRUE,TRUE) on selected min_group and min_port
 	 *         + promoting port counter
 	 *         + setting path in remote switch fwd tbl
@@ -2443,7 +2430,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 	 *         + setting hops in remote switch on all the ports of each group
 	 *           if it hasn't been set yet
 	 *
-	 *  2. is_real_lid == TRUE && is_main_path == FALSE:
+	 *  2. is_main_path == FALSE:
 	 *      - going UP(TRUE,FALSE) on ALL the groups, each time on port 0,
 	 *        but only if the remote (upper) switch hasn't been already
 	 *        configured for this target LID
@@ -2451,15 +2438,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 	 *         + setting path in remote switch fwd tbl if it hasn't been set yet
 	 *         + setting hops in remote switch on all the ports of each group
 	 *           if it hasn't been set yet
-	 *
-	 *  3. is_real_lid == FALSE && is_main_path == TRUE:
-	 *      - going UP(FALSE,TRUE) ONLY on selected min_group and min_port
-	 *         + promoting port counter
-	 *         + NOT setting path in remote switch fwd tbl
-	 *         + NOT setting hops in remote switch
-	 *
-	 *  4. is_real_lid == FALSE && is_main_path == FALSE:
-	 *      - illegal state - we shouldn't get here
 	 */
 
 	/* covering first half of case 1, and case 3 */
@@ -2467,7 +2445,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		if (p_sw->is_leaf) {
 			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 				" - Routing MAIN path for %s CA LID %u: %s --> %s\n",
-				(is_real_lid) ? "real" : "DUMMY",
+				(target_lid != 0) ? "real" : "DUMMY",
 				target_lid,
 				tuple_to_str(p_sw->tuple),
 				tuple_to_str(p_remote_sw->tuple));
@@ -2485,58 +2463,47 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 			    (p_min_group->remote_hca_or_sw.p_sw);
 		}
 
-		if (is_real_lid) {
-			/* This LID may already be in the LFT in the reverse_hop feature is used */
-			/* We update the LFT only if this LID isn't already present. */
+		/* This LID may already be in the LFT in the reverse_hop feature is used */
+		/* We update the LFT only if this LID isn't already present. */
 
-			/* skip if target lid has been already set on remote switch fwd tbl (with a bigger hop count) */
-			if ((p_remote_sw->p_osm_sw->new_lft[target_lid] ==
-			     OSM_NO_PATH)
-			    ||
-			    ((p_remote_sw->p_osm_sw->new_lft[target_lid] !=
-			      OSM_NO_PATH)
+		/* skip if target lid has been already set on remote switch fwd tbl (with a bigger hop count) */
+		if ((p_remote_sw->p_osm_sw->new_lft[target_lid] == OSM_NO_PATH)
+		    ||
+		    ((p_remote_sw->p_osm_sw->new_lft[target_lid] != OSM_NO_PATH)
 			     &&
-			     (current_hops + 1 <
-			      sw_get_least_hops(p_remote_sw, target_lid)))) {
+		      (current_hops + 1 <
+		       sw_get_least_hops(p_remote_sw, target_lid)))) {
 
-				p_remote_sw->p_osm_sw->new_lft[target_lid] =
-				    p_min_port->remote_port_num;
-				OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
+			p_remote_sw->p_osm_sw->new_lft[target_lid] =
+				p_min_port->remote_port_num;
+			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 					"Switch %s: set path to CA LID %u through port %u\n",
 					tuple_to_str(p_remote_sw->tuple),
 					target_lid,
 					p_min_port->remote_port_num);
 
-				/* On the remote switch that is pointed by the min_group,
-				   set hops for ALL the ports in the remote group. */
+			/* On the remote switch that is pointed by the min_group,
+			set hops for ALL the ports in the remote group. */
 
-				set_hops_on_remote_sw(p_min_group, target_lid,
+			set_hops_on_remote_sw(p_min_group, target_lid,
 						      current_hops + 1,
 						      is_target_a_sw);
-
-				/* Recursion step:
-				   Assign downgoing ports by stepping up, starting on REMOTE switch. */
-				created_route |= fabric_route_downgoing_by_going_up(p_ftree, p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
-										    p_sw,	/* this switch - prev. position switch for the function */
-										    target_lid,	/* LID that we're routing to */
-										    is_real_lid,	/* whether this target LID is real or dummy */
-										    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
-										    is_target_a_sw,	/* Whether target lid is a switch or not */
-										    reverse_hop_credit,	/* Remaining reverse_hops allowed */
-										    reverse_hops,	/* Number of reverse_hops done up to this point */
-										    current_hops
-										    +
-										    1);
-			}
 		}
+	/* Recursion step: Assign downgoing ports by stepping up, starting on REMOTE switch. */
+	created_route |= fabric_route_downgoing_by_going_up(p_ftree,
+							    p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
+							    p_sw,		/* this switch - prev. position switch for the function */
+							    target_lid,		/* LID that we're routing to */
+							    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
+							    is_target_a_sw,	/* Whether target lid is a switch or not */
+							    reverse_hop_credit,	/* Remaining reverse_hops allowed */
+							    reverse_hops,	/* Number of reverse_hops done up to this point */
+							    current_hops + 1);
 	}
-	/* we're done for the third case */
-	if (!is_real_lid)
-		return created_route;
 
 	/* What's left to do at this point:
 	 *
-	 *  1. is_real_lid == TRUE && is_main_path == TRUE:
+	 *  1. is_main_path == TRUE:
 	 *      - going UP(TRUE,FALSE) on rest of the groups, each time on port 0,
 	 *        but only if the remote (upper) switch hasn't been already
 	 *        configured for this target LID
@@ -2545,7 +2512,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 	 *         + setting hops in remote switch on all the ports of each group
 	 *           if it hasn't been set yet
 	 *
-	 *  2. is_real_lid == TRUE && is_main_path == FALSE:
+	 *  2. is_main_path == FALSE:
 	 *      - going UP(TRUE,FALSE) on ALL the groups, each time on port 0,
 	 *        but only if the remote (upper) switch hasn't been already
 	 *        configured for this target LID
@@ -2621,7 +2588,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		routed = fabric_route_downgoing_by_going_up(p_ftree, p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
 							    p_sw,	/* this switch - prev. position switch for the function */
 							    target_lid,	/* LID that we're routing to */
-							    TRUE,	/* whether the target LID is real or dummy */
 							    FALSE,	/* whether this is path to HCA that should by tracked by counters */
 							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    reverse_hop_credit,	/* Remaining reverse_hops allowed */
@@ -2689,7 +2655,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		routed = fabric_route_downgoing_by_going_up(p_ftree, p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
 							    p_sw,	/* this switch - prev. position switch for the function */
 							    target_lid,	/* LID that we're routing to */
-							    TRUE,	/* whether the target LID is real or dummy */
 							    FALSE,	/* whether this is path to HCA that should by tracked by counters */
 							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    reverse_hop_credit,	/* Remaining reverse_hops allowed */
@@ -2726,7 +2691,6 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		created_route |= fabric_route_downgoing_by_going_up(p_ftree, p_remote_sw,	/* remote switch - used as a route-downgoing alg. next step point */
 								    p_sw,	/* this switch - prev. position switch for the function */
 								    target_lid,	/* LID that we're routing to */
-								    TRUE,	/* whether the target LID is real or dummy */
 								    TRUE,	/* whether this is path to HCA that should by tracked by counters */
 								    is_target_a_sw,	/* Whether target lid is a switch or not */
 								    reverse_hop_credit - 1,	/* Remaining reverse_hops allowed */
@@ -2816,7 +2780,6 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 			fabric_route_downgoing_by_going_up(p_ftree, p_sw,	/* local switch - used as a route-downgoing alg. start point */
 							   NULL,	/* prev. position switch */
 							   hca_lid,	/* LID that we're routing to */
-							   TRUE,	/* whether this HCA LID is real or dummy */
 							   TRUE,	/* whether this path to HCA should by tracked by counters */
 							   FALSE,	/* whether target lid is a switch or not */
 							   0,	/* Number of reverse hops allowed */
@@ -2838,16 +2801,26 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 			for (j = 0; j <
 			     p_ftree->max_cn_per_leaf - routed_targets_on_leaf;
 			     j++) {
+				ftree_sw_t *p_next_sw, *p_ftree_sw;
 				/* assign downgoing ports by stepping up */
 				fabric_route_downgoing_by_going_up(p_ftree, p_sw,	/* local switch - used as a route-downgoing alg. start point */
 								   NULL,	/* prev. position switch */
 								   0,	/* LID that we're routing to - ignored for dummy HCA */
-								   FALSE,	/* whether this HCA LID is real or dummy */
 								   TRUE,	/* whether this path to HCA should by tracked by counters */
 								   FALSE,	/* Whether the target LID is a switch or not */
 								   0,	/* Number of reverse hops allowed */
 								   0,	/* Number of reverse hops done yet */
 								   1);	/* Number of hops done yet */
+
+				p_next_sw = (ftree_sw_t *) cl_qmap_head(&p_ftree->sw_tbl);
+				/* need to clean the LID 0 hops for dummy node */
+				while (p_next_sw != (ftree_sw_t *) cl_qmap_end(&p_ftree->sw_tbl)) {
+					p_ftree_sw = p_next_sw;
+					p_next_sw = (ftree_sw_t *) cl_qmap_next(&p_ftree_sw->map_item);
+					p_ftree_sw->hops[0] = OSM_NO_PATH;
+					p_ftree_sw->p_osm_sw->new_lft[0] = OSM_NO_PATH;
+				}
+
 			}
 		}
 	}
@@ -2929,7 +2902,6 @@ static void fabric_route_to_non_cns(IN ftree_fabric_t * p_ftree)
 			fabric_route_downgoing_by_going_up(p_ftree, p_sw,	/* local switch - used as a route-downgoing alg. start point */
 							   NULL,	/* prev. position switch */
 							   hca_lid,	/* LID that we're routing to */
-							   TRUE,	/* whether this HCA LID is real or dummy */
 							   TRUE,	/* whether this path to HCA should by tracked by counters */
 							   FALSE,	/* Whether the target LID is a switch or not */
 							   p_hca_port_group->is_io ? p_ftree->p_osm->subn.opt.max_reverse_hops : 0,	/* Number or reverse hops allowed */
@@ -2982,7 +2954,6 @@ static void fabric_route_to_switches(IN ftree_fabric_t * p_ftree)
 		fabric_route_downgoing_by_going_up(p_ftree, p_sw,	/* local switch - used as a route-downgoing alg. start point */
 						   NULL,	/* prev. position switch */
 						   p_sw->base_lid,	/* LID that we're routing to */
-						   TRUE,	/* whether the target LID is a real or dummy */
 						   FALSE,	/* whether this path to HCA should by tracked by counters */
 						   TRUE,	/* Whether the target LID is a switch or not */
 						   0,	/* Number of reverse hops allowed */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
