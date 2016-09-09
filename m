From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 16/20] IB/hns: Validate mtu when modified qp
Date: Fri, 9 Sep 2016 18:30:47 +0800
Message-ID: <1473417051-99560-17-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Peter Chen <luck.chen@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

The mtu should be validated when modify qp,so we check it.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Peter Chen <luck.chen@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 51fefbf..1c5be59 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <rdma/ib_addr.h>
 #include <rdma/ib_umem.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
@@ -658,6 +659,7 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	struct device *dev = &hr_dev->pdev->dev;
 	int ret = -EINVAL;
 	int p;
+	u32 active_mtu = 0;
 
 	mutex_lock(&hr_qp->mutex);
 
@@ -688,6 +690,19 @@ int hns_roce_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
1.7.9.5
