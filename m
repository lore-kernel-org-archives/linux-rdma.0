From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_dump.c: Fix FDR10 speed dumping
Date: Wed, 28 Sep 2011 08:50:49 -0400
Message-ID: <4E831829.4000106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In dump_topology_node, FDR10 can be active regardless of whether
PortInfo:CapabilityMask.IsExtendedSpeeds is set or not

Prior to this, FDR10 was only indicated if IsExtendedSpeeds was not set

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 7e58301..8aa8095 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -454,6 +454,9 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 		else
 			link_speed_act_str = "??";
 
+		if (p_physp->ext_port_info.link_speed_active & FDR10)
+			link_speed_act_str = "FDR10";
+
 		if (p_default_physp->port_info.capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) {
 			link_speed_act =
 			    ib_port_info_get_link_speed_ext_active(&p_physp->port_info);
@@ -463,8 +466,7 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 				link_speed_act_str = "25";
 			else if (link_speed_act != IB_LINK_SPEED_EXT_ACTIVE_NONE)
 				link_speed_act_str = "??";
-		} else if (p_physp->ext_port_info.link_speed_active & FDR10)
-			link_speed_act_str = "FDR10";
+		}
 
 		fprintf(file, "PHY=%s LOG=%s SPD=%s\n",
 			p_physp->port_info.link_width_active == 1 ? "1x" :
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
