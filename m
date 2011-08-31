From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 4/6] infiniband-diags/ibqueryerrors.c: Add support for FDR10
Date: Wed, 31 Aug 2011 11:26:42 -0400
Message-ID: <4E5E52B2.4000405@dev.mellanox.co.il>
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
Changes since v1:
Rebased to latest master

 src/ibqueryerrors.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 142214d..f225d3b 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -168,7 +168,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	char width_msg[256];
 	char speed_msg[256];
 	char ext_port_str[256];
-	int iwidth, ispeed, espeed, istate, iphystate, cap_mask;
+	int iwidth, ispeed, fdr10, espeed, istate, iphystate, cap_mask;
 	uint8_t *info;
 
 	ibnd_port_t *port = node->ports[portnum];
@@ -178,6 +178,9 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	fdr10 = mad_get_field(port->ext_info, 0,
+			      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10;
+
 	if (port->node->type == IB_NODE_SWITCH)
 		info = (uint8_t *)&port->node->ports[0]->info;
 	else
@@ -199,12 +202,20 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
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
-		snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
+		snprintf(link_str, 256, "(%3s %18s %6s/%8s)",
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-			 (ispeed != 4 || !espeed) ?
-			     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed) :
-			     mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64, &espeed),
+			 speed,
 			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
 			 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
 	} else {
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
