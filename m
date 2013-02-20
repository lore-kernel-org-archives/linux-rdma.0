From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_dump.c: Fix enhanced switch port 0 handling in
 print_node_report
Date: Wed, 20 Feb 2013 14:02:19 -0500
Message-ID: <51251DBB.70203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Enhanced switch port 0 has port state, link speed, link width, and MTU.
Only base (original) switch port 0 doesn't.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index aae6a18..7f29259 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -563,9 +563,10 @@ static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 		p_pi = &p_physp->port_info;
 
 		/*
-		 * Port state is not defined for switch port 0
+		 * Port state is not defined for base switch port 0
 		 */
-		if (port_num == 0)
+		if (port_num == 0 &&
+		    ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info) == FALSE)
 			fprintf(file, "     :");
 		else
 			fprintf(file, " %s :",
@@ -584,7 +585,10 @@ static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 		else
 			fprintf(file, "      :     :");
 
-		if (port_num != 0)
+		if (port_num == 0 &&
+		    ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info) == FALSE)
+			fprintf(file, "      :     :      ");
+		else
 			fprintf(file, " %s : %s : %s ",
 				osm_get_mtu_str
 				(ib_port_info_get_neighbor_mtu(p_pi)),
@@ -594,8 +598,6 @@ static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 				 ib_port_info_get_link_speed_ext_active(p_pi),
 				 ib_port_info_get_port_state(p_pi),
 				 p_physp->ext_port_info.link_speed_active & FDR10));
-		else
-			fprintf(file, "      :     :      ");
 
 		if (osm_physp_get_port_guid(p_physp) == osm->subn.sm_port_guid)
 			fprintf(file, "* %016" PRIx64 " *",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
