From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Date: Mon, 19 Sep 2011 19:06:05 +0300
Message-ID: <201109191906.05360.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch implements IB spec extension of the PortInfo attribute:

Component  : LinkSpeedExtActive
Used By    : (All X's except base SP0)
Access     : RO
Length     : 4
Offset     : 496
Description: If PortInfo:CapabilityMask.IsExtendedSpeedsSupported, currently
             active extended link speed, indicated as follows:
	     This patchis in conformance with IBTA RefID 4720 and utilizes
	     IBTA RefID2 4719 (PortInfo:CapabilityMask.IsExtendedSpeedsSupported)
	     and IBTA RefID 4727 (SA PathRecord:Rate)
0: No extended speed active
1: 14.0625 Gbps (FDR)
2: 25.78125 Gbps (EDR)
3-15: Reserved

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c         |   46 +++++++++++++++++++++++++-------
 drivers/infiniband/core/uverbs_cmd.c    |    1 
 drivers/infiniband/core/verbs.c         |   17 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_fs.c |   30 ++++++++++++++------
 include/rdma/ib_user_verbs.h            |    3 +-
 include/rdma/ib_verbs.h                 |   29 +++++++++++++++++++-
 6 files changed, 105 insertions(+), 21 deletions(-)

Index: b/drivers/infiniband/core/sysfs.c
===================================================================
--- a/drivers/infiniband/core/sysfs.c	2011-09-13 13:34:19.649036700 +0300
+++ b/drivers/infiniband/core/sysfs.c	2011-09-14 13:49:58.000000000 +0300
@@ -185,18 +185,44 @@ static ssize_t rate_show(struct ib_port
 	if (ret)
 		return ret;
 
-	switch (attr.active_speed) {
-	case 2: speed = " DDR"; break;
-	case 4: speed = " QDR"; break;
+	if ((attr.port_cap_flags & IB_PORT_EXTENDED_SPEEDS_SUP) &&
+	    attr.ext_active_speed) {
+		switch (attr.ext_active_speed) {
+		case 1:
+			speed = " FDR";
+			break;
+		case 2:
+			speed = " EDR";
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		return sprintf(buf, "%d Gb/sec (%dX%s)\n",
+			       ib_ext_active_speed_to_rate(attr.
+							   ext_active_speed) *
+			       ib_width_enum_to_int(attr.active_width),
+			       ib_width_enum_to_int(attr.active_width), speed);
+	} else {
+		switch (attr.active_speed) {
+		case 2:
+			speed = " DDR";
+			break;
+		case 4:
+			speed = " QDR";
+			break;
+		}
+
+		rate = 25 * ib_width_enum_to_int(attr.active_width) *
+		       attr.active_speed;
+		if (rate < 0)
+			return -EINVAL;
+
+		return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
+			       rate / 10, rate % 10 ? ".5" : "",
+			       ib_width_enum_to_int(attr.active_width), speed);
 	}
 
-	rate = 25 * ib_width_enum_to_int(attr.active_width) * attr.active_speed;
-	if (rate < 0)
-		return -EINVAL;
-
-	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate / 10, rate % 10 ? ".5" : "",
-		       ib_width_enum_to_int(attr.active_width), speed);
 }
 
 static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
Index: b/drivers/infiniband/core/uverbs_cmd.c
===================================================================
--- a/drivers/infiniband/core/uverbs_cmd.c	2011-09-13 13:34:19.655037900 +0300
+++ b/drivers/infiniband/core/uverbs_cmd.c	2011-09-13 13:34:25.029112500 +0300
@@ -462,6 +462,7 @@ ssize_t ib_uverbs_query_port(struct ib_u
 	resp.phys_state      = attr.phys_state;
 	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
 							cmd.port_num);
+	resp.ext_active_speed = attr.ext_active_speed;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
Index: b/drivers/infiniband/core/verbs.c
===================================================================
--- a/drivers/infiniband/core/verbs.c	2011-09-13 13:34:19.660539000 +0300
+++ b/drivers/infiniband/core/verbs.c	2011-09-13 16:42:39.713754400 +0300
@@ -77,6 +77,23 @@ enum ib_rate mult_to_ib_rate(int mult)
 }
 EXPORT_SYMBOL(mult_to_ib_rate);
 
