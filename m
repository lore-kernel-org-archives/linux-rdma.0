From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm: Added print_desc to various log messages
Date: Fri, 04 Dec 2009 15:26:17 +0100
Message-ID: <4B191C09.90900@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added print_desc to various log messages to make it easier to
identify the node

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_lin_fwd_rcv.c b/opensm/opensm/osm_lin_fwd_rcv.c
index c686f3b..ef33df3 100644
--- a/opensm/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/opensm/osm_lin_fwd_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -89,8 +90,9 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 		if (status != IB_SUCCESS) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0402: "
 				"Setting forwarding table block failed (%s)"
-				"\n\t\t\t\tSwitch 0x%" PRIx64 "\n",
-				ib_get_err_str(status), cl_ntoh64(node_guid));
+				", Switch 0x%" PRIx64 " %s\n",
+				ib_get_err_str(status), cl_ntoh64(node_guid),
+				p_sw->p_node->print_desc);
 		}
 	}
 
diff --git a/opensm/opensm/osm_mcast_fwd_rcv.c b/opensm/opensm/osm_mcast_fwd_rcv.c
index 0fbc95a..917233e 100644
--- a/opensm/opensm/osm_mcast_fwd_rcv.c
+++ b/opensm/opensm/osm_mcast_fwd_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -107,10 +108,10 @@ void osm_mft_rcv_process(IN void *context, IN void *data)
 		if (status != IB_SUCCESS) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0802: "
 				"Setting MFT block failed (%s)"
-				"\n\t\t\t\tSwitch 0x%016" PRIx64
-				", block %u, position %u\n",
-				ib_get_err_str(status),
-				cl_ntoh64(node_guid), block_num, position);
+				", Switch 0x%016" PRIx64
+				" (%s), block %u, position %u\n",
+				ib_get_err_str(status), cl_ntoh64(node_guid),
+				p_sw->p_node->print_desc, block_num, position);
 		}
 	}
 
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 616584f..697fb58 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -270,9 +271,9 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 
 	if (p_best_sw)
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-			"Best switch is 0x%" PRIx64 ", hops = %f\n",
+			"Best switch is 0x%" PRIx64 " (%s), hops = %f\n",
 			cl_ntoh64(osm_node_get_node_guid(p_best_sw->p_node)),
-			best_hops);
+			p_best_sw->p_node->print_desc, best_hops);
 	else
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"No multicast capable switches detected\n");
@@ -352,8 +353,8 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 				     &context);
 		if (status != IB_SUCCESS) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A02: "
-				"Sending multicast fwd. tbl. block failed (%s)\n",
-				ib_get_err_str(status));
+				"Sending multicast fwd. tbl. block to %s failed (%s)\n",
+				p_node->print_desc, ib_get_err_str(status));
 			ret = -1;
 		}
 	}
@@ -404,9 +405,10 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 			    cl_ntoh64(osm_node_get_node_guid(p_sw->p_node));
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A03: "
 				"Error routing MLID 0x%X through switch 0x%"
-				PRIx64 "\n"
+				PRIx64 " %s\n"
 				"\t\t\t\tNo multicast paths from this switch "
 				"for port with LID %u\n", mlid_ho, node_guid_ho,
+				p_sw->p_node->print_desc,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 			mcast_work_obj_delete(p_wobj);
@@ -418,9 +420,10 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 			    cl_ntoh64(osm_node_get_node_guid(p_sw->p_node));
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A04: "
 				"Error routing MLID 0x%X through switch 0x%"
-				PRIx64 "\n"
+				PRIx64 " %s\n"
 				"\t\t\t\tNo multicast paths from this switch "
 				"to port with LID %u\n", mlid_ho, node_guid_ho,
+				p_sw->p_node->print_desc,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 			mcast_work_obj_delete(p_wobj);
@@ -486,8 +489,9 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 		"Routing MLID 0x%X through switch 0x%" PRIx64
-		", %u nodes at depth %u\n",
-		mlid_ho, node_guid_ho, cl_qlist_count(p_list), depth);
+		" %s, %u nodes at depth %u\n",
+		mlid_ho, node_guid_ho, p_sw->p_node->print_desc,
+		cl_qlist_count(p_list), depth);
 
 	CL_ASSERT(cl_qlist_count(p_list) > 0);
 
