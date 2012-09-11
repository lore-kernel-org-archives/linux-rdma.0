From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 7/8 v2] opensm/osm_port_info_rcv.c: check received local_port_num
Date: Tue, 11 Sep 2012 18:32:11 +0300
Message-ID: <504F597B.1060507@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osm_port_info_rcv.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index c3bc66c..442bc3f 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -505,6 +505,11 @@ void osm_pi_rcv_process(IN void *context, IN void *data)

 	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_PORT_INFO);

+	/*
+	 * Attribute modifier has already been validated upon MAD receive,
+	 * which means that port_num has to be valid - it originated from
+	 * the request attribute modifier.
+	 */
 	port_num = (uint8_t) cl_ntoh32(p_smp->attr_mod);

 	port_guid = p_context->port_guid;
@@ -554,6 +559,17 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 	p_node = p_port->p_node;
 	CL_ASSERT(p_node);

+	if (p_pi->local_port_num > p_node->node_info.num_ports) {
+		CL_PLOCK_RELEASE(sm->p_lock);
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F15: "
+			"Received PortInfo for port GUID 0x%" PRIx64 " is "
+			"non-compliant and is being ignored since the "
+			"local port num %u > num ports %u\n",
+			cl_ntoh64(port_guid), p_pi->local_port_num,
+			p_node->node_info.num_ports);
+		goto Exit;
+	}
+
 	/*
 	   If we were setting the PortInfo, then receiving
 	   this attribute was not part of sweeping the subnet.
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
