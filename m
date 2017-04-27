From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 3/5] RDMA/qedr: enhance destroy flow for GSI QP
Date: Thu, 27 Apr 2017 13:35:33 +0300
Message-ID: <1493289335-29350-4-git-send-email-Ram.Amrani@cavium.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid attempting to release irrelevant (and unused) resources for GSI QP.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 62ab22a..bb235ea 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -992,26 +992,27 @@ int qedr_destroy_cq(struct ib_cq *ibcq)
 	struct qed_rdma_destroy_cq_out_params oparams;
 	struct qed_rdma_destroy_cq_in_params iparams;
 	struct qedr_cq *cq = get_qedr_cq(ibcq);
+	int rc;
 
-	DP_DEBUG(dev, QEDR_MSG_CQ, "destroy cq: cq_id %d", cq->icid);
+	DP_DEBUG(dev, QEDR_MSG_CQ, "destroy cq %p (icid=%d)\n", cq, cq->icid);
 
 	/* GSIs CQs are handled by driver, so they don't exist in the FW */
-	if (cq->cq_type != QEDR_CQ_TYPE_GSI) {
-		int rc;
+	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
+		goto done;
 
-		iparams.icid = cq->icid;
-		rc = dev->ops->rdma_destroy_cq(dev->rdma_ctx, &iparams,
-					       &oparams);
-		if (rc)
-			return rc;
-		dev->ops->common->chain_free(dev->cdev, &cq->pbl);
-	}
+	iparams.icid = cq->icid;
+	rc = dev->ops->rdma_destroy_cq(dev->rdma_ctx, &iparams, &oparams);
+	if (rc)
+		return rc;
+
+	dev->ops->common->chain_free(dev->cdev, &cq->pbl);
 
 	if (ibcq->uobject && ibcq->uobject->context) {
 		qedr_free_pbl(dev, &cq->q.pbl_info, cq->q.pbl_tbl);
 		ib_umem_release(cq->q.umem);
 	}
 
+done:
 	kfree(cq);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
