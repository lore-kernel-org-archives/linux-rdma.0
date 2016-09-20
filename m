From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 01/19] IB/hns: Remove unused parameters in some functions
Date: Tue, 20 Sep 2016 17:06:54 +0100
Message-ID: <20160920160712.1190216-2-salil.mehta@huawei.com>
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

The parameter named collapsed unused in hns_roce_cq_alloc.
Also, parameter named doorbell_lock unsed in
hns_roce_v1_cq_set_ci. This patch optimize these parameters.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  7 +++----
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 13 ++++---------
 drivers/infiniband/hw/hns/hns_roce_main.c   |  1 -
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 875597b..10fd209 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -83,8 +83,7 @@ static int hns_roce_sw2hw_cq(struct hns_roce_dev *dev,
 static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 			     struct hns_roce_mtt *hr_mtt,
 			     struct hns_roce_uar *hr_uar,
-			     struct hns_roce_cq *hr_cq, int vector,
-			     int collapsed)
+			     struct hns_roce_cq *hr_cq, int vector)
 {
 	struct hns_roce_cmd_mailbox *mailbox = NULL;
 	struct hns_roce_cq_table *cq_table = NULL;
@@ -338,8 +337,8 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 	}
 
 	/* Allocate cq index, fill cq_context */
-	ret = hns_roce_cq_alloc(hr_dev, cq_entries, &hr_cq->hr_buf.hr_mtt,
-				uar, hr_cq, vector, 0);
+	ret = hns_roce_cq_alloc(hr_dev, cq_entries, &hr_cq->hr_buf.hr_mtt, uar,
+				hr_cq, vector);
 	if (ret) {
 		dev_err(dev, "Creat CQ .Failed to cq_alloc.\n");
 		goto err_mtt;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 4d02bcf..db974e4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -536,7 +536,6 @@ struct hns_roce_dev {
 	struct hns_roce_uar     priv_uar;
 	const char		*irq_names[HNS_ROCE_MAX_IRQ_NUM];
 	spinlock_t		sm_lock;
-	spinlock_t		cq_db_lock;
 	spinlock_t		bt_cmd_lock;
 	struct hns_roce_ib_iboe iboe;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 5ffdf7a..48c0862 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1189,9 +1189,7 @@ static struct hns_roce_cqe *next_cqe_sw(struct hns_roce_cq *hr_cq)
 	return get_sw_cqe(hr_cq, hr_cq->cons_index);
 }
 
-void hns_roce_v1_cq_set_ci(struct hns_roce_cq *hr_cq, u32 cons_index,
-			   spinlock_t *doorbell_lock)
-
+void hns_roce_v1_cq_set_ci(struct hns_roce_cq *hr_cq, u32 cons_index)
 {
 	u32 doorbell[2];
 
@@ -1251,8 +1249,7 @@ static void __hns_roce_v1_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
 		*/
 		wmb();
 
-		hns_roce_v1_cq_set_ci(hr_cq, hr_cq->cons_index,
-				   &to_hr_dev(hr_cq->ib_cq.device)->cq_db_lock);
+		hns_roce_v1_cq_set_ci(hr_cq, hr_cq->cons_index);
 	}
 }
 
@@ -1588,10 +1585,8 @@ int hns_roce_v1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 			break;
 	}
 
-	if (npolled) {
-		hns_roce_v1_cq_set_ci(hr_cq, hr_cq->cons_index,
-				      &to_hr_dev(ibcq->device)->cq_db_lock);
-	}
+	if (npolled)
+		hns_roce_v1_cq_set_ci(hr_cq, hr_cq->cons_index);
 
 	spin_unlock_irqrestore(&hr_cq->lock, flags);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index a9960ba..4b44998 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -951,7 +951,6 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 	struct device *dev = &hr_dev->pdev->dev;
 
 	spin_lock_init(&hr_dev->sm_lock);
-	spin_lock_init(&hr_dev->cq_db_lock);
 	spin_lock_init(&hr_dev->bt_cmd_lock);
 
 	ret = hns_roce_init_uar_table(hr_dev);
-- 
1.9.1
