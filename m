From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_link_mgr.c: active_transition parameter in PortInfo(Set)
 context may not be initialized
Date: Mon, 28 Oct 2013 08:12:05 -0400
Message-ID: <526E5495.6070402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 98126f1..0d00984 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -440,13 +440,12 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	}
 
 Send:
+	context.pi_context.active_transition = FALSE;
 	if (port_state != IB_LINK_NO_CHANGE &&
 	    port_state != ib_port_info_get_port_state(p_old_pi)) {
 		send_set = TRUE;
 		if (port_state == IB_LINK_ACTIVE)
 			context.pi_context.active_transition = TRUE;
-		else
-			context.pi_context.active_transition = FALSE;
 	}
 
 	context.pi_context.node_guid = osm_node_get_node_guid(p_node);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
