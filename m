Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F7F52E07A;
	Wed, 23 Sep 2026 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169175; cv=none; b=DM39ufryVyUOmm3NhfvWGQhuTmzsRIsUVkiY1ovgsmQ2ip3igCJ7WVVCnunaPxwsSaNy0cOqsp2C3G73HcVVE12OAK0kHZSPkZYpQWSUQniKGF/ipFFA+SykNwWneDzWrf3W2X29bVd4Ki399yPc3RwkHM73pik6XeMdB03N+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169175; c=relaxed/simple;
	bh=QjLLxCbTQaEzUMO+DiVqQlpiDg9B1JiGcq/yxfRj+Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5rtdp5v5KfevyJZOuRFdRXbFUBOW29iJuOP8BYMr6zOP6cUnRL++j2Sv+OBmuUGAUvfwBb8naFrU48gacAz74BRyg8qDpkMQYXD1Zeh1uQm50fY7WdYcPCEXFgvg/cDi7EngSLIYAayJkgqYigCRH8fbuwR5xVf4TfKYvs8/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eAscuQgn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eAscuQgn"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 716B320B716D; Wed, 23 Sep 2026 06:11:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 716B320B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790169115;
	bh=3o8l1v9ofgeYT5h9KW64hK04kvp6TkOja80beweas3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAscuQgnim9k+4u151UrqsJnbQQAww0CTfz9WYOOdTXqx2ASI1Px1kT9kXYYAQjAY
	 x420EJajcziw2XOI8j+WCNWASJqpnC6EdV602xpY8ZTTl+vnJB+5XTKXhiGspvX3+c
	 emjhM0G2BXGoKi0BElYl6AVOvRoW3wKc48ljM39A=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 5/5] RDMA/mana_ib: Poll UD completions and flush software error QPs
Date: Wed, 23 Sep 2026 06:11:55 -0700
Message-ID: <20260923131155.4055875-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Build WCs directly from CQEs and their corresponding published shadow
entries. This avoids iterating over all QPs that share a CQ. Track only
QPs in the error state instead of every QP associated with the CQ.

Keep the explicit GSI send-drain path responsible for adding the QP to
the send error list and invoking its CQ handler. To invoke the handler
for WQEs posted after GSI draining, check the QP state after posting
WQEs. This is required because MANA hardware ignores doorbells for QPs
in the error state.

Introduce a WC-budgeted polling context that caches CQEs representing
multiple WCs.

Before consuming a shadow entry, match the CQE against the low 24 bits
of the posted WQE offset to filter out stale CQEs. Implement WR signaling
to skip WC generation for unsignaled WQEs.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
Changes in v3:
- Honor IB_SIGNAL_ALL_WR and set MANA_WQ_NO_SIGNAL_WC for unsignaled sends.
- Find the matching CQE target before retiring its unsignaled prefix and
  the target with a wrap-safe inclusive loop, preserving stale-CQE checks.
- Notify the send CQ after posting to an already-flushing QP, outside the
  CQ lock, so later sends are flushed without another hardware CQE.

Changes in v2:
- Serialize each shadow queue reset and error-list removal with CQ polling
  and software flushing by holding the corresponding CQ lock.
- Return the unmasked WQE start offset from GDMA posting to ignore CQEs
  with mismatched low 24-bit WQE offsets.

 drivers/infiniband/hw/mana/cq.c               | 298 ++++++++++++------
 drivers/infiniband/hw/mana/mana_ib.h          |  64 +++-
 drivers/infiniband/hw/mana/qp.c               |  80 +++--
 drivers/infiniband/hw/mana/shadow_queue.h     |  38 +--
 drivers/infiniband/hw/mana/wr.c               |  19 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |   6 +-
 include/net/mana/gdma.h                       |   2 +
 7 files changed, 359 insertions(+), 148 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 6764e2de0..3b8044b7d 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -5,6 +5,58 @@
 
 #include "mana_ib.h"
 
