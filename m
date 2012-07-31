From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 24/27] opensm/osm_node_info_rcv.c: Handle non-compliant SMA gracefully
Date: Tue, 31 Jul 2012 19:04:52 +0300
Message-ID: <1343750695-28063-24-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If NodeInfo.LocalPortNum > NodeInfo.NumPorts, then SMA is
not compliant. In this case, ignore the node and don't add
it to any subnet data structures.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index c35aea4..75ab853 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -624,6 +624,17 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)
 		ib_get_node_type_str(p_ni->node_type),
 		cl_ntoh64(p_ni->node_guid), cl_ntoh64(p_smp->trans_id));
 
+	if (port_num > p_ni->num_ports) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0A: "
+			"New %s node GUID 0x%" PRIx64 "is non-compliant and "
+			"is being ignored since the "
+			"local port num %u > num ports %u\n",
+			ib_get_node_type_str(p_ni->node_type),
+			cl_ntoh64(p_ni->node_guid), port_num,
+			p_ni->num_ports);
+		goto Exit;
+	}
+
 	p_node = osm_node_new(p_madw);
 	if (p_node == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D07: "
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
