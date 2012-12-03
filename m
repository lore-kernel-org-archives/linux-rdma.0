From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_port_info_rcv.c: Don't modify subnet minimal values
 when PortState DOWN
Date: Mon, 03 Dec 2012 16:26:08 -0500
Message-ID: <50BD18F0.4030900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

as they are vendor dependent fields in PortInfo and can't be relied on due to:

C14-24.2.1: If PortInfo:Portstate=Down, then
o a SubnGet(PortInfo) shall produce valid data for PortInfo:PortState
  and PortInfo:PortPhysicalState; whether any other component has
  valid data is vendor-dependent.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 6f6922c..859a6be 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -94,7 +94,8 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 	port_guid = osm_physp_get_port_guid(p_physp);
 
 	/* HACK extended port 0 should be handled too! */
-	if (osm_physp_get_port_num(p_physp) != 0) {
+	if (osm_physp_get_port_num(p_physp) != 0 &&
+	    ib_port_info_get_port_state(p_pi) != IB_LINK_DOWN) {
 		/* track the minimal endport MTU, rate, and operational VLs */
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 		if (mtu < sm->p_subn->min_ca_mtu) {
@@ -323,6 +324,9 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			p_physp->port_info = *p_pi;
 		pi_rcv_process_endport(sm, p_physp, p_pi);
 	} else {
+		if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
+			goto Exit;
+
 		/* track the minimal switch ext port MTU, rate, and operational VLs */
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 		if (mtu < sm->p_subn->min_sw_mtu) {
@@ -358,6 +362,7 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		}
 	}
 
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