+static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
+{
+	switch (vendor_error) {
+	case VENDOR_ERR_OK:
+		return IB_WC_SUCCESS;
+	case VENDOR_ERR_RX_PKT_LEN:
+	case VENDOR_ERR_RX_MSG_LEN_OVFL:
+		return IB_WC_LOC_LEN_ERR;
+	case VENDOR_ERR_TX_GDMA_CORRUPTED_WQE:
+	case VENDOR_ERR_TX_PCIE_WQE:
+	case VENDOR_ERR_TX_PCIE_MSG:
+	case VENDOR_ERR_RX_MALFORMED_WQE:
+	case VENDOR_ERR_TX_GDMA_INVALID_STATE:
+	case VENDOR_ERR_TX_MISBEHAVING_CLIENT:
+	case VENDOR_ERR_TX_RDMA_MALFORMED_WQE_SIZE:
+	case VENDOR_ERR_TX_RDMA_MALFORMED_WQE_FIELD:
+	case VENDOR_ERR_TX_RDMA_WQE_UNSUPPORTED:
+	case VENDOR_ERR_TX_RDMA_WQE_LEN_ERR:
+	case VENDOR_ERR_TX_RDMA_MTU_ERR:
+		return IB_WC_LOC_QP_OP_ERR;
+	case VENDOR_ERR_TX_ATB_MSG_ACCESS_VIOLATION:
+	case VENDOR_ERR_TX_ATB_MSG_ADDR_RANGE:
+	case VENDOR_ERR_TX_ATB_MSG_CONFIG_ERR:
+	case VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION:
+	case VENDOR_ERR_TX_ATB_WQE_ADDR_RANGE:
+	case VENDOR_ERR_TX_ATB_WQE_CONFIG_ERR:
+	case VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE:
+	case VENDOR_ERR_RX_ATB_SGE_MISSCONFIG:
+		return IB_WC_LOC_PROT_ERR;
+	case VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT:
+	case VENDOR_ERR_RX_GFID:
+		return IB_WC_LOC_ACCESS_ERR;
+	case VENDOR_ERR_RX_MISBEHAVING_CLIENT:
+	case VENDOR_ERR_RX_CLIENT_ID:
+	case VENDOR_ERR_RX_PCIE:
+	case VENDOR_ERR_RX_NO_AVAIL_WQE:
+	case VENDOR_ERR_RX_ATB_WQE_MISCONFIG:
+	case VENDOR_ERR_RX_ATB_WQE_ADDR_RIGHT:
+	case VENDOR_ERR_RX_ATB_WQE_ADDR_RANGE:
+	case VENDOR_ERR_TX_RDMA_INVALID_STATE:
+	case VENDOR_ERR_TX_RDMA_INVALID_NPT:
+	case VENDOR_ERR_TX_RDMA_INVALID_SGID:
+	case VENDOR_ERR_TX_RDMA_VFID_MISMATCH:
+		return IB_WC_FATAL_ERR;
+	case VENDOR_ERR_RX_NOT_EMPTY_ON_DISABLE:
+	case VENDOR_ERR_SW_FLUSHED:
+		return IB_WC_WR_FLUSH_ERR;
+	default:
+		return IB_WC_GENERAL_ERR;
+	}
+}
+
 int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct uverbs_attr_bundle *attrs)
 {
@@ -89,8 +141,8 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 	spin_lock_init(&cq->cq_lock);
-	INIT_LIST_HEAD(&cq->list_send_qp);
-	INIT_LIST_HEAD(&cq->list_recv_qp);
+	INIT_LIST_HEAD(&cq->send_err_qp_list);
+	INIT_LIST_HEAD(&cq->recv_err_qp_list);
 
 	return 0;
 
@@ -236,126 +288,172 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	return 0;
 }
 
-static inline void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe)
-{
-	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
-	struct gdma_queue *wq = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].kmem;
-	struct shadow_wqe_header *shadow_wqe;
+struct mana_cq_poll {
+	struct ib_wc *wc;
+	int budget;
+	int produced;
+};
 
-	shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq);
-	if (!shadow_wqe)
-		return;
+static struct ib_wc *mana_fill_wc(struct mana_ib_qp *qp,
+				  struct mana_cq_poll *poll,
+				  const struct shadow_wqe_header *wqe,
+				  enum ib_wc_opcode opcode, u32 vendor_error)
+{
+	struct ib_wc *wc = &poll->wc[poll->produced++];
 
-	shadow_wqe->error_code = rdma_cqe->ud_send.vendor_error;
+	memset(wc, 0, sizeof(*wc));
+	wc->wr_id = wqe->wr_id;
+	wc->status = vendor_error_to_wc_error(vendor_error);
+	wc->opcode = opcode;
+	wc->vendor_err = vendor_error;
+	wc->qp = &qp->ibqp;
 
-	wq->tail += shadow_wqe->wqe_size_in_bu;
-	shadow_queue_advance_next_to_complete(&qp->shadow_sq);
+	return wc;
 }
 
