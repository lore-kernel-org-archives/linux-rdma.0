From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Wed, 16 Dec 2015 10:22:10 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512161000150.17457@east.gentwo.org>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <20151211235630.GG7855@phlsvsds.ph.intel.com> <20151212000047.GA9961@obsidianresearch.com> <566EEE69.5080906@dev.mellanox.co.il> <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com> <5670717F.9090701@dev.mellanox.co.il> <20151215212035.GD28167@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151215212035.GD28167-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2015, Jason Gunthorpe wrote:

> > The unicast/multicast extended counters are not always supported -
> > depends on setting of PerfMgt ClassPortInfo
> > CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).
>
> Yes.. certainly this proposed patch needs to account for that and
> continue to use the 32 bit ones in that case.

So this is in struct ib_class_port_info the capability_mask? This does not
seem to be used anywhere in the IB core.

Here is a draft patch to change the counters depending on a bit (which I
do not know how to determine). So this would hopefully work if someone
would insert the proper check. Note that this patch no longer needs the
earlier 2 patches.

>From Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: IB Core: Display extended counter set if available

Check if the extended counters are available and if so
create the proper extended and additional counters.

DRAFT: This is missing the check if this device supports
extended counters.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/core/sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/core/sysfs.c
+++ linux/drivers/infiniband/core/sysfs.c
@@ -39,6 +39,7 @@
 #include <linux/string.h>

 #include <rdma/ib_mad.h>
+#include <rdma/ib_pma.h>

 struct ib_port {
 	struct kobject         kobj;
@@ -65,6 +66,7 @@ struct port_table_attribute {
 	struct port_attribute	attr;
 	char			name[8];
 	int			index;
+	int			attr_id;
 };

 static ssize_t port_attr_show(struct kobject *kobj,
@@ -314,7 +316,15 @@ static ssize_t show_port_pkey(struct ib_
 #define PORT_PMA_ATTR(_name, _counter, _width, _offset)			\
 struct port_table_attribute port_pma_attr_##_name = {			\
 	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
-	.index = (_offset) | ((_width) << 16) | ((_counter) << 24)	\
+	.index = (_offset) | ((_width) << 16) | ((_counter) << 24),	\
+	.attr_id = IB_PMA_PORT_COUNTERS ,				\
+}
+
+#define PORT_PMA_ATTR_EXT(_name, _width, _offset)			\
+struct port_table_attribute port_pma_attr_ext_##_name = {		\
+	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
+	.index = (_offset) | ((_width) << 16),				\
+	.attr_id = IB_PMA_PORT_COUNTERS_EXT ,				\
 }

 static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
@@ -344,7 +354,7 @@ static ssize_t show_pma_counter(struct i
 	in_mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_PERF_MGMT;
 	in_mad->mad_hdr.class_version = 1;
 	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
-	in_mad->mad_hdr.attr_id       = cpu_to_be16(0x12); /* PortCounters */
+	in_mad->mad_hdr.attr_id       = tab_attr->attr_id;

 	in_mad->data[41] = p->port_num;	/* PortSelect field */

@@ -375,6 +385,11 @@ static ssize_t show_pma_counter(struct i
 		ret = sprintf(buf, "%u\n",
 			      be32_to_cpup((__be32 *)(out_mad->data + 40 + offset / 8)));
 		break;
+	case 64:
+		ret = sprintf(buf, "%llu\n",
+				be64_to_cpup((__be64 *)(out_mad->data + 40 + offset / 8)));
+		break;
+
 	default:
 		ret = 0;
 	}
@@ -403,6 +418,18 @@ static PORT_PMA_ATTR(port_rcv_data
 static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
 static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);

+/*
+ * Counters added by extended set
+ */
+static PORT_PMA_ATTR_EXT(port_xmit_data		    , 64,  64);
+static PORT_PMA_ATTR_EXT(port_rcv_data		    , 64, 128);
+static PORT_PMA_ATTR_EXT(port_xmit_packets	    , 64, 192);
+static PORT_PMA_ATTR_EXT(port_rcv_packets	    , 64, 256);
+static PORT_PMA_ATTR_EXT(unicast_xmit_packets	    , 64, 320);
+static PORT_PMA_ATTR_EXT(unicast_rcv_packets	    , 64, 384);
+static PORT_PMA_ATTR_EXT(multicast_xmit_packets	    , 64, 448);
+static PORT_PMA_ATTR_EXT(multicast_rcv_packets	    , 64, 512);
+
 static struct attribute *pma_attrs[] = {
 	&port_pma_attr_symbol_error.attr.attr,
 	&port_pma_attr_link_error_recovery.attr.attr,
@@ -423,11 +450,40 @@ static struct attribute *pma_attrs[] = {
 	NULL
 };

+static struct attribute *pma_attrs_ext[] = {
+	&port_pma_attr_symbol_error.attr.attr,
+	&port_pma_attr_link_error_recovery.attr.attr,
+	&port_pma_attr_link_downed.attr.attr,
+	&port_pma_attr_port_rcv_errors.attr.attr,
+	&port_pma_attr_port_rcv_remote_physical_errors.attr.attr,
+	&port_pma_attr_port_rcv_switch_relay_errors.attr.attr,
+	&port_pma_attr_port_xmit_discards.attr.attr,
+	&port_pma_attr_port_xmit_constraint_errors.attr.attr,
+	&port_pma_attr_port_rcv_constraint_errors.attr.attr,
+	&port_pma_attr_local_link_integrity_errors.attr.attr,
+	&port_pma_attr_excessive_buffer_overrun_errors.attr.attr,
+	&port_pma_attr_VL15_dropped.attr.attr,
+	&port_pma_attr_ext_port_xmit_data.attr.attr,
+	&port_pma_attr_ext_port_rcv_data.attr.attr,
+	&port_pma_attr_ext_port_xmit_packets.attr.attr,
+	&port_pma_attr_ext_port_rcv_packets.attr.attr,
+	&port_pma_attr_ext_unicast_rcv_packets.attr.attr,
+	&port_pma_attr_ext_unicast_xmit_packets.attr.attr,
+	&port_pma_attr_ext_multicast_rcv_packets.attr.attr,
+	&port_pma_attr_ext_multicast_xmit_packets.attr.attr,
+	NULL
+};
+
 static struct attribute_group pma_group = {
 	.name  = "counters",
 	.attrs  = pma_attrs
 };

+static struct attribute_group pma_group_ext = {
+	.name  = "counters",
+	.attrs  = pma_attrs_ext
+};
+
 static void ib_port_release(struct kobject *kobj)
 {
 	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
@@ -528,7 +584,9 @@ static int add_port(struct ib_device *de
 		return ret;
 	}

-	ret = sysfs_create_group(&p->kobj, &pma_group);
+	ret = sysfs_create_group(&p->kobj,
+		*** Extended counters *** ? &pma_group_ext : &pma_group);
+
 	if (ret)
 		goto err_put;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
