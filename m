From: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Subject: [PATCH] IB/hns: Fix a potential use after free in 'hns_roce_v1_destroy_qp_work_fn()'
Date: Wed, 28 Jun 2017 07:22:27 +0200
Message-ID: <20170628052227.31493-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The last 'dev_dbg' call uses 'hr_qp->qpn'. However, 'hr_qp' may have been
freed a few lines above.

In order to fix it, take the value of 'hr_qp->qpn' earlier in the function
and use it instead.

Fixes: d838c481e025 ("IB/hns: Fix the bug when destroy qp")
Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 37d5d29597a4..8233335a0fc2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3641,6 +3641,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	struct hns_roce_dev *hr_dev;
 	struct hns_roce_qp *hr_qp;
 	struct device *dev;
+	unsigned long qpn;
 	int ret;
 
 	qp_work_entry = container_of(work, struct hns_roce_qp_work, work);
@@ -3648,8 +3649,9 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	dev = &hr_dev->pdev->dev;
 	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
 	hr_qp = qp_work_entry->qp;
+	qpn = hr_qp->qpn;
 
-	dev_dbg(dev, "Schedule destroy QP(0x%lx) work.\n", hr_qp->qpn);
+	dev_dbg(dev, "Schedule destroy QP(0x%lx) work.\n", qpn);
 
 	qp_work_entry->sche_cnt++;
 
@@ -3660,7 +3662,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 					 &qp_work_entry->db_wait_stage);
 	if (ret) {
 		dev_err(dev, "Check QP(0x%lx) db process status failed!\n",
-			hr_qp->qpn);
+			qpn);
 		return;
 	}
 
@@ -3674,7 +3676,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	ret = hns_roce_v1_modify_qp(&hr_qp->ibqp, NULL, 0, hr_qp->state,
 				    IB_QPS_RESET);
 	if (ret) {
-		dev_err(dev, "Modify QP(0x%lx) to RST failed!\n", hr_qp->qpn);
+		dev_err(dev, "Modify QP(0x%lx) to RST failed!\n", qpn);
 		return;
 	}
 
@@ -3683,14 +3685,14 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 
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
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
