From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_perfmgr.c: Don't rely on PortInfo:PortState
 for base SP0
Date: Mon, 18 Apr 2011 09:29:57 -0400
Message-ID: <4DAC3CD5.8000700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


For base SP0, PortState in SM PortInfo attribute is not used and base SP0
is always "active".

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 6a1fa63..86efde6 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -684,6 +684,10 @@ static unsigned is_sm_port_down(osm_sm_t * sm)
 	}
 	CL_PLOCK_RELEASE(sm->p_lock);
 
+	if (p_port->p_node->sw &&
+	    !ib_switch_info_is_enhanced_port0(&p_port->p_node->sw->switch_info))
+		return 0;	/* base SP0 */
+
 	return osm_physp_get_port_state(p_port->p_physp) == IB_LINK_DOWN;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
