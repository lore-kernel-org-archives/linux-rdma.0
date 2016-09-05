From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/6] IB/core: remove ib_get_dma_mr
Date: Mon,  5 Sep 2016 12:56:21 +0200
Message-ID: <1473072981-2035-7-git-send-email-hch@lst.de>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473072981-2035-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We now only use it from ib_alloc_pd to create a local DMA lkey if the
device doesn't provide one, or a global rkey if the ULP requests it.

This patch removes ib_get_dma_mr and open codes the functionality in
ib_alloc_pd so that we can simplify the code and prevent abuse of the
functionality.  As a side effect we can also simplify things by removing
the valid access bit check, and the PD refcounting.

In the future I hope to also remove the per-PD global MR entirely by
shifting this work into the HW drivers, as one step towards avoiding
the struct ib_mr overload for various different use cases.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 34 ++++++++--------------------------
 include/rdma/ib_verbs.h         | 12 ------------
 2 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e87b518..d4ef3b1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -256,12 +256,17 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	if (mr_access_flags) {
 		struct ib_mr *mr;
 
-		mr = ib_get_dma_mr(pd, mr_access_flags);
+		mr = pd->device->get_dma_mr(pd, mr_access_flags);
 		if (IS_ERR(mr)) {
 			ib_dealloc_pd(pd);
-			return (struct ib_pd *)mr;
+			return ERR_CAST(mr);
 		}
 
+		mr->device	= pd->device;
+		mr->pd		= pd;
+		mr->uobject	= NULL;
+		mr->need_inval	= false;
+
 		pd->__internal_mr = mr;
 
 		if (!(device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY))
@@ -288,7 +293,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 	int ret;
 
 	if (pd->__internal_mr) {
-		ret = ib_dereg_mr(pd->__internal_mr);
+		ret = pd->device->dereg_mr(pd->__internal_mr);
 		WARN_ON(ret);
 		pd->__internal_mr = NULL;
 	}
@@ -1408,29 +1413,6 @@ EXPORT_SYMBOL(ib_resize_cq);
 
 /* Memory regions */
 
-struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
-{
-	struct ib_mr *mr;
-	int err;
-
-	err = ib_check_mr_access(mr_access_flags);
-	if (err)
-		return ERR_PTR(err);
-
-	mr = pd->device->get_dma_mr(pd, mr_access_flags);
-
-	if (!IS_ERR(mr)) {
-		mr->device  = pd->device;
-		mr->pd      = pd;
-		mr->uobject = NULL;
-		atomic_inc(&pd->usecnt);
-		mr->need_inval = false;
-	}
-
-	return mr;
-}
-EXPORT_SYMBOL(ib_get_dma_mr);
-
 int ib_dereg_mr(struct ib_mr *mr)
 {
 	struct ib_pd *pd = mr->pd;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4bdd898..0a6c708 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2879,18 +2879,6 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
 }
 
 /**
- * ib_get_dma_mr - Returns a memory region for system memory that is
- *   usable for DMA.
- * @pd: The protection domain associated with the memory region.
- * @mr_access_flags: Specifies the memory access rights.
- *
- * Note that the ib_dma_*() functions defined below must be used
- * to create/destroy addresses used with the Lkey or Rkey returned
- * by ib_get_dma_mr().
- */
-struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
-
-/**
  * ib_dma_mapping_error - check a DMA addr for error
  * @dev: The device for which the dma_addr was created
  * @dma_addr: The DMA address to check
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