-static inline void handle_ud_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe)
+static void mana_complete_send(struct mana_ib_qp *qp,
+			       struct mana_cq_poll *poll, u32 vendor_error)
 {
-	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
-	struct gdma_queue *wq = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].kmem;
-	struct shadow_wqe_header *shadow_wqe;
+	struct shadow_queue *shadow = &qp->shadow_sq;
+	struct shadow_wqe_header *wqe = shadow_queue_get_next_to_consume(shadow);
+	struct gdma_queue *queue;
 
-	shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_rq);
-	if (!shadow_wqe)
+	if (!wqe)
 		return;
 
-	shadow_wqe->byte_len = rdma_cqe->ud_recv.msg_len;
-	shadow_wqe->src_qpn = rdma_cqe->ud_recv.src_qpn;
-	shadow_wqe->error_code = IB_WC_SUCCESS;
+	if (vendor_error || !(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
+		mana_fill_wc(qp, poll, wqe, wqe->send_opcode, vendor_error);
 
-	wq->tail += shadow_wqe->wqe_size_in_bu;
-	shadow_queue_advance_next_to_complete(&qp->shadow_rq);
+	queue = mana_qp_get_sq(qp)->kmem;
+	queue->tail += wqe->wqe_size_in_bu;
+	shadow_queue_advance_consumer(shadow);
 }
 
-static void mana_handle_cqe(struct mana_ib_dev *mdev, struct gdma_comp *cqe)
+static void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct mana_rdma_cqe *rdma_cqe,
+			     struct mana_cq_poll *poll)
 {
-	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
+	u32 offset = rdma_cqe->ud_send.tx_wqe_offset & MANA_WQE_OFFSET_MASK;
+	struct shadow_queue *shadow = &qp->shadow_sq;
+	struct shadow_wqe_header *wqe;
+	u64 idx = shadow->cons_idx;
+	u32 to_complete = 0;
+	u64 prod_idx;
+
+	/* Pair with posting's release of the initialized shadow entries. */
+	prod_idx = smp_load_acquire(&shadow->prod_idx);
+	/* Find the target before retiring any entries: the CQE may be stale. */
+	for (; idx != prod_idx; idx++) {
+		wqe = shadow_queue_get_element(shadow, idx);
+		to_complete++;
+		if (wqe->wqe_offset_or_psn == offset)
+			break;
+		if (!(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
+			return;
+	}
+	if (idx == prod_idx)
+		return;
 
-	if (!qp)
+	for (; to_complete; to_complete--)
+		mana_complete_send(qp, poll, VENDOR_ERR_OK);
+}
+
+static void handle_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe,
+			  struct mana_cq_poll *poll)
+{
+	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
+	u32 offset = rdma_cqe->ud_recv.rx_wqe_offset / GDMA_WQE_BU_SIZE;
+	struct mana_ib_queue *rq = mana_qp_get_rq(qp);
+	struct gdma_queue *wq = rq->kmem;
+	struct shadow_wqe_header *wqe;
+	struct ib_wc *wc;
+
+	wqe = shadow_queue_get_next_to_consume(&qp->shadow_rq);
+	if (!wqe || wqe->wqe_offset_or_psn != (offset & MANA_WQE_OFFSET_MASK))
 		return;
 
-	if (qp->ibqp.qp_type == IB_QPT_GSI || qp->ibqp.qp_type == IB_QPT_UD) {
-		if (cqe->is_sq)
-			handle_ud_sq_cqe(qp, cqe);
-		else
-			handle_ud_rq_cqe(qp, cqe);
+	wc = mana_fill_wc(qp, poll, wqe, IB_WC_RECV, VENDOR_ERR_OK);
+	switch (rdma_cqe->cqe_type) {
+	case CQE_TYPE_UD_SEND_IMM:
+		wc->ex.imm_data = cpu_to_be32(rdma_cqe->ud_recv.imm_data);
+		wc->wc_flags |= IB_WC_WITH_IMM;
+		fallthrough;
+	case CQE_TYPE_UD_SEND:
+		wc->byte_len = rdma_cqe->ud_recv.msg_len;
+		wc->src_qp = rdma_cqe->ud_recv.src_qpn;
+		wc->wc_flags |= IB_WC_GRH;
+		break;
+	default:
+		break;
 	}
 
-	mana_put_qp_ref(qp);
+	wq->tail += wqe->wqe_size_in_bu;
+	shadow_queue_advance_consumer(&qp->shadow_rq);
 }
 
-static void fill_verbs_from_shadow_wqe(struct mana_ib_qp *qp, struct ib_wc *wc,
-				       const struct shadow_wqe_header *shadow_wqe,
-				       enum ib_wc_opcode opcode)
+static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
+			    struct mana_cq_poll *poll)
 {
-	wc->wr_id = shadow_wqe->wr_id;
-	wc->status = shadow_wqe->error_code;
-	wc->opcode = opcode;
-	wc->vendor_err = shadow_wqe->error_code;
-	wc->wc_flags = 0;
-	wc->qp = &qp->ibqp;
-	wc->pkey_index = 0;
+	struct gdma_comp *cqe = &cq->pending_cqe;
+	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
+	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
 
-	if (opcode == IB_WC_RECV) {
-		wc->byte_len = shadow_wqe->byte_len;
-		wc->src_qp = shadow_wqe->src_qpn;
-		wc->wc_flags |= IB_WC_GRH;
+	if (!qp)
+		return true;
+
+	switch (rdma_cqe->cqe_type) {
+	case CQE_TYPE_UD_SEND:
+		if (cqe->is_sq) {
+			handle_ud_sq_cqe(qp, rdma_cqe, poll);
+			break;
+		}
+		fallthrough;
+	case CQE_TYPE_UD_SEND_IMM:
+		handle_rq_cqe(qp, cqe, poll);
+		break;
+	default:
+		ibdev_warn_ratelimited(qp->ibqp.device, "Unexpected CQE type %u\n",
+				       rdma_cqe->cqe_type);
+		break;
 	}
+	mana_put_qp_ref(qp);
+	return true;
 }
 
-static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc *wc)
+static void mana_flush_completions(struct mana_ib_cq *cq, struct mana_cq_poll *poll)
 {
-	struct shadow_wqe_header *shadow_wqe;
+	struct shadow_wqe_header *wqe;
 	struct mana_ib_qp *qp;
-	int wc_index = 0;
 
-	/* process send shadow queue completions  */
-	list_for_each_entry(qp, &cq->list_send_qp, cq_send_list) {
-		while ((shadow_wqe = shadow_queue_get_next_to_consume(&qp->shadow_sq))
-				!= NULL) {
-			if (wc_index >= nwc)
-				goto out;
+	if (poll->produced >= poll->budget)
+		return;
 
-			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe,
-						   shadow_wqe->send_opcode);
-			shadow_queue_advance_consumer(&qp->shadow_sq);
-			wc_index++;
-		}
+	list_for_each_entry(qp, &cq->send_err_qp_list, send_err_node) {
+		while (poll->produced < poll->budget &&
+		       shadow_queue_get_next_to_consume(&qp->shadow_sq))
+			mana_complete_send(qp, poll, VENDOR_ERR_SW_FLUSHED);
+		if (poll->produced == poll->budget)
+			return;
 	}
 
-	/* process recv shadow queue completions */
-	list_for_each_entry(qp, &cq->list_recv_qp, cq_recv_list) {
-		while ((shadow_wqe = shadow_queue_get_next_to_consume(&qp->shadow_rq))
-				!= NULL) {
-			if (wc_index >= nwc)
-				goto out;
-
-			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe,
-						   IB_WC_RECV);
+	list_for_each_entry(qp, &cq->recv_err_qp_list, recv_err_node) {
+		while (poll->produced < poll->budget &&
+		       (wqe = shadow_queue_get_next_to_consume(&qp->shadow_rq))) {
+			mana_fill_wc(qp, poll, wqe, IB_WC_RECV, VENDOR_ERR_SW_FLUSHED);
 			shadow_queue_advance_consumer(&qp->shadow_rq);
-			wc_index++;
 		}
+		if (poll->produced == poll->budget)
+			return;
 	}
-
-out:
-	return wc_index;
 }
 
 static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
 {
 	struct mana_ib_cq *cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
-	struct shadow_wqe_header *shadow_wqe;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
-	while ((shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq))
-			!= NULL) {
-		shadow_wqe->error_code = IB_WC_GENERAL_ERR;
-		shadow_queue_advance_next_to_complete(&qp->shadow_sq);
-	}
+	if (list_empty(&qp->send_err_node))
+		list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
 	if (cq->ibcq.comp_handler)
@@ -382,25 +480,39 @@ int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 	struct mana_ib_dev *mdev = container_of(ibcq->device, struct mana_ib_dev, ib_dev);
+	struct mana_cq_poll poll = { .wc = wc, .budget = num_entries, .produced = 0 };
 	struct gdma_queue *queue = cq->queue.kmem;
-	struct gdma_comp gdma_cqe;
 	unsigned long flags;
-	int num_polled = 0;
-	int comp_read, i;
+	bool consumed;
+	int comp_read;
+
+	if (!queue)
+		return -EINVAL;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
-	for (i = 0; i < num_entries; i++) {
-		comp_read = mana_gd_poll_cq(queue, &gdma_cqe, 1);
-		if (comp_read < 1)
-			break;
-		cq->poll_credit--;
-		if (!cq->poll_credit)
-			mana_ib_cq_doorbell(cq, 0);
-		mana_handle_cqe(mdev, &gdma_cqe);
+	while (poll.produced < poll.budget) {
+		if (!cq->has_pending_cqe) {
+			comp_read = mana_gd_poll_cq(queue, &cq->pending_cqe, 1);
+			if (comp_read < 0) {
+				if (!poll.produced)
+					poll.produced = comp_read;
+				goto out;
+			}
+			if (!comp_read)
+				break;
+
+			cq->poll_credit--;
+			if (!cq->poll_credit)
+				mana_ib_cq_doorbell(cq, 0);
+		}
+
+		consumed = mana_handle_cqe(cq, mdev, &poll);
+		cq->has_pending_cqe = !consumed;
 	}
 
-	num_polled = mana_process_completions(cq, num_entries, wc);
+	mana_flush_completions(cq, &poll);
+out:
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
-	return num_polled;
+	return poll.produced;
 }
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 0ad757990..74edb6e70 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -166,8 +166,10 @@ struct mana_ib_cq {
 	struct mana_ib_queue queue;
 	/* protects CQ polling */
 	spinlock_t cq_lock;
-	struct list_head list_send_qp;
-	struct list_head list_recv_qp;
+	struct list_head send_err_qp_list;
+	struct list_head recv_err_qp_list;
+	struct gdma_comp pending_cqe;
+	bool has_pending_cqe;
 	int cqe;
 	u32 comp_vector;
 	u32 poll_credit;
@@ -223,9 +225,13 @@ struct mana_ib_qp {
 	/* The port on the IB device, starting with 1 */
 	u32 port;
 	u32 sq_psn;
+	bool sq_sig_all;
 
-	struct list_head cq_send_list;
-	struct list_head cq_recv_list;
+	/* Serializes QP modification and error-list transitions. */
+	struct mutex modify_lock;
+
+	struct list_head send_err_node;
+	struct list_head recv_err_node;
 	struct shadow_queue shadow_rq;
 	struct shadow_queue shadow_sq;
 
@@ -586,6 +592,53 @@ struct rdma_recv_oob {
 	u32 reserved2   : 8;
 }; /* HW DATA */
 
+enum mana_ib_error_code {
+	VENDOR_ERR_OK					= 0x0,
+	VENDOR_ERR_RX_PKT_LEN                           = 0x05,
+	VENDOR_ERR_RX_MSG_LEN_OVFL                      = 0x102,
+	VENDOR_ERR_RX_MISBEHAVING_CLIENT                = 0x108,
+	VENDOR_ERR_RX_MALFORMED_WQE                     = 0x109,
+	VENDOR_ERR_RX_CLIENT_ID                         = 0x10a,
+	VENDOR_ERR_RX_GFID                              = 0x10b,
+	VENDOR_ERR_RX_PCIE                              = 0x10c,
+	VENDOR_ERR_RX_NO_AVAIL_WQE                      = 0x111,
+	VENDOR_ERR_RX_ATB_SGE_MISSCONFIG                = 0x143,
+	VENDOR_ERR_RX_ATB_WQE_MISCONFIG                 = 0x145,
+	VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT                = 0x183,
+	VENDOR_ERR_RX_ATB_WQE_ADDR_RIGHT                = 0x185,
+	VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE                = 0x1c3,
+	VENDOR_ERR_RX_ATB_WQE_ADDR_RANGE                = 0x1c5,
+	VENDOR_ERR_RX_NOT_EMPTY_ON_DISABLE              = 0x1c7,
+	VENDOR_ERR_TX_GDMA_CORRUPTED_WQE                = 0x201,
+	VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION          = 0x202,
+	VENDOR_ERR_TX_ATB_WQE_ADDR_RANGE                = 0x203,
+	VENDOR_ERR_TX_ATB_WQE_CONFIG_ERR                = 0x204,
+	VENDOR_ERR_TX_PCIE_WQE                          = 0x205,
+	VENDOR_ERR_TX_ATB_MSG_ACCESS_VIOLATION          = 0x206,
+	VENDOR_ERR_TX_ATB_MSG_ADDR_RANGE                = 0x207,
+	VENDOR_ERR_TX_ATB_MSG_CONFIG_ERR                = 0x208,
+	VENDOR_ERR_TX_PCIE_MSG                          = 0x209,
+	VENDOR_ERR_TX_GDMA_INVALID_STATE                = 0x20a,
+	VENDOR_ERR_TX_MISBEHAVING_CLIENT                = 0x20b,
+	VENDOR_ERR_TX_RDMA_MALFORMED_WQE_SIZE           = 0x210,
+	VENDOR_ERR_TX_RDMA_MALFORMED_WQE_FIELD          = 0x211,
+	VENDOR_ERR_TX_RDMA_INVALID_STATE                = 0x212,
+	VENDOR_ERR_TX_RDMA_INVALID_NPT                  = 0x213,
+	VENDOR_ERR_TX_RDMA_INVALID_SGID                 = 0x214,
+	VENDOR_ERR_TX_RDMA_WQE_UNSUPPORTED              = 0x215,
+	VENDOR_ERR_TX_RDMA_WQE_LEN_ERR                  = 0x216,
+	VENDOR_ERR_TX_RDMA_MTU_ERR                      = 0x217,
+	VENDOR_ERR_TX_RDMA_VFID_MISMATCH                = 0x218,
+	VENDOR_ERR_HW_MAX                               = 0x3ff,
+	/* SW vendor errors */
+	VENDOR_ERR_SW_FLUSHED				= 0xfff,
+};
+
+enum mana_ib_cqe_type {
+	CQE_TYPE_UD_SEND = 1,
+	CQE_TYPE_UD_SEND_IMM = 2,
+}; /* HW DATA */
+
 struct mana_rdma_cqe {
 	union {
 		struct {
@@ -594,8 +647,7 @@ struct mana_rdma_cqe {
 		};
 		struct {
 			u32 cqe_type		: 8;
-			u32 vendor_error	: 9;
-			u32 reserved1		: 15;
+			u32 reserved1		: 24;
 			u32 sge_offset		: 5;
 			u32 tx_wqe_offset	: 27;
 		} ud_send;
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 79c9cc944..ae2ebbcc7 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -694,33 +694,23 @@ static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	return err;
 }
 
-static void mana_add_qp_to_cqs(struct mana_ib_qp *qp)
+static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
 {
 	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&send_cq->cq_lock, flags);
-	list_add_tail(&qp->cq_send_list, &send_cq->list_send_qp);
+	list_del_init(&qp->send_err_node);
+	/* Keep shadow reset serialized with hardware polling and SW flushing. */
+	if (reset)
+		reset_shadow_queue(&qp->shadow_sq);
 	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
 
 	spin_lock_irqsave(&recv_cq->cq_lock, flags);
-	list_add_tail(&qp->cq_recv_list, &recv_cq->list_recv_qp);
-	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
-}
-
-static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp)
-{
-	struct mana_ib_cq *send_cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
-	struct mana_ib_cq *recv_cq = container_of(qp->ibqp.recv_cq, struct mana_ib_cq, ibcq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&send_cq->cq_lock, flags);
-	list_del(&qp->cq_send_list);
-	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
-
-	spin_lock_irqsave(&recv_cq->cq_lock, flags);
-	list_del(&qp->cq_recv_list);
+	list_del_init(&qp->recv_err_node);
+	if (reset)
+		reset_shadow_queue(&qp->shadow_rq);
 	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
 }
 
@@ -776,8 +766,6 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	if (err)
 		goto destroy_qp;
 
-	mana_add_qp_to_cqs(qp);
-
 	return 0;
 
 destroy_qp:
@@ -794,6 +782,13 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		      struct ib_udata *udata)
 {
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+
+	qp->sq_sig_all = attr->sq_sig_type == IB_SIGNAL_ALL_WR;
+	mutex_init(&qp->modify_lock);
+	INIT_LIST_HEAD(&qp->send_err_node);
+	INIT_LIST_HEAD(&qp->recv_err_node);
+
 	switch (attr->qp_type) {
 	case IB_QPT_RAW_PACKET:
 		/* When rwq_ind_tbl is used, it's for creating WQs for RSS */
@@ -891,19 +886,56 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return 0;
 }
 
+static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+				    int attr_mask, struct ib_udata *udata)
+{
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+
+	if (udata)
+		return;
+
+	if (attr_mask & IB_QP_STATE) {
+		switch (attr->qp_state) {
+		case IB_QPS_RESET:
+			mana_remove_qp_from_cqs(qp, true);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (attr_mask & IB_QP_SQ_PSN)
+		qp->sq_psn = attr->sq_psn;
+}
+
 int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	int ret;
+
+	mutex_lock(&qp->modify_lock);
+
 	switch (ibqp->qp_type) {
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
-		return mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
+		ret = mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
+		if (ret)
+			goto out_unlock;
+		break;
 	default:
-		ibdev_dbg(ibqp->device, "Modify QP type %u not supported", ibqp->qp_type);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
 	}
+
+	mana_ib_modify_qp_state(ibqp, attr, attr_mask, udata);
+
+out_unlock:
+	mutex_unlock(&qp->modify_lock);
+
+	return ret;
 }
 
 static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
@@ -1040,8 +1072,8 @@ static int mana_ib_destroy_ud_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
 	if (err)
 		return err;
 
-	mana_remove_qp_from_cqs(qp);
 	mana_table_remove_qp(mdev, qp);
+	mana_remove_qp_from_cqs(qp, false);
 
 	destroy_shadow_queue(&qp->shadow_rq);
 	destroy_shadow_queue(&qp->shadow_sq);
diff --git a/drivers/infiniband/hw/mana/shadow_queue.h b/drivers/infiniband/hw/mana/shadow_queue.h
index a127edf7a..b5d6bb28b 100644
--- a/drivers/infiniband/hw/mana/shadow_queue.h
+++ b/drivers/infiniband/hw/mana/shadow_queue.h
@@ -6,13 +6,19 @@
 #ifndef _MANA_SHADOW_QUEUE_H_
 #define _MANA_SHADOW_QUEUE_H_
 
+#include <linux/build_bug.h>
+
+#define MANA_WQ_FENCE_WC		BIT(0)
+#define MANA_WQ_NO_SIGNAL_WC		BIT(1)
+#define MANA_WQE_OFFSET_MASK	GENMASK(23, 0)
+
 struct shadow_wqe_header {
 	u64 wr_id;
+	u64 wqe_offset_or_psn : 24;
 	u64 wqe_size_in_bu : 8;
+	u64 fsn : 24;
 	u64 send_opcode : 4;
-	u64 error_code : 16;
-	u32 byte_len;
-	u32 src_qpn;
+	u64 flags : 2;
 };
 
 struct shadow_queue {
@@ -20,8 +26,6 @@ struct shadow_queue {
 	u64 prod_idx;
 	/* Unmasked consumer index, Incremented on cq polling */
 	u64 cons_idx;
-	/* Unmasked index of next-to-complete (from HW) shadow WQE */
-	u64 next_to_complete_idx;
 	/* queue size in wqes */
 	u32 length;
 	/* distance between elements in bytes */
@@ -42,6 +46,12 @@ static inline int create_shadow_queue(struct shadow_queue *queue, uint32_t lengt
 	return 0;
 }
 
+static inline void reset_shadow_queue(struct shadow_queue *queue)
+{
+	queue->prod_idx = 0;
+	queue->cons_idx = 0;
+}
+
 static inline void destroy_shadow_queue(struct shadow_queue *queue)
 {
 	kvfree(queue->buffer);
@@ -76,22 +86,13 @@ shadow_queue_producer_entry(struct shadow_queue *queue)
 static inline void *
 shadow_queue_get_next_to_consume(const struct shadow_queue *queue)
 {
-	if (queue->cons_idx == queue->next_to_complete_idx)
+	/* The producer publishes the WQE before advancing prod_idx. */
+	if (queue->cons_idx == smp_load_acquire(&queue->prod_idx))
 		return NULL;
 
 	return shadow_queue_get_element(queue, queue->cons_idx);
 }
 
-static inline void *
-shadow_queue_get_next_to_complete(struct shadow_queue *queue)
-{
-	/* Observe initialized WQE fields published by the posting CPU. */
-	if (queue->next_to_complete_idx == smp_load_acquire(&queue->prod_idx))
-		return NULL;
-
-	return shadow_queue_get_element(queue, queue->next_to_complete_idx);
-}
-
 static inline void shadow_queue_advance_producer(struct shadow_queue *queue)
 {
 	/* Publish all WQE fields to CQ polling on another CPU. */
@@ -104,9 +105,4 @@ static inline void shadow_queue_advance_consumer(struct shadow_queue *queue)
 	smp_store_release(&queue->cons_idx, queue->cons_idx + 1);
 }
 
-static inline void shadow_queue_advance_next_to_complete(struct shadow_queue *queue)
-{
-	queue->next_to_complete_idx++;
-}
-
 #endif
diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index eb671b45b..250d673f5 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -40,6 +40,7 @@ static int mana_ib_post_rq(struct mana_ib_qp *qp, const struct ib_recv_wr *wr)
 	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
 	shadow_wqe->wr_id = wr->wr_id;
 	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
+	shadow_wqe->wqe_offset_or_psn = wqe_info.wqe_offset;
 	shadow_queue_advance_producer(&qp->shadow_rq);
 
 	return 0;
@@ -96,6 +97,7 @@ static int mana_ib_post_send_ud_one(struct mana_ib_qp *qp, const struct ib_ud_wr
 	struct gdma_wqe_request wqe_req = {0};
 	struct rdma_send_oob send_oob = {0};
 	struct shadow_wqe_header *shadow_wqe;
+	bool signaled = qp->sq_sig_all || (wr->wr.send_flags & IB_SEND_SIGNALED);
 	int err, i;
 
 	if (!ndev)
@@ -128,7 +130,7 @@ static int mana_ib_post_send_ud_one(struct mana_ib_qp *qp, const struct ib_ud_wr
 
 	send_oob.wqe_type = WQE_TYPE_UD_SEND;
 	send_oob.fence = !!(wr->wr.send_flags & IB_SEND_FENCE);
-	send_oob.signaled = !!(wr->wr.send_flags & IB_SEND_SIGNALED);
+	send_oob.signaled = signaled;
 	send_oob.solicited = !!(wr->wr.send_flags & IB_SEND_SOLICITED);
 	send_oob.psn = qp->sq_psn;
 	send_oob.ssn_or_rqpn = wr->remote_qpn;
@@ -143,7 +145,9 @@ static int mana_ib_post_send_ud_one(struct mana_ib_qp *qp, const struct ib_ud_wr
 	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_sq);
 	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
 	shadow_wqe->wr_id = wr->wr.wr_id;
+	shadow_wqe->flags = signaled ? 0 : MANA_WQ_NO_SIGNAL_WC;
 	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
+	shadow_wqe->wqe_offset_or_psn = wqe_info.wqe_offset;
 	shadow_queue_advance_producer(&qp->shadow_sq);
 
 	return 0;
@@ -153,8 +157,11 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *
 				const struct ib_send_wr **bad_wr)
 {
 	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_cq *cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
 	struct gdma_queue *queue = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].kmem;
+	unsigned long flags;
 	bool ring_sq = false;
+	bool flush_send;
 	int err = 0;
 
 	for (; wr; wr = wr->next) {
@@ -166,9 +173,17 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_send_wr *
 		ring_sq = true;
 	}
 
-	if (ring_sq)
+	if (ring_sq) {
 		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
 
+		spin_lock_irqsave(&cq->cq_lock, flags);
+		flush_send = !list_empty(&qp->send_err_node);
+		spin_unlock_irqrestore(&cq->cq_lock, flags);
+
+		if (flush_send && cq->ibcq.comp_handler)
+			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+	}
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index cb51fcf57..05ba70554 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1807,10 +1807,12 @@ int mana_gd_post_work_request(struct gdma_queue *wq,
 	if (wq->monitor_avl_buf && wqe_size > mana_gd_wq_avail_space(wq))
 		return -ENOSPC;
 
-	if (wqe_info)
+	head = wq->head;
+	if (wqe_info) {
 		wqe_info->wqe_size_in_bu = wqe_size / GDMA_WQE_BU_SIZE;
+		wqe_info->wqe_offset = head;
+	}
 
-	head = wq->head;
 	wqe_offset = (head * GDMA_WQE_BU_SIZE) & (wq->queue_size - 1);
 	wqe_ptr = mana_gd_get_wqe_ptr(wq, head);
 	oob_len = mana_gd_write_client_oob(wqe_req, wq->type, client_oob_size,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 02632acd7..2a28fcaa6 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -630,6 +630,8 @@ struct gdma_eqe {
 
 struct gdma_posted_wqe_info {
 	u32 wqe_size_in_bu;
+	/* Unmasked WQE start offset in GDMA basic units. */
+	u32 wqe_offset;
 };
 
 /* GDMA_GENERATE_TEST_EQE */
-- 
2.43.0
