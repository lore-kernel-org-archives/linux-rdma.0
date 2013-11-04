From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix timeout handling for pkeyGet for sw port 0
Date: Mon, 04 Nov 2013 07:52:56 -0500
Message-ID: <527798A8.2020001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove node in addition to port when getting timeout for
pkeyGet for sw port 0.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 85a6f58..11c1561 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -535,7 +535,15 @@ void osm_drop_mgr_process(osm_sm_t * sm)
 			drop_mgr_process_node(sm, p_node);
 		else {
 			/*
-			 * Drop port if there was timeout for GetPKeyTable
+			 * We want to preserve the configured pkey indexes,
+			 * so if we don't receive GetResp P_KeyTable for some block,
+			 * do the following:
+			 *   1. Drop node if the node is sw and got timeout for port 0.
+			 *   2. Drop node if node is HCA/RTR.
+			 *   3. Drop only physp if got timeout for sw when the port isn't 0.
+			 * We'll set error during initialization in order to
+			 * cause an immediate heavy sweep and try to get the
+			 * configured P_KeyTable again.
 			 */
 			if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH)
 				port_num = 0;
@@ -547,12 +555,12 @@ void osm_drop_mgr_process(osm_sm_t * sm)
 				if (!p_physp || p_physp->pkeys.rcv_blocks_cnt == 0)
 					continue;
 				sm->p_subn->subnet_initialization_error = TRUE;
-				if (!port_num || osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH) {
-					port_guid = osm_physp_get_port_guid(p_physp);
-					p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
-					p_port->discovery_count = 0;
-				} else
+				port_guid = osm_physp_get_port_guid(p_physp);
+				p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
+				if (p_node->physp_discovered[port_num]) {
 					p_node->physp_discovered[port_num] = 0;
+					p_port->discovery_count--;
+				}
 			}
 		}
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
