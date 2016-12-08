From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 22/23] IB/hfi1,IB/qib: use rvt swqe mr deref helper
Date: Wed, 07 Dec 2016 19:34:31 -0800
Message-ID: <20161208033430.21135.32339.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert to use new swqe put routine.

Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c     |   15 ++-------------
 drivers/infiniband/hw/hfi1/ruc.c    |    7 +------
 drivers/infiniband/hw/qib/qib_rc.c  |   15 ++-------------
 drivers/infiniband/hw/qib/qib_ruc.c |    7 +------
 4 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 42dae2e..a297f79 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1146,7 +1146,6 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
 	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	unsigned i;
 	u32 opcode;
 	u32 psn;
 
@@ -1194,11 +1193,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct rvt_sge *sge = &wqe->sg_list[i];
-
-			rvt_put_mr(sge->mr);
-		}
+		rvt_put_swqe(wqe);
 		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	}
 	/*
@@ -1229,8 +1224,6 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 					 struct rvt_swqe *wqe,
 					 struct hfi1_ibport *ibp)
 {
-	unsigned i;
-
 	lockdep_assert_held(&qp->s_lock);
 	/*
 	 * Don't decrement refcount and don't generate a
@@ -1241,11 +1234,7 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		u32 s_last;
 
-		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct rvt_sge *sge = &wqe->sg_list[i];
-
-			rvt_put_mr(sge->mr);
-		}
+		rvt_put_swqe(wqe);
 		s_last = qp->s_last;
 		if (++s_last >= qp->s_size)
 			s_last = 0;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 03c8931..717ed4b 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -942,7 +942,6 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status)
 {
 	u32 old_last, last;
-	unsigned i;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
@@ -954,11 +953,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	qp->s_last = last;
 	/* See post_send() */
 	barrier();
-	for (i = 0; i < wqe->wr.num_sge; i++) {
-		struct rvt_sge *sge = &wqe->sg_list[i];
-
-		rvt_put_mr(sge->mr);
-	}
+	rvt_put_swqe(wqe);
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index d549905..e23ee6c 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -941,7 +941,6 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
 	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	unsigned i;
 	u32 opcode;
 	u32 psn;
 
@@ -987,11 +986,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct rvt_sge *sge = &wqe->sg_list[i];
-
-			rvt_put_mr(sge->mr);
-		}
+		rvt_put_swqe(wqe);
 		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	}
 	/*
@@ -1021,8 +1016,6 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 					 struct rvt_swqe *wqe,
 					 struct qib_ibport *ibp)
 {
-	unsigned i;
-
 	/*
 	 * Don't decrement refcount and don't generate a
 	 * completion if the SWQE is being resent until the send
@@ -1032,11 +1025,7 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		u32 s_last;
 
-		for (i = 0; i < wqe->wr.num_sge; i++) {
-			struct rvt_sge *sge = &wqe->sg_list[i];
-
-			rvt_put_mr(sge->mr);
-		}
+		rvt_put_swqe(wqe);
 		s_last = qp->s_last;
 		if (++s_last >= qp->s_size)
 			s_last = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 87e3eb5..e54a2fe 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -793,7 +793,6 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status)
 {
 	u32 old_last, last;
-	unsigned i;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
@@ -805,11 +804,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	qp->s_last = last;
 	/* See post_send() */
 	barrier();
-	for (i = 0; i < wqe->wr.num_sge; i++) {
-		struct rvt_sge *sge = &wqe->sg_list[i];
-
-		rvt_put_mr(sge->mr);
-	}
+	rvt_put_swqe(wqe);
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