@@ -511,8 +515,8 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 		   This switch doesn't do multicast.  Clean-up.
 		 */
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A14: "
-			"Switch 0x%" PRIx64 " does not support multicast\n",
-			node_guid_ho);
+			"Switch 0x%" PRIx64 " %s does not support multicast\n",
+			node_guid_ho, p_sw->p_node->print_desc);
 
 		/*
 		   Deallocate all the work objects on this branch of the tree.
diff --git a/opensm/opensm/osm_pkey_mgr.c b/opensm/opensm/osm_pkey_mgr.c
index df2cc20..f2e0cc3 100644
--- a/opensm/opensm/osm_pkey_mgr.c
+++ b/opensm/opensm/osm_pkey_mgr.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -193,10 +194,11 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	if ((p_pi->vl_enforce & 0xc) == (0xc) * (enforce == TRUE)) {
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"No need to update PortInfo for "
-			"node 0x%016" PRIx64 " port %u\n",
+			"node 0x%016" PRIx64 " port %u (%s)\n",
 			cl_ntoh64(osm_node_get_node_guid
 				  (osm_physp_get_node_ptr(p_physp))),
-			osm_physp_get_port_num(p_physp));
+			osm_physp_get_port_num(p_physp),
+			p_physp->p_node->print_desc);
 		return IB_SUCCESS;
 	}
 
@@ -227,16 +229,18 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	if (status != IB_SUCCESS)
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0511: "
 			"Failed to set PortInfo for "
-			"node 0x%016" PRIx64 " port %u\n",
+			"node 0x%016" PRIx64 " port %u (%s)\n",
 			cl_ntoh64(osm_node_get_node_guid
 				  (osm_physp_get_node_ptr(p_physp))),
-			osm_physp_get_port_num(p_physp));
+			osm_physp_get_port_num(p_physp),
+			p_physp->p_node->print_desc);
 	else
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
-			"Set PortInfo for node 0x%016" PRIx64 " port %u\n",
+			"Set PortInfo for node 0x%016" PRIx64 " port %u (%s)\n",
 			cl_ntoh64(osm_node_get_node_guid
 				  (osm_physp_get_node_ptr(p_physp))),
-			osm_physp_get_port_num(p_physp));
+			osm_physp_get_port_num(p_physp),
+			p_physp->p_node->print_desc);
 	return status;
 }
 
@@ -273,10 +277,11 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (p_pkey_tbl->max_blocks > max_num_of_blocks) {
 		OSM_LOG(p_log, OSM_LOG_INFO,
 			"Max number of blocks reduced from %u to %u "
-			"for node 0x%016" PRIx64 " port %u\n",
+			"for node 0x%016" PRIx64 " port %u (%s)\n",
 			p_pkey_tbl->max_blocks, max_num_of_blocks,
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
-			osm_physp_get_port_num(p_physp));
+			osm_physp_get_port_num(p_physp),
+			p_physp->p_node->print_desc);
 	}
 	p_pkey_tbl->max_blocks = max_num_of_blocks;
 
@@ -302,11 +307,12 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 			if (!found) {
 				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0504: "
 					"Failed to find empty space for new pkey 0x%04x "
-					"for node 0x%016" PRIx64 " port %u\n",
+					"for node 0x%016" PRIx64 " port %u (%s)\n",
 					cl_ntoh16(p_pending->pkey),
 					cl_ntoh64(osm_node_get_node_guid
 						  (p_node)),
-					osm_physp_get_port_num(p_physp));
+					osm_physp_get_port_num(p_physp),
+					p_physp->p_node->print_desc);
 			} else {
 				block_index = last_free_block_index;
 				pkey_index = last_free_pkey_index++;
@@ -320,12 +326,13 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 						       p_pending->pkey)) {
 				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0505: "
 					"Failed to set PKey 0x%04x in block %u idx %u "
-					"for node 0x%016" PRIx64 " port %u\n",
+					"for node 0x%016" PRIx64 " port %u (%s)\n",
 					cl_ntoh16(p_pending->pkey), block_index,
 					pkey_index,
 					cl_ntoh64(osm_node_get_node_guid
 						  (p_node)),
-					osm_physp_get_port_num(p_physp));
+					osm_physp_get_port_num(p_physp),
+					p_physp->p_node->print_desc);
 			}
 		}
 
@@ -350,16 +357,18 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 		if (status == IB_SUCCESS)
 			OSM_LOG(p_log, OSM_LOG_DEBUG,
 				"Updated pkey table block %d for node 0x%016"
-				PRIx64 " port %u\n", block_index,
+				PRIx64 " port %u (%s)\n", block_index,
 				cl_ntoh64(osm_node_get_node_guid(p_node)),
-				osm_physp_get_port_num(p_physp));
+				osm_physp_get_port_num(p_physp),
+				p_physp->p_node->print_desc);
 		else {
 			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0506: "
 				"pkey_mgr_update_pkey_entry() failed to update "
 				"pkey table block %d for node 0x%016" PRIx64
-				" port %u\n", block_index,
+				" port %u (%s)\n", block_index,
 				cl_ntoh64(osm_node_get_node_guid(p_node)),
-				osm_physp_get_port_num(p_physp));
+				osm_physp_get_port_num(p_physp),
+				p_physp->p_node->print_desc);
 			ret = -1;
 		}
 	}
@@ -403,10 +412,11 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (peer_max_blocks < p_pkey_tbl->used_blocks) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
 			"Not enough pkey entries (%u < %u) on switch 0x%016"
-			PRIx64 " port %u. Clearing Enforcement bit\n",
+			PRIx64 " port %u (%s). Clearing Enforcement bit\n",
 			peer_max_blocks, num_of_blocks,
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
-			osm_physp_get_port_num(peer));
+			osm_physp_get_port_num(peer),
+			p_node->print_desc);
 		enforce = FALSE;
 		ret = -1;
 	}
@@ -434,10 +444,11 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0509: "
 					"pkey_mgr_update_pkey_entry() failed to update "
 					"pkey table block %d for node 0x%016"
-					PRIx64 " port %u\n", block_index,
+					PRIx64 " port %u (%s)\n", block_index,
 					cl_ntoh64(osm_node_get_node_guid
 						  (p_node)),
-					osm_physp_get_port_num(peer));
+					osm_physp_get_port_num(peer),
+					p_node->print_desc);
 				ret = -1;
 			}
 		}
@@ -446,9 +457,9 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (!ret)
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"Pkey table was updated for node 0x%016" PRIx64
-			" port %u\n",
+			" port %u (%s)\n",
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
-			osm_physp_get_port_num(peer));
+			osm_physp_get_port_num(peer), p_node->print_desc);
 
 	return ret;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
