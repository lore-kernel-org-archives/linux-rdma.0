From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_node_info_rcv.c: Update NodeInfo.SysImageGUID
 on heavy sweep
Date: Mon, 10 Mar 2014 11:57:33 -0400
Message-ID: <531DE0ED.2000005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 7 Aug 2012 10:58:16 +0300

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 499d9cb..622644e 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -864,6 +864,13 @@ static void ni_rcv_process_existing(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		break;
 	}
 
+	if ( p_ni->sys_guid != p_node->node_info.sys_guid) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "Updated SysImageGUID: 0x%"
+			PRIx64 " for node 0x%" PRIx64 "\n",
+			cl_ntoh64(p_ni->sys_guid),
+			cl_ntoh64(p_ni->node_guid));
+		p_node->node_info.sys_guid = p_ni->sys_guid;
+	}
 	ni_rcv_set_links(sm, p_node, port_num, p_ni_context);
 
 Exit:
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
