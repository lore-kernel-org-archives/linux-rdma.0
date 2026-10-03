Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D8837C93F;
	Sat,  3 Oct 2026 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791009695; cv=none; b=oX7PrmrPMrUymOZqwGVTltbfDdSwE0dy1stDsfLvaYkRBDBvRUIEqa6tnQwH/ZuY54TslaqQh9q0gzzUAZnr+UJPBV+QuMcXL+ToZx4V/JtI5LcHNdtf1NXo/tPRd9nREsgeD+V3OFrCoOfKwOccXMRXJu0z+u2YD293NiMVstA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791009695; c=relaxed/simple;
	bh=iXve9TP7YasUhinOHakLqHvg+y4PUSjIavAPRTFToB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt10EzfiydAx6LROs1ManA+QFQriv1hAXRKWb8ZXhQ0s/iPuGp+Ojm6DtC30pDWsfErBWfm8XnuosAtg5HAO5lH5OML9VpXm70aL0s01+wPOHdRYJ6eygewZJ+s1QTDaVjb0G/3+y4JhUNftWG3Q58MhsPDi0vm5Sh+AwE2AEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LV9i48kD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LV9i48kD"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 4434E20B716E; Fri,  2 Oct 2026 23:40:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4434E20B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791009638;
	bh=Spdnu/BPd63EFtWRqW/nyx9NdfqyC2D+0APgk+MiVDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LV9i48kDPSSJsNQBM+0oPRO471BfRuKGsCvUrBpYtqGre4DHxxg+BveaD3M1WkMPQ
	 HauN1DGhsbWY8QfOv5HIO7P3fKUkhj3JJ+IpPvUTuZbznvbPZLTaT+IRl1j6L0LSn+
	 B/WnVBD5b3+wRqfPrxxGZLTIY/CEspfenCoRb/LU=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 07/10] RDMA/mana_ib: Poll RC completions using PSN and FSN progress
Date: Fri,  2 Oct 2026 23:40:34 -0700
Message-ID: <20261003064037.2092669-8-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Decode RC receive completions, armed-PSN notifications, and MMQ
completions. Retire requester and MMQ shadow entries using their
sequence numbers, honor cross-queue fence dependencies, and suppress
successful WCs for unsignaled work requests.

On an ARMED completion, rearm the next signal PSN to generate the next
send CQE.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c           | 149 ++++++++++++++++++++--
 drivers/infiniband/hw/mana/mana_ib.h      |  31 +++++
 drivers/infiniband/hw/mana/shadow_queue.h |  22 ++++
 3 files changed, 192 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 3b8044b7dc8f..29eb12c1848e 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -5,6 +5,12 @@
 
 #include "mana_ib.h"
 
