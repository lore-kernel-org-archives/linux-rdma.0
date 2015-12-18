From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/10] IB: remove ib_query_mr
Date: Fri, 18 Dec 2015 14:54:58 +0100
Message-ID: <1450446906-10336-3-git-send-email-hch@lst.de>
References: <1450446906-10336-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450446906-10336-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This functionality has no users and was only supported by the staged out
EHCA driver.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> [core]
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/verbs.c         |  7 -----
 drivers/staging/rdma/ehca/ehca_iverbs.h |  2 --
 drivers/staging/rdma/ehca/ehca_main.c   |  1 -
 drivers/staging/rdma/ehca/ehca_mrmw.c   | 49 ---------------------------------
 include/rdma/ib_verbs.h                 | 18 ------------
 5 files changed, 77 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 87d3746..29a3e53 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1216,13 +1216,6 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 }
 EXPORT_SYMBOL(ib_get_dma_mr);
 
-int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
-{
-	return mr->device->query_mr ?
-		mr->device->query_mr(mr, mr_attr) : -ENOSYS;
-}
-EXPORT_SYMBOL(ib_query_mr);
-
 int ib_dereg_mr(struct ib_mr *mr)
 {
 	struct ib_pd *pd;
diff --git a/drivers/staging/rdma/ehca/ehca_iverbs.h b/drivers/staging/rdma/ehca/ehca_iverbs.h
index 75c9876..4a45ca3 100644
--- a/drivers/staging/rdma/ehca/ehca_iverbs.h
+++ b/drivers/staging/rdma/ehca/ehca_iverbs.h
@@ -94,8 +94,6 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 		       struct ib_phys_buf *phys_buf_array,
 		       int num_phys_buf, int mr_access_flags, u64 *iova_start);
 
-int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr);
-
 int ehca_dereg_mr(struct ib_mr *mr);
 
 struct ib_mw *ehca_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
index 285e560..0be7959 100644
--- a/drivers/staging/rdma/ehca/ehca_main.c
+++ b/drivers/staging/rdma/ehca/ehca_main.c
@@ -513,7 +513,6 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.get_dma_mr	    = ehca_get_dma_mr;
 	shca->ib_device.reg_phys_mr	    = ehca_reg_phys_mr;
 	shca->ib_device.reg_user_mr	    = ehca_reg_user_mr;
-	shca->ib_device.query_mr	    = ehca_query_mr;
 	shca->ib_device.dereg_mr	    = ehca_dereg_mr;
 	shca->ib_device.rereg_phys_mr	    = ehca_rereg_phys_mr;
 	shca->ib_device.alloc_mw	    = ehca_alloc_mw;
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index f914b30..eb274c1 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -589,55 +589,6 @@ rereg_phys_mr_exit0:
 	return ret;
 } /* end ehca_rereg_phys_mr() */
 
-/*----------------------------------------------------------------------*/
-
-int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
-{
-	int ret = 0;
-	u64 h_ret;
-	struct ehca_shca *shca =
-		container_of(mr->device, struct ehca_shca, ib_device);
-	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
-	unsigned long sl_flags;
-	struct ehca_mr_hipzout_parms hipzout;
-
-	if ((e_mr->flags & EHCA_MR_FLAG_FMR)) {
-		ehca_err(mr->device, "not supported for FMR, mr=%p e_mr=%p "
-			 "e_mr->flags=%x", mr, e_mr, e_mr->flags);
-		ret = -EINVAL;
-		goto query_mr_exit0;
-	}
-
-	memset(mr_attr, 0, sizeof(struct ib_mr_attr));
-	spin_lock_irqsave(&e_mr->mrlock, sl_flags);
-
-	h_ret = hipz_h_query_mr(shca->ipz_hca_handle, e_mr, &hipzout);
-	if (h_ret != H_SUCCESS) {
-		ehca_err(mr->device, "hipz_mr_query failed, h_ret=%lli mr=%p "
-			 "hca_hndl=%llx mr_hndl=%llx lkey=%x",
-			 h_ret, mr, shca->ipz_hca_handle.handle,
-			 e_mr->ipz_mr_handle.handle, mr->lkey);
-		ret = ehca2ib_return_code(h_ret);
-		goto query_mr_exit1;
-	}
-	mr_attr->pd = mr->pd;
-	mr_attr->device_virt_addr = hipzout.vaddr;
-	mr_attr->size = hipzout.len;
-	mr_attr->lkey = hipzout.lkey;
-	mr_attr->rkey = hipzout.rkey;
-	ehca_mrmw_reverse_map_acl(&hipzout.acl, &mr_attr->mr_access_flags);
-
-query_mr_exit1:
-	spin_unlock_irqrestore(&e_mr->mrlock, sl_flags);
-query_mr_exit0:
-	if (ret)
-		ehca_err(mr->device, "ret=%i mr=%p mr_attr=%p",
-			 ret, mr, mr_attr);
-	return ret;
-} /* end ehca_query_mr() */
-
-/*----------------------------------------------------------------------*/
-
 int ehca_dereg_mr(struct ib_mr *mr)
 {
 	int ret = 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index db4e3fe..a2a7c22 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1180,15 +1180,6 @@ struct ib_phys_buf {
 	u64      size;
 };
 
-struct ib_mr_attr {
-	struct ib_pd	*pd;
-	u64		device_virt_addr;
-	u64		size;
-	int		mr_access_flags;
-	u32		lkey;
-	u32		rkey;
-};
-
 enum ib_mr_rereg_flags {
 	IB_MR_REREG_TRANS	= 1,
 	IB_MR_REREG_PD		= (1<<1),
@@ -1737,8 +1728,6 @@ struct ib_device {
 						    int mr_access_flags,
 						    struct ib_pd *pd,
 						    struct ib_udata *udata);
-	int                        (*query_mr)(struct ib_mr *mr,
-					       struct ib_mr_attr *mr_attr);
 	int                        (*dereg_mr)(struct ib_mr *mr);
 	struct ib_mr *		   (*alloc_mr)(struct ib_pd *pd,
 					       enum ib_mr_type mr_type,
@@ -2883,13 +2872,6 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 }
 
 /**
- * ib_query_mr - Retrieves information about a specific memory region.
- * @mr: The memory region to retrieve information about.
- * @mr_attr: The attributes of the specified memory region.
- */
-int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr);
-
-/**
  * ib_dereg_mr - Deregisters a memory region and removes it from the
  *   HCA translation table.
  * @mr: The memory region to deregister.
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
