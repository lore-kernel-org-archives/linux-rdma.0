From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/5] ib/core: add support for extended performance counters
 in sysfs
Date: Mon, 10 Oct 2011 10:56:25 +0200
Message-ID: <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

issue a PMA classportinfo query towards the HW driver, and if extended
counters are supported, expose new sysfs entries which allow to read them.

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
---
 drivers/infiniband/core/sysfs.c |  100 ++++++++++++++++++++++++++++++++++++++-
 include/rdma/ib_pma.h           |    1 +
 2 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 9ab5df7..8bbed12 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -38,6 +38,7 @@
 #include <linux/string.h>

 #include <rdma/ib_mad.h>
+#include <rdma/ib_pma.h>

 struct ib_port {
 	struct kobject         kobj;
@@ -288,6 +289,13 @@ static ssize_t show_port_pkey(struct ib_port *p, struct port_attribute *attr,
 	return sprintf(buf, "0x%04x\n", pkey);
 }

+enum {
+	COUNTERS_START		= 0,
+	COUNTERS_LAST		= 15,
+	EXT_COUNTERS_START	= 16,
+	EXT_COUNTERS_LAST 	= 23
+};
+
 #define PORT_PMA_ATTR(_name, _counter, _width, _offset)			\
 struct port_table_attribute port_pma_attr_##_name = {			\
 	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
@@ -301,6 +309,7 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 		container_of(attr, struct port_table_attribute, attr);
 	int offset = tab_attr->index & 0xffff;
 	int width  = (tab_attr->index >> 16) & 0xff;
+	int counter  = (tab_attr->index >> 24) & 0xff;
 	struct ib_mad *in_mad  = NULL;
 	struct ib_mad *out_mad = NULL;
 	ssize_t ret;
@@ -319,7 +328,14 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	in_mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_PERF_MGMT;
 	in_mad->mad_hdr.class_version = 1;
 	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
-	in_mad->mad_hdr.attr_id       = cpu_to_be16(0x12); /* PortCounters */
+	if (counter >= COUNTERS_START && counter <= COUNTERS_LAST)
+		in_mad->mad_hdr.attr_id	= IB_PMA_PORT_COUNTERS;
+	else if (counter >= EXT_COUNTERS_START && counter <= EXT_COUNTERS_LAST)
+		in_mad->mad_hdr.attr_id	= IB_PMA_PORT_COUNTERS_EXT;
+	else {
+		ret = -EINVAL;
+		goto out;
+	}

 	in_mad->data[41] = p->port_num;	/* PortSelect field */

@@ -347,6 +363,10 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 		ret = sprintf(buf, "%u\n",
 			      be32_to_cpup((__be32 *)(out_mad->data + 40 + offset / 8)));
 		break;
+	case 64:
+		ret = sprintf(buf, "%llu\n", be64_to_cpup(
+				(__be64 *)(out_mad->data + 40 + offset / 8)));
+		break;
 	default:
 		ret = 0;
 	}
@@ -358,6 +378,7 @@ out:
 	return ret;
 }

+
 static PORT_PMA_ATTR(symbol_error		    ,  0, 16,  32);
 static PORT_PMA_ATTR(link_error_recovery	    ,  1,  8,  48);
 static PORT_PMA_ATTR(link_downed		    ,  2,  8,  56);
@@ -374,6 +395,15 @@ static PORT_PMA_ATTR(port_xmit_data		    , 12, 32, 192);
 static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224);
 static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
 static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
+/* definition for port counters extension */
+static PORT_PMA_ATTR(port_xmit_data_64		    , 16, 64,  64);
+static PORT_PMA_ATTR(port_rcv_data_64		    , 17, 64, 128);
+static PORT_PMA_ATTR(port_xmit_packets_64	    , 18, 64, 192);
+static PORT_PMA_ATTR(port_rcv_packets_64	    , 19, 64, 256);
+static PORT_PMA_ATTR(port_unicast_xmit_packets	    , 20, 64, 320);
+static PORT_PMA_ATTR(port_unicast_rcv_packets	    , 21, 64, 384);
+static PORT_PMA_ATTR(port_multicast_xmit_packets   , 22, 64, 448);
+static PORT_PMA_ATTR(port_multicast_rcv_packets    , 23, 64, 512);

 static struct attribute *pma_attrs[] = {
 	&port_pma_attr_symbol_error.attr.attr,
@@ -400,6 +430,68 @@ static struct attribute_group pma_group = {
 	.attrs  = pma_attrs
 };

+static struct attribute *pma_attrs_ext[] = {
+	&port_pma_attr_port_xmit_data_64.attr.attr,
+	&port_pma_attr_port_rcv_data_64.attr.attr,
+	&port_pma_attr_port_xmit_packets_64.attr.attr,
+	&port_pma_attr_port_rcv_packets_64.attr.attr,
+	&port_pma_attr_port_unicast_xmit_packets.attr.attr,
+	&port_pma_attr_port_unicast_rcv_packets.attr.attr,
+	&port_pma_attr_port_multicast_xmit_packets.attr.attr,
+	&port_pma_attr_port_multicast_rcv_packets.attr.attr,
+	NULL
+};
+
+static struct attribute_group pma_ext_group = {
+	.name  = "counters_ext",
+	.attrs  = pma_attrs_ext
+};
+
+static int is_pma_class_cap_ext_width(struct ib_device *ibdev, int port_num)
+{
+	struct ib_mad *in_mad  = NULL;
+	struct ib_mad *out_mad = NULL;
+	struct ib_class_port_info *cpi = NULL;
+	int ret = 0;
+
+	if (!ibdev->process_mad)
+		return -ENOSYS;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	in_mad->mad_hdr.base_version  = 1;
+	in_mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_PERF_MGMT;
+	in_mad->mad_hdr.class_version = 1;
+	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
+	in_mad->mad_hdr.attr_id       = IB_PMA_CLASS_PORT_INFO;
+
+	in_mad->data[41] = port_num;
+
+	if ((ibdev->process_mad(ibdev, IB_MAD_IGNORE_MKEY, port_num,
+				NULL, NULL, in_mad, out_mad) &
+	    (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) !=
+	    (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cpi = (struct ib_class_port_info *)(out_mad->data + 40);
+	if (!(cpi->capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) &&
+	    !(cpi->capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF))
+		ret = -ENOSYS;
+
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+
+	return ret;
+}
+
 static void ib_port_release(struct kobject *kobj)
 {
 	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
@@ -520,6 +612,12 @@ static int add_port(struct ib_device *device, int port_num,
 	if (ret)
 		goto err_put;

+	if (is_pma_class_cap_ext_width(device, port_num) == 0) {
+		ret = sysfs_create_group(&p->kobj, &pma_ext_group);
+		if (ret)
+			goto err_put;
+	}
+
 	p->gid_group.name  = "gids";
 	p->gid_group.attrs = alloc_group_attrs(show_port_gid, attr.gid_tbl_len);
 	if (!p->gid_group.attrs)
diff --git a/include/rdma/ib_pma.h b/include/rdma/ib_pma.h
index a5889f1..2f8a65c 100644
--- a/include/rdma/ib_pma.h
+++ b/include/rdma/ib_pma.h
@@ -42,6 +42,7 @@
  */
 #define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
 #define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
+#define IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF cpu_to_be16(1 << 10)
 #define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)

 #define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
