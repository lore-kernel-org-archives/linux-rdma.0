From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Tue, 4 Oct 2011 15:27:23 +0300
Message-ID: <201110041427.23819.marcela@dev.mellanox.co.il>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110031754.59246.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes from v1
-   function ib_rate_to_int changed to ib_rate_to_mbps
-   new implementation for ib_rate_to_mbps

The following extended speeds are introduced:
FDR-10  - is a proprietary link speed which is 10.3125 Gbps at 64/66
	  encoding rather than 8b10b encoding.
FDR     - represents the IBA extended speed: 14.0625 Gbps.
EDR     - represents the IBA extended speed: 25.78125 Gbps.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 drivers/infiniband/core/sysfs.c |   23 ++++++++++++++---
 drivers/infiniband/core/verbs.c |   25 ++++++++++++++++++
 include/rdma/ib_verbs.h         |   54 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -179,6 +179,7 @@ static ssize_t rate_show(struct ib_port 
 	struct ib_port_attr attr;
 	char *speed = "";
 	int rate;
+	int rate_rounded;
 	ssize_t ret;
 
 	ret = ib_query_port(p->ibdev, p->port_num, &attr);
@@ -186,16 +187,30 @@ static ssize_t rate_show(struct ib_port 
 		return ret;
 
 	switch (attr.active_speed) {
-	case 2: speed = " DDR"; break;
-	case 4: speed = " QDR"; break;
+	case 2:
+		speed = " DDR";
+		break;
+	case 4:
+		speed = " QDR";
+		break;
+	case 8:
+		speed = " FDR10";
+		break;
+	case 16:
+		speed = " FDR";
+		break;
+	case 32:
+		speed = " EDR";
+		break;
 	}
 
-	rate = 25 * ib_width_enum_to_int(attr.active_width) * attr.active_speed;
+	rate = ib_width_enum_to_int(attr.active_width) *
+	       ib_active_speed_to_rate(attr.active_speed, &rate_rounded);
 	if (rate < 0)
 		return -EINVAL;
 
 	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate / 10, rate % 10 ? ".5" : "",
+		       rate, rate_rounded ? ".5" : "",
 		       ib_width_enum_to_int(attr.active_width), speed);
 }
 
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -77,6 +77,31 @@ enum ib_rate mult_to_ib_rate(int mult)
 }
 EXPORT_SYMBOL(mult_to_ib_rate);
 
+int ib_rate_to_mbps(enum ib_rate rate)
+{
+	switch (rate) {
+	case IB_RATE_2_5_GBPS: return 2500;
+	case IB_RATE_5_GBPS:   return 5000;
+	case IB_RATE_10_GBPS:  return 10000;
+	case IB_RATE_20_GBPS:  return 20000;
+	case IB_RATE_30_GBPS:  return 30000;
+	case IB_RATE_40_GBPS:  return 40000;
+	case IB_RATE_60_GBPS:  return 60000;
+	case IB_RATE_80_GBPS:  return 80000;
+	case IB_RATE_120_GBPS: return 120000;
+	case IB_RATE_14_GBPS:  return 14062;
+	case IB_RATE_56_GBPS:  return 56250;
+	case IB_RATE_112_GBPS: return 112500;
+	case IB_RATE_168_GBPS: return 168750;
+	case IB_RATE_25_GBPS:  return 25781;
+	case IB_RATE_100_GBPS: return 103125;
+	case IB_RATE_200_GBPS: return 206250;
+	case IB_RATE_300_GBPS: return 309375;
+	default:	       return -1;
+	}
+}
+EXPORT_SYMBOL(ib_rate_to_mbps);
+
 enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type)
 {
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -207,6 +207,7 @@ enum ib_port_cap_flags {
 	IB_PORT_SM_DISABLED			= 1 << 10,
 	IB_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
 	IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
+	IB_PORT_EXTENDED_SPEEDS_SUP             = 1 << 14,
 	IB_PORT_CM_SUP				= 1 << 16,
 	IB_PORT_SNMP_TUNNEL_SUP			= 1 << 17,
 	IB_PORT_REINIT_SUP			= 1 << 18,
@@ -226,6 +227,42 @@ enum ib_port_width {
 	IB_WIDTH_12X	= 8
 };
 
+static inline int ib_active_speed_to_rate(u8 active_speed, int *rounded)
+{
+	int rate;
+
+	*rounded = 0;
+
+	switch (active_speed) {
+	case 1:
+	case 2:
+	case 4:
+		rate = (25 * active_speed) / 10;
+		*rounded =  (25 * active_speed) % 10;
+		break;
+
+	/* FDR10 */
+	case 8:
+		rate = 10;
+		break;
+
+	/* FDR */
+	case 16:
+		rate = 14;
+		break;
+
+	/* EDR */
+	case 32:
+		rate = 25;
+		break;
+
+	default:
+		rate = -1;
+	}
+
+	return rate;
+}
+
 static inline int ib_width_enum_to_int(enum ib_port_width width)
 {
 	switch (width) {
@@ -415,7 +452,15 @@ enum ib_rate {
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
+	IB_RATE_300_GBPS = 18
 };
 
 /**
@@ -427,6 +472,13 @@ enum ib_rate {
 int ib_rate_to_mult(enum ib_rate rate) __attribute_const__;
 
 /**
+ * ib_rate_to_mbps - Convert the IB rate enum to Mbps.
+ * For example, IB_RATE_2_5_GBPS will be converted to 2500.
+ * @rate: rate to convert.
+ */
+int ib_rate_to_mbps(enum ib_rate rate) __attribute_const__;
+
+/**
  * mult_to_ib_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate
  * enum.
  * @mult: multiple to convert.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
