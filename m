From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE device
Date: Wed, 10 Jan 2018 14:39:53 +0800
Message-ID: <1515566393-63888-8-git-send-email-oulijun@huawei.com>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515566393-63888-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch assgin a guid(Global Unique identifer)
value to the hip08 device.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
V2:
- Use the correct way to update guid from Leon
  Romanovsky's review.

V1:
- The initial submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a1839a3..2af4948 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -34,6 +34,7 @@
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <net/addrconf.h>
 #include <rdma/ib_umem.h>
 
 #include "hnae3.h"
@@ -4679,6 +4680,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
 	hr_dev->iboe.phy_port[0] = 0;
 
+	addrconf_addr_eui48((u8 *)&hr_dev->ib_dev.node_guid,
+			    hr_dev->iboe.netdevs[0]->dev_addr);
+
 	for (i = 0; i < HNS_ROCE_V2_MAX_IRQ_NUM; i++)
 		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
 						i + handle->rinfo.base_vector);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
