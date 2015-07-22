From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 35/43] qib: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:35 +0300
Message-ID: <1437548143-24893-36-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just duplicated the functions to take the needed
arguments from the private MR context. The old
fast_reg routines will be dropped later.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  | 56 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_mr.c    | 11 +++++++
 drivers/infiniband/hw/qib/qib_verbs.c |  6 +++-
 drivers/infiniband/hw/qib/qib_verbs.h |  5 ++++
 4 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index ad843c7..557e6c2 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -385,3 +385,59 @@ bail:
 	spin_unlock_irqrestore(&rkt->lock, flags);
 	return ret;
 }
+
+/*
+ * Initialize the memory region specified by the work reqeust.
+ */
+int qib_fastreg_mr(struct qib_qp *qp, struct ib_send_wr *wr)
+{
+	struct qib_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
+	struct qib_pd *pd = to_ipd(qp->ibqp.pd);
+	struct qib_mr *mr = to_imr(wr->wr.fastreg.mr);
+	struct qib_mregion *mrg;
+	u32 key = wr->wr.fastreg.key;
+	unsigned i, n, m;
+	int ret = -EINVAL;
+	unsigned long flags;
+	u64 *page_list;
+	size_t ps;
+
+	spin_lock_irqsave(&rkt->lock, flags);
+	if (pd->user || key == 0)
+		goto bail;
+
+	mrg = rcu_dereference_protected(
+		rkt->table[(key >> (32 - ib_qib_lkey_table_size))],
+		lockdep_is_held(&rkt->lock));
+	if (unlikely(mrg == NULL || qp->ibqp.pd != mrg->pd))
+		goto bail;
+
+	if (mr->npages > mrg->max_segs)
+		goto bail;
+
+	ps = 1UL << PAGE_SHIFT;
+	if (mr->ibmr.length > ps * mr->npages)
+		goto bail;
+
+	mrg->user_base = mr->ibmr.iova;
+	mrg->iova = mr->ibmr.iova;
+	mrg->lkey = key;
+	mrg->length = mr->ibmr.length;
+	mrg->access_flags = mr->ibmr.access;
+	page_list = mr->pl;
+	m = 0;
+	n = 0;
+	for (i = 0; i < wr->wr.fast_reg.page_list_len; i++) {
+		mrg->map[m]->segs[n].vaddr = (void *) page_list[i];
+		mrg->map[m]->segs[n].length = ps;
+		if (++n == QIB_SEGSZ) {
+			m++;
+			n = 0;
+		}
+	}
+
+	ret = 0;
+bail:
+	spin_unlock_irqrestore(&rkt->lock, flags);
+	return ret;
+}
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index a58a347..a4986f0 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -353,6 +353,17 @@ err:
 	return ERR_PTR(-ENOMEM);
 }
 
+int qib_map_mr_sg(struct ib_mr *ibmr,
+		  struct scatterlist *sg,
+		  unsigned short sg_nents)
+{
+	struct qib_mr *mr = to_imr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mr->mr.max_segs,
+			      mr->pl, &mr->npages,
+			      &ibmr->length, &ibmr->iova);
+}
+
 struct ib_fast_reg_page_list *
 qib_alloc_fast_reg_page_list(struct ib_device *ibdev, int page_list_len)
 {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index ef022a1..8561f90 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -361,7 +361,10 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	 * undefined operations.
 	 * Make sure buffer is large enough to hold the result for atomics.
 	 */
-	if (wr->opcode == IB_WR_FAST_REG_MR) {
+	if (wr->opcode == IB_WR_FASTREG_MR) {
+		if (qib_fastreg_mr(qp, wr))
+			goto bail_inval;
+	} else if (wr->opcode == IB_WR_FAST_REG_MR) {
 		if (qib_fast_reg_mr(qp, wr))
 			goto bail_inval;
 	} else if (qp->ibqp.qp_type == IB_QPT_UC) {
@@ -2236,6 +2239,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->reg_user_mr = qib_reg_user_mr;
 	ibdev->dereg_mr = qib_dereg_mr;
 	ibdev->alloc_mr = qib_alloc_mr;
+	ibdev->map_mr_sg = qib_map_mr_sg;
 	ibdev->alloc_fast_reg_page_list = qib_alloc_fast_reg_page_list;
 	ibdev->free_fast_reg_page_list = qib_free_fast_reg_page_list;
 	ibdev->alloc_fmr = qib_alloc_fmr;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index c8062ae..c7a3af5 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1039,12 +1039,17 @@ struct ib_mr *qib_alloc_mr(struct ib_pd *pd,
 			   u32 max_entries,
 			   u32 flags);
 
+int qib_map_mr_sg(struct ib_mr *ibmr,
+		  struct scatterlist *sg,
+		  unsigned short sg_nents);
+
 struct ib_fast_reg_page_list *qib_alloc_fast_reg_page_list(
 				struct ib_device *ibdev, int page_list_len);
 
 void qib_free_fast_reg_page_list(struct ib_fast_reg_page_list *pl);
 
 int qib_fast_reg_mr(struct qib_qp *qp, struct ib_send_wr *wr);
+int qib_fastreg_mr(struct qib_qp *qp, struct ib_send_wr *wr);
 
 struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			     struct ib_fmr_attr *fmr_attr);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
