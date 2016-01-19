From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/31] staging/rdma/hfi1: Remove srq from hfi1
Date: Tue, 19 Jan 2016 14:42:33 -0800
Message-ID: <20160119224233.32765.29008.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
index 5a68455..0f00365 100644
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
index 762fca9..3b2f032 100644
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
index 0782a85..97df555 100644
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
@@ -539,11 +531,6 @@ static inline struct hfi1_cq *to_icq(struct ib_cq *ibcq)
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
