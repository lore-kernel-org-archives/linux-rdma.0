From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: removed use_cnt for queues.
Date: Tue, 28 May 2013 15:42:42 +0530
Message-ID: <53ab9538-b443-4b0a-ade8-dbecc311182c@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lnx-roce-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Removed use_cnt. Rely on OFED stack to keep track of the use count.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  4 ---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 39 +----------------------------
 3 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 48970af..21d99f6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -97,7 +97,6 @@ struct ocrdma_queue_info {
 	u16 id;			/* qid, where to ring the doorbell. */
 	u16 head, tail;
 	bool created;
-	atomic_t used;		/* Number of valid elements in the queue */
 };
 
 struct ocrdma_eq {
@@ -198,7 +197,6 @@ struct ocrdma_cq {
 	struct ocrdma_ucontext *ucontext;
 	dma_addr_t pa;
 	u32 len;
-	atomic_t use_cnt;
 
 	/* head of all qp's sq and rq for which cqes need to be flushed
 	 * by the software.
@@ -210,7 +208,6 @@ struct ocrdma_pd {
 	struct ib_pd ibpd;
 	struct ocrdma_dev *dev;
 	struct ocrdma_ucontext *uctx;
-	atomic_t use_cnt;
 	u32 id;
 	int num_dpp_qp;
 	u32 dpp_page;
@@ -246,7 +243,6 @@ struct ocrdma_srq {
 
 	struct ocrdma_qp_hwq_info rq;
 	struct ocrdma_pd *pd;
-	atomic_t use_cnt;
 	u32 id;
 	u64 *rqe_wr_id_tbl;
 	u32 *idx_bit_fields;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 71942af..910b706 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -128,7 +128,6 @@ static inline struct ocrdma_mqe *ocrdma_get_mqe(struct ocrdma_dev *dev)
 static inline void ocrdma_mq_inc_head(struct ocrdma_dev *dev)
 {
 	dev->mq.sq.head = (dev->mq.sq.head + 1) & (OCRDMA_MQ_LEN - 1);
-	atomic_inc(&dev->mq.sq.used);
 }
 
 static inline void *ocrdma_get_mqe_rsp(struct ocrdma_dev *dev)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index b29a424..38c145b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -398,7 +398,6 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 		kfree(pd);
 		return ERR_PTR(status);
 	}
-	atomic_set(&pd->use_cnt, 0);
 
 	if (udata && context) {
 		status = ocrdma_copy_pd_uresp(pd, context, udata);
@@ -419,12 +418,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	int status;
 	u64 usr_db;
 
-	if (atomic_read(&pd->use_cnt)) {
-		ocrdma_err("%s(%d) pd=0x%x is in use.\n",
-			   __func__, dev->id, pd->id);
-		status = -EFAULT;
-		goto dealloc_err;
-	}
 	status = ocrdma_mbx_dealloc_pd(dev, pd);
 	if (pd->uctx) {
 		u64 dpp_db = dev->nic_info.dpp_unmapped_addr +
@@ -436,7 +429,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 		ocrdma_del_mmap(pd->uctx, usr_db, dev->nic_info.db_page_size);
 	}
 	kfree(pd);
-dealloc_err:
 	return status;
 }
 
@@ -474,7 +466,6 @@ static struct ocrdma_mr *ocrdma_alloc_lkey(struct ib_pd *ibpd,
 		return ERR_PTR(-ENOMEM);
 	}
 	mr->pd = pd;
-	atomic_inc(&pd->use_cnt);
 	mr->ibmr.lkey = mr->hwmr.lkey;
 	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
 		mr->ibmr.rkey = mr->hwmr.lkey;
@@ -664,7 +655,6 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	if (status)
 		goto mbx_err;
 	mr->pd = pd;
-	atomic_inc(&pd->use_cnt);
 	mr->ibmr.lkey = mr->hwmr.lkey;
 	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
 		mr->ibmr.rkey = mr->hwmr.lkey;
@@ -689,7 +679,6 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 	if (mr->hwmr.fr_mr == 0)
 		ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
 
-	atomic_dec(&mr->pd->use_cnt);
 	/* it could be user registered memory. */
 	if (mr->umem)
 		ib_umem_release(mr->umem);
@@ -752,7 +741,6 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 
 	spin_lock_init(&cq->cq_lock);
 	spin_lock_init(&cq->comp_handler_lock);
-	atomic_set(&cq->use_cnt, 0);
 	INIT_LIST_HEAD(&cq->sq_head);
 	INIT_LIST_HEAD(&cq->rq_head);
 	cq->dev = dev;
@@ -799,9 +787,6 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
 	struct ocrdma_dev *dev = cq->dev;
 
-	if (atomic_read(&cq->use_cnt))
-		return -EINVAL;
-
 	status = ocrdma_mbx_destroy_cq(dev, cq);
 
 	if (cq->ucontext) {
@@ -1023,15 +1008,6 @@ static void ocrdma_set_qp_init_params(struct ocrdma_qp *qp,
 	qp->state = OCRDMA_QPS_RST;
 }
 
-static void ocrdma_set_qp_use_cnt(struct ocrdma_qp *qp, struct ocrdma_pd *pd)
-{
-	atomic_inc(&pd->use_cnt);
-	atomic_inc(&qp->sq_cq->use_cnt);
-	atomic_inc(&qp->rq_cq->use_cnt);
-	if (qp->srq)
-		atomic_inc(&qp->srq->use_cnt);
-	qp->ibqp.qp_num = qp->id;
-}
 
 static void ocrdma_store_gsi_qp_cq(struct ocrdma_dev *dev,
 				   struct ib_qp_init_attr *attrs)
@@ -1099,7 +1075,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 			goto cpy_err;
 	}
 	ocrdma_store_gsi_qp_cq(dev, attrs);
-	ocrdma_set_qp_use_cnt(qp, pd);
+	qp->ibqp.qp_num = qp->id;
 	mutex_unlock(&dev->dev_lock);
 	return &qp->ibqp;
 
@@ -1475,11 +1451,6 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 
 	ocrdma_del_flush_qp(qp);
 
-	atomic_dec(&qp->pd->use_cnt);
-	atomic_dec(&qp->sq_cq->use_cnt);
-	atomic_dec(&qp->rq_cq->use_cnt);
-	if (qp->srq)
-		atomic_dec(&qp->srq->use_cnt);
 	kfree(qp->wqe_wr_id_tbl);
 	kfree(qp->rqe_wr_id_tbl);
 	kfree(qp);
@@ -1565,14 +1536,12 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 			goto arm_err;
 	}
 
-	atomic_set(&srq->use_cnt, 0);
 	if (udata) {
 		status = ocrdma_copy_srq_uresp(srq, udata);
 		if (status)
 			goto arm_err;
 	}
 
-	atomic_inc(&pd->use_cnt);
 	return &srq->ibsrq;
 
 arm_err:
@@ -1618,18 +1587,12 @@ int ocrdma_destroy_srq(struct ib_srq *ibsrq)
 
 	srq = get_ocrdma_srq(ibsrq);
 	dev = srq->dev;
-	if (atomic_read(&srq->use_cnt)) {
-		ocrdma_err("%s(%d) err, srq=0x%x in use\n",
-			   __func__, dev->id, srq->id);
-		return -EAGAIN;
-	}
 
 	status = ocrdma_mbx_destroy_srq(dev, srq);
 
 	if (srq->pd->uctx)
 		ocrdma_del_mmap(srq->pd->uctx, (u64) srq->rq.pa, srq->rq.len);
 
-	atomic_dec(&srq->pd->use_cnt);
 	kfree(srq->idx_bit_fields);
 	kfree(srq->rqe_wr_id_tbl);
 	kfree(srq);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
