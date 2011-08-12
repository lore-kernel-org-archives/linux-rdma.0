From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags: add Ext Speed Support to
 ibqueryerrors
Date: Thu, 11 Aug 2011 18:08:06 -0700
Message-ID: <20110811180806.7b570d81.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibqueryerrors.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 493020b..e7a7cdb 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -169,6 +169,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	char speed_msg[256];
 	char ext_port_str[256];
 	int iwidth, ispeed, istate, iphystate;
+	int n = 0;
 
 	ibnd_port_t *port = node->ports[portnum];
 
@@ -176,7 +177,9 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 		return;
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
-	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+	ispeed <<= 4;
+	ispeed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
 	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
 	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
 
@@ -189,11 +192,25 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
 	if (istate != IB_LINK_DOWN) {
-		snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
-			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
-			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
-			 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
+		n = snprintf(link_str, 256, "(%3s",
+		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
+				  &iwidth));
+
+		if (ispeed & 0xF0) {
+			ispeed >>= 4;
+			n += snprintf(link_str + n, 256 - n, " %12s",
+				mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64,
+						&ispeed));
+		} else {
+			n += snprintf(link_str + n, 256 - n, " %12s",
+				mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
+					&ispeed));
+		}
+
+		snprintf(link_str + n, 256 - n, " %6s/%8s)",
+			mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+			mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
+				&iphystate));
 	} else {
 		snprintf(link_str, 256, "(              %6s/%8s)",
 			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
