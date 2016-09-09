From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 05/20] IB/hns: Simplify function of pd alloc and qp alloc
Date: Fri, 9 Sep 2016 18:30:36 +0800
Message-ID: <1473417051-99560-6-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Hns_roce_pd_alloc and hns_roce_reserve_range_qp use unnecessary
transformation of parameters. This patch simplify these two
functions.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_pd.c |   14 +-------------
 drivers/infiniband/hw/hns/hns_roce_qp.c |   10 +---------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 4109f74..0cd6132 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -35,19 +35,7 @@
 
 static int hns_roce_pd_alloc(struct hns_roce_dev *hr_dev, unsigned long *pdn)
 {
-	struct device *dev = &hr_dev->pdev->dev;
-	unsigned long pd_number;
-	int ret = 0;
-
-	ret = hns_roce_bitmap_alloc(&hr_dev->pd_bitmap, &pd_number);
-	if (ret == -1) {
-		dev_err(dev, "alloc pdn from pdbitmap failed\n");
-		return -ENOMEM;
-	}
-
-	*pdn = pd_number;
-
-	return 0;
+	return hns_roce_bitmap_alloc(&hr_dev->pd_bitmap, pdn);
 }
 
 static void hns_roce_pd_free(struct hns_roce_dev *hr_dev, unsigned long pdn)
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 089da7f..6095cde 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -113,16 +113,8 @@ static int hns_roce_reserve_range_qp(struct hns_roce_dev *hr_dev, int cnt,
 				     int align, unsigned long *base)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
-	int ret = 0;
-	unsigned long qpn;
-
-	ret = hns_roce_bitmap_alloc_range(&qp_table->bitmap, cnt, align, &qpn);
-	if (ret == -1)
-		return -ENOMEM;
 
-	*base = qpn;
-
-	return 0;
+	return hns_roce_bitmap_alloc_range(&qp_table->bitmap, cnt, align, base);
 }
 
 enum hns_roce_qp_state to_hns_roce_state(enum ib_qp_state state)
-- 
1.7.9.5
