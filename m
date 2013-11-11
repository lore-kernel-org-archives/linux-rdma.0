From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2 opensm] osm_link_mgr.c: fix uninitialized variable usage
Date: Mon, 11 Nov 2013 15:23:26 -0500
Message-ID: <52813CBE.40203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

PortInfo may be sent without the correct M_Key

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 2420e4f..5fdb7ca 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -149,6 +149,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			goto Exit;
 		}
 
+		physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
+
 		if (ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info)
 		    == FALSE) {
 
@@ -190,6 +192,13 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	p_pi->state_info2 = 0x02;
 	ib_port_info_set_port_state(p_pi, port_state);
 
+	/* Determine ports' M_Key */
+	if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH &&
+	    osm_physp_get_port_num(p_physp) != 0)
+		m_key = ib_port_info_get_m_key(&physp0->port_info);
+	else
+		m_key = ib_port_info_get_m_key(p_pi);
+
 	/* Check whether this is base port0 smsl handling only */
 	if (port_num == 0 && esp0 == FALSE) {
 		ib_port_info_set_master_smsl(p_pi, smsl);
@@ -369,13 +378,10 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 
 		if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH &&
 		    osm_physp_get_port_num(p_physp) != 0) {
-			physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
 			cap_mask = physp0->port_info.capability_mask;
-			m_key = ib_port_info_get_m_key(&physp0->port_info);
-		} else {
+		} else
 			cap_mask = p_pi->capability_mask;
-			m_key = ib_port_info_get_m_key(p_pi);
-		}
+
 		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
 			issue_ext = 1;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
