From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_port_info_rcv.c: Handle non-compliant SMA gracefully
Date: Thu, 28 Jun 2012 13:12:06 -0400
Message-ID: <4FEC9066.6000405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


If PortInfo.LocalPortNum > NodeInfo.NumPorts, then SMA is
not compliant. In this case, ignore the portinfo response.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index a4f81a8..d243bb2 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -552,6 +552,18 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 	p_node = p_port->p_node;
 	CL_ASSERT(p_node);
 
+	if (p_pi->local_port_num > p_node->node_info.num_ports) {
+		CL_PLOCK_RELEASE(sm->p_lock);
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F09: "
+			"PortInfo from %s node GUID 0x%" PRIx64
+			" is non-compliant and is being ignored since the "
+			"local port num %u > num ports %u\n",
+			ib_get_node_type_str(p_node->node_info.node_type),
+			cl_ntoh64(p_node->node_info.node_guid),
+			p_pi->local_port_num, p_node->node_info.num_ports);
+		goto Exit;
+	}
+
 	/*
 	   If we were setting the PortInfo, then receiving
 	   this attribute was not part of sweeping the subnet.
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
