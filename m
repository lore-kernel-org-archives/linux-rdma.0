From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/6] infiniband-diags/iblinkinfo.c: Add support for FDR10
Date: Fri, 19 Aug 2011 12:54:05 -0400
Message-ID: <4E4E952D.9050904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/iblinkinfo.c |   41 +++++++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index b282d07..65f2310 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -92,7 +92,7 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 {
 	char buf[64];
 	uint32_t max_speed = 0;
-	uint32_t cap_mask, rem_cap_mask;
+	uint32_t cap_mask, rem_cap_mask, fdr10;
 	uint8_t *info;
 
 	uint32_t max_width = get_max(mad_get_field(port->info, 0,
@@ -121,7 +121,14 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
 	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
 		goto check_ext_speed;
-check_speed_supp:
+check_fdr10_supp:
+	fdr10 = (mad_get_field(port->ext_info, 0,
+			       IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F) & FDR10)
+		&& (mad_get_field(port->remoteport->ext_info, 0,
+				  IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F) & FDR10);
+	if (fdr10)
+		goto check_fdr10_active;
+
 	max_speed = get_max(mad_get_field(port->info, 0,
 					  IB_PORT_LINK_SPEED_SUPPORTED_F)
 			    & mad_get_field(port->remoteport->info, 0,
@@ -140,7 +147,7 @@ check_ext_speed:
 			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
 	    mad_get_field(port->remoteport->info, 0,
 			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
-		goto check_speed_supp;
+		goto check_fdr10_supp;
 	max_speed = get_max(mad_get_field(port->info, 0,
 					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
 			    & mad_get_field(port->remoteport->info, 0,
@@ -152,6 +159,12 @@ check_ext_speed:
 		snprintf(speed_msg, msg_size, "Could be %s",
 			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
 				      buf, 64, &max_speed));
+	return;
+
+check_fdr10_active:
+	if ((mad_get_field(port->ext_info, 0,
+			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0)
+		snprintf(speed_msg, msg_size, "Could be FDR10");
 }
 
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
@@ -187,7 +200,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	char width_msg[256];
 	char speed_msg[256];
 	char ext_port_str[256];
-	int iwidth, ispeed, espeed, istate, iphystate, cap_mask;
+	int iwidth, ispeed, fdr10, espeed, istate, iphystate, cap_mask;
 	int n = 0;
 	uint8_t *info;
 
@@ -196,6 +209,8 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	fdr10 = mad_get_field(port->ext_info, 0,
+			      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10;
 
 	if (port->node->type == IB_NODE_SWITCH)
 		info = (uint8_t *)&port->node->ports[0]->info;
@@ -225,15 +240,21 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	/* C14-24.2.1 states that a down port allows for invalid data to be
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
+	if (!espeed) {
+		if (fdr10)
+			sprintf(speed, "10.0 Gbps (FDR10)");
+		else
+			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed,
+				     64, &ispeed);
+	} else
+		mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed,
+			     64, &espeed);
+
 	if (istate != IB_LINK_DOWN) {
-		n = snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
+		n = snprintf(link_str, 256, "(%3s %18s %6s/%8s)",
 		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
 				  &iwidth),
-		     (ispeed != 4 || !espeed) ?
-			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
-				     &ispeed) :
-			mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64,
-				     &espeed),
+		     speed,
 		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
 		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
 				  &iphystate));
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
