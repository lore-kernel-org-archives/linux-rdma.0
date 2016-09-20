From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 17/19] IB/hns: Fix the bug when platform_get_resource() exec fail
Date: Tue, 20 Sep 2016 17:07:10 +0100
Message-ID: <20160920160712.1190216-18-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch mainly fixes the bug with platform_get_resource().
It should return NULL when platform_get_resource() exec fail.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_pd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 0cd6132..05db7d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -110,6 +110,10 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
 			     (hr_dev->caps.phy_num_uars - 1) + 1;
 
 	res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&hr_dev->pdev->dev, "memory resource not found!\n");
+		return -EINVAL;
+	}
 	uar->pfn = ((res->start) >> PAGE_SHIFT) + uar->index;
 
 	return 0;
-- 
1.9.1
