From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] RDMA/ocrdma: Changed macros to inline funtions.
Date: Mon, 10 Jun 2013 10:12:41 +0530
Message-ID: <638cf842-13a8-4474-8140-60416d290cd3@CMEXHTCAS2.ad.emulex.com>
References: <1370839362-3871-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370839362-3871-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Changed macros to inline funtions.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 43 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 15 ----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 9d82d09..7aa7f0f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -290,10 +290,6 @@ struct ocrdma_qp {
 	u8 *ird_q_va;
 };
 
-#define OCRDMA_GET_NUM_POSTED_SHIFT_VAL(qp) \
-	(((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) && \
-		(qp->id < 64)) ? 24 : 16)
-
 struct ocrdma_hw_mr {
 	struct ocrdma_dev *dev;
 	u32 lkey;
@@ -384,4 +380,43 @@ static inline struct ocrdma_srq *get_ocrdma_srq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct ocrdma_srq, ibsrq);
 }
 
+
+static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp)
+{
+	return ((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY &&
+		 qp->id < 64) ? 24 : 16);
+}
+
+static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)
+{
+	int cqe_valid;
+	cqe_valid = le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_VALID;
+	return ((cqe_valid == cq->phase) ? 1 : 0);
+}
+
+static inline int is_cqe_for_sq(struct ocrdma_cqe *cqe)
+{
+	return (le32_to_cpu(cqe->flags_status_srcqpn) &
+		OCRDMA_CQE_QTYPE) ? 0 : 1;
+}
+
+static inline int is_cqe_invalidated(struct ocrdma_cqe *cqe)
+{
+	return (le32_to_cpu(cqe->flags_status_srcqpn) &
+		OCRDMA_CQE_INVALIDATE) ? 1 : 0;
+}
+
+static inline int is_cqe_imm(struct ocrdma_cqe *cqe)
+{
+	return (le32_to_cpu(cqe->flags_status_srcqpn) &
+		OCRDMA_CQE_IMM) ? 1 : 0;
+}
+
+static inline int is_cqe_wr_imm(struct ocrdma_cqe *cqe)
+{
+	return (le32_to_cpu(cqe->flags_status_srcqpn) &
+		OCRDMA_CQE_WRITE_IMM) ? 1 : 0;
+}
+
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index cd0512f..36b062d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1534,21 +1534,6 @@ struct ocrdma_cqe {
 	u32 flags_status_srcqpn;	/* w3 */
 } __packed;
 
-#define is_cqe_valid(cq, cqe) \
-	(((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_VALID)\
-	== cq->phase) ? 1 : 0)
-#define is_cqe_for_sq(cqe) \
-	((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_QTYPE) ? 0 : 1)
-#define is_cqe_for_rq(cqe) \
-	((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_QTYPE) ? 1 : 0)
-#define is_cqe_invalidated(cqe) \
-	((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_INVALIDATE) ? \
-	1 : 0)
-#define is_cqe_imm(cqe) \
-	((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_IMM) ? 1 : 0)
-#define is_cqe_wr_imm(cqe) \
-	((le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_WRITE_IMM) ? 1 : 0)
-
 struct ocrdma_sge {
 	u32 addr_hi;
 	u32 addr_lo;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 0621530..dcfbab1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1819,7 +1819,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)
 {
-	u32 val = qp->rq.dbid | (1 << OCRDMA_GET_NUM_POSTED_SHIFT_VAL(qp));
+	u32 val = qp->rq.dbid | (1 << ocrdma_get_num_posted_shift(qp));
 
 	iowrite32(val, qp->rq_db);
 }
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
