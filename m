From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 15/18] IB/rdmavt: Add data structures and routines
 for table driven post send
Date: Fri, 01 Jul 2016 16:02:07 -0700
Message-ID: <20160701230207.20160.44817.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add flexibility for driver dependent operations in post send
because different drivers will have differing post send
operation support.

This includes data structure definitions to support a table
driven scheme along with the necessary validation routine
using the new table.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   67 ++++++++++++++++++++++++++++++++++---
 include/rdma/rdma_vt.h            |    3 ++
 include/rdma/rdmavt_qp.h          |   28 +++++++++++++--
 3 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 41ba7e9..d2b5b54 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -613,6 +613,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	struct rvt_dev_info *rdi = ib_to_rvt(ibpd->device);
 	void *priv = NULL;
 	gfp_t gfp;
+	size_t sqsize;
 
 	if (!rdi)
 		return ERR_PTR(-EINVAL);
@@ -643,7 +644,8 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		    init_attr->cap.max_recv_wr == 0)
 			return ERR_PTR(-EINVAL);
 	}
-
+	sqsize =
+		init_attr->cap.max_send_wr + 1;
 	switch (init_attr->qp_type) {
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
@@ -658,11 +660,11 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			sizeof(struct rvt_swqe);
 		if (gfp == GFP_NOIO)
 			swq = __vmalloc(
-				(init_attr->cap.max_send_wr + 1) * sz,
+				sqsize * sz,
 				gfp | __GFP_ZERO, PAGE_KERNEL);
 		else
 			swq = vzalloc_node(
-				(init_attr->cap.max_send_wr + 1) * sz,
+				sqsize * sz,
 				rdi->dparms.node);
 		if (!swq)
 			return ERR_PTR(-ENOMEM);
@@ -747,7 +749,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		INIT_LIST_HEAD(&qp->rspwait);
 		qp->state = IB_QPS_RESET;
 		qp->s_wq = swq;
-		qp->s_size = init_attr->cap.max_send_wr + 1;
+		qp->s_size = sqsize;
 		qp->s_avail = init_attr->cap.max_send_wr;
 		qp->s_max_sge = init_attr->cap.max_send_sge;
 		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
@@ -1440,12 +1442,65 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 }
 
 /**
- * qp_get_savail - return number of avail send entries
+ * rvt_qp_valid_operation - validate post send wr request
+ * @qp - the qp
+ * @post-parms - the post send table for the driver
+ * @wr - the work request
  *
+ * The routine validates the operation based on the
+ * validation table an returns the length of the operation
+ * which can extend beyond the ib_send_bw.  Operation
+ * dependent flags key atomic operation validation.
+ *
+ * There is an exception for UD qps that validates the pd and
+ * overrides the length to include the additional UD specific
+ * length.
+ *
+ * Returns a negative error or the length of the work request
+ * for building the swqe.
+ */
+static inline int rvt_qp_valid_operation(
+	struct rvt_qp *qp,
+	const struct rvt_operation_params *post_parms,
+	struct ib_send_wr *wr)
+{
+	int len;
+
+	if (wr->opcode >= RVT_OPERATION_MAX || !post_parms[wr->opcode].length)
+		return -EINVAL;
+	if (!(post_parms[wr->opcode].qpt_support & BIT(qp->ibqp.qp_type)))
+		return -EINVAL;
+	if ((post_parms[wr->opcode].flags & RVT_OPERATION_PRIV) &&
+	    ibpd_to_rvtpd(qp->ibqp.pd)->user)
+		return -EINVAL;
+	if (post_parms[wr->opcode].flags & RVT_OPERATION_ATOMIC_SGE &&
+	    (wr->num_sge == 0 ||
+	     wr->sg_list[0].length < sizeof(u64) ||
+	     wr->sg_list[0].addr & (sizeof(u64) - 1)))
+		return -EINVAL;
+	if (post_parms[wr->opcode].flags & RVT_OPERATION_ATOMIC &&
+	    !qp->s_max_rd_atomic)
+		return -EINVAL;
+	len = post_parms[wr->opcode].length;
+	/* UD specific */
+	if (qp->ibqp.qp_type != IB_QPT_UC &&
+	    qp->ibqp.qp_type != IB_QPT_RC) {
+		if (qp->ibqp.pd != ud_wr(wr)->ah->pd)
+			return -EINVAL;
+		len = sizeof(struct ib_ud_wr);
+	}
+	return len;
+}
+
+/**
+ * qp_get_savail - return number of avail send entries
  * @qp - the qp
  *
  * This assumes the s_hlock is held but the s_last
  * qp variable is uncontrolled.
+ *
+ * The return is adjusted to not count device specific
+ * reserved operations.
  */
 static inline u32 qp_get_savail(struct rvt_qp *qp)
 {
@@ -1481,6 +1536,8 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	u8 log_pmtu;
 	int ret;
 
+	BUILD_BUG_ON(IB_QPT_MAX >= (sizeof(u32) * BITS_PER_BYTE));
+
 	/* IB spec says that num_sge == 0 is OK. */
 	if (unlikely(wr->num_sge > qp->s_max_sge))
 		return -EINVAL;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 9c9a27d..3a70dc0 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -351,6 +351,9 @@ struct rvt_dev_info {
 	/* Driver specific properties */
 	struct rvt_driver_params dparms;
 
+	/* post send table */
+	const struct rvt_operation_params *post_parms;
+
 	struct rvt_mregion __rcu *dma_mr;
 	struct rvt_lkey_table lkey_table;
 
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 6d23b87..a90d1e9 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -228,11 +228,31 @@ struct rvt_ack_entry {
 
 #define	RC_QP_SCALING_INTERVAL	5
 
-/*
- * Variables prefixed with s_ are for the requester (sender).
- * Variables prefixed with r_ are for the responder (receiver).
- * Variables prefixed with ack_ are for responder replies.
+#define RVT_OPERATION_PRIV        0x00000001
+#define RVT_OPERATION_ATOMIC      0x00000002
+#define RVT_OPERATION_ATOMIC_SGE  0x00000004
+
+#define RVT_OPERATION_MAX (IB_WR_RESERVED10 + 1)
+
+/**
+ * rvt_operation_params - op table entry
+ * @length - the length to copy into the swqe entry
+ * @qpt_support - a bit mask indicating QP type support
+ * @flags - RVT_OPERATION flags (see above)
+ *
+ * This supports table driven post send so that
+ * the driver can have differing an potentially
+ * different sets of operations.
  *
+ **/
+
+struct rvt_operation_params {
+	size_t length;
+	u32 qpt_support;
+	u32 flags;
+};
+
+/*
  * Common variables are protected by both r_rq.lock and s_lock in that order
  * which only happens in modify_qp() or changing the QP 'state'.
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
