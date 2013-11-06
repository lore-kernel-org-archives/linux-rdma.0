From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_drop_mgr.c: fix timeouts on Get Pkey from ext
 switch ports
Date: Wed, 06 Nov 2013 12:48:07 -0500
Message-ID: <527A80D7.8070706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case SM doesn't recieve PkeyTable GetResp from external switch ports,
it should clear the PkeyTable GetResp counter and set physp->need_update
= 2, in order to resend PkeyTable Get on the next sweep.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_drop_mgr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 7e7c7f6..cb685cb 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -582,6 +582,8 @@ void osm_drop_mgr_process(osm_sm_t * sm)
 				p_physp = osm_node_get_physp_ptr(p_node, port_num);
 				if (!p_physp || p_physp->pkeys.rcv_blocks_cnt == 0)
 					continue;
+				p_physp->pkeys.rcv_blocks_cnt = 0;
+				p_physp->need_update = 2;
 				sm->p_subn->subnet_initialization_error = TRUE;
 				port_guid = osm_physp_get_port_guid(p_physp);
 				p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
