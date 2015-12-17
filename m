From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] IB core counters: Specify attribute_id in port_table_attribute
Date: Thu, 17 Dec 2015 13:52:57 -0600
Message-ID: <20151217195312.228660904@linux.com>
References: <20151217195255.334854705@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=ib_64bit_specify_attribute_id
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add the attr_id on port_table_attribute since we will have to add
a different port_table_attribute for the extended attribute soon.

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
@@ -314,7 +316,8 @@ static ssize_t show_port_pkey(struct ib_
 #define PORT_PMA_ATTR(_name, _counter, _width, _offset)			\
 struct port_table_attribute port_pma_attr_##_name = {			\
 	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
-	.index = (_offset) | ((_width) << 16) | ((_counter) << 24)	\
+	.index = (_offset) | ((_width) << 16) | ((_counter) << 24),	\
+	.attr_id = IB_PMA_PORT_COUNTERS ,				\
 }
 
 /*
@@ -376,7 +379,7 @@ static ssize_t show_pma_counter(struct i
 	ssize_t ret;
 	u8 data[8];
 
-	ret = get_perf_mad(p->ibdev, p->port_num, cpu_to_be16(0x12), &data,
+	ret = get_perf_mad(p->ibdev, p->port_num, tab_attr->attr_id, &data,
 			40 + offset / 8, sizeof(data));
 	if (ret < 0)
 		return sprintf(buf, "N/A (no PMA)\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
