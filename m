From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_node_info_rcv.c: remove useless code line
Date: Tue, 7 Sep 2010 17:58:53 +0300
Message-ID: <4C86532D.3040409@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_node_info_rcv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_node_info_rcv.c b/opensm/opensm/osm_node_info_rcv.c
index d24e757..1041e42 100644
--- a/opensm/opensm/osm_node_info_rcv.c
+++ b/opensm/opensm/osm_node_info_rcv.c
@@ -436,7 +436,6 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
 		if (sm->p_subn->sm_state == IB_SMINFO_STATE_MASTER)
 			p_port->is_new = 1;

-		p_physp = osm_node_get_physp_ptr(p_node, port_num);
 	} else {
 		p_physp = osm_node_get_physp_ptr(p_node, port_num);
 		/*
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
