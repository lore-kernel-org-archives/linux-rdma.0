From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 2/5] RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
Date: Thu, 17 May 2018 16:02:50 +0800
Message-ID: <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org

This patch modified uar allocation algorithm in hns_roce_uar_alloc
function to avoid bitmap exhaust.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_pd.c     | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 53c2f1b..412297d4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -214,6 +214,7 @@ enum {
 struct hns_roce_uar {
 	u64		pfn;
 	unsigned long	index;
+	unsigned long	logic_idx;
 };
 
 struct hns_roce_ucontext {
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 4b41e04..b9f2c87 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -107,13 +107,15 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
 	int ret = 0;
 
 	/* Using bitmap to manager UAR index */
-	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->index);
+	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
 	if (ret == -1)
 		return -ENOMEM;
 
-	if (uar->index > 0)
-		uar->index = (uar->index - 1) %
+	if (uar->logic_idx > 0 && hr_dev->caps.phy_num_uars > 1)
+		uar->index = (uar->logic_idx - 1) %
 			     (hr_dev->caps.phy_num_uars - 1) + 1;
+	else
+		uar->index = 0;
 
 	if (!dev_is_pci(hr_dev->dev)) {
 		res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
@@ -132,7 +134,7 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
 
 void hns_roce_uar_free(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
 {
-	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->index,
+	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
 			     BITMAP_NO_RR);
 }
 
-- 
1.9.1
