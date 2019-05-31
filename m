From: Colin King <colin.king@canonical.com>
Subject: [PATCH 1/2][next] RDMA/hns: fix comparison of unsigned long variable 'end' with less than zero
Date: Fri, 31 May 2019 10:21:00 +0100
Message-ID: <20190531092101.28772-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the comparison of end with less than zero is always false
because end is an unsigned long.  Also, replace checks of end with
non-zero with end > 0 as it is possible that the #defined decrement
may be changed in the future causing end to step over zero and go
negative.

The initialization of end with 0 is also redundant as this value is
never read and is later set to HW_SYNC_TIMEOUT_MSECS, so fix this by
initializing it with this value to begin with.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 669cefb654cb ("RDMA/hns: Remove jiffies operation in disable interrupt context")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c   |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 157c84a1f55f..b3641aeff27a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -326,7 +326,7 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 {
 	spinlock_t *lock = &hr_dev->bt_cmd_lock;
 	struct device *dev = hr_dev->dev;
-	unsigned long end = 0;
+	long end;
 	unsigned long flags;
 	struct hns_roce_hem_iter iter;
 	void __iomem *bt_cmd;
@@ -377,7 +377,7 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 		bt_cmd = hr_dev->reg_base + ROCEE_BT_CMD_H_REG;
 
 		end = HW_SYNC_TIMEOUT_MSECS;
-		while (end) {
+		while (end > 0) {
 			if (!readl(bt_cmd) >> BT_CMD_SYNC_SHIFT)
 				break;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 1fc77b1f2c6d..e13fea71bcb8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -966,7 +966,7 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
 	struct hns_roce_free_mr *free_mr;
 	struct hns_roce_v1_priv *priv;
 	struct completion comp;
-	unsigned long end = HNS_ROCE_V1_RECREATE_LP_QP_TIMEOUT_MSECS;
+	long end = HNS_ROCE_V1_RECREATE_LP_QP_TIMEOUT_MSECS;
 
 	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
@@ -986,7 +986,7 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
 
 	queue_work(free_mr->free_mr_wq, &(lp_qp_work->work));
 
-	while (end) {
+	while (end > 0) {
 		if (try_wait_for_completion(&comp))
 			return 0;
 		msleep(HNS_ROCE_V1_RECREATE_LP_QP_WAIT_VALUE);
@@ -1104,7 +1104,7 @@ static int hns_roce_v1_dereg_mr(struct hns_roce_dev *hr_dev,
 	struct hns_roce_free_mr *free_mr;
 	struct hns_roce_v1_priv *priv;
 	struct completion comp;
-	unsigned long end = HNS_ROCE_V1_FREE_MR_TIMEOUT_MSECS;
+	long end = HNS_ROCE_V1_FREE_MR_TIMEOUT_MSECS;
 	unsigned long start = jiffies;
 	int npages;
 	int ret = 0;
@@ -1134,7 +1134,7 @@ static int hns_roce_v1_dereg_mr(struct hns_roce_dev *hr_dev,
 
 	queue_work(free_mr->free_mr_wq, &(mr_work->work));
 
-	while (end) {
+	while (end > 0) {
 		if (try_wait_for_completion(&comp))
 			goto free_mr;
 		msleep(HNS_ROCE_V1_FREE_MR_WAIT_VALUE);
@@ -2425,7 +2425,8 @@ static int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_v1_priv *priv;
-	unsigned long end = 0, flags = 0;
+	unsigned long flags = 0;
+	long end = HW_SYNC_TIMEOUT_MSECS;
 	__le32 bt_cmd_val[2] = {0};
 	void __iomem *bt_cmd;
 	u64 bt_ba = 0;
@@ -2463,7 +2464,6 @@ static int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
 
 	bt_cmd = hr_dev->reg_base + ROCEE_BT_CMD_H_REG;
 
-	end = HW_SYNC_TIMEOUT_MSECS;
 	while (1) {
 		if (readl(bt_cmd) >> BT_CMD_SYNC_SHIFT) {
 			if (end < 0) {
-- 
2.20.1
