From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 15/19] IB/hns: Cq has not been freed
Date: Tue, 20 Sep 2016 17:07:08 +0100
Message-ID: <20160920160712.1190216-16-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Peter Chen <luck.chen@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Cq has not been freed when fail to ib_copy_to_udata, so need to
free it.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Peter Chen <luck.chen@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 3095f06..0973659 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -357,12 +357,15 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 	if (context) {
 		if (ib_copy_to_udata(udata, &hr_cq->cqn, sizeof(u64))) {
 			ret = -EFAULT;
-			goto err_mtt;
+			goto err_cqc;
 		}
 	}
 
 	return &hr_cq->ib_cq;
 
+err_cqc:
+	hns_roce_free_cq(hr_dev, hr_cq);
+
 err_mtt:
 	hns_roce_mtt_cleanup(hr_dev, &hr_cq->hr_buf.hr_mtt);
 	if (context)
-- 
1.9.1
