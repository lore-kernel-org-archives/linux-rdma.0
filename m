From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] opensm/osm_state_mgr.c Added more info to some error messages
Date: Fri, 27 Nov 2009 14:14:48 +0100
Message-ID: <4B0FD0C8.9020200@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added status_value and print_desc to some error messages

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 7540adc..05c31f7 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
@@ -136,7 +137,8 @@ static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3304: "
-			"Request for SwitchInfo failed\n");
+			"Request for SwitchInfo failed (%s)\n",
+			ib_get_err_str(status));
 
 	OSM_LOG_EXIT(sm->p_log);
 }
@@ -182,7 +184,8 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 332E: "
-			"Request for PortInfo failed\n");
+			"Request for PortInfo failed (%s)\n",
+			ib_get_err_str(status));
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
@@ -241,7 +244,8 @@ static ib_api_status_t state_mgr_sweep_hop_0(IN osm_sm_t * sm)
 
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3305: "
-				"Request for NodeInfo failed\n");
+				"Request for NodeInfo failed (%s)\n",
+				ib_get_err_str(status));
 	} else {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"No bound ports. Deferring sweep...\n");
@@ -441,7 +445,8 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 				     CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3311: "
-				"Request for NodeInfo failed\n");
+				"Request for NodeInfo failed (%s)\n",
+				ib_get_err_str(status));
 		break;
 
 	case IB_NODE_TYPE_SWITCH:
@@ -474,7 +479,8 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 				if (status != IB_SUCCESS)
 					OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 						"ERR 3312: "
-						"Request for NodeInfo failed\n");
+						"Request for NodeInfo failed (%s)\n",
+						ib_get_err_str(status));
 			}
 		}
 		break;
@@ -617,14 +623,14 @@ static ib_api_status_t state_mgr_light_sweep_start(IN osm_sm_t * sm)
 				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3315: "
 					"Unknown remote side for node 0x%016"
 					PRIx64
-					"(%s) port %u. Adding to light sweep sampling list\n",
+					" (%s) port %u. Adding to light sweep sampling list\n",
 					cl_ntoh64(osm_node_get_node_guid
 						  (p_node)),
 					p_node->print_desc, port_num);
 
 				osm_dump_dr_path(sm->p_log,
 						 osm_physp_get_dr_path_ptr
-						 (p_physp), OSM_LOG_ERROR);
+						 (p_physp), OSM_LOG_INFO);
 
 				state_mgr_get_remote_port_info(sm, p_physp);
 			}
@@ -861,7 +867,7 @@ static void state_mgr_report_new_ports(IN osm_sm_t * sm)
 		osm_port_get_lid_range_ho(p_port, &min_lid_ho, &max_lid_ho);
 		OSM_LOG(sm->p_log, OSM_LOG_INFO,
 			"Discovered new port with GUID:0x%016" PRIx64
-			" LID range [%u,%u] of node:%s\n",
+			" LID range [%u,%u] of node: %s\n",
 			cl_ntoh64(port_gid.unicast.interface_id),
 			min_lid_ho, max_lid_ho,
 			p_port->p_node ? p_port->p_node->
@@ -1003,8 +1009,9 @@ static void cleanup_switch(cl_map_item_t * item, void *log)
 
 	if (memcmp(sw->lft, sw->new_lft, sw->max_lid_ho + 1))
 		osm_log(log, OSM_LOG_ERROR, "ERR 331D: "
-			"LFT of switch 0x%016" PRIx64 " is not up to date\n",
-			cl_ntoh64(sw->p_node->node_info.node_guid));
+			"LFT of switch 0x%016" PRIx64 " (%s) is not up to date\n",
+			cl_ntoh64(sw->p_node->node_info.node_guid),
+			sw->p_node->print_desc);
 	else {
 		free(sw->new_lft);
 		sw->new_lft = NULL;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
