From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] IB/rdamvt: Fix rdmavt s_ack_queue sizing
Date: Tue, 24 May 2016 12:50:40 -0700
Message-ID: <20160524195039.19706.66866.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rdmavt allows the driver to specify the size of the ack queue, but
only uses it for the modify QP limit testing for setting the atomic
limit value.

The driver dependent size is now used to size the s_ack_queue ring
dynamicially.

Since the driver knows its size, the driver will use its define
for any ring size dependent code.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   22 ++++++++++++++++++++--
 include/rdma/rdma_vt.h            |    9 +++++++++
 include/rdma/rdmavt_qp.h          |    5 +----
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index dd03b23..5fa4d4d 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -397,6 +397,7 @@ static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 static void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
+	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
 
 	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 		rvt_put_ss(&qp->s_rdma_read_sge);
@@ -431,7 +432,7 @@ static void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 	if (qp->ibqp.qp_type != IB_QPT_RC)
 		return;
 
-	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
+	for (n = 0; n < rvt_max_atomic(rdi); n++) {
 		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
 
 		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
@@ -569,7 +570,12 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	qp->s_ssn = 1;
 	qp->s_lsn = 0;
 	qp->s_mig_state = IB_MIG_MIGRATED;
-	memset(qp->s_ack_queue, 0, sizeof(qp->s_ack_queue));
+	if (qp->s_ack_queue)
+		memset(
+			qp->s_ack_queue,
+			0,
+			rvt_max_atomic(rdi) *
+				sizeof(*qp->s_ack_queue));
 	qp->r_head_ack_queue = 0;
 	qp->s_tail_ack_queue = 0;
 	qp->s_num_rd_atomic = 0;
@@ -677,6 +683,16 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			goto bail_swq;
 
 		RCU_INIT_POINTER(qp->next, NULL);
+		if (init_attr->qp_type == IB_QPT_RC) {
+			qp->s_ack_queue =
+				kzalloc_node(
+					sizeof(*qp->s_ack_queue) *
+					 rvt_max_atomic(rdi),
+					gfp,
+					rdi->dparms.node);
+			if (!qp->s_ack_queue)
+				goto bail_qp;
+		}
 
 		/*
 		 * Driver needs to set up it's private QP structure and do any
@@ -857,6 +873,7 @@ bail_driver_priv:
 	rdi->driver_f.qp_priv_free(rdi, qp);
 
 bail_qp:
+	kfree(qp->s_ack_queue);
 	kfree(qp);
 
 bail_swq:
@@ -1284,6 +1301,7 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 		vfree(qp->r_rq.wq);
 	vfree(qp->s_wq);
 	rdi->driver_f.qp_priv_free(rdi, qp);
+	kfree(qp->s_ack_queue);
 	kfree(qp);
 	return 0;
 }
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 3f12da9..16274e2 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -426,6 +426,15 @@ static inline unsigned rvt_get_npkeys(struct rvt_dev_info *rdi)
 }
 
 /*
+ * Return the max atomic suitable for determining
+ * the size of the ack ring buffer in a QP.
+ */
+static inline unsigned int rvt_max_atomic(struct rvt_dev_info *rdi)
+{
+	return rdi->dparms.max_rdma_atomic + 1;
+}
+
+/*
  * Return the indexed PKEY from the port PKEY table.
  */
 static inline u16 rvt_get_pkey(struct rvt_dev_info *rdi,
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 0e1ff2a..6d23b87 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -211,8 +211,6 @@ struct rvt_mmap_info {
 	unsigned size;
 };
 
-#define RVT_MAX_RDMA_ATOMIC	16
-
 /*
  * This structure holds the information that the send tasklet needs
  * to send a RDMA read response or atomic operation.
@@ -282,8 +280,7 @@ struct rvt_qp {
 	atomic_t refcount ____cacheline_aligned_in_smp;
 	wait_queue_head_t wait;
 
-	struct rvt_ack_entry s_ack_queue[RVT_MAX_RDMA_ATOMIC + 1]
-		____cacheline_aligned_in_smp;
+	struct rvt_ack_entry *s_ack_queue;
 	struct rvt_sge_state s_rdma_read_sge;
 
 	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
