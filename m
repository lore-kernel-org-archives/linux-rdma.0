From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-next 3/5] RDMA/ocrdma: Check resource ids received in Async CQE
Date: Tue, 20 Oct 2015 14:17:58 +0530
Message-ID: <1445330880-3912-4-git-send-email-selvin.xavier@avagotech.com>
References: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445330880-3912-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Naga Irrinki <Naga.Irrinki-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naga Irrinki <Naga.Irrinki-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Some versions of the FW sends wrong QP or CQ IDs in the
Async CQE. Adding a check to see whether qp or cq structures
associated with the CQE is valid.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aab391a..9d99142 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -678,11 +678,33 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	int dev_event = 0;
 	int type = (cqe->valid_ae_event & OCRDMA_AE_MCQE_EVENT_TYPE_MASK) >>
 	    OCRDMA_AE_MCQE_EVENT_TYPE_SHIFT;
+	u16 qpid = cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPID_MASK;
+	u16 cqid = cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQID_MASK;
 
-	if (cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPVALID)
-		qp = dev->qp_tbl[cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPID_MASK];
-	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID)
-		cq = dev->cq_tbl[cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQID_MASK];
+	/*
+	 * Some FW version returns wrong qp or cq ids in CQEs.
+	 * Checking whether the IDs are valid
+	 */
+
+	if (cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPVALID) {
+		if (qpid < dev->attr.max_qp)
+			qp = dev->qp_tbl[qpid];
+		if (qp == NULL) {
+			pr_err("ocrdma%d:Async event - qpid %u is not valid\n",
+			       dev->id, qpid);
+			return;
+		}
+	}
+
+	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID) {
+		if (cqid < dev->attr.max_cq)
+			cq = dev->cq_tbl[cqid];
+		if (cq == NULL) {
+			pr_err("ocrdma%d:Async event - cqid %u is not valid\n",
+			       dev->id, cqid);
+			return;
+		}
+	}
 
 	memset(&ib_evt, 0, sizeof(ib_evt));
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
