From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_node_info_rcv.c: Update local copy of node info
 for known nodes
Date: Mon, 10 Mar 2014 11:58:06 -0400
Message-ID: <531DE10E.7060309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 6 Mar 2014 16:33:21 +0200

Update local copy of node info when it receives node info for existing
node.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index a953c54..d445cc2 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -1137,9 +1137,9 @@ static void ni_rcv_process_existing(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			PRIx64 " for node 0x%" PRIx64 "\n",
 			cl_ntoh64(p_ni->sys_guid),
 			cl_ntoh64(p_ni->node_guid));
-		p_node->node_info.sys_guid = p_ni->sys_guid;
 	}
 	ni_rcv_set_links(sm, p_node, port_num, p_ni_context);
+	p_node->node_info = *p_ni;
 
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
