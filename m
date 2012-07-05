From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] iblinkinfo: fix no port 0 info segmentation fault
Date: Thu, 05 Jul 2012 12:45:20 -0400
Message-ID: <4FF5C4A0.1080108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix iblinkinfo segfault when switch port 0 not responding to PortInfo
If switch port 0 doesn't respond to PortInfo, the speed and width of switch
ports is unknown.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibdiag_common.c |   24 ++++++++++++++++++------
 src/iblinkinfo.c    |   38 +++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index b26a5e2..fdf9419 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -670,7 +670,7 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
 	char buf[64];
 	uint32_t max_speed = 0;
 	uint32_t cap_mask, rem_cap_mask, fdr10;
-	uint8_t *info;
+	uint8_t *info = NULL;
 
 	uint32_t max_width = get_max(mad_get_field(port->info, 0,
 						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
@@ -684,17 +684,29 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
 				      buf, 64, &max_width));
 
-	if (port->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->node->ports[0]->info;
+	if (port->node->type == IB_NODE_SWITCH) {
+		if (port->node->ports[0])
+			info = (uint8_t *)&port->node->ports[0]->info;
+	}
 	else
 		info = (uint8_t *)&port->info;
-	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
 
+	if (info)
+		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	else
+		cap_mask = 0;
+
+	info = NULL;
 	if (port->remoteport->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
+		if (port->remoteport->node->ports[0])
+			info = (uint8_t *)&port->remoteport->node->ports[0]->info;
 	else
 		info = (uint8_t *)&port->remoteport->info;
-	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+
+	if (info)
+		rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	else
+		rem_cap_mask = 0;
 	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS) &&
 	    rem_cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		goto check_ext_speed;
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 3b2e7c9..982b29a 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -113,7 +113,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	char ext_port_str[256];
 	int iwidth, ispeed, fdr10, espeed, istate, iphystate, cap_mask;
 	int n = 0;
-	uint8_t *info;
+	uint8_t *info = NULL;
 
 	if (!port)
 		return;
@@ -123,16 +123,25 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	fdr10 = mad_get_field(port->ext_info, 0,
 			      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10;
 
-	if (port->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->node->ports[0]->info;
+	if (port->node->type == IB_NODE_SWITCH) {
+		if (port->node->ports[0])
+			info = (uint8_t *)&port->node->ports[0]->info;
+	}
 	else
 		info = (uint8_t *)&port->info;
-	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
-		espeed = mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
-	else
+
+	if (info) {
+		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
+			espeed = mad_get_field(port->info, 0,
+					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+		else
+			espeed = 0;
+	} else {
+		ispeed = 0;
+		iwidth = 0;
 		espeed = 0;
+	}
 
 	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
 	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
@@ -259,15 +268,22 @@ static inline const char *nodetype_str(ibnd_node_t * node)
 void print_node_header(ibnd_node_t *node, int *out_header_flag,
 			char *out_prefix)
 {
+	uint64_t guid = 0;
 	if ((!out_header_flag || !(*out_header_flag)) && !line_mode) {
 		char *remap =
 			remap_node_name(node_name_map, node->guid, node->nodedesc);
-		if (node->type == IB_NODE_SWITCH)
+		if (node->type == IB_NODE_SWITCH) {
+			if (node->ports[0])
+				guid = node->ports[0]->guid;
+			else if (node->info)
+				guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
+
 			printf("%s%s: 0x%016" PRIx64 " %s:\n",
 				out_prefix ? out_prefix : "",
 				nodetype_str(node),
-				node->ports[0]->guid, remap);
-		else
+				guid,
+				remap);
+		} else
 			printf("%s%s: %s:\n",
 				out_prefix ? out_prefix : "",
 				nodetype_str(node), remap);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
