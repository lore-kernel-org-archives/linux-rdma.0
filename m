From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/23] IB/hfi1,IB/qib: Use new send completion helper
Date: Wed, 07 Dec 2016 19:34:12 -0800
Message-ID: <20161208033411.21135.32850.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert cq completion returns in both rdmavt drivers
to use the new helper.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c       |   26 ++------------------------
 drivers/infiniband/hw/hfi1/ruc.c      |   17 +----------------
 drivers/infiniband/hw/hfi1/verbs.c    |   16 ----------------
 drivers/infiniband/hw/qib/qib_rc.c    |   26 ++------------------------
 drivers/infiniband/hw/qib/qib_ruc.c   |   17 +----------------
 drivers/infiniband/hw/qib/qib_verbs.c |   13 -------------
 6 files changed, 6 insertions(+), 109 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 3a31ed7..42dae2e 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1146,7 +1146,6 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
 	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	struct ib_wc wc;
 	unsigned i;
 	u32 opcode;
 	u32 psn;
@@ -1200,17 +1199,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 
 			rvt_put_mr(sge->mr);
 		}
-		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof(wc));
-			wc.wr_id = wqe->wr.wr_id;
-			wc.status = IB_WC_SUCCESS;
-			wc.opcode = ib_hfi1_wc_opcode[wqe->wr.opcode];
-			wc.byte_len = wqe->length;
-			wc.qp = &qp->ibqp;
-			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
-		}
+		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	}
 	/*
 	 * If we were waiting for sends to complete before re-sending,
@@ -1240,7 +1229,6 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 					 struct rvt_swqe *wqe,
 					 struct hfi1_ibport *ibp)
 {
-	struct ib_wc wc;
 	unsigned i;
 
 	lockdep_assert_held(&qp->s_lock);
@@ -1264,17 +1252,7 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof(wc));
-			wc.wr_id = wqe->wr.wr_id;
-			wc.status = IB_WC_SUCCESS;
-			wc.opcode = ib_hfi1_wc_opcode[wqe->wr.opcode];
-			wc.byte_len = wqe->length;
-			wc.qp = &qp->ibqp;
-			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
-		}
+		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	} else {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 2ec3e90..03c8931 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -964,22 +964,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	    qp->ibqp.qp_type == IB_QPT_GSI)
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
-	/* See ch. 11.2.4.1 and 10.7.3.1 */
-	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-	    status != IB_WC_SUCCESS) {
-		struct ib_wc wc;
-
-		memset(&wc, 0, sizeof(wc));
-		wc.wr_id = wqe->wr.wr_id;
-		wc.status = status;
-		wc.opcode = ib_hfi1_wc_opcode[wqe->wr.opcode];
-		wc.qp = &qp->ibqp;
-		if (status == IB_WC_SUCCESS)
-			wc.byte_len = wqe->length;
-		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
-			     status != IB_WC_SUCCESS);
-	}
+	rvt_qp_swqe_complete(qp, wqe, status);
 
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 3b7bfd8..95ed4d6 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -297,22 +297,6 @@ static inline int wss_exceeds_threshold(void)
 }
 
 /*
- * Translate ib_wr_opcode into ib_wc_opcode.
- */
-const enum ib_wc_opcode ib_hfi1_wc_opcode[] = {
-	[IB_WR_RDMA_WRITE] = IB_WC_RDMA_WRITE,
-	[IB_WR_RDMA_WRITE_WITH_IMM] = IB_WC_RDMA_WRITE,
-	[IB_WR_SEND] = IB_WC_SEND,
-	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
-	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
-	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
-	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD,
-	[IB_WR_SEND_WITH_INV] = IB_WC_SEND,
-	[IB_WR_LOCAL_INV] = IB_WC_LOCAL_INV,
-	[IB_WR_REG_MR] = IB_WC_REG_MR
-};
-
-/*
  * Length of header by opcode, 0 --> not supported
  */
 const u8 hdr_len_by_opcode[256] = {
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 2097512..d549905 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -941,7 +941,6 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 {
 	struct ib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	struct ib_wc wc;
 	unsigned i;
 	u32 opcode;
 	u32 psn;
@@ -993,17 +992,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 
 			rvt_put_mr(sge->mr);
 		}
-		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof(wc));
-			wc.wr_id = wqe->wr.wr_id;
-			wc.status = IB_WC_SUCCESS;
-			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
-			wc.byte_len = wqe->length;
-			wc.qp = &qp->ibqp;
-			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
-		}
+		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	}
 	/*
 	 * If we were waiting for sends to complete before resending,
@@ -1032,7 +1021,6 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 					 struct rvt_swqe *wqe,
 					 struct qib_ibport *ibp)
 {
-	struct ib_wc wc;
 	unsigned i;
 
 	/*
@@ -1055,17 +1043,7 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof(wc));
-			wc.wr_id = wqe->wr.wr_id;
-			wc.status = IB_WC_SUCCESS;
-			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
-			wc.byte_len = wqe->length;
-			wc.qp = &qp->ibqp;
-			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
-		}
+		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
 	} else
 		this_cpu_inc(*ibp->rvp.rc_delayed_comp);
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index de1bde5..87e3eb5 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -815,22 +815,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	    qp->ibqp.qp_type == IB_QPT_GSI)
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
-	/* See ch. 11.2.4.1 and 10.7.3.1 */
-	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
-	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-	    status != IB_WC_SUCCESS) {
-		struct ib_wc wc;
-
-		memset(&wc, 0, sizeof(wc));
-		wc.wr_id = wqe->wr.wr_id;
-		wc.status = status;
-		wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
-		wc.qp = &qp->ibqp;
-		if (status == IB_WC_SUCCESS)
-			wc.byte_len = wqe->length;
-		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
-			     status != IB_WC_SUCCESS);
-	}
+	rvt_qp_swqe_complete(qp, wqe, status);
 
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 2044824..4b54c0d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -114,19 +114,6 @@
 MODULE_PARM_DESC(disable_sma, "Disable the SMA");
 
 /*
- * Translate ib_wr_opcode into ib_wc_opcode.
- */
-const enum ib_wc_opcode ib_qib_wc_opcode[] = {
-	[IB_WR_RDMA_WRITE] = IB_WC_RDMA_WRITE,
-	[IB_WR_RDMA_WRITE_WITH_IMM] = IB_WC_RDMA_WRITE,
-	[IB_WR_SEND] = IB_WC_SEND,
-	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
-	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
-	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
-	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD
-};
-
-/*
  * System image GUID.
  */
 __be64 ib_qib_sys_image_guid;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
