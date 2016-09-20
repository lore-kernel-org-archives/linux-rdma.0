From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 14/19] IB/hns: Validate mtu when modified qp
Date: Tue, 20 Sep 2016 17:07:07 +0100
Message-ID: <20160920160712.1190216-15-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Peter Chen <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The mtu should be validated when modify qp,so we check it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Peter Chen <luck.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
PATCH V2: Addressed Leon Romanovsky's comments
          Link: https://lkml.org/lkml/2016/9/13/39
PATCH V1: Initial Submit
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index dd1b214..6a38909 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <rdma/ib_addr.h>
 #include <rdma/ib_umem.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
@@ -657,6 +658,7 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	struct device *dev = &hr_dev->pdev->dev;
 	int ret = -EINVAL;
 	int p;
+	enum ib_mtu active_mtu;
 
 	mutex_lock(&hr_qp->mutex);
 
@@ -687,6 +689,19 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		}
 	}
 
+	if (attr_mask & IB_QP_PATH_MTU) {
+		p = attr_mask & IB_QP_PORT ? (attr->port_num - 1) : hr_qp->port;
+		active_mtu = iboe_get_mtu(hr_dev->iboe.netdevs[p]->mtu);
+
+		if (attr->path_mtu > IB_MTU_2048 ||
+		    attr->path_mtu < IB_MTU_256 ||
+		    attr->path_mtu > active_mtu) {
+			dev_err(dev, "attr path_mtu(%d)invalid while modify qp",
+				attr->path_mtu);
+			goto out;
+		}
+	}
+
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic > hr_dev->caps.max_qp_init_rdma) {
 		dev_err(dev, "attr max_rd_atomic invalid.attr->max_rd_atomic=%d\n",
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
