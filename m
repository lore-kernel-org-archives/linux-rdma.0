From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] infiniband-diags: move get_msg to common code
Date: Thu, 11 Aug 2011 18:08:04 -0700
Message-ID: <20110811180804.5a23ccc6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so that iblinkinfo and ibqueryerrors can share this.  This also supports Ext
Link Speeds for the message in ibqueryerrors.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    5 ++++
 src/ibdiag_common.c     |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 src/iblinkinfo.c        |   61 +----------------------------------------------
 src/ibqueryerrors.c     |   43 +--------------------------------
 4 files changed, 67 insertions(+), 102 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index a7ce62f..352b410 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -41,6 +41,7 @@
 
 #include <infiniband/iba/ib_types.h>
 #include <infiniband/mad.h>
+#include <infiniband/ibnetdisc.h>
 
 extern int ibverbose;
 extern char *ibd_ca;
@@ -131,4 +132,8 @@ void sa_report_err(int status);
 		comp_mask |= IB_##name##_COMPMASK_##mask; \
 	}
 
+/* note port must have a non-null remote_port */
+void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
+		 ibnd_port_t * port);
+
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e7e1590..a3e48b5 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -513,3 +513,63 @@ void sa_report_err(int status)
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
+void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
+		 ibnd_port_t * port)
+{
+	char buf[64];
+	uint32_t max_speed = 0;
+	uint32_t loc_sup_speed = 0;
+	uint32_t rem_sup_speed = 0;
+	uint32_t speed = 0;
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
+		// we are not at the max supported speed
+		// print what we could be at.
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
+}
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 81fa8aa..76c3b68 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -78,65 +78,6 @@ static int down_links_only = 0;
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
-	uint32_t loc_sup_speed = 0;
-	uint32_t rem_sup_speed = 0;
-	uint32_t speed = 0;
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
-	loc_sup_speed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_SUPPORTED_F);
-	loc_sup_speed <<= 4;
-	loc_sup_speed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_SUPPORTED_F);
-
-	rem_sup_speed = mad_get_field(port->remoteport->info, 0, IB_PORT_LINK_SPEED_EXT_SUPPORTED_F);
-	rem_sup_speed <<= 4;
-	rem_sup_speed |= mad_get_field(port->remoteport->info, 0, IB_PORT_LINK_SPEED_SUPPORTED_F);
-
-	max_speed = get_max(loc_sup_speed & rem_sup_speed);
-
-	speed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
-	speed <<= 4;
-	speed |= mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
-
-	if ((max_speed & speed) == 0) {
-		// we are not at the max supported speed
-		// print what we could be at.
-		if (max_speed & 0xF0) {
-			max_speed >>= 4;
-			snprintf(speed_msg, msg_size, "Could be %s",
-				 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
-					      buf, 64, &max_speed));
-		} else
-			snprintf(speed_msg, msg_size, "Could be %s",
-				 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
-					      buf, 64, &max_speed));
-	}
-}
-
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
 {
 	ibnd_node_t *fsw;
@@ -246,7 +187,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 		else
 			ext_port_str[0] = '\0';
 
-		get_msg(width_msg, speed_msg, 256, port);
+		get_max_msg(width_msg, speed_msg, 256, port);
 
 		if (line_mode) {
 			snprintf(remote_guid_str, 256,
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 4677db4..493020b 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -160,47 +160,6 @@ static int exceeds_threshold(int field, unsigned val)
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
-}
-
 static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 {
 	char width[64], speed[64], state[64], physstate[64];
@@ -250,7 +209,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
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
