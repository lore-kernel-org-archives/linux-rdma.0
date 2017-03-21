From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/20] IB/rdmavt, IB/hfi1,
 IB/qib: Make wc opcode translation driver dependent
Date: Mon, 20 Mar 2017 17:25:04 -0700
Message-ID: <20170321002503.28538.44884.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The work to create a completion helper moved the translation of send
wqe operations to completion opcodes to rdmvat.

This precludes having driver dependent operations.  Make the translation
driver dependent by doing the translation in the driver prior to the
rvt_qp_swqe_complete() call using restored translation tables.

Fixes: Commit f2dc9cdce83c ("IB/rdmavt: Add a send completion helper")
Fixes: Commit 0771da5a6e9d ("IB/hfi1,IB/qib: Use new send completion helper")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c       |   10 ++++++++--
 drivers/infiniband/hw/hfi1/ruc.c      |    5 ++++-
 drivers/infiniband/hw/hfi1/verbs.c    |   16 ++++++++++++++++
 drivers/infiniband/hw/qib/qib_rc.c    |   10 ++++++++--
 drivers/infiniband/hw/qib/qib_ruc.c   |    5 ++++-
 drivers/infiniband/hw/qib/qib_verbs.c |   13 +++++++++++++
 drivers/infiniband/sw/rdmavt/qp.c     |   17 -----------------
 include/rdma/rdmavt_qp.h              |    3 ++-
 8 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 7382be1..4649530 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1034,7 +1034,10 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		/* see post_send() */
 		barrier();
 		rvt_put_swqe(wqe);
-		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
+		rvt_qp_swqe_complete(qp,
+				     wqe,
+				     ib_hfi1_wc_opcode[wqe->wr.opcode],
+				     IB_WC_SUCCESS);
 	}
 	/*
 	 * If we were waiting for sends to complete before re-sending,
@@ -1081,7 +1084,10 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
+		rvt_qp_swqe_complete(qp,
+				     wqe,
+				     ib_hfi1_wc_opcode[wqe->wr.opcode],
+				     IB_WC_SUCCESS);
 	} else {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index aa15bcb..d2eb793 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -920,7 +920,10 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	    qp->ibqp.qp_type == IB_QPT_GSI)
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
-	rvt_qp_swqe_complete(qp, wqe, status);
+	rvt_qp_swqe_complete(qp,
+			     wqe,
+			     ib_hfi1_wc_opcode[wqe->wr.opcode],
+			     status);
 
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 222315f..815cb44 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -297,6 +297,22 @@ static inline bool wss_exceeds_threshold(void)
 }
 
 /*
+ * Translate ib_wr_opcode into ib_wc_opcode.
+ */
+const enum ib_wc_opcode ib_hfi1_wc_opcode[] = {
+	[IB_WR_RDMA_WRITE] = IB_WC_RDMA_WRITE,
+	[IB_WR_RDMA_WRITE_WITH_IMM] = IB_WC_RDMA_WRITE,
+	[IB_WR_SEND] = IB_WC_SEND,
+	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
+	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
+	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
+	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD,
+	[IB_WR_SEND_WITH_INV] = IB_WC_SEND,
+	[IB_WR_LOCAL_INV] = IB_WC_LOCAL_INV,
+	[IB_WR_REG_MR] = IB_WC_REG_MR
+};
+
+/*
  * Length of header by opcode, 0 --> not supported
  */
 const u8 hdr_len_by_opcode[256] = {
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 12658e3..0234987 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -938,7 +938,10 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		/* see post_send() */
 		barrier();
 		rvt_put_swqe(wqe);
-		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
+		rvt_qp_swqe_complete(qp,
+				     wqe,
+				     ib_qib_wc_opcode[wqe->wr.opcode],
+				     IB_WC_SUCCESS);
 	}
 	/*
 	 * If we were waiting for sends to complete before resending,
@@ -983,7 +986,10 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 		qp->s_last = s_last;
 		/* see post_send() */
 		barrier();
-		rvt_qp_swqe_complete(qp, wqe, IB_WC_SUCCESS);
+		rvt_qp_swqe_complete(qp,
+				     wqe,
+				     ib_qib_wc_opcode[wqe->wr.opcode],
+				     IB_WC_SUCCESS);
 	} else
 		this_cpu_inc(*ibp->rvp.rc_delayed_comp);
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 17655cc..6e1adf7 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -769,7 +769,10 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	    qp->ibqp.qp_type == IB_QPT_GSI)
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
-	rvt_qp_swqe_complete(qp, wqe, status);
+	rvt_qp_swqe_complete(qp,
+			     wqe,
+			     ib_qib_wc_opcode[wqe->wr.opcode],
+			     status);
 
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 83f8b5f..e120efe 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -114,6 +114,19 @@
 MODULE_PARM_DESC(disable_sma, "Disable the SMA");
 
 /*
+ * Translate ib_wr_opcode into ib_wc_opcode.
+ */
+const enum ib_wc_opcode ib_qib_wc_opcode[] = {
+	[IB_WR_RDMA_WRITE] = IB_WC_RDMA_WRITE,
+	[IB_WR_RDMA_WRITE_WITH_IMM] = IB_WC_RDMA_WRITE,
+	[IB_WR_SEND] = IB_WC_SEND,
+	[IB_WR_SEND_WITH_IMM] = IB_WC_SEND,
+	[IB_WR_RDMA_READ] = IB_WC_RDMA_READ,
+	[IB_WR_ATOMIC_CMP_AND_SWP] = IB_WC_COMP_SWAP,
+	[IB_WR_ATOMIC_FETCH_AND_ADD] = IB_WC_FETCH_ADD
+};
+
+/*
  * System image GUID.
  */
 __be64 ib_qib_sys_image_guid;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index f5ad8d4..28fb724 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -117,23 +117,6 @@
 };
 EXPORT_SYMBOL(ib_rvt_state_ops);
 
-/*
- * Translate ib_wr_opcode into ib_wc_opcode.
- */
-const enum ib_wc_opcode ib_rvt_wc_opcode[] = {
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
-EXPORT_SYMBOL(ib_rvt_wc_opcode);
-
 static void get_map_page(struct rvt_qpn_table *qpt,
 			 struct rvt_qpn_map *map,
 			 gfp_t gfp)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f381639..3cdd9e2 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -574,6 +574,7 @@ static inline void rvt_qp_wqe_unreserve(
 static inline void rvt_qp_swqe_complete(
 	struct rvt_qp *qp,
 	struct rvt_swqe *wqe,
+	enum ib_wc_opcode opcode,
 	enum ib_wc_status status)
 {
 	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED))
@@ -586,7 +587,7 @@ static inline void rvt_qp_swqe_complete(
 		memset(&wc, 0, sizeof(wc));
 		wc.wr_id = wqe->wr.wr_id;
 		wc.status = status;
-		wc.opcode = ib_rvt_wc_opcode[wqe->wr.opcode];
+		wc.opcode = opcode;
 		wc.qp = &qp->ibqp;
 		wc.byte_len = wqe->length;
 		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
