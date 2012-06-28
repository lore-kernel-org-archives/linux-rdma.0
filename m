From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_node_info_rcv.c: Handle non-compliant SMA gracefully
Date: Thu, 28 Jun 2012 13:11:52 -0400
Message-ID: <4FEC9058.2020203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


If NodeInfo.LocalPortNum > NodeInfo.NumPorts, then SMA is
not compliant. In this case, ignore the node and don't add
it to any subnet data structures.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 7d2675f..9375e36 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -817,6 +817,7 @@ void osm_ni_rcv_process(IN void *context, IN void *data)
 	ib_node_info_t *p_ni;
 	ib_smp_t *p_smp;
 	osm_node_t *p_node;
+	uint8_t port_num;
 
 	CL_ASSERT(sm);
 
@@ -843,6 +844,18 @@ void osm_ni_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
+	port_num = ib_node_info_get_local_port_num(p_ni);
+	if (port_num > p_ni->num_ports) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0A: "
+			"New %s node GUID 0x%" PRIx64
+			" is non-compliant and is being ignored since the "
+			"local port num %u > num ports %u\n",
+			ib_get_node_type_str(p_ni->node_type),
+			cl_ntoh64(p_ni->node_guid), port_num,
+			p_ni->num_ports);
+		goto Exit;
+	}
+
 	/*
 	   Determine if this node has already been discovered,
 	   and process accordingly.
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
