From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp
Date: Mon, 4 Mar 2019 10:56:20 +0800
Message-ID: <20190304025620.27224-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

In commit 0425e3e6e0c7, hns_roce_v2_modify_qp called inside
spinlock which using GFP_KERNEL, it may sleep with holding
the spinlock, so we should use GFP_ATOMIC instead.

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8795266..1c54390 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4027,7 +4027,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	struct device *dev = hr_dev->dev;
 	int ret = -EINVAL;
 
-	context = kcalloc(2, sizeof(*context), GFP_KERNEL);
+	context = kcalloc(2, sizeof(*context), GFP_ATOMIC);
 	if (!context)
 		return -ENOMEM;
 
-- 
2.7.0
