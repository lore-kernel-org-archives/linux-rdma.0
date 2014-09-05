From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: convert kernel va to pa for mmap in user
Date: Fri, 5 Sep 2014 19:35:40 +0530
Message-ID: <0526d46d-a1f3-4dd5-ace6-882d008826d3@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some platforms, when iommu is enabled, bus address
returned by dma_alloc_coherent is different than the
physical address. ocrdma should use physical address
for mmap-ing the queue memory for the applications.

This patch adds the use of virt_to_phys at all such places
where kernel buffer is mapped to user process context.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index acb434d..4924eae 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -388,7 +388,7 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 
 	memset(&resp, 0, sizeof(resp));
 	resp.ah_tbl_len = ctx->ah_tbl.len;
-	resp.ah_tbl_page = ctx->ah_tbl.pa;
+	resp.ah_tbl_page = virt_to_phys(ctx->ah_tbl.va);
 
 	status = ocrdma_add_mmap(ctx, resp.ah_tbl_page, resp.ah_tbl_len);
 	if (status)
@@ -870,7 +870,7 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	uresp.page_size = PAGE_ALIGN(cq->len);
 	uresp.num_pages = 1;
 	uresp.max_hw_cqe = cq->max_hw_cqe;
-	uresp.page_addr[0] = cq->pa;
+	uresp.page_addr[0] = virt_to_phys(cq->va);
 	uresp.db_page_addr =  ocrdma_get_db_addr(dev, uctx->cntxt_pd->id);
 	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.phase_change = cq->phase_change ? 1 : 0;
@@ -1123,13 +1123,13 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	uresp.sq_dbid = qp->sq.dbid;
 	uresp.num_sq_pages = 1;
 	uresp.sq_page_size = PAGE_ALIGN(qp->sq.len);
-	uresp.sq_page_addr[0] = qp->sq.pa;
+	uresp.sq_page_addr[0] = virt_to_phys(qp->sq.va);
 	uresp.num_wqe_allocated = qp->sq.max_cnt;
 	if (!srq) {
 		uresp.rq_dbid = qp->rq.dbid;
 		uresp.num_rq_pages = 1;
 		uresp.rq_page_size = PAGE_ALIGN(qp->rq.len);
-		uresp.rq_page_addr[0] = qp->rq.pa;
+		uresp.rq_page_addr[0] = virt_to_phys(qp->rq.va);
 		uresp.num_rqe_allocated = qp->rq.max_cnt;
 	}
 	uresp.db_page_addr = usr_db;
@@ -1680,7 +1680,7 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
 	memset(&uresp, 0, sizeof(uresp));
 	uresp.rq_dbid = srq->rq.dbid;
 	uresp.num_rq_pages = 1;
-	uresp.rq_page_addr[0] = srq->rq.pa;
+	uresp.rq_page_addr[0] = virt_to_phys(srq->rq.va);
 	uresp.rq_page_size = srq->rq.len;
 	uresp.db_page_addr = dev->nic_info.unmapped_db +
 	    (srq->pd->id * dev->nic_info.db_page_size);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
