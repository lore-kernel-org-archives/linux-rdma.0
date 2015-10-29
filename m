From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 27/26] IB/hfi1: Remove fast registration from the code
Date: Thu, 29 Oct 2015 17:33:31 +0200
Message-ID: <1446132812-20170-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The driver does not support it anyway, and the support
should be added to a generic layer shared by both hfi1,
qib and softroce drivers.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/keys.c  |   55 -------------------------------------
 drivers/staging/rdma/hfi1/mr.c    |   33 +---------------------
 drivers/staging/rdma/hfi1/verbs.c |    9 +-----
 drivers/staging/rdma/hfi1/verbs.h |    8 -----
 4 files changed, 3 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/keys.c b/drivers/staging/rdma/hfi1/keys.c
index 82c21b1..cb4e608 100644
--- a/drivers/staging/rdma/hfi1/keys.c
+++ b/drivers/staging/rdma/hfi1/keys.c
@@ -354,58 +354,3 @@ bail:
 	rcu_read_unlock();
 	return 0;
 }
-
-/*
- * Initialize the memory region specified by the work request.
- */
-int hfi1_fast_reg_mr(struct hfi1_qp *qp, struct ib_fast_reg_wr *wr)
-{
-	struct hfi1_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct hfi1_pd *pd = to_ipd(qp->ibqp.pd);
-	struct hfi1_mregion *mr;
-	u32 rkey = wr->rkey;
-	unsigned i, n, m;
-	int ret = -EINVAL;
-	unsigned long flags;
-	u64 *page_list;
-	size_t ps;
-
-	spin_lock_irqsave(&rkt->lock, flags);
-	if (pd->user || rkey == 0)
-		goto bail;
-
-	mr = rcu_dereference_protected(
-		rkt->table[(rkey >> (32 - hfi1_lkey_table_size))],
-		lockdep_is_held(&rkt->lock));
-	if (unlikely(mr == NULL || qp->ibqp.pd != mr->pd))
-		goto bail;
-
-	if (wr->page_list_len > mr->max_segs)
-		goto bail;
-
-	ps = 1UL << wr->page_shift;
-	if (wr->length > ps * wr->page_list_len)
-		goto bail;
-
-	mr->user_base = wr->iova_start;
-	mr->iova = wr->iova_start;
-	mr->lkey = rkey;
-	mr->length = wr->length;
-	mr->access_flags = wr->access_flags;
-	page_list = wr->page_list->page_list;
-	m = 0;
-	n = 0;
-	for (i = 0; i < wr->page_list_len; i++) {
-		mr->map[m]->segs[n].vaddr = (void *) page_list[i];
-		mr->map[m]->segs[n].length = ps;
-		if (++n == HFI1_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-
-	ret = 0;
-bail:
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	return ret;
-}
diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1/mr.c
index bd64e4f..402bd64 100644
--- a/drivers/staging/rdma/hfi1/mr.c
+++ b/drivers/staging/rdma/hfi1/mr.c
@@ -344,9 +344,10 @@ out:
 
 /*
  * Allocate a memory region usable with the
- * IB_WR_FAST_REG_MR send work request.
+ * IB_WR_REG_MR send work request.
  *
  * Return the memory region on success, otherwise return an errno.
+ * FIXME: IB_WR_REG_MR is not supported
  */
 struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
@@ -364,36 +365,6 @@ struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
 	return &mr->ibmr;
 }
 
-struct ib_fast_reg_page_list *
-hfi1_alloc_fast_reg_page_list(struct ib_device *ibdev, int page_list_len)
-{
-	unsigned size = page_list_len * sizeof(u64);
-	struct ib_fast_reg_page_list *pl;
-
-	if (size > PAGE_SIZE)
-		return ERR_PTR(-EINVAL);
-
-	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
-	if (!pl)
-		return ERR_PTR(-ENOMEM);
-
-	pl->page_list = kzalloc(size, GFP_KERNEL);
-	if (!pl->page_list)
-		goto err_free;
-
-	return pl;
-
-err_free:
-	kfree(pl);
-	return ERR_PTR(-ENOMEM);
-}
-
-void hfi1_free_fast_reg_page_list(struct ib_fast_reg_page_list *pl)
-{
-	kfree(pl->page_list);
-	kfree(pl);
-}
-
 /**
  * hfi1_alloc_fmr - allocate a fast memory region
  * @pd: the protection domain for this memory region
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 981e6c1..6e2da7e 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -380,9 +380,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 	 * undefined operations.
 	 * Make sure buffer is large enough to hold the result for atomics.
 	 */
-	if (wr->opcode == IB_WR_FAST_REG_MR) {
-		return -EINVAL;
-	} else if (qp->ibqp.qp_type == IB_QPT_UC) {
+	if (qp->ibqp.qp_type == IB_QPT_UC) {
 		if ((unsigned) wr->opcode >= IB_WR_RDMA_READ)
 			return -EINVAL;
 	} else if (qp->ibqp.qp_type != IB_QPT_RC) {
@@ -417,9 +415,6 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 	if (qp->ibqp.qp_type != IB_QPT_UC &&
 	    qp->ibqp.qp_type != IB_QPT_RC)
 		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
-	else if (wr->opcode == IB_WR_FAST_REG_MR)
-		memcpy(&wqe->fast_reg_wr, fast_reg_wr(wr),
-			sizeof(wqe->fast_reg_wr));
 	else if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
 		 wr->opcode == IB_WR_RDMA_WRITE ||
 		 wr->opcode == IB_WR_RDMA_READ)
@@ -2065,8 +2060,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->reg_user_mr = hfi1_reg_user_mr;
 	ibdev->dereg_mr = hfi1_dereg_mr;
 	ibdev->alloc_mr = hfi1_alloc_mr;
-	ibdev->alloc_fast_reg_page_list = hfi1_alloc_fast_reg_page_list;
-	ibdev->free_fast_reg_page_list = hfi1_free_fast_reg_page_list;
 	ibdev->alloc_fmr = hfi1_alloc_fmr;
 	ibdev->map_phys_fmr = hfi1_map_phys_fmr;
 	ibdev->unmap_fmr = hfi1_unmap_fmr;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index cf5a3c9..159ec08 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -353,7 +353,6 @@ struct hfi1_swqe {
 		struct ib_rdma_wr rdma_wr;
 		struct ib_atomic_wr atomic_wr;
 		struct ib_ud_wr ud_wr;
-		struct ib_fast_reg_wr fast_reg_wr;
 	};
 	u32 psn;                /* first packet sequence number */
 	u32 lpsn;               /* last packet sequence number */
@@ -1026,13 +1025,6 @@ struct ib_mr *hfi1_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
 			    u32 max_entries);
 
-struct ib_fast_reg_page_list *hfi1_alloc_fast_reg_page_list(
-				struct ib_device *ibdev, int page_list_len);
-
-void hfi1_free_fast_reg_page_list(struct ib_fast_reg_page_list *pl);
-
-int hfi1_fast_reg_mr(struct hfi1_qp *qp, struct ib_fast_reg_wr *wr);
-
 struct ib_fmr *hfi1_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			      struct ib_fmr_attr *fmr_attr);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
