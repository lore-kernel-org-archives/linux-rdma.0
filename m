From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: Changes for extended link
 speeds
Date: Tue, 16 Aug 2011 07:13:59 -0400
Message-ID: <4E4A50F7.602@dev.mellanox.co.il>
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
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 4677db4..9005fda 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
- * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -175,6 +175,8 @@ static void get_msg(char *width_msg, char *speed_msg, int msg_size,
 {
 	char buf[64];
 	uint32_t max_speed = 0;
+	uint32_t cap_mask, rem_cap_mask;
+	uint8_t *info;
 
 	uint32_t max_width = get_max(mad_get_field(port->info, 0,
 						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
@@ -188,6 +190,21 @@ static void get_msg(char *width_msg, char *speed_msg, int msg_size,
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
 				      buf, 64, &max_width));
 
+	if (port->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->info;
+	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	if (port->remoteport->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->remoteport->info;
+	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
+	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		goto check_ext_speed;
+
+check_speed_supp:
 	max_speed = get_max(mad_get_field(port->info, 0,
 					  IB_PORT_LINK_SPEED_SUPPORTED_F)
 			    & mad_get_field(port->remoteport->info, 0,
@@ -199,6 +216,25 @@ static void get_msg(char *width_msg, char *speed_msg, int msg_size,
 		snprintf(speed_msg, msg_size, "Could be %s",
 			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
 				      buf, 64, &max_speed));
+	return;
+
+check_ext_speed:
+	if (mad_get_field(port->info, 0,
+			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
+	    mad_get_field(port->remoteport->info, 0,
+			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
+		goto check_speed_supp;
+	max_speed = get_max(mad_get_field(port->info, 0,
+					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
+			    & mad_get_field(port->remoteport->info, 0,
+					    IB_PORT_LINK_SPEED_EXT_SUPPORTED_F));
+	if ((max_speed & mad_get_field(port->info, 0,
+				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F)) == 0)
+		// we are not at the max supported extended speed
+		// print what we could be at.
+		snprintf(speed_msg, msg_size, "Could be %s",
+			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
+				      buf, 64, &max_speed));
 }
 
 static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
@@ -209,7 +245,8 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	char width_msg[256];
 	char speed_msg[256];
 	char ext_port_str[256];
-	int iwidth, ispeed, istate, iphystate;
+	int iwidth, ispeed, espeed, istate, iphystate, cap_mask;
+	uint8_t *info;
 
 	ibnd_port_t *port = node->ports[portnum];
 
@@ -218,6 +255,16 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	if (port->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->info;
+	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		espeed = mad_get_field(port->info, 0,
+				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+	else
+		espeed = 0;
 	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
 	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
 
@@ -232,7 +279,9 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	if (istate != IB_LINK_DOWN) {
 		snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
+			 (ispeed != 4 || !espeed) ?
+			     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed) :
+			     mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64, &espeed),
 			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
 			 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
 	} else {
@@ -295,7 +344,7 @@ static int suppress(enum MAD_FIELDS field)
 static void report_suppressed(void)
 {
 	int i = 0;
-	printf("## Suppresed:");
+	printf("## Suppressed:");
 	for (i = 0; i < sup_total; i++)
 		printf(" %s", mad_field_name(suppressed_fields[i]));
 	printf("\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
