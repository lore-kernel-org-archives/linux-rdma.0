From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_link_mgr.c: Fix uninitialized value (physp0)
Date: Tue, 12 Nov 2013 16:27:42 -0500
Message-ID: <52829D4E.9070802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

physp0 might be uninitialized

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 44bfbe6..6bcfbf6 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -135,6 +135,9 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			send_set = TRUE;
 	}
 
+	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH)
+		physp0 = osm_node_get_physp_ptr(p_node, 0);
+
 	if (port_num == 0) {
 		/*
 		   CAs don't have a port 0, and for switch port 0,
@@ -149,8 +152,6 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			goto Exit;
 		}
 
-		physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
-
 		if (ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info)
 		    == FALSE) {
 
@@ -193,7 +194,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	ib_port_info_set_port_state(p_pi, port_state);
 
 	/* Determine ports' M_Key */
-	if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH &&
+	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH &&
 	    osm_physp_get_port_num(p_physp) != 0)
 		m_key = ib_port_info_get_m_key(&physp0->port_info);
 	else
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
