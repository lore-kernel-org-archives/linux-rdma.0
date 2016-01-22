From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 10/10] IB/qib: Remove srq from qib
Date: Fri, 22 Jan 2016 12:46:17 -0800
Message-ID: <20160122204613.2022.92265.stgit@scvm10.sc.intel.com>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204145.2022.26449.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove srq from qib now that it has been moved into rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |    2 +-
 drivers/infiniband/hw/qib/qib_ruc.c   |    4 ++--
 drivers/infiniband/hw/qib/qib_srq.c   |   10 +++++-----
 drivers/infiniband/hw/qib/qib_verbs.h |   13 -------------
 4 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6c023f7..1f63835 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1046,7 +1046,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		sz = sizeof(*qp);
 		sg_list_sz = 0;
 		if (init_attr->srq) {
-			struct qib_srq *srq = to_isrq(init_attr->srq);
+			struct rvt_srq *srq = ibsrq_to_rvtsrq(init_attr->srq);
 
 			if (srq->rq.max_sge > 1)
 				sg_list_sz = sizeof(*qp->r_sg_list) *
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 3900459..682447e 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -141,14 +141,14 @@ int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	unsigned long flags;
 	struct rvt_rq *rq;
 	struct rvt_rwq *wq;
-	struct qib_srq *srq;
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
diff --git a/drivers/infiniband/hw/qib/qib_srq.c b/drivers/infiniband/hw/qib/qib_srq.c
index 8547263..e9dfa30 100644
--- a/drivers/infiniband/hw/qib/qib_srq.c
+++ b/drivers/infiniband/hw/qib/qib_srq.c
@@ -48,7 +48,7 @@
 int qib_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 			 struct ib_recv_wr **bad_wr)
 {
-	struct qib_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_rwq *wq;
 	unsigned long flags;
 	int ret;
@@ -103,7 +103,7 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
 			      struct ib_udata *udata)
 {
 	struct qib_ibdev *dev = to_idev(ibpd->device);
-	struct qib_srq *srq;
+	struct rvt_srq *srq;
 	u32 sz;
 	struct ib_srq *ret;
 
@@ -212,7 +212,7 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		   enum ib_srq_attr_mask attr_mask,
 		   struct ib_udata *udata)
 {
-	struct qib_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_rwq *wq;
 	int ret = 0;
 
@@ -350,7 +350,7 @@ bail:
 
 int qib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 {
-	struct qib_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 
 	attr->max_wr = srq->rq.size - 1;
 	attr->max_sge = srq->rq.max_sge;
@@ -364,7 +364,7 @@ int qib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
  */
 int qib_destroy_srq(struct ib_srq *ibsrq)
 {
-	struct qib_srq *srq = to_isrq(ibsrq);
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct qib_ibdev *dev = to_idev(ibsrq->device);
 
 	spin_lock(&dev->n_srqs_lock);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index a9d7f0a..00dd2ad 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -251,14 +251,6 @@ struct qib_cq {
 	struct rvt_mmap_info *ip;
 };
 
-struct qib_srq {
-	struct ib_srq ibsrq;
-	struct rvt_rq rq;
-	struct rvt_mmap_info *ip;
-	/* send signal when number of RWQEs < limit */
-	u32 limit;
-};
-
 /*
  * qib specific data structure that will be hidden from rvt after the queue pair
  * is made common.
@@ -539,11 +531,6 @@ static inline struct qib_cq *to_icq(struct ib_cq *ibcq)
 	return container_of(ibcq, struct qib_cq, ibcq);
 }
 
-static inline struct qib_srq *to_isrq(struct ib_srq *ibsrq)
-{
-	return container_of(ibsrq, struct qib_srq, ibsrq);
-}
-
 static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct rvt_qp, ibqp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
