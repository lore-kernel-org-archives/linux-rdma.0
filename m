From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 37/37] IB/rdmavt: Add support for new memory registration API
Date: Mon, 07 Dec 2015 15:45:41 -0500
Message-ID: <20151207204540.8144.94303.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

commit 38071a461f0a ("IB/qib: Support the new memory registration API")"
added support for map_mr_sg to qib. This patch brings that
support into rdmavt, it also adds a register mr function that will be
called from the post send routine which is inline with the qib patch.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   91 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mr.h |    5 ++
 drivers/infiniband/sw/rdmavt/vt.c |    1 
 include/rdma/rdma_vt.h            |    2 -
 4 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index e809aaa..3ca8a6b 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -474,6 +474,7 @@ int rvt_dereg_mr(struct ib_mr *ibmr)
 	int ret = 0;
 	unsigned long timeout;
 
+	kfree(mr->pages);
 	rvt_free_lkey(&mr->mr);
 
 	rvt_put_mr(&mr->mr); /* will set completion if last */
@@ -515,7 +516,38 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 	if (IS_ERR(mr))
 		return (struct ib_mr *)mr;
 
+	mr->pages = kcalloc(max_num_sg, sizeof(u64), GFP_KERNEL);
+	if (!mr->pages)
+		goto err;
+
 	return &mr->ibmr;
+
+err:
+	rvt_dereg_mr(&mr->ibmr);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int rvt_set_page(struct ib_mr *ibmr, u64 addr)
+{
+	struct rvt_mr *mr = to_imr(ibmr);
+
+	if (unlikely(mr->npages == mr->mr.max_segs))
+		return -ENOMEM;
+
+	mr->pages[mr->npages++] = addr;
+
+	return 0;
+}
+
+int rvt_map_mr_sg(struct ib_mr *ibmr,
+		  struct scatterlist *sg,
+		  int sg_nents)
+{
+	struct rvt_mr *mr = to_imr(ibmr);
+
+	mr->npages = 0;
+
+	return ib_sg_to_pages(ibmr, sg, sg_nents, rvt_set_page);
 }
 
 /**
@@ -867,3 +899,62 @@ bail:
 	return 0;
 }
 EXPORT_SYMBOL(rvt_rkey_ok);
+
+/*
+ * Initialize the memory region specified by the work request.
+ * This is only called in the post send.
+ */
+int rvt_reg_mr(struct rvt_qp *qp, struct ib_reg_wr *wr)
+{
+	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+	struct rvt_lkey_table *rkt = &rdi->lk_table;
+	struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
+	struct rvt_mr *mr = to_imr(wr->mr);
+	struct rvt_mregion *mrg;
+	u32 key = wr->key;
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
+		rkt->table[(key >> (32 - rdi->dparms.lkey_table_size))],
+		lockdep_is_held(&rkt->lock));
+	if (unlikely(!mrg || qp->ibqp.pd != mrg->pd))
+		goto bail;
+
+	if (mr->npages > mrg->max_segs)
+		goto bail;
+
+	ps = mr->ibmr.page_size;
+	if (mr->ibmr.length > ps * mr->npages)
+		goto bail;
+
+	mrg->user_base = mr->ibmr.iova;
+	mrg->iova = mr->ibmr.iova;
+	mrg->lkey = key;
+	mrg->length = mr->ibmr.length;
+	mrg->access_flags = wr->access;
+	page_list = mr->pages;
+	m = 0;
+	n = 0;
+	for (i = 0; i < mr->npages; i++) {
+		mrg->map[m]->segs[n].vaddr = (void *)page_list[i];
+		mrg->map[m]->segs[n].length = ps;
+		if (++n == RVT_SEGSZ) {
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
+EXPORT_SYMBOL(rvt_reg_mr);
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index 3b43278..3bb3306 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -60,6 +60,8 @@ struct rvt_fmr {
 struct rvt_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
+	u64 *pages;
+	u32 npages;
 	struct rvt_mregion mr;  /* must be last */
 };
 
@@ -88,6 +90,9 @@ int rvt_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
 			   enum ib_mr_type mr_type,
 			   u32 max_num_sg);
+int rvt_map_mr_sg(struct ib_mr *ibmr,
+		  struct scatterlist *sg,
+		  int sg_nents);
 struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 			     struct ib_fmr_attr *fmr_attr);
 int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d541b05..3b38dd3 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -306,6 +306,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, unmap_fmr);
 	CDR(rdi, dealloc_fmr);
 	CDR(rdi, mmap);
+	CDR(rdi, map_mr_sg);
 
 	/* Completion queues */
 	CDR(rdi, create_cq);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index afcc819..9faacdf 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -335,5 +335,5 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 					   void *obj);
 void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
 			  u32 size, void *obj);
-
+int rvt_reg_mr(struct rvt_qp *qp, struct ib_reg_wr *wr);
 #endif          /* DEF_RDMA_VT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