+#define PSN_SIGN_BIT 0x800000
+#define PSN_GE(PSN1, PSN2) ((((PSN1) - (PSN2)) & PSN_SIGN_BIT) == 0)
+#define PSN_GT(PSN1, PSN2) PSN_GE(PSN1, (PSN2) + 1)
+#define PSN_LE(PSN1, PSN2) PSN_GE(PSN2, PSN1)
+#define PSN_LT(PSN1, PSN2) PSN_GT(PSN2, PSN1)
+
 static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
 {
 	switch (vendor_error) {
@@ -311,10 +317,10 @@ static struct ib_wc *mana_fill_wc(struct mana_ib_qp *qp,
 	return wc;
 }
 
-static void mana_complete_send(struct mana_ib_qp *qp,
+static void mana_complete_send(struct mana_ib_qp *qp, bool mmq,
 			       struct mana_cq_poll *poll, u32 vendor_error)
 {
-	struct shadow_queue *shadow = &qp->shadow_sq;
+	struct shadow_queue *shadow = mmq ? &qp->shadow_mmq : &qp->shadow_sq;
 	struct shadow_wqe_header *wqe = shadow_queue_get_next_to_consume(shadow);
 	struct gdma_queue *queue;
 
@@ -324,8 +330,19 @@ static void mana_complete_send(struct mana_ib_qp *qp,
 	if (vendor_error || !(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
 		mana_fill_wc(qp, poll, wqe, wqe->send_opcode, vendor_error);
 
-	queue = mana_qp_get_sq(qp)->kmem;
-	queue->tail += wqe->wqe_size_in_bu;
+	if (mmq) {
+		queue = qp->rc_qp.queues[MANA_RC_SEND_QUEUE_MMQ].kmem;
+		queue->tail += wqe->wqe_size_in_bu;
+	} else {
+		queue = mana_qp_get_sq(qp)->kmem;
+		if (wqe->send_opcode == IB_WC_RDMA_READ) {
+			qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem->tail +=
+				wqe->wqe_size_in_bu;
+			queue->tail += qp->rc_qp.wqe_size_in_bu;
+		} else {
+			queue->tail += wqe->wqe_size_in_bu;
+		}
+	}
 	shadow_queue_advance_consumer(shadow);
 }
 
@@ -354,7 +371,7 @@ static void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct mana_rdma_cqe *rdma_c
 		return;
 
 	for (; to_complete; to_complete--)
-		mana_complete_send(qp, poll, VENDOR_ERR_OK);
+		mana_complete_send(qp, false, poll, VENDOR_ERR_OK);
 }
 
 static void handle_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe,
@@ -382,6 +399,21 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe,
 		wc->src_qp = rdma_cqe->ud_recv.src_qpn;
 		wc->wc_flags |= IB_WC_GRH;
 		break;
+	case CQE_TYPE_RC_WRITE_IMM:
+		wc->opcode = IB_WC_RECV_RDMA_WITH_IMM;
+		fallthrough;
+	case CQE_TYPE_RC_SEND_IMM:
+		wc->wc_flags |= IB_WC_WITH_IMM;
+		wc->ex.imm_data = cpu_to_be32(rdma_cqe->rc_recv.imm_data);
+		fallthrough;
+	case CQE_TYPE_RC_SEND:
+		wc->byte_len = rdma_cqe->rc_recv.msg_len;
+		break;
+	case CQE_TYPE_RC_SEND_INV:
+		wc->wc_flags |= IB_WC_WITH_INVALIDATE;
+		wc->byte_len = rdma_cqe->rc_recv.msg_len;
+		wc->ex.invalidate_rkey = rdma_cqe->rc_recv.imm_data;
+		break;
 	default:
 		break;
 	}
@@ -390,17 +422,104 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe,
 	shadow_queue_advance_consumer(&qp->shadow_rq);
 }
 
+/*
+ * A fenced WQE can acknowledge the other send queue. Retire those dependencies
+ * first, without losing the fence when the caller's WC array fills up.
+ */
+static bool mana_advance_send(struct mana_ib_qp *qp, bool mmq, u32 seq,
+			      struct mana_cq_poll *poll)
+{
+	struct shadow_queue *shadow = mmq ? &qp->shadow_mmq : &qp->shadow_sq;
+	struct shadow_queue *other = mmq ? &qp->shadow_sq : &qp->shadow_mmq;
+	struct shadow_wqe_header *shadow_wqe;
+
+	while ((shadow_wqe = shadow_queue_get_next_to_consume(shadow))) {
+		if (PSN_LT(seq, mmq ? shadow_wqe->fsn : shadow_wqe->wqe_offset_or_psn))
+			break;
+		if (poll->produced == poll->budget)
+			return false;
+		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
+			u32 dependency = mmq ? shadow_wqe->wqe_offset_or_psn : shadow_wqe->fsn;
+			struct shadow_wqe_header *other_wqe;
+
+			while ((other_wqe = shadow_queue_get_next_to_consume(other))) {
+				if (PSN_LT(dependency, mmq ? other_wqe->wqe_offset_or_psn :
+							     other_wqe->fsn))
+					break;
+				mana_complete_send(qp, !mmq, poll, VENDOR_ERR_OK);
+				if (poll->produced == poll->budget)
+					return false;
+			}
+		}
+
+		mana_complete_send(qp, mmq, poll, VENDOR_ERR_OK);
+	}
+
+	return true;
+}
+
+static bool handle_mmq_cqe(struct mana_ib_qp *qp, u32 fsn,
+			   struct mana_cq_poll *poll)
+{
+	return mana_advance_send(qp, true, fsn, poll);
+}
+
+static bool handle_psn_cqe(struct mana_ib_qp *qp, u32 psn,
+			   struct mana_cq_poll *poll)
+{
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct shadow_wqe_header *shadow_wqe;
+	struct gdma_queue *recv_q;
+	bool consumed;
+	u32 arm_psn;
+
+	if (qp->ibqp.qp_type != IB_QPT_RC)
+		return true;
+
+	recv_q = qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
+
+	consumed = mana_advance_send(qp, false, psn, poll);
+	if (consumed) {
+		shadow_wqe = shadow_queue_get_next_to_signal(&qp->shadow_sq);
+		arm_psn = shadow_wqe ? shadow_wqe->wqe_offset_or_psn : psn + 1;
+		mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), recv_q, arm_psn,
+					     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
+	}
+
+	return consumed;
+}
+
+static bool next_shadow_wqe_is_sq(struct shadow_wqe_header *shadow_wqe_sq,
+				  struct shadow_wqe_header *shadow_wqe_mq)
+{
+	if (!shadow_wqe_mq)
+		return true;
+
+	if (!shadow_wqe_sq)
+		return false;
+
+	return (PSN_LE(shadow_wqe_sq->wqe_offset_or_psn, shadow_wqe_mq->wqe_offset_or_psn) &&
+		PSN_LE(shadow_wqe_sq->fsn, shadow_wqe_mq->fsn));
+}
+
 static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
 			    struct mana_cq_poll *poll)
 {
 	struct gdma_comp *cqe = &cq->pending_cqe;
 	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
 	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
+	bool consumed = true;
 
 	if (!qp)
 		return true;
 
 	switch (rdma_cqe->cqe_type) {
+	case CQE_TYPE_ARMED_CMPL:
+		consumed = handle_psn_cqe(qp, rdma_cqe->rc_armed_completion.psn, poll);
+		break;
+	case CQE_TYPE_LWR:
+		consumed = handle_mmq_cqe(qp, rdma_cqe->rc_mm.fsn, poll);
+		break;
 	case CQE_TYPE_UD_SEND:
 		if (cqe->is_sq) {
 			handle_ud_sq_cqe(qp, rdma_cqe, poll);
@@ -408,6 +527,10 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
 		}
 		fallthrough;
 	case CQE_TYPE_UD_SEND_IMM:
+	case CQE_TYPE_RC_SEND:
+	case CQE_TYPE_RC_SEND_IMM:
+	case CQE_TYPE_RC_SEND_INV:
+	case CQE_TYPE_RC_WRITE_IMM:
 		handle_rq_cqe(qp, cqe, poll);
 		break;
 	default:
@@ -416,21 +539,27 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
 		break;
 	}
 	mana_put_qp_ref(qp);
-	return true;
+	return consumed;
 }
 
 static void mana_flush_completions(struct mana_ib_cq *cq, struct mana_cq_poll *poll)
 {
-	struct shadow_wqe_header *wqe;
+	struct shadow_wqe_header *sq_wqe, *mmq_wqe, *wqe;
 	struct mana_ib_qp *qp;
+	bool next_is_sq;
 
 	if (poll->produced >= poll->budget)
 		return;
 
 	list_for_each_entry(qp, &cq->send_err_qp_list, send_err_node) {
-		while (poll->produced < poll->budget &&
-		       shadow_queue_get_next_to_consume(&qp->shadow_sq))
-			mana_complete_send(qp, poll, VENDOR_ERR_SW_FLUSHED);
+		while (poll->produced < poll->budget) {
+			sq_wqe = shadow_queue_get_next_to_consume(&qp->shadow_sq);
+			mmq_wqe = shadow_queue_get_next_to_consume(&qp->shadow_mmq);
+			if (!sq_wqe && !mmq_wqe)
+				break;
+			next_is_sq = next_shadow_wqe_is_sq(sq_wqe, mmq_wqe);
+			mana_complete_send(qp, !next_is_sq, poll, VENDOR_ERR_SW_FLUSHED);
+		}
 		if (poll->produced == poll->budget)
 			return;
 	}
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index c7968d3c7ecd..1fc816792fc6 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -687,6 +687,12 @@ enum mana_ib_error_code {
 enum mana_ib_cqe_type {
 	CQE_TYPE_UD_SEND = 1,
 	CQE_TYPE_UD_SEND_IMM = 2,
+	CQE_TYPE_RC_SEND = 3,
+	CQE_TYPE_RC_SEND_IMM = 4,
+	CQE_TYPE_RC_SEND_INV = 5,
+	CQE_TYPE_RC_WRITE_IMM = 6,
+	CQE_TYPE_ARMED_CMPL = 7,
+	CQE_TYPE_LWR = 8,
 }; /* HW DATA */
 
 struct mana_rdma_cqe {
@@ -710,6 +716,31 @@ struct mana_rdma_cqe {
 			u32 imm_data;
 			u32 rx_wqe_offset;
 		} ud_recv;
+		struct {
+			u32 cqe_type		: 8;
+			u32 reserved1		: 24;
+			u32 msg_len;
+			u32 psn			: 24;
+			u32 reserved2		: 8;
+			u32 imm_data;
+			u32 rx_wqe_offset;
+		} rc_recv;
+		struct {
+			u32 cqe_type		: 8;
+			u32 reserved1		: 24;
+			u32 msn			: 24;
+			u32 syndrome		: 8;
+			u32 psn			: 24;
+			u32 reserved2		: 8;
+		} rc_armed_completion;
+		struct {
+			u32 cqe_type		: 8;
+			u32 reserved1		: 24;
+			u32 psn			: 24;
+			u32 reserved2		: 8;
+			u32 fsn			: 24;
+			u32 reserved3		: 8;
+		} rc_mm;
 	};
 }; /* HW DATA */
 
diff --git a/drivers/infiniband/hw/mana/shadow_queue.h b/drivers/infiniband/hw/mana/shadow_queue.h
index b5d6bb28bd45..9abf390cf3a3 100644
--- a/drivers/infiniband/hw/mana/shadow_queue.h
+++ b/drivers/infiniband/hw/mana/shadow_queue.h
@@ -26,6 +26,8 @@ struct shadow_queue {
 	u64 prod_idx;
 	/* Unmasked consumer index, Incremented on cq polling */
 	u64 cons_idx;
+	/* Unmasked index of next-to-signal shadow WQE */
+	u64 next_to_signal_idx;
 	/* queue size in wqes */
 	u32 length;
 	/* distance between elements in bytes */
@@ -50,6 +52,7 @@ static inline void reset_shadow_queue(struct shadow_queue *queue)
 {
 	queue->prod_idx = 0;
 	queue->cons_idx = 0;
+	queue->next_to_signal_idx = 0;
 }
 
 static inline void destroy_shadow_queue(struct shadow_queue *queue)
@@ -105,4 +108,23 @@ static inline void shadow_queue_advance_consumer(struct shadow_queue *queue)
 	smp_store_release(&queue->cons_idx, queue->cons_idx + 1);
 }
 
+static inline struct shadow_wqe_header *
+shadow_queue_get_next_to_signal(struct shadow_queue *queue)
+{
+	struct shadow_wqe_header *wqe = NULL;
+	/* Inspect only entries that have been fully published by posting. */
+	u64 prod_idx = smp_load_acquire(&queue->prod_idx);
+
+	queue->next_to_signal_idx = max(queue->next_to_signal_idx,
+					queue->cons_idx);
+	while (queue->next_to_signal_idx < prod_idx) {
+		wqe = shadow_queue_get_element(queue, queue->next_to_signal_idx);
+		queue->next_to_signal_idx++;
+		if (!(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
+			return wqe;
+	}
+
+	return NULL;
+}
+
 #endif
-- 
2.43.0

