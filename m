From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 03/10] IB/qib: Use rdmavt protection domain
Date: Wed, 06 Jan 2016 10:07:49 -0800
Message-ID: <20160106180745.15836.5678.stgit@scvm10.sc.intel.com>
References: <20160106180541.15836.58173.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106180541.15836.58173.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove protection domain datastructure from qib and use rdmavts version.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  |    6 ++-
 drivers/infiniband/hw/qib/qib_mr.c    |    2 +
 drivers/infiniband/hw/qib/qib_ruc.c   |    4 +-
 drivers/infiniband/hw/qib/qib_verbs.c |   66 +++------------------------------
 drivers/infiniband/hw/qib/qib_verbs.h |   13 +------
 5 files changed, 12 insertions(+), 79 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index d725c56..04fa272 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -152,7 +152,7 @@ out:
  * Check the IB SGE for validity and initialize our internal version
  * of it.
  */
-int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
+int qib_lkey_ok(struct qib_lkey_table *rkt, struct rvt_pd *pd,
 		struct qib_sge *isge, struct ib_sge *sge, int acc)
 {
 	struct qib_mregion *mr;
@@ -263,7 +263,7 @@ int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,
 	 */
 	rcu_read_lock();
 	if (rkey == 0) {
-		struct qib_pd *pd = to_ipd(qp->ibqp.pd);
+		struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
 		struct qib_ibdev *dev = to_idev(pd->ibpd.device);
 
 		if (pd->user)
@@ -341,7 +341,7 @@ bail:
 int qib_reg_mr(struct qib_qp *qp, struct ib_reg_wr *wr)
 {
 	struct qib_lkey_table *rkt = &to_idev(qp->ibqp.device)->lk_table;
-	struct qib_pd *pd = to_ipd(qp->ibqp.pd);
+	struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	struct qib_mr *mr = to_imr(wr->mr);
 	struct qib_mregion *mrg;
 	u32 key = wr->key;
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 5f53304..9d84e0d 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -99,7 +99,7 @@ struct ib_mr *qib_get_dma_mr(struct ib_pd *pd, int acc)
 	struct ib_mr *ret;
 	int rval;
 
-	if (to_ipd(pd)->user) {
+	if (ibpd_to_rvtpd(pd)->user) {
 		ret = ERR_PTR(-EPERM);
 		goto bail;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index b1aa21b..425c8c2 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -84,11 +84,11 @@ static int qib_init_sge(struct qib_qp *qp, struct qib_rwqe *wqe)
 	int i, j, ret;
 	struct ib_wc wc;
 	struct qib_lkey_table *rkt;
-	struct qib_pd *pd;
+	struct rvt_pd *pd;
 	struct qib_sge_state *ss;
 
 	rkt = &to_idev(qp->ibqp.device)->lk_table;
-	pd = to_ipd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
+	pd = ibpd_to_rvtpd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
 	ss = &qp->r_sge;
 	ss->sg_list = qp->r_sg_list;
 	qp->r_len = 0;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index fb6ef2c..1aaafea 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -346,7 +346,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	int ret;
 	unsigned long flags;
 	struct qib_lkey_table *rkt;
-	struct qib_pd *pd;
+	struct rvt_pd *pd;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
@@ -396,7 +396,7 @@ static int qib_post_one_send(struct qib_qp *qp, struct ib_send_wr *wr,
 	}
 
 	rkt = &to_idev(qp->ibqp.device)->lk_table;
-	pd = to_ipd(qp->ibqp.pd);
+	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = get_swqe_ptr(qp, qp->s_head);
 
 	if (qp->ibqp.qp_type != IB_QPT_UC &&
@@ -1599,7 +1599,7 @@ static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_mr = dev->lk_table.max;
 	props->max_fmr = dev->lk_table.max;
 	props->max_map_per_fmr = 32767;
-	props->max_pd = ib_qib_max_pds;
+	props->max_pd = dev->rdi.dparms.props.max_pd;
 	props->max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
 	props->max_qp_init_rd_atom = 255;
 	/* props->max_res_rd_atom */
@@ -1751,61 +1751,6 @@ static int qib_query_gid(struct ib_device *ibdev, u8 port,
 	return ret;
 }
 
-static struct ib_pd *qib_alloc_pd(struct ib_device *ibdev,
-				  struct ib_ucontext *context,
-				  struct ib_udata *udata)
-{
-	struct qib_ibdev *dev = to_idev(ibdev);
-	struct qib_pd *pd;
-	struct ib_pd *ret;
-
-	/*
-	 * This is actually totally arbitrary.  Some correctness tests
-	 * assume there's a maximum number of PDs that can be allocated.
-	 * We don't actually have this limit, but we fail the test if
-	 * we allow allocations of more than we report for this value.
-	 */
-
-	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	spin_lock(&dev->n_pds_lock);
-	if (dev->n_pds_allocated == ib_qib_max_pds) {
-		spin_unlock(&dev->n_pds_lock);
-		kfree(pd);
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	dev->n_pds_allocated++;
-	spin_unlock(&dev->n_pds_lock);
-
-	/* ib_alloc_pd() will initialize pd->ibpd. */
-	pd->user = udata != NULL;
-
-	ret = &pd->ibpd;
-
-bail:
-	return ret;
-}
-
-static int qib_dealloc_pd(struct ib_pd *ibpd)
-{
-	struct qib_pd *pd = to_ipd(ibpd);
-	struct qib_ibdev *dev = to_idev(ibpd->device);
-
-	spin_lock(&dev->n_pds_lock);
-	dev->n_pds_allocated--;
-	spin_unlock(&dev->n_pds_lock);
-
-	kfree(pd);
-
-	return 0;
-}
-
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 {
 	/* A multicast address requires a GRH (see ch. 8.4.1). */
@@ -2110,7 +2055,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 	spin_lock_init(&dev->qpt_lock);
-	spin_lock_init(&dev->n_pds_lock);
 	spin_lock_init(&dev->n_ahs_lock);
 	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
@@ -2234,8 +2178,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_gid = qib_query_gid;
 	ibdev->alloc_ucontext = qib_alloc_ucontext;
 	ibdev->dealloc_ucontext = qib_dealloc_ucontext;
-	ibdev->alloc_pd = qib_alloc_pd;
-	ibdev->dealloc_pd = qib_dealloc_pd;
+	ibdev->alloc_pd = NULL;
+	ibdev->dealloc_pd = NULL;
 	ibdev->create_ah = qib_create_ah;
 	ibdev->destroy_ah = qib_destroy_ah;
 	ibdev->modify_ah = qib_modify_ah;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 8ac0724..f1ca5d1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -222,12 +222,6 @@ struct qib_mcast {
 	int n_attached;
 };
 
-/* Protection domain */
-struct qib_pd {
-	struct ib_pd ibpd;
-	int user;               /* non-zero if created from user space */
-};
-
 /* Address Handle */
 struct qib_ah {
 	struct ib_ah ibah;
@@ -819,11 +813,6 @@ static inline struct qib_mr *to_imr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct qib_mr, ibmr);
 }
 
-static inline struct qib_pd *to_ipd(struct ib_pd *ibpd)
-{
-	return container_of(ibpd, struct qib_pd, ibpd);
-}
-
 static inline struct qib_ah *to_iah(struct ib_ah *ibah)
 {
 	return container_of(ibah, struct qib_ah, ibah);
@@ -994,7 +983,7 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region);
 
 void qib_free_lkey(struct qib_mregion *mr);
 
-int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
+int qib_lkey_ok(struct qib_lkey_table *rkt, struct rvt_pd *pd,
 		struct qib_sge *isge, struct ib_sge *sge, int acc);
 
 int qib_rkey_ok(struct qib_qp *qp, struct qib_sge *sge,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
