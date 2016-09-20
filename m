From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 02/19] IB/hns: Remove parameters of resize cq
Date: Tue, 20 Sep 2016 17:06:55 +0100
Message-ID: <20160920160712.1190216-3-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Dongdong Huang <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

In old version of RoCE, it doesn't support to resize cq.
So, we remove parameters related to resize cq.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 3 ---
 drivers/infiniband/hw/hns/hns_roce_device.h | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 10fd209..a52306f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -299,10 +299,7 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 
 	cq_entries = roundup_pow_of_two((unsigned int)cq_entries);
 	hr_cq->ib_cq.cqe = cq_entries - 1;
-	mutex_init(&hr_cq->resize_mutex);
 	spin_lock_init(&hr_cq->lock);
-	hr_cq->hr_resize_buf = NULL;
-	hr_cq->resize_umem = NULL;
 
 	if (context) {
 		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index db974e4..15bc229 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -284,20 +284,11 @@ struct hns_roce_cq_buf {
 	struct hns_roce_mtt hr_mtt;
 };
 
-struct hns_roce_cq_resize {
-	struct hns_roce_cq_buf	hr_buf;
-	int			cqe;
-};
-
 struct hns_roce_cq {
 	struct ib_cq			ib_cq;
 	struct hns_roce_cq_buf		hr_buf;
-	/* pointer to store information after resize*/
-	struct hns_roce_cq_resize	*hr_resize_buf;
 	spinlock_t			lock;
-	struct mutex			resize_mutex;
 	struct ib_umem			*umem;
-	struct ib_umem			*resize_umem;
 	void (*comp)(struct hns_roce_cq *);
 	void (*event)(struct hns_roce_cq *, enum hns_roce_event);
 
-- 
1.9.1
