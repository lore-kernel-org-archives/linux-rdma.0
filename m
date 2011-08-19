From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: move get_msg to common code
Date: Thu, 18 Aug 2011 18:04:13 -0700
Message-ID: <20110818180413.135ab992.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


iblinkinfo and ibqueryerrors should share this.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    4 ++
 src/ibdiag_common.c     |   76 +++++++++++++++++++++++++++++++++++++++++++++
 src/iblinkinfo.c        |   77 +---------------------------------------------
 src/ibqueryerrors.c     |   79 +----------------------------------------------
 4 files changed, 82 insertions(+), 154 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 57bde20..2425c94 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -41,6 +41,7 @@
 
 #include <infiniband/iba/ib_types.h>
 #include <infiniband/mad.h>
+#include <infiniband/ibnetdisc.h>
 
 extern int ibverbose;
 extern char *ibd_ca;
@@ -130,4 +131,7 @@ void sa_report_err(int status);
 		comp_mask |= IB_##name##_COMPMASK_##mask; \
 	}
 
+void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
+		 ibnd_port_t * port);
+
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e7e1590..e231af2 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -513,3 +513,79 @@ void sa_report_err(int status)
 	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
 		status, sm_err_str, sa_err_str);
 }
+
+static unsigned int get_max(unsigned int num)
+{
+	unsigned r = 0;		// r will be lg(num)
+
+	while (num >>= 1)	// unroll for more speed...
+		r++;
+
+	return (1 << r);
+}
+
+void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
+{
+	char buf[64];
+	uint32_t max_speed = 0;
+	uint32_t cap_mask, rem_cap_mask;
+	uint8_t *info;
+
+	uint32_t max_width = get_max(mad_get_field(port->info, 0,
+						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
+				     & mad_get_field(port->remoteport->info, 0,
+						     IB_PORT_LINK_WIDTH_SUPPORTED_F));
+	if ((max_width & mad_get_field(port->info, 0,
+				       IB_PORT_LINK_WIDTH_ACTIVE_F)) == 0)
+		// we are not at the max supported width
+		// print what we could be at.
+		snprintf(width_msg, msg_size, "Could be %s",
+			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
+				      buf, 64, &max_width));
+
+	if (port->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->info;
+	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+
+	if (port->remoteport->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->remoteport->info;
+	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
+	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		goto check_ext_speed;
+check_speed_supp:
+	max_speed = get_max(mad_get_field(port->info, 0,
+					  IB_PORT_LINK_SPEED_SUPPORTED_F)
+			    & mad_get_field(port->remoteport->info, 0,
+					    IB_PORT_LINK_SPEED_SUPPORTED_F));
+	if ((max_speed & mad_get_field(port->info, 0,
+				       IB_PORT_LINK_SPEED_ACTIVE_F)) == 0)
+		// we are not at the max supported speed
+		// print what we could be at.
+		snprintf(speed_msg, msg_size, "Could be %s",
+			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
+				      buf, 64, &max_speed));
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
+}
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index b282d07..bbdb51d 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -78,81 +78,6 @@ static int down_links_only = 0;
 static int line_mode = 0;
 static int add_sw_settings = 0;
 
-static unsigned int get_max(unsigned int num)
-{
-	unsigned r = 0;		// r will be lg(num)
-
-	while (num >>= 1)	// unroll for more speed...
-		r++;
-
-	return (1 << r);
-}
-
-void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
-{
-	char buf[64];
-	uint32_t max_speed = 0;
-	uint32_t cap_mask, rem_cap_mask;
-	uint8_t *info;
-
-	uint32_t max_width = get_max(mad_get_field(port->info, 0,
-						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
-				     & mad_get_field(port->remoteport->info, 0,
-						     IB_PORT_LINK_WIDTH_SUPPORTED_F));
-	if ((max_width & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_WIDTH_ACTIVE_F)) == 0)
-		// we are not at the max supported width
-		// print what we could be at.
-		snprintf(width_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
-				      buf, 64, &max_width));
-
-	if (port->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->node->ports[0]->info;
-	else
-		info = (uint8_t *)&port->info;
-	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-
-	if (port->remoteport->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
-	else
-		info = (uint8_t *)&port->remoteport->info;
-	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
-	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
-		goto check_ext_speed;
-check_speed_supp:
-	max_speed = get_max(mad_get_field(port->info, 0,
-					  IB_PORT_LINK_SPEED_SUPPORTED_F)
-			    & mad_get_field(port->remoteport->info, 0,
-					    IB_PORT_LINK_SPEED_SUPPORTED_F));
-	if ((max_speed & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_ACTIVE_F)) == 0)
-		// we are not at the max supported speed
-		// print what we could be at.
-		snprintf(speed_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
-				      buf, 64, &max_speed));
-	return;
-
-check_ext_speed:
-	if (mad_get_field(port->info, 0,
-			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
-	    mad_get_field(port->remoteport->info, 0,
-			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
-		goto check_speed_supp;
-	max_speed = get_max(mad_get_field(port->info, 0,
-					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
-			    & mad_get_field(port->remoteport->info, 0,
-					    IB_PORT_LINK_SPEED_EXT_SUPPORTED_F));
-	if ((max_speed & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F)) == 0)
-		// we are not at the max supported extended speed
-		// print what we could be at.
-		snprintf(speed_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
-				      buf, 64, &max_speed));
-}
 
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
 {
@@ -265,7 +190,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 		else
 			ext_port_str[0] = '\0';
 
-		get_msg(width_msg, speed_msg, 256, port);
+		get_max_msg(width_msg, speed_msg, 256, port);
 
 		if (line_mode) {
 			snprintf(remote_guid_str, 256,
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 9005fda..6de3d6f 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -160,83 +160,6 @@ static int exceeds_threshold(int field, unsigned val)
 	return (val > thres);
 }
 
-static unsigned int get_max(unsigned int num)
-{
-	unsigned r = 0;		// r will be lg(num)
-
-	while (num >>= 1)	// unroll for more speed...
-		r++;
-
-	return (1 << r);
-}
-
-static void get_msg(char *width_msg, char *speed_msg, int msg_size,
-		    ibnd_port_t * port)
-{
-	char buf[64];
-	uint32_t max_speed = 0;
-	uint32_t cap_mask, rem_cap_mask;
-	uint8_t *info;
-
-	uint32_t max_width = get_max(mad_get_field(port->info, 0,
-						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
-				     & mad_get_field(port->remoteport->info, 0,
-						     IB_PORT_LINK_WIDTH_SUPPORTED_F));
-	if ((max_width & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_WIDTH_ACTIVE_F)) == 0)
-		// we are not at the max supported width
-		// print what we could be at.
-		snprintf(width_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
-				      buf, 64, &max_width));
-
-	if (port->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->node->ports[0]->info;
-	else
-		info = (uint8_t *)&port->info;
-	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (port->remoteport->node->type == IB_NODE_SWITCH)
-		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
-	else
-		info = (uint8_t *)&port->remoteport->info;
-	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
-	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
-		goto check_ext_speed;
-
-check_speed_supp:
-	max_speed = get_max(mad_get_field(port->info, 0,
-					  IB_PORT_LINK_SPEED_SUPPORTED_F)
-			    & mad_get_field(port->remoteport->info, 0,
-					    IB_PORT_LINK_SPEED_SUPPORTED_F));
-	if ((max_speed & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_ACTIVE_F)) == 0)
-		// we are not at the max supported speed
-		// print what we could be at.
-		snprintf(speed_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
-				      buf, 64, &max_speed));
-	return;
-
-check_ext_speed:
-	if (mad_get_field(port->info, 0,
-			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
-	    mad_get_field(port->remoteport->info, 0,
-			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
-		goto check_speed_supp;
-	max_speed = get_max(mad_get_field(port->info, 0,
-					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
-			    & mad_get_field(port->remoteport->info, 0,
-					    IB_PORT_LINK_SPEED_EXT_SUPPORTED_F));
-	if ((max_speed & mad_get_field(port->info, 0,
-				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F)) == 0)
-		// we are not at the max supported extended speed
-		// print what we could be at.
-		snprintf(speed_msg, msg_size, "Could be %s",
-			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
-				      buf, 64, &max_speed));
-}
-
 static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 {
 	char width[64], speed[64], state[64], physstate[64];
@@ -299,7 +222,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 		else
 			ext_port_str[0] = '\0';
 
-		get_msg(width_msg, speed_msg, 256, port);
+		get_max_msg(width_msg, speed_msg, 256, port);
 
 		rem_node_name = remap_node_name(node_name_map,
 						port->remoteport->node->guid,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