+int ib_ext_rate_to_int(enum ib_rate rate)
+{
+	switch (rate) {
+	case IB_RATE_14_GBPS:	return 14;
+	case IB_RATE_56_GBPS:	return 56;
+	case IB_RATE_112_GBPS:	return 112;
+	case IB_RATE_168_GBPS:	return 168;
+	case IB_RATE_25_GBPS:	return 25;
+	case IB_RATE_100_GBPS:	return 100;
+	case IB_RATE_200_GBPS:	return 200;
+	case IB_RATE_300_GBPS:	return 300;
+	/* For higher speeds report 56 */
+	default:		return 56;
+	}
+}
+EXPORT_SYMBOL(ib_ext_rate_to_int);
+
 enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type)
 {
Index: b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c	2011-09-13 13:34:19.666040100 +0300
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c	2011-09-13 13:34:25.043115300 +0300
@@ -212,16 +212,28 @@ static int ipoib_path_seq_show(struct se
 		   gid_buf, path.pathrec.dlid ? "yes" : "no");
 
 	if (path.pathrec.dlid) {
-		rate = ib_rate_to_mult(path.pathrec.rate) * 25;
+		if (path.pathrec.rate > IB_RATE_120_GBPS) {
+			rate = ib_ext_rate_to_int(path.pathrec.rate);
 
-		seq_printf(file,
-			   "  DLID:     0x%04x\n"
-			   "  SL: %12d\n"
-			   "  rate: %*d%s Gb/sec\n",
-			   be16_to_cpu(path.pathrec.dlid),
-			   path.pathrec.sl,
-			   10 - ((rate % 10) ? 2 : 0),
-			   rate / 10, rate % 10 ? ".5" : "");
+			seq_printf(file,
+				   "  DLID:     0x%04x\n"
+				   "  SL: %12d\n"
+				   "  rate: %*d Gb/sec\n",
+				   be16_to_cpu(path.pathrec.dlid),
+				   path.pathrec.sl,
+				   rate);
+		} else {
+			rate = ib_rate_to_mult(path.pathrec.rate) * 25;
+
+			seq_printf(file,
+				   "  DLID:     0x%04x\n"
+				   "  SL: %12d\n"
+				   "  rate: %*d%s Gb/sec\n",
+				   be16_to_cpu(path.pathrec.dlid),
+				   path.pathrec.sl,
+				   10 - ((rate % 10) ? 2 : 0),
+				   rate / 10, rate % 10 ? ".5" : "");
+		}
 	}
 
 	seq_putc(file, '\n');
Index: b/include/rdma/ib_user_verbs.h
===================================================================
--- a/include/rdma/ib_user_verbs.h	2011-09-13 13:34:19.745055900 +0300
+++ b/include/rdma/ib_user_verbs.h	2011-09-13 13:34:25.050116700 +0300
@@ -206,7 +206,8 @@ struct ib_uverbs_query_port_resp {
 	__u8  active_speed;
 	__u8  phys_state;
 	__u8  link_layer;
-	__u8  reserved[2];
+	__u8  ext_active_speed;
+	__u8  reserved;
 };
 
 struct ib_uverbs_alloc_pd {
Index: b/include/rdma/ib_verbs.h
===================================================================
--- a/include/rdma/ib_verbs.h	2011-09-13 13:34:19.752057300 +0300
+++ b/include/rdma/ib_verbs.h	2011-09-14 13:49:58.000000000 +0300
@@ -207,6 +207,7 @@ enum ib_port_cap_flags {
 	IB_PORT_SM_DISABLED			= 1 << 10,
 	IB_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
 	IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
+	IB_PORT_EXTENDED_SPEEDS_SUP		= 1 << 14,
 	IB_PORT_CM_SUP				= 1 << 16,
 	IB_PORT_SNMP_TUNNEL_SUP			= 1 << 17,
 	IB_PORT_REINIT_SUP			= 1 << 18,
@@ -226,6 +227,15 @@ enum ib_port_width {
 	IB_WIDTH_12X	= 8
 };
 
+static inline int ib_ext_active_speed_to_rate(u8 ext_active_speed)
+{
+	switch (ext_active_speed) {
+	case 1:	return 14;
+	case 2:	return 25;
+	default: return -1;
+	}
+}
+
 static inline int ib_width_enum_to_int(enum ib_port_width width)
 {
 	switch (width) {
@@ -308,6 +318,7 @@ struct ib_port_attr {
 	u8			active_width;
 	u8			active_speed;
 	u8                      phys_state;
+	u8                      ext_active_speed;
 };
 
 enum ib_device_modify_flags {
@@ -415,7 +426,15 @@ enum ib_rate {
 	IB_RATE_40_GBPS  = 7,
 	IB_RATE_60_GBPS  = 8,
 	IB_RATE_80_GBPS  = 9,
-	IB_RATE_120_GBPS = 10
+	IB_RATE_120_GBPS = 10,
+	IB_RATE_14_GBPS  = 11,
+	IB_RATE_56_GBPS  = 12,
+	IB_RATE_112_GBPS = 13,
+	IB_RATE_168_GBPS = 14,
+	IB_RATE_25_GBPS  = 15,
+	IB_RATE_100_GBPS = 16,
+	IB_RATE_200_GBPS = 17,
+	IB_RATE_300_GBPS = 18,
 };
 
 /**
@@ -427,6 +446,14 @@ enum ib_rate {
 int ib_rate_to_mult(enum ib_rate rate) __attribute_const__;
 
 /**
+ * ib_ext_rate_to_int - Convert the extended IB rate enum to a
+ * real integer value.  For example,
+ * IB_RATE_14_GBPS will be converted to 14
+ * @rate: extended rate to convert.
+ */
+int ib_ext_rate_to_int(enum ib_rate rate) __attribute_const__;
+
+/**
  * mult_to_ib_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate
  * enum.
  * @mult: multiple to convert.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
