From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/8] qedr: clear the vendor error field in the work completion
Date: Thu, 22 Dec 2016 14:40:39 +0200
Message-ID: <1482410440-2297-8-git-send-email-Ram.Amrani@cavium.com>
References: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We clear the vendor error field in the work completion so that if
a work completion is erroneous  the field won't confuse the caller.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 18341ed..2c4496f 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3185,6 +3185,7 @@ static int process_req(struct qedr_dev *dev, struct qedr_qp *qp,
 
 		/* fill WC */
 		wc->status = status;
+		wc->vendor_err = 0;
 		wc->wc_flags = 0;
 		wc->src_qp = qp->id;
 		wc->qp = &qp->ibqp;
@@ -3374,6 +3375,7 @@ static void __process_resp_one(struct qedr_dev *dev, struct qedr_qp *qp,
 
 	/* fill WC */
 	wc->status = wc_status;
+	wc->vendor_err = 0;
 	wc->src_qp = qp->id;
 	wc->qp = &qp->ibqp;
 	wc->wr_id = wr_id;
@@ -3402,6 +3404,7 @@ static int process_resp_flush(struct qedr_qp *qp, struct qedr_cq *cq,
 	while (num_entries && qp->rq.wqe_cons != hw_cons) {
 		/* fill WC */
 		wc->status = IB_WC_WR_FLUSH_ERR;
+		wc->vendor_err = 0;
 		wc->wc_flags = 0;
 		wc->src_qp = qp->id;
 		wc->byte_len = 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
