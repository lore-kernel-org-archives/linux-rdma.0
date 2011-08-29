From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover.c: Fix cap_mask endian for
 extended link speeds
Date: Mon, 29 Aug 2011 11:41:38 -0400
Message-ID: <4E5BB332.2000700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 0966217..cadf648 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -375,7 +375,7 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 	ext_port_str = out_ext_port(port->remoteport, group);
 	cap_mask = mad_get_field(port->node->ports[0]->info, 0,
 				 IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0,
 				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
@@ -433,7 +433,7 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 				       port->remoteport->node->nodedesc);
 
 	cap_mask = mad_get_field(port->info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS) )
 		espeed = mad_get_field(port->info, 0,
 				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
@@ -684,7 +684,7 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 		else
 			info = (uint8_t *)&port->info;
 		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS) )
 			espeed = mad_get_field(port->info, 0,
 					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 		else
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
