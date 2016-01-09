From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 04/27] IB/hfi1: Use rdmavt protection domain
Date: Sat, 09 Jan 2016 07:17:00 -0800
Message-ID: <20160109151659.30800.68545.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove protection domain from hfi1 and use rdmavt's version.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/keys.c  |    4 +-
 drivers/staging/rdma/hfi1/mr.c    |    2 +
 drivers/staging/rdma/hfi1/ruc.c   |    4 +-
 drivers/staging/rdma/hfi1/verbs.c |   67 +++----------------------------------
 drivers/staging/rdma/hfi1/verbs.h |   15 +-------
 5 files changed, 12 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/keys.c b/drivers/staging/rdma/hfi1/keys.c
index cb4e608..57a266f 100644
--- a/drivers/staging/rdma/hfi1/keys.c
+++ b/drivers/staging/rdma/hfi1/keys.c
@@ -176,7 +176,7 @@ out:
  * Check the IB SGE for validity and initialize our internal version
  * of it.
  */
-int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct hfi1_pd *pd,
+int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct rvt_pd *pd,
 		 struct hfi1_sge *isge, struct ib_sge *sge, int acc)
 {
 	struct hfi1_mregion *mr;
@@ -285,7 +285,7 @@ int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,
 	 */
 	rcu_read_lock();
 	if (rkey == 0) {
-		struct hfi1_pd *pd = to_ipd(qp->ibqp.pd);
+		struct rvt_pd *pd = ibpd_to_rvtpd(qp->ibqp.pd);
 		struct hfi1_ibdev *dev = to_idev(pd->ibpd.device);
 
 		if (pd->user)
diff --git a/drivers/staging/rdma/hfi1/mr.c b/drivers/staging/rdma/hfi1/mr.c
index a3f8b88..3f1ef58 100644
--- a/drivers/staging/rdma/hfi1/mr.c
+++ b/drivers/staging/rdma/hfi1/mr.c
@@ -116,7 +116,7 @@ struct ib_mr *hfi1_get_dma_mr(struct ib_pd *pd, int acc)
 	struct ib_mr *ret;
 	int rval;
 
-	if (to_ipd(pd)->user) {
+	if (ibpd_to_rvtpd(pd)->user) {
 		ret = ERR_PTR(-EPERM);
 		goto bail;
 	}
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 49bc9fd..58af852 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -102,11 +102,11 @@ static int init_sge(struct hfi1_qp *qp, struct hfi1_rwqe *wqe)
 	int i, j, ret;
 	struct ib_wc wc;
 	struct hfi1_lkey_table *rkt;
-	struct hfi1_pd *pd;
+	struct rvt_pd *pd;
 	struct hfi1_sge_state *ss;
 
 	rkt = &to_idev(qp->ibqp.device)->lk_table;
-	pd = to_ipd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
+	pd = ibpd_to_rvtpd(qp->ibqp.srq ? qp->ibqp.srq->pd : qp->ibqp.pd);
 	ss = &qp->r_sge;
 	ss->sg_list = qp->r_sg_list;
 	qp->r_len = 0;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 08ce9d3..058f245 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -366,7 +366,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 	int j;
 	int acc;
 	struct hfi1_lkey_table *rkt;
-	struct hfi1_pd *pd;
+	struct rvt_pd *pd;
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_pportdata *ppd;
 	struct hfi1_ibport *ibp;
@@ -411,7 +411,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 		return -ENOMEM;
 
 	rkt = &to_idev(qp->ibqp.device)->lk_table;
-	pd = to_ipd(qp->ibqp.pd);
+	pd = ibpd_to_rvtpd(qp->ibqp.pd);
 	wqe = get_swqe_ptr(qp, qp->s_head);
 
 
@@ -1405,7 +1405,7 @@ static int query_device(struct ib_device *ibdev,
 	props->max_mr = dev->lk_table.max;
 	props->max_fmr = dev->lk_table.max;
 	props->max_map_per_fmr = 32767;
-	props->max_pd = hfi1_max_pds;
+	props->max_pd = dev->rdi.dparms.props.max_pd;
 	props->max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
 	props->max_qp_init_rd_atom = 255;
 	/* props->max_res_rd_atom */
@@ -1603,61 +1603,6 @@ static int query_gid(struct ib_device *ibdev, u8 port,
 	return ret;
 }
 
-static struct ib_pd *alloc_pd(struct ib_device *ibdev,
-			      struct ib_ucontext *context,
-			      struct ib_udata *udata)
-{
-	struct hfi1_ibdev *dev = to_idev(ibdev);
-	struct hfi1_pd *pd;
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
-	if (dev->n_pds_allocated == hfi1_max_pds) {
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
-static int dealloc_pd(struct ib_pd *ibpd)
-{
-	struct hfi1_pd *pd = to_ipd(ibpd);
-	struct hfi1_ibdev *dev = to_idev(ibpd->device);
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
 /*
  * convert ah port,sl to sc
  */
@@ -1931,7 +1876,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 		init_ibport(ppd + i);
 
 	/* Only need to initialize non-zero fields. */
-	spin_lock_init(&dev->n_pds_lock);
+
 	spin_lock_init(&dev->n_ahs_lock);
 	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
@@ -2040,8 +1985,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->query_gid = query_gid;
 	ibdev->alloc_ucontext = alloc_ucontext;
 	ibdev->dealloc_ucontext = dealloc_ucontext;
-	ibdev->alloc_pd = alloc_pd;
-	ibdev->dealloc_pd = dealloc_pd;
+	ibdev->alloc_pd = NULL;
+	ibdev->dealloc_pd = NULL;
 	ibdev->create_ah = create_ah;
 	ibdev->destroy_ah = destroy_ah;
 	ibdev->modify_ah = modify_ah;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index ecc8dde..083f1a8 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -234,12 +234,6 @@ struct hfi1_mcast {
 	int n_attached;
 };
 
-/* Protection domain */
-struct hfi1_pd {
-	struct ib_pd ibpd;
-	int user;               /* non-zero if created from user space */
-};
-
 /* Address Handle */
 struct hfi1_ah {
 	struct ib_ah ibah;
@@ -762,8 +756,6 @@ struct hfi1_ibdev {
 	u64 n_kmem_wait;
 	u64 n_send_schedule;
 
-	u32 n_pds_allocated;    /* number of PDs allocated for device */
-	spinlock_t n_pds_lock;
 	u32 n_ahs_allocated;    /* number of AHs allocated for device */
 	spinlock_t n_ahs_lock;
 	u32 n_cqs_allocated;    /* number of CQs allocated for device */
@@ -803,11 +795,6 @@ static inline struct hfi1_mr *to_imr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct hfi1_mr, ibmr);
 }
 
-static inline struct hfi1_pd *to_ipd(struct ib_pd *ibpd)
-{
-	return container_of(ibpd, struct hfi1_pd, ibpd);
-}
-
 static inline struct hfi1_ah *to_iah(struct ib_ah *ibah)
 {
 	return container_of(ibah, struct hfi1_ah, ibah);
@@ -971,7 +958,7 @@ int hfi1_alloc_lkey(struct hfi1_mregion *mr, int dma_region);
 
 void hfi1_free_lkey(struct hfi1_mregion *mr);
 
-int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct hfi1_pd *pd,
+int hfi1_lkey_ok(struct hfi1_lkey_table *rkt, struct rvt_pd *pd,
 		 struct hfi1_sge *isge, struct ib_sge *sge, int acc);
 
 int hfi1_rkey_ok(struct hfi1_qp *qp, struct hfi1_sge *sge,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
