From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_sa_portinfo_record.c: In pir_rcv_new_pir,
 fix switch port 0 physp
Date: Wed, 17 Aug 2011 14:39:48 -0400
Message-ID: <4E4C0AF4.6000400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


use requested rather than requesting port

Found and fixed by Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_portinfo_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index e8631a1..6a2a520 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -109,7 +109,7 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 		/* Does requested port have an extended link speed active ? */
 		if (osm_node_get_type(p_physp->p_node) ==
 		    IB_NODE_TYPE_SWITCH) {
-			p_physp0 = osm_node_get_physp_ptr(p_ctxt->p_req_physp->p_node, 0);
+			p_physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
 			p_pi = &p_physp0->port_info;
 		} else
 			p_pi = (ib_port_info_t *) &p_physp->port_info;
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
