From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling
Date: Mon, 28 Dec 2015 16:53:18 -0500
Message-ID: <5681AF4E.8060604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Port number is not part of ClassPortInfo attribute but is
still needed as a parameter when invoking process_mad.

To properly handle this attribute, port_num is added as a
parameter to get_counter_table and get_perf_mad was changed
not to store port_num in the attribute itself when it's
querying the ClassPortInfo attribute.

This handles issue pointed out by Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 539040f..2daf832 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -438,7 +438,8 @@ static int get_perf_mad(struct ib_device *dev, int port_num, int attr,
 	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
 	in_mad->mad_hdr.attr_id       = attr;
 
-	in_mad->data[41] = port_num;	/* PortSelect field */
+	if (attr != IB_PMA_CLASS_PORT_INFO)
+		in_mad->data[41] = port_num;	/* PortSelect field */
 
 	if ((dev->process_mad(dev, IB_MAD_IGNORE_MKEY,
 		 port_num, NULL, NULL,
@@ -714,11 +715,12 @@ err:
  * Figure out which counter table to use depending on
  * the device capabilities.
  */
-static struct attribute_group *get_counter_table(struct ib_device *dev)
+static struct attribute_group *get_counter_table(struct ib_device *dev,
+						 int port_num)
 {
 	struct ib_class_port_info cpi;
 
-	if (get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO,
+	if (get_perf_mad(dev, port_num, IB_PMA_CLASS_PORT_INFO,
 				&cpi, 40, sizeof(cpi)) >= 0) {
 
 		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH)
@@ -776,7 +778,7 @@ static int add_port(struct ib_device *device, int port_num,
 		goto err_put;
 	}
 
-	p->pma_table = get_counter_table(device);
+	p->pma_table = get_counter_table(device, port_num);
 	ret = sysfs_create_group(&p->kobj, p->pma_table);
 	if (ret)
 		goto err_put_gid_attrs;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
