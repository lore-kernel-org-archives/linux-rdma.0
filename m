From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures in the resource destroy path
Date: Sat, 16 May 2015 13:21:48 +0530
Message-ID: <1431762709-20740-11-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Avoid returning FW failures in the resource destroy verbs.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 48ec56f..b1f9d7d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -531,13 +531,12 @@ map_err:
 
 int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 {
-	int status = 0;
 	struct ocrdma_mm *mm, *tmp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ibctx);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibctx->device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 
-	status = ocrdma_dealloc_ucontext_pd(uctx);
+	(void)ocrdma_dealloc_ucontext_pd(uctx);
 
 	ocrdma_del_mmap(uctx, uctx->ah_tbl.pa, uctx->ah_tbl.len);
 	dma_free_coherent(&pdev->dev, uctx->ah_tbl.len, uctx->ah_tbl.va,
@@ -548,7 +547,7 @@ int ocrdma_dealloc_ucontext(struct ib_ucontext *ibctx)
 		kfree(mm);
 	}
 	kfree(uctx);
-	return status;
+	return 0;
 }
 
 int ocrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
@@ -690,7 +689,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_ucontext *uctx = NULL;
-	int status = 0;
 	u64 usr_db;
 
 	uctx = pd->uctx;
@@ -704,11 +702,11 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 
 		if (is_ucontext_pd(uctx, pd)) {
 			ocrdma_release_ucontext_pd(uctx);
-			return status;
+			return 0;
 		}
 	}
-	status = _ocrdma_dealloc_pd(dev, pd);
-	return status;
+	(void)_ocrdma_dealloc_pd(dev, pd);
+	return 0;
 }
 
 static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
@@ -1905,13 +1903,12 @@ int ocrdma_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 
 int ocrdma_destroy_srq(struct ib_srq *ibsrq)
 {
-	int status;
 	struct ocrdma_srq *srq;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibsrq->device);
 
 	srq = get_ocrdma_srq(ibsrq);
 
-	status = ocrdma_mbx_destroy_srq(dev, srq);
+	(void)ocrdma_mbx_destroy_srq(dev, srq);
 
 	if (srq->pd->uctx)
 		ocrdma_del_mmap(srq->pd->uctx, (u64) srq->rq.pa,
@@ -1920,7 +1917,7 @@ int ocrdma_destroy_srq(struct ib_srq *ibsrq)
 	kfree(srq->idx_bit_fields);
 	kfree(srq->rqe_wr_id_tbl);
 	kfree(srq);
-	return status;
+	return 0;
 }
 
 /* unprivileged verbs and their support functions. */
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
