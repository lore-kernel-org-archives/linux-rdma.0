From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm/osm_sa_portinfo_record.c: Add SA PortInfoRecord
 support for CapabilityMask2 matching
Date: Wed, 17 Aug 2011 14:40:13 -0400
Message-ID: <4E4C0B0D.9010608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_portinfo_record.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 6a2a520..5aa599a 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -402,6 +402,21 @@ static void sa_pir_check_physp(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 		    ib_port_info_get_overrun_err_thd(p_pi))
 			goto Exit;
 	}
+
+	/* IBTA 1.2 errata provides support for bitwise compare if the bit 31
+	   of the attribute modifier of the Get/GetTable is set */
+	if (comp_mask & IB_PIR_COMPMASK_CAPMASK2) {
+		if (p_ctxt->is_enhanced_comp_mask) {
+			if ((cl_ntoh16(p_comp_pi->capability_mask2) &
+			     cl_ntoh16(p_pi->capability_mask2)) !=
+			     cl_ntoh16(p_comp_pi->capability_mask2))
+				goto Exit;
+		} else {
+			if (cl_ntoh16(p_comp_pi->capability_mask2) !=
+			    cl_ntoh16(p_pi->capability_mask2))
+				goto Exit;
+		}
+	}
 	if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH) {
 		p_physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
 		cap_mask = p_physp0->port_info.capability_mask;
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
