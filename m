From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 04/20] IB/hns: Fix bug of using uninit refcount and free
Date: Fri, 9 Sep 2016 18:30:35 +0800
Message-ID: <1473417051-99560-5-git-send-email-salil.mehta@huawei.com>
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

In current version, it uses uninitialized parameters named
refcount and free in hns_roce_cq_event.
This patch initializes these parameter in cq alloc and add
correspond process in cq free.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index a52306f..3095f06 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -152,6 +152,9 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 	hr_cq->cons_index = 0;
 	hr_cq->uar = hr_uar;
 
+	atomic_set(&hr_cq->refcount, 1);
+	init_completion(&hr_cq->free);
+
 	return 0;
 
 err_radix:
@@ -191,6 +194,11 @@ static void hns_roce_free_cq(struct hns_roce_dev *hr_dev,
 	/* Waiting interrupt process procedure carried out */
 	synchronize_irq(hr_dev->eq_table.eq[hr_cq->vector].irq);
 
+	/* wait for all interrupt processed */
+	if (atomic_dec_and_test(&hr_cq->refcount))
+		complete(&hr_cq->free);
+	wait_for_completion(&hr_cq->free);
+
 	spin_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, hr_cq->cqn);
 	spin_unlock_irq(&cq_table->lock);
-- 
1.7.9.5
