From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Add a couple of asserts
Date: Wed, 30 May 2012 10:33:31 -0400
Message-ID: <4FC62FBB.30107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, fix some commentary typos

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index ee4c34b..1233310 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -519,6 +519,7 @@ static void port_group_add_port(IN ftree_port_group_t * p_group,
 	}
 
 	p_port = port_create(port_num, remote_port_num);
+	CL_ASSERT(p_port);
 	cl_ptr_vector_insert(&p_group->ports, p_port, NULL);
 }
 
@@ -765,7 +766,7 @@ static int set_hops_on_remote_sw(IN ftree_port_group_t * p_group,
 	CL_ASSERT(p_group->remote_node_type == IB_NODE_TYPE_SWITCH);
 	p_remote_sw->hops[target_lid] = hops;
 
-	/* If taget lid is a switch we set the min hop table values
+	/* If target lid is a switch we set the min hop table values
 	 * for each port on the associated osm_sw struct */
 	if (!is_target_sw)
 		return 0;
@@ -911,6 +912,7 @@ static void hca_add_port(IN ftree_hca_t * p_hca, IN uint8_t port_num,
 					    remote_port_guid, remote_node_guid,
 					    remote_node_type,
 					    p_remote_hca_or_sw, is_cn, is_io);
+		CL_ASSERT(p_group);
 		p_hca->up_port_groups[p_hca->up_port_groups_num++] = p_group;
 	}
 	port_group_add_port(p_group, port_num, remote_port_num);
@@ -2278,7 +2280,7 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 							    target_lid,	/* LID that we're routing to */
 							    is_real_lid,	/* whether the target LID is real or dummy */
 							    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
-							    is_target_a_sw,	/* Wheter target lid is a switch or not */
+							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    current_hops + 1);	/* Number of hops done to this point */
 		created_route |= routed;
 		/* Counters are promoted only if a route toward a node is created */
@@ -2345,7 +2347,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 							   target_lid,	/* LID that we're routing to */
 							   is_real_lid,	/* whether this target LID is real or dummy */
 							   is_main_path,	/* whether this path to HCA should by tracked by counters */
-							   is_target_a_sw,	/* Wheter target lid is a switch or not */
+							   is_target_a_sw,	/* Whether target lid is a switch or not */
 							   current_hops);	/* Number of hops done up to this point */
 
 	/* recursion stop condition - if it's a root switch, */
@@ -2373,7 +2375,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 										    target_lid,	/* LID that we're routing to */
 										    is_real_lid,	/* whether this target LID is real or dummy */
 										    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
-										    is_target_a_sw,	/* Wheter target lid is a switch or not */
+										    is_target_a_sw,	/* Whether target lid is a switch or not */
 										    reverse_hop_credit - 1,	/* Remaining reverse_hops allowed */
 										    reverse_hops + 1,	/* Number of reverse_hops done up to this point */
 										    current_hops
@@ -2502,7 +2504,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 										    target_lid,	/* LID that we're routing to */
 										    is_real_lid,	/* whether this target LID is real or dummy */
 										    is_main_path,	/* whether this is path to HCA that should by tracked by counters */
-										    is_target_a_sw,	/* Wheter target lid is a switch or not */
+										    is_target_a_sw,	/* Whether target lid is a switch or not */
 										    reverse_hop_credit,	/* Remaining reverse_hops allowed */
 										    reverse_hops,	/* Number of reverse_hops done up to this point */
 										    current_hops
@@ -2568,7 +2570,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		/* Routing REAL lids on SECONDARY path means routing
 		   switch-to-switch or switch-to-CA paths.
 		   We can safely assume that switch will initiate very
-		   few traffic, so there's no point waisting runtime on
+		   few traffic, so there's no point wasting runtime on
 		   trying to balance these routes - always pick port 0. */
 		p_min_port = NULL;
 		ports_num = (uint16_t) cl_ptr_vector_get_size(&p_group->ports);
@@ -2602,7 +2604,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 							    target_lid,	/* LID that we're routing to */
 							    TRUE,	/* whether the target LID is real or dummy */
 							    FALSE,	/* whether this is path to HCA that should by tracked by counters */
