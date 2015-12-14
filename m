From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 12/15] IB/hfi1: Remove srq from hfi1
Date: Mon, 14 Dec 2015 12:29:17 -0500
Message-ID: <20151214172915.11576.19379.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SRQ data structure has been moved to rdmavt. Make use of it.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |    2 +-
 drivers/staging/rdma/hfi1/ruc.c   |    4 ++--
 drivers/staging/rdma/hfi1/srq.c   |   10 +++++-----
 drivers/staging/rdma/hfi1/verbs.h |   13 -------------
 4 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index b82855f..045ee74 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -1092,7 +1092,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 		sz = sizeof(*qp);
 		sg_list_sz = 0;
 		if (init_attr->srq) {
-			struct hfi1_srq *srq = to_isrq(init_attr->srq);
+			struct rvt_srq *srq = ibsrq_to_rvtsrq(init_attr->srq);
 
 			if (srq->rq.max_sge > 1)
 				sg_list_sz = sizeof(*qp->r_sg_list) *
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 558dadb..9841e89 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -159,14 +159,14 @@ int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	unsigned long flags;
 	struct rvt_rq *rq;
 	struct rvt_rwq *wq;
-	struct hfi1_srq *srq;
+	struct rvt_srq *srq;
 	struct rvt_rwqe *wqe;
 	void (*handler)(struct ib_event *, void *);
 	u32 tail;
 	int ret;
 
 	if (qp->ibqp.srq) {
-		srq = to_isrq(qp->ibqp.srq);
+		srq = ibsrq_to_rvtsrq(qp->ibqp.srq);
 		handler = srq->ibsrq.event_handler;
 		rq = &srq->rq;
 	} else {
diff --git a/drivers/staging/rdma/hfi1/srq.c b/drivers/staging/rdma/hfi1/srq.c
index 932bd96..78f190a 100644
--- a/drivers/staging/rdma/hfi1/srq.c
+++ b/drivers/staging/rdma/hfi1/srq.c
@@ -65,7 +65,7 @@
 int hfi1_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			  struct ib_recv_wr **bad_wr)
 {
-	struct hfi1_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_rwq *wq;
 	unsigned long flags;
 	int ret;
@@ -120,7 +120,7 @@ struct ib_srq *hfi1_create_srq(struct ib_pd *ibpd,
 			       struct ib_udata *udata)
 {
 	struct hfi1_ibdev *dev = to_idev(ibpd->device);
-	struct hfi1_srq *srq;
+	struct rvt_srq *srq;
 	u32 sz;
 	struct ib_srq *ret;
 
@@ -229,7 +229,7 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		    enum ib_srq_attr_mask attr_mask,
 		    struct ib_udata *udata)
 {
-	struct hfi1_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_rwq *wq;
 	int ret = 0;
 
@@ -367,7 +367,7 @@ bail:
 
 int hfi1_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 {
-	struct hfi1_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 
 	attr->max_wr = srq->rq.size - 1;
 	attr->max_sge = srq->rq.max_sge;
@@ -381,7 +381,7 @@ int hfi1_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
  */
 int hfi1_destroy_srq(struct ib_srq *ibsrq)
 {
-	struct hfi1_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct hfi1_ibdev *dev = to_idev(ibsrq->device);
 
 	spin_lock(&dev->n_srqs_lock);
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index fec5e7b..f4ec83c 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -263,14 +263,6 @@ struct hfi1_cq {
 	struct rvt_mmap_info *ip;
 };
 
-struct hfi1_srq {
-	struct ib_srq ibsrq;
-	struct rvt_rq rq;
-	struct rvt_mmap_info *ip;
-	/* send signal when number of RWQEs < limit */
-	u32 limit;
-};
-
 /*
  * hfi1 specific data structures that will be hidden from rvt after the queue
  * pair is made common
@@ -537,11 +529,6 @@ static inline struct hfi1_cq *to_icq(struct ib_cq *ibcq)
 	return container_of(ibcq, struct hfi1_cq, ibcq);
 }
 
-static inline struct hfi1_srq *to_isrq(struct ib_srq *ibsrq)
-{
-	return container_of(ibsrq, struct hfi1_srq, ibsrq);
-}
-
 static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct rvt_qp, ibqp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
