From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] infiniband-diags: Add Extended Link Speed Support to
 iblinkinfo
Date: Thu, 11 Aug 2011 18:08:02 -0700
Message-ID: <20110811180802.314c35b2.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    1 +
 src/iblinkinfo.c        |   61 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 57bde20..a7ce62f 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -49,6 +49,7 @@ extern enum MAD_DEST ibd_dest_type;
 extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
 
+
 /*========================================================*/
 /*                External interface                      */
 /*========================================================*/
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index c07d33e..81fa8aa 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -92,6 +92,9 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 {
 	char buf[64];
 	uint32_t max_speed = 0;
+	uint32_t loc_sup_speed = 0;
+	uint32_t rem_sup_speed = 0;
+	uint32_t speed = 0;
 
 	uint32_t max_width = get_max(mad_get_field(port->info, 0,
 						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
@@ -105,17 +108,33 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
 				      buf, 64, &max_width));
 
-	max_speed = get_max(mad_get_field(port->info, 0,
-					  IB_PORT_LINK_SPEED_SUPPORTED_F)
-			    & mad_get_field(port->remoteport->info, 0,
-					    IB_PORT_LINK_SPEED_SUPPORTED_F));
-	if ((max_speed & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_ACTIVE_F)) == 0)
+	loc_sup_speed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_SUPPORTED_F);
+	loc_sup_speed <<= 4;
+	loc_sup_speed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_SUPPORTED_F);
+
+	rem_sup_speed = mad_get_field(port->remoteport->info, 0, IB_PORT_LINK_SPEED_EXT_SUPPORTED_F);
+	rem_sup_speed <<= 4;
+	rem_sup_speed |= mad_get_field(port->remoteport->info, 0, IB_PORT_LINK_SPEED_SUPPORTED_F);
+
+	max_speed = get_max(loc_sup_speed & rem_sup_speed);
+
+	speed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+	speed <<= 4;
+	speed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+
+	if ((max_speed & speed) == 0) {
 		// we are not at the max supported speed
 		// print what we could be at.
-		snprintf(speed_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
-				      buf, 64, &max_speed));
+		if (max_speed & 0xF0) {
+			max_speed >>= 4;
+			snprintf(speed_msg, msg_size, "Could be %s",
+				 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
+					      buf, 64, &max_speed));
+		} else
+			snprintf(speed_msg, msg_size, "Could be %s",
+				 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
+					      buf, 64, &max_speed));
+	}
 }
 
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
@@ -158,7 +177,9 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 		return;
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
-	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+	ispeed <<= 4;
+	ispeed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
 	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
 	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
 
@@ -177,11 +198,23 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	 * returned for all PortInfo components except PortState and
 	 * PortPhysicalState */
 	if (istate != IB_LINK_DOWN) {
-		n = snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
+
+		n = snprintf(link_str, 256, "(%3s",
 		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
-				  &iwidth),
-		     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
-				  &ispeed),
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
+		n += snprintf(link_str + n, 256 - n, " %6s/%8s)",
 		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
 		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
 				  &iphystate));
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
