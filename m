From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Thu, 17 Dec 2015 16:50:09 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512171649070.22782@east.gentwo.org>
References: <20151217195255.334854705@linux.com> <20151217195312.334770847@linux.com> <567316F7.9030707@dev.mellanox.co.il> <alpine.DEB.2.20.1512171527060.22782@east.gentwo.org> <56732D97.2080303@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56732D97.2080303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 17 Dec 2015, Hal Rosenstock wrote:

> On 12/17/2015 4:28 PM, Christoph Lameter wrote:
> > So port_check_extended_counters need to return another value for this.
> > The IETF ones are the uni/mcast xxx counters?
>
> Yes

Ok. Then this patch on top of the last one should give us all of what you
want:



Subject: IB core counters: Support noietf extended counters

Detect if we have extended counters but not IETF counters.
For that we need a special table and create a function that
returns the table address.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/core/sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/core/sysfs.c
+++ linux/drivers/infiniband/core/sysfs.c
@@ -493,6 +493,26 @@ static struct attribute *pma_attrs_ext[]
 	NULL
 };

+static struct attribute *pma_attrs_noietf[] = {
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
+	NULL
+};
+
 static struct attribute_group pma_group = {
 	.name  = "counters",
 	.attrs  = pma_attrs
@@ -503,6 +523,11 @@ static struct attribute_group pma_group_
 	.attrs  = pma_attrs_ext
 };

+static struct attribute_group pma_group_noietf = {
+	.name  = "counters",
+	.attrs  = pma_attrs_noietf
+};
+
 static void ib_port_release(struct kobject *kobj)
 {
 	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
@@ -576,23 +601,32 @@ err:
 }

 /*
- * Check if the port supports the Extended Counters.
- * Return error code of 0 for success
+ * Figure out which counter table to use depending on
+ * the device capabilities.
  */
-static int port_check_extended_counters(struct ib_device *dev)
+static struct attribute_group *get_counter_table(struct ib_device *dev)
 {
 	int ret = 0;
 	struct ib_class_port_info cpi;

 	ret = get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO, &cpi, 40, sizeof(cpi));

-	if (ret >= 0) {
-		if (!(cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) &&
-			!(cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF))
-			ret = -ENOSYS;
+	if (ret < 0)
+		/* Fall back to normal counters */
+		return &pma_group;
+
+
+	if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) {
+		/* We have extended counters */
+
+		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
+			/* But not the IETF ones */
+			return &pma_group_noietf;
+
+		return &pma_group_ext;
 	}

-	return ret;
+	return &pma_group;
 }

 static int add_port(struct ib_device *device, int port_num,
@@ -623,11 +657,7 @@ static int add_port(struct ib_device *de
 		return ret;
 	}

-	ret = sysfs_create_group(&p->kobj,
-		port_check_extended_counters(device) ?
-			&pma_group_ext :
-			&pma_group);
-
+	ret = sysfs_create_group(&p->kobj, get_counter_table(device));
 	if (ret)
 		goto err_put;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
