From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: Ignore PortInfo data on down port.
Date: Fri, 19 Mar 2010 11:19:43 -0700
Message-ID: <20100319111943.80ae2e24.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 18 Mar 2010 18:35:34 -0700
Subject: [PATCH] infiniband-diags: Ignore PortInfo data on down port.

According to C14-24.2.1:
If PortInfo:PortState == Down then only PortInfo:PortState and
PortInfo:PortPhysicalState _must_ be valid.  Other fields may be invalid
depending on the vendor.  Therefore ignore all PortInfo data other than those
fields when reporting PortInfo on a down port.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/iblinkinfo.c    |   32 +++++++++++++++++++++++---------
 infiniband-diags/src/ibqueryerrors.c |   19 ++++++++++++++-----
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index d6a0a09..ecfd579 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -134,20 +134,34 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port)
 	width_msg[0] = '\0';
 	speed_msg[0] = '\0';
 
-	n = snprintf(link_str, 256, "(%3s %s %6s/%8s)",
+	/* C14-24.2.1 states that a down port allows for invalid data to be
+	 * returned for all PortInfo components except PortState and
+	 * PortPhysicalState */
+	if (istate != IB_LINK_DOWN) {
+		n = snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
 		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
 				  &iwidth),
 		     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
-				  &ispeed), mad_dump_val(IB_PORT_STATE_F, state,
-							 64, &istate),
+				  &ispeed),
+		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
 		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
 				  &iphystate));
+	} else {
+		n = snprintf(link_str, 256, "(              %6s/%8s)",
+		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
+				  &iphystate));
+	}
 
-	if (add_sw_settings)
-		snprintf(link_str + n, 256 - n, " (HOQ:%d VL_Stall:%d)",
-			 mad_get_field(port->info, 0, IB_PORT_HOQ_LIFE_F),
-			 mad_get_field(port->info, 0,
-				       IB_PORT_VL_STALL_COUNT_F));
+	/* again default values due to C14-24.2.1 */
+	if (add_sw_settings && istate != IB_LINK_DOWN) {
+		snprintf(link_str + n, 256 - n,
+			" (HOQ:%d VL_Stall:%d)",
+			mad_get_field(port->info, 0,
+				IB_PORT_HOQ_LIFE_F),
+			mad_get_field(port->info, 0,
+				IB_PORT_VL_STALL_COUNT_F));
+	}
 
 	if (port->remoteport) {
 		char *remap =
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 0b320ec..7d27806 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -142,11 +142,20 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	width_msg[0] = '\0';
 	speed_msg[0] = '\0';
 
-	snprintf(link_str, 256, "(%3s %s %6s/%8s)",
-		 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-		 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
-		 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
-		 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
+	/* C14-24.2.1 states that a down port allows for invalid data to be
+	 * returned for all PortInfo components except PortState and
+	 * PortPhysicalState */
+	if (istate != IB_LINK_DOWN) {
+		snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
+			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
+			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
+			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+			 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
+	} else {
+		snprintf(link_str, 256, "(              %6s/%8s)",
+			 mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
+			 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
+	}
 
 	if (port->remoteport) {
 		char *rem_node_name = NULL;
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
