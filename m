From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover: fix no port 0 info segmentation
 fault
Date: Thu, 28 Jun 2012 13:13:07 -0400
Message-ID: <4FEC90A3.8000008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix ibnetdiscover egmentation fault when it reaches a switch
that does not respond to a PortInfo Get for port 0.

Note:
When ibnetdiscover can't read the port capabilites field from switch port 0,
'???' is printed for link speed and width.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index d27b784..aeadc25 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -378,13 +378,20 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 				       port->remoteport->node->nodedesc);
 
 	ext_port_str = out_ext_port(port->remoteport, group);
-	cap_mask = mad_get_field(port->node->ports[0]->info, 0,
-				 IB_PORT_CAPMASK_F);
-	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
-		espeed = mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
-	else
+
+	if (!port->node->ports[0]) {
+		cap_mask = 0;
+		ispeed = 0;
 		espeed = 0;
+	} else {
+		cap_mask = mad_get_field(port->node->ports[0]->info, 0,
+					 IB_PORT_CAPMASK_F);
+		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
+			espeed = mad_get_field(port->info, 0,
+					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+		else
+			espeed = 0;
+	}
 	fprintf(f, "\t%s[%d]%s",
 		node_name(port->remoteport->node), port->remoteport->portnum,
 		ext_port_str ? ext_port_str : "");
@@ -679,23 +686,31 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 	for (p = node->numports, port = node->ports[p]; p > 0;
 	     port = node->ports[--p]) {
 		uint32_t iwidth, ispeed, fdr10, espeed, cap_mask;
-		uint8_t *info;
+		uint8_t *info = NULL;
 		if (port == NULL)
 			continue;
 		iwidth =
 		    mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 		ispeed =
 		    mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
-		if (port->node->type == IB_NODE_SWITCH)
-			info = (uint8_t *)&port->node->ports[0]->info;
+		if (port->node->type == IB_NODE_SWITCH) {
+			if (port->node->ports[0])
+				info = (uint8_t *)&port->node->ports[0]->info;
+		}
 		else
 			info = (uint8_t *)&port->info;
-		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
-			espeed = mad_get_field(port->info, 0,
-					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
-		else
+		if (info) {
+			cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+			if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
+				espeed = mad_get_field(port->info, 0,
+						       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+			else
+				espeed = 0;
+		} else {
+			ispeed = 0;
+			iwidth = 0;
 			espeed = 0;
+		}
 		fdr10 = mad_get_field(port->ext_info, 0,
 				      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 		nodename = remap_node_name(node_name_map,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
