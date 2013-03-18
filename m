From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_port_info_rcv.c: Fix min_sw_data_vls calculation
Date: Mon, 18 Mar 2013 11:40:18 -0400
Message-ID: <51473562.8060805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Only update min_sw_data_vls when peer port is another switch port

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 84f9fb1..2ea35b8 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -327,16 +327,22 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
 			goto Exit;
 
-		data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
-		if (data_vls >= IB_MAX_NUM_VLS)
-			data_vls = IB_MAX_NUM_VLS - 1;
-		if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
-			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-				"Setting switch port minimal data VLs to:%u defined by node:0x%"
-				PRIx64 ", port:%u\n", data_vls,
-				cl_ntoh64(osm_node_get_node_guid(p_node)),
-				port_num);
-			sm->p_subn->min_sw_data_vls = data_vls;
+		p_remote_physp = osm_physp_get_remote(p_physp);
+		if (p_remote_physp) {
+			p_remote_node = osm_physp_get_node_ptr(p_remote_physp);
+			if (p_remote_node->sw) {
+				data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+				if (data_vls >= IB_MAX_NUM_VLS)
+					data_vls = IB_MAX_NUM_VLS - 1;
+				if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
+					OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+						"Setting switch port minimal data VLs to:%u defined by node:0x%"
+						PRIx64 ", port:%u\n", data_vls,
+						cl_ntoh64(osm_node_get_node_guid(p_node)),
+						port_num);
+					sm->p_subn->min_sw_data_vls = data_vls;
+				}
+			}
 		}
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
