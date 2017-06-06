From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/5] IB/hns: Fix the bug with wild pointer when destroy rc qp
Date: Tue, 6 Jun 2017 09:24:45 +0800
Message-ID: <1496712288-63434-3-git-send-email-oulijun@huawei.com>
References: <1496712288-63434-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496712288-63434-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When destroyed rc qp, the hr_qp will be used after freed. This patch
will fix it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 4b886c6..aa2e31da 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3655,6 +3655,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	struct hns_roce_dev *hr_dev;
 	struct hns_roce_qp *hr_qp;
 	struct device *dev;
+	unsigned long qpn;
 	int ret;
 
 	qp_work_entry = container_of(work, struct hns_roce_qp_work, work);
@@ -3662,8 +3663,9 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	dev = &hr_dev->pdev->dev;
 	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
 	hr_qp = qp_work_entry->qp;
+	qpn = hr_qp->qpn;
 
-	dev_dbg(dev, "Schedule destroy QP(0x%lx) work.\n", hr_qp->qpn);
+	dev_dbg(dev, "Schedule destroy QP(0x%lx) work.\n", qpn);
 
 	qp_work_entry->sche_cnt++;
 
@@ -3674,7 +3676,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 					 &qp_work_entry->db_wait_stage);
 	if (ret) {
 		dev_err(dev, "Check QP(0x%lx) db process status failed!\n",
-			hr_qp->qpn);
+			qpn);
 		return;
 	}
 
@@ -3688,7 +3690,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	ret = hns_roce_v1_modify_qp(&hr_qp->ibqp, NULL, 0, hr_qp->state,
 				    IB_QPS_RESET);
 	if (ret) {
-		dev_err(dev, "Modify QP(0x%lx) to RST failed!\n", hr_qp->qpn);
+		dev_err(dev, "Modify QP(0x%lx) to RST failed!\n", qpn);
 		return;
 	}
 
@@ -3697,14 +3699,14 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_RC) {
 		/* RC QP, release QPN */
-		hns_roce_release_range_qp(hr_dev, hr_qp->qpn, 1);
+		hns_roce_release_range_qp(hr_dev, qpn, 1);
 		kfree(hr_qp);
 	} else
 		kfree(hr_to_hr_sqp(hr_qp));
 
 	kfree(qp_work_entry);
 
-	dev_dbg(dev, "Accomplished destroy QP(0x%lx) work.\n", hr_qp->qpn);
+	dev_dbg(dev, "Accomplished destroy QP(0x%lx) work.\n", qpn);
 }
 
 int hns_roce_v1_destroy_qp(struct ib_qp *ibqp)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