-							    is_target_a_sw,	/* Wheter target lid is a switch or not */
+							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    reverse_hop_credit,	/* Remaining reverse_hops allowed */
 							    reverse_hops,	/* Number of reverse_hops done up to this point */
 							    current_hops + 1);
@@ -2635,7 +2637,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 		/* Routing REAL lids on SECONDARY path means routing
 		   switch-to-switch or switch-to-CA paths.
 		   We can safely assume that switch will initiate very
-		   few traffic, so there's no point waisting runtime on
+		   few traffic, so there's no point wasting runtime on
 		   trying to balance these routes - always pick port 0. */
 
 		p_min_port = NULL;
@@ -2670,7 +2672,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 							    target_lid,	/* LID that we're routing to */
 							    TRUE,	/* whether the target LID is real or dummy */
 							    FALSE,	/* whether this is path to HCA that should by tracked by counters */
-							    is_target_a_sw,	/* Wheter target lid is a switch or not */
+							    is_target_a_sw,	/* Whether target lid is a switch or not */
 							    reverse_hop_credit,	/* Remaining reverse_hops allowed */
 							    reverse_hops,	/* Number of reverse_hops done up to this point */
 							    current_hops + 1);
@@ -2707,7 +2709,7 @@ fabric_route_downgoing_by_going_up(IN ftree_fabric_t * p_ftree,
 								    target_lid,	/* LID that we're routing to */
 								    TRUE,	/* whether the target LID is real or dummy */
 								    TRUE,	/* whether this is path to HCA that should by tracked by counters */
-								    is_target_a_sw,	/* Wheter target lid is a switch or not */
+								    is_target_a_sw,	/* Whether target lid is a switch or not */
 								    reverse_hop_credit - 1,	/* Remaining reverse_hops allowed */
 								    reverse_hops + 1,	/* Number of reverse_hops done up to this point */
 								    current_hops
@@ -2797,7 +2799,7 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 							   hca_lid,	/* LID that we're routing to */
 							   TRUE,	/* whether this HCA LID is real or dummy */
 							   TRUE,	/* whether this path to HCA should by tracked by counters */
-							   FALSE,	/* wheter target lid is a switch or not */
+							   FALSE,	/* whether target lid is a switch or not */
 							   0,	/* Number of reverse hops allowed */
 							   0,	/* Number of reverse hops done yet */
 							   1);	/* Number of hops done yet */
@@ -2823,7 +2825,7 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 								   0,	/* LID that we're routing to - ignored for dummy HCA */
 								   FALSE,	/* whether this HCA LID is real or dummy */
 								   TRUE,	/* whether this path to HCA should by tracked by counters */
-								   FALSE,	/* Wheter the target LID is a switch or not */
+								   FALSE,	/* Whether the target LID is a switch or not */
 								   0,	/* Number of reverse hops allowed */
 								   0,	/* Number of reverse hops done yet */
 								   1);	/* Number of hops done yet */
@@ -2910,7 +2912,7 @@ static void fabric_route_to_non_cns(IN ftree_fabric_t * p_ftree)
 							   hca_lid,	/* LID that we're routing to */
 							   TRUE,	/* whether this HCA LID is real or dummy */
 							   TRUE,	/* whether this path to HCA should by tracked by counters */
-							   FALSE,	/* Wheter the target LID is a switch or not */
+							   FALSE,	/* Whether the target LID is a switch or not */
 							   p_hca_port_group->is_io ? p_ftree->p_osm->subn.opt.max_reverse_hops : 0,	/* Number or reverse hops allowed */
 							   0,	/* Number or reverse hops done yet */
 							   1);	/* Number of hops done yet */
@@ -2963,7 +2965,7 @@ static void fabric_route_to_switches(IN ftree_fabric_t * p_ftree)
 						   p_sw->base_lid,	/* LID that we're routing to */
 						   TRUE,	/* whether the target LID is a real or dummy */
 						   FALSE,	/* whether this path to HCA should by tracked by counters */
-						   TRUE,	/* Wheter the target LID is a switch or not */
+						   TRUE,	/* Whether the target LID is a switch or not */
 						   0,	/* Number of reverse hops allowed */
 						   0,	/* Number of reverse hops done yet */
 						   0);	/* Number of hops done yet */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
