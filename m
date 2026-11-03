Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704665;
	b=A5bafyKBrjsPHwaPzyMid6kD2S0E7MB+JohbINeIjM/6OxwIXGMI6VEAYPCbFBds7t43
	 U6qFYGo8+fI4B2dwHpJBFaqyVxQWkP4UKkDsvFOVMIztYhDiwikvbRBcFjq/yMZPLNpUy
	 G1x4H546+mWwG2T2VIFfZL/kjCcAp20WqxA5zNlzZ7zXsG2pGEaDHG6Vi9rkwvJkctYf/
	 fe8xMJJI9LyWcx32AoKNQuurMSjcl5Ld/JZJEACZ3e9wT7TmIvlPvkaVR/KCwt7wo4BlF
	 hANpO92nzeQ9RMlGh5Fze/NfD+yJNpmsqtdFrvLe3FmT3MZZEuX5+1bHK8sn0399kww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704665;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z3fL+XTUf4ywTVBcl8rBfJOczYxRHRzQoBXK7GW57pI=;
	b=xX9cdEiDMby0MEAHU82N9aFPjCUwnkYXtd+HgomxiGUS5raub8u0aFYb4ENP/66Qyh7E
	 SATgghQDPND5DF4EIHdF8Zw9Z0sG8LTLf4il0sUSLMIbqv6rMSW+e4TTMf6s+V2vxebzZ
	 palXeh+ELQB42zZKn7dRlcMbDj53PeHz+5/MJSVBl1+o7Lxwf/uvc0HlFXAukJGjVGT8w
	 F6BLrktP/LaQdDyFUg6lHzdoCadZi8XERpK5o5Yd7yJ2B5hrC6yYBbx5F+qqcR5qBZsrj
	 9Xcx6ntOpfayX5yLEY39M9u9OrYwD2SVRaEZ/by0xN6pY/0x9MZEoqYoI2kCa2pSjlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=idRbFBlF;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4212606D82A;
	Tue,  3 Nov 2026 11:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F4212606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=idRbFBlF
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id B3A1720B716F; Tue,  3 Nov 2026 03:17:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3A1720B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793704649;
	bh=Z3fL+XTUf4ywTVBcl8rBfJOczYxRHRzQoBXK7GW57pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idRbFBlFDkz8N0FMYqgGpIK94LOF7kkNg1/gXJQf4HDqLY2RdqSqjMpctmMY3O57m
	 qRUJde+bXya4A1chm4Sy34sKO81M/cR4w1zZq4RwuMASpJl8SDlGhowXhiqpN6hbd8
	 PqCnIa3f4T3vdDfj0URrUiPCDrPfyHO8gwsTFgxg=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v8 9/9] RDMA/mana_ib: Handle error CQEs for kernel QPs
Date: Tue,  3 Nov 2026 03:17:29 -0800
Message-ID: <20261103111729.729886-10-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
References: <20261103111729.729886-1-kotaranov@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Decode hardware error CQEs and process them on the corresponding work
queue. Complete the failing shadow entry with the vendor status from
the CQE.

Defer transitioning QPs to the ERR state so that the other work
queues can be flushed. Complete software-flush setup even if the deferred
ERR request fails, since the error CQE already guarantees whole QP
shutdown.

Clear pending CQEs for a kernel QP after a hardware RESET by setting
their QIDs to zero. Discard CQEs with a zero QID.

Mark deferred errors as pending when scheduling work to prevent stale
work from moving a reset and reused QP to ERR.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v7:
- Schedule error work for GSI. Complete software-flush after an error CQE
  even if the firmware ERR request fails. 
v6:
- Check fenced WQEs on error cqes to prevent flushing completed WQEs.
- Add mana_ib_cq_clean on QP reset to discard stale CQEs. QID 0 is
 an invalid value for RNIC and safe dor discarding.
- Add error_pending flag to prevent deffered ERR request to error reset QPs.
- Update commit message
v2:
- Flush error_work after draining QP references during teardown.

 drivers/infiniband/hw/mana/cq.c      | 201 ++++++++++++++++++++++++---
 drivers/infiniband/hw/mana/mana_ib.h |  44 +++++-
 drivers/infiniband/hw/mana/qp.c      |  46 +++++-
 3 files changed, 263 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d6fa1942b535..b4b1c913df8c 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -5,6 +5,8 @@
 
 #include "mana_ib.h"
 
+#define MANA_CQE_INVALID_QID 0
+
 #define PSN_SIGN_BIT 0x800000
 #define PSN_GE(PSN1, PSN2) ((((PSN1) - (PSN2)) & PSN_SIGN_BIT) == 0)
 #define PSN_GT(PSN1, PSN2) PSN_GE(PSN1, (PSN2) + 1)
@@ -18,6 +20,7 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
 		return IB_WC_SUCCESS;
 	case VENDOR_ERR_RX_PKT_LEN:
 	case VENDOR_ERR_RX_MSG_LEN_OVFL:
+	case VENDOR_ERR_RX_READRESP_LEN_MISMATCH:
 		return IB_WC_LOC_LEN_ERR;
 	case VENDOR_ERR_TX_GDMA_CORRUPTED_WQE:
 	case VENDOR_ERR_TX_PCIE_WQE:
@@ -37,12 +40,30 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
 	case VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION:
 	case VENDOR_ERR_TX_ATB_WQE_ADDR_RANGE:
 	case VENDOR_ERR_TX_ATB_WQE_CONFIG_ERR:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_MISS:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_IDX_ERROR:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_TAG_MISMATCH_ERROR:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_PDID_MISMATCH_ERROR:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_AR_ERROR:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_OVF:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_LENGHT_MISMATCH:
+	case VENDOR_ERR_TX_RDMA_ATB_CMD_ILLEGAL_CMD:
 	case VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE:
 	case VENDOR_ERR_RX_ATB_SGE_MISSCONFIG:
 		return IB_WC_LOC_PROT_ERR;
 	case VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT:
 	case VENDOR_ERR_RX_GFID:
 		return IB_WC_LOC_ACCESS_ERR;
+	case VENDOR_ERR_RX_OP_REQ:
+		return IB_WC_REM_INV_REQ_ERR;
+	case VENDOR_ERR_RX_ATB_RKEY_MISCONFIG_ERR:
+	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RIGHT:
+	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RANGE:
+	case VENDOR_ERR_RX_REMOTE_ACCESS_NAK:
+		return IB_WC_REM_ACCESS_ERR;
+	case VENDOR_ERR_RX_INVALID_REQ_NAK:
+	case VENDOR_ERR_RX_REMOTE_OP_ERR_NAK:
+		return IB_WC_REM_OP_ERR;
 	case VENDOR_ERR_RX_MISBEHAVING_CLIENT:
 	case VENDOR_ERR_RX_CLIENT_ID:
 	case VENDOR_ERR_RX_PCIE:
@@ -58,6 +79,10 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
 	case VENDOR_ERR_RX_NOT_EMPTY_ON_DISABLE:
 	case VENDOR_ERR_SW_FLUSHED:
 		return IB_WC_WR_FLUSH_ERR;
+	case VENDOR_ERR_TX_RETRY_LIMIT_EXCEEDED:
+		return IB_WC_RETRY_EXC_ERR;
+	case VENDOR_ERR_RX_RNR_NAK:
+		return IB_WC_RNR_RETRY_EXC_ERR;
 	default:
 		return IB_WC_GENERAL_ERR;
 	}
@@ -235,19 +260,24 @@ void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gc->cq_table[cq->queue.id] = NULL;
 }
 
-static inline bool gdma_cq_idx_produced(struct gdma_queue *gdma_cq, uint32_t idx)
+static struct gdma_cqe *mana_ib_get_cqe(struct gdma_queue *gdma_cq, u32 idx)
 {
 	struct gdma_mem_info *gmi = &gdma_cq->mem_info;
 	u32 num_cqe = gdma_cq->queue_size / GDMA_CQE_SIZE;
-	u32 expected_bits = (idx / num_cqe) & GDMA_CQE_OWNER_MASK;
 	u32 offset = (idx % num_cqe) * GDMA_CQE_SIZE;
-	struct gdma_cqe *cqe;
 
 	if (gmi->nr_pages)
-		cqe = gmi->pages_va[offset / PAGE_SIZE] +
-		      (offset & (PAGE_SIZE - 1));
-	else
-		cqe = gdma_cq->queue_mem_ptr + offset;
+		return gmi->pages_va[offset / PAGE_SIZE] +
+		       (offset & (PAGE_SIZE - 1));
+
+	return gdma_cq->queue_mem_ptr + offset;
+}
+
+static inline bool gdma_cq_idx_produced(struct gdma_queue *gdma_cq, uint32_t idx)
+{
+	u32 num_cqe = gdma_cq->queue_size / GDMA_CQE_SIZE;
+	u32 expected_bits = (idx / num_cqe) & GDMA_CQE_OWNER_MASK;
+	struct gdma_cqe *cqe = mana_ib_get_cqe(gdma_cq, idx);
 
 	return cqe->cqe_info.owner_bits == expected_bits;
 }
@@ -278,6 +308,43 @@ static inline void mana_ib_cq_doorbell(struct mana_ib_cq *cq, uint8_t arm)
 	mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), gdma_cq, idx, arm, 0);
 }
 
+static bool mana_ib_cqe_matches_qp(struct mana_ib_qp *qp, u32 wq_num, bool is_sq)
+{
+	struct mana_ib_queue *wq = is_sq ? mana_qp_get_sq(qp) : mana_qp_get_rq(qp);
+
+	return (wq_num & ~MANA_QID_SUBTYPE_MASK) == (wq->id & ~MANA_QID_SUBTYPE_MASK);
+}
+
+void mana_ib_cq_clean(struct mana_ib_cq *cq, struct mana_ib_qp *qp)
+{
+	struct gdma_queue *gdma_cq = cq->queue.kmem;
+	struct gdma_cqe *cqe;
+	u32 num_cqe, idx, i;
+
+	lockdep_assert_held(&cq->cq_lock);
+
+	if (!gdma_cq)
+		return;
+
+	if (cq->has_pending_cqe &&
+	    mana_ib_cqe_matches_qp(qp, cq->pending_cqe.wq_num, cq->pending_cqe.is_sq))
+		cq->has_pending_cqe = false;
+
+	/* Hardware RESET has completed, so this QP cannot produce new CQEs. */
+	num_cqe = gdma_cq->queue_size / GDMA_CQE_SIZE;
+	for (i = 0; i < num_cqe; i++) {
+		idx = gdma_cq->head + i;
+		if (!gdma_cq_idx_produced(gdma_cq, idx))
+			break;
+
+		/* Read CQE contents only after observing their owner bits. */
+		rmb();
+		cqe = mana_ib_get_cqe(gdma_cq, idx);
+		if (mana_ib_cqe_matches_qp(qp, cqe->cqe_info.wq_num, cqe->cqe_info.is_sq))
+			cqe->cqe_info.wq_num = MANA_CQE_INVALID_QID;
+	}
+}
+
 static bool mana_ib_cq_has_flush_work(struct mana_ib_cq *cq)
 {
 	struct mana_ib_qp *qp;
@@ -452,11 +519,33 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe,
  * A fenced WQE can acknowledge the other send queue. Retire those dependencies
  * first, without losing the fence when the caller's WC array fills up.
  */
+static bool mana_complete_send_dependencies(struct mana_ib_qp *qp, bool mmq,
+					    const struct shadow_wqe_header *wqe,
+					    struct mana_cq_poll *poll)
+{
+	struct shadow_queue *other = mmq ? &qp->shadow_sq : &qp->shadow_mmq;
+	u32 dependency = mmq ? wqe->wqe_offset_or_psn : wqe->fsn;
+	struct shadow_wqe_header *other_wqe;
+
+	if (!(wqe->flags & MANA_WQ_FENCE_WC))
+		return true;
+
+	while ((other_wqe = shadow_queue_get_next_to_consume(other))) {
+		if (PSN_LT(dependency, mmq ? other_wqe->wqe_offset_or_psn :
+					  other_wqe->fsn))
+			break;
+		if (poll->produced == poll->budget)
+			return false;
+		mana_complete_send(qp, !mmq, poll, VENDOR_ERR_OK);
+	}
+
+	return poll->produced < poll->budget;
+}
+
 static bool mana_advance_send(struct mana_ib_qp *qp, bool mmq, u32 seq,
 			      struct mana_cq_poll *poll)
 {
 	struct shadow_queue *shadow = mmq ? &qp->shadow_mmq : &qp->shadow_sq;
-	struct shadow_queue *other = mmq ? &qp->shadow_sq : &qp->shadow_mmq;
 	struct shadow_wqe_header *shadow_wqe;
 
 	while ((shadow_wqe = shadow_queue_get_next_to_consume(shadow))) {
@@ -464,19 +553,8 @@ static bool mana_advance_send(struct mana_ib_qp *qp, bool mmq, u32 seq,
 			break;
 		if (poll->produced == poll->budget)
 			return false;
-		if (shadow_wqe->flags & MANA_WQ_FENCE_WC) {
-			u32 dependency = mmq ? shadow_wqe->wqe_offset_or_psn : shadow_wqe->fsn;
-			struct shadow_wqe_header *other_wqe;
-
-			while ((other_wqe = shadow_queue_get_next_to_consume(other))) {
-				if (PSN_LT(dependency, mmq ? other_wqe->wqe_offset_or_psn :
-							     other_wqe->fsn))
-					break;
-				mana_complete_send(qp, !mmq, poll, VENDOR_ERR_OK);
-				if (poll->produced == poll->budget)
-					return false;
-			}
-		}
+		if (!mana_complete_send_dependencies(qp, mmq, shadow_wqe, poll))
+			return false;
 
 		mana_complete_send(qp, mmq, poll, VENDOR_ERR_OK);
 	}
@@ -516,6 +594,78 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u32 psn,
 	return consumed;
 }
 
+static bool mana_cqe_is_send(struct mana_ib_qp *qp, struct gdma_comp *cqe)
+{
+	u32 qtype = cqe->wq_num & MANA_QID_SUBTYPE_MASK;
+
+	if (qp->ibqp.qp_type != IB_QPT_RC)
+		return cqe->is_sq;
+
+	return cqe->is_sq ? (qtype == MANA_QID_SUBTYPE_SREQ ||
+			    qtype == MANA_QID_SUBTYPE_MMQ) :
+			    qtype == MANA_QID_SUBTYPE_RREQ;
+}
+
+static void mana_ib_schedule_qp_error(struct mana_ib_qp *qp)
+{
+	/* CQ polling cannot sleep; teardown drains this reference before freeing. */
+	atomic_set(&qp->error_pending, 1);
+	refcount_inc(&qp->refcount);
+	if (!schedule_work(&qp->error_work))
+		mana_put_qp_ref(qp);
+}
+
+static bool handle_error_cqe(struct mana_ib_cq *cq, struct mana_ib_qp *qp,
+			     struct gdma_comp *cqe, struct mana_cq_poll *poll)
+{
+	bool mmq = cqe->is_sq && (cqe->wq_num & MANA_QID_SUBTYPE_MASK) == MANA_QID_SUBTYPE_MMQ;
+	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
+	bool send = mana_cqe_is_send(qp, cqe);
+	u32 vendor_err = rdma_cqe->error.vendor_error;
+	struct shadow_wqe_header *shadow_wqe;
+	struct shadow_queue *shadow_q;
+
+	if (send && qp->ibqp.qp_type == IB_QPT_RC) {
+		/* The error PSN/FSN belongs to the failing WQE, not a success. */
+		if (!mana_advance_send(qp, mmq, rdma_cqe->error.psn - 1, poll))
+			return false;
+		if (poll->produced == poll->budget)
+			return false;
+	}
+
+	if (!send)
+		shadow_q = &qp->shadow_rq;
+	else if (mmq)
+		shadow_q = &qp->shadow_mmq;
+	else
+		shadow_q = &qp->shadow_sq;
+
+	shadow_wqe = shadow_queue_get_next_to_consume(shadow_q);
+	if (shadow_wqe) {
+		if (send) {
+			if (!mana_complete_send_dependencies(qp, mmq, shadow_wqe, poll))
+				return false;
+
+			mana_complete_send(qp, mmq, poll, vendor_err);
+		} else {
+			mana_fill_wc(qp, poll, shadow_wqe, IB_WC_RECV, vendor_err);
+			shadow_queue_advance_consumer(shadow_q);
+		}
+	}
+
+	/* Hardware has stopped DMA for the queues flushed below. */
+	if (send) {
+		if (list_empty(&qp->send_err_node))
+			list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
+	} else {
+		if (list_empty(&qp->recv_err_node))
+			list_add_tail(&qp->recv_err_node, &cq->recv_err_qp_list);
+	}
+	mana_ib_schedule_qp_error(qp);
+
+	return true;
+}
+
 static bool next_shadow_wqe_is_sq(struct shadow_wqe_header *shadow_wqe_sq,
 				  struct shadow_wqe_header *shadow_wqe_mq)
 {
@@ -534,9 +684,13 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
 {
 	struct gdma_comp *cqe = &cq->pending_cqe;
 	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
-	struct mana_ib_qp *qp = mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
+	struct mana_ib_qp *qp;
 	bool consumed = true;
 
+	if (cqe->wq_num == MANA_CQE_INVALID_QID)
+		return true;
+
+	qp = mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
 	if (!qp)
 		return true;
 
@@ -547,6 +701,9 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
 	case CQE_TYPE_LWR:
 		consumed = handle_mmq_cqe(qp, rdma_cqe->rc_mm.fsn, poll);
 		break;
+	case CQE_TYPE_ERROR:
+		consumed = handle_error_cqe(cq, qp, cqe, poll);
+		break;
 	case CQE_TYPE_UD_SEND:
 		if (cqe->is_sq) {
 			handle_ud_sq_cqe(qp, rdma_cqe, poll);
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index ef20ec0ec77b..6f563f8bee3e 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -11,7 +11,9 @@
 #include <rdma/iter.h>
 #include <rdma/mana-abi.h>
 #include <rdma/uverbs_ioctl.h>
+#include <linux/atomic.h>
 #include <linux/dmapool.h>
+#include <linux/workqueue.h>
 
 #include <net/mana/mana.h>
 #include "shadow_queue.h"
@@ -33,6 +35,11 @@
 /* Queue ID encodes type in the lower 2 bits */
 #define MANA_QID_SUBTYPE_MASK 0x3
 
+#define MANA_QID_SUBTYPE_SREQ 0x0
+#define MANA_QID_SUBTYPE_MMQ 0x2
+#define MANA_QID_SUBTYPE_RRESP 0x0
+#define MANA_QID_SUBTYPE_RREQ 0x1
+
 /*
  * The hardware limit of number of MRs is greater than maximum number of MRs
  * that can possibly represent in 24 bits
@@ -276,8 +283,10 @@ struct mana_ib_qp {
 	spinlock_t rq_lock;
 	/* Serializes send and memory-management WR posting. */
 	spinlock_t sq_lock;
-	/* Serializes QP modification and error-list transitions. */
+	/* Serializes QP modification and deferred error work. */
 	struct mutex modify_lock;
+	struct work_struct error_work;
+	atomic_t error_pending;
 
 	struct list_head send_err_node;
 	struct list_head recv_err_node;
@@ -646,20 +655,30 @@ struct rdma_recv_oob {
 
 enum mana_ib_error_code {
 	VENDOR_ERR_OK					= 0x0,
+	VENDOR_ERR_RX_OP_REQ                            = 0x03,
 	VENDOR_ERR_RX_PKT_LEN                           = 0x05,
+	VENDOR_ERR_RX_ATB_RKEY_MISCONFIG_ERR            = 0x43,
+	VENDOR_ERR_RX_ATB_RKEY_ADDR_RIGHT               = 0x83,
+	VENDOR_ERR_RX_ATB_RKEY_ADDR_RANGE               = 0xc3,
 	VENDOR_ERR_RX_MSG_LEN_OVFL                      = 0x102,
 	VENDOR_ERR_RX_MISBEHAVING_CLIENT                = 0x108,
 	VENDOR_ERR_RX_MALFORMED_WQE                     = 0x109,
 	VENDOR_ERR_RX_CLIENT_ID                         = 0x10a,
 	VENDOR_ERR_RX_GFID                              = 0x10b,
+	VENDOR_ERR_RX_READRESP_LEN_MISMATCH             = 0x10f,
 	VENDOR_ERR_RX_PCIE                              = 0x10c,
 	VENDOR_ERR_RX_NO_AVAIL_WQE                      = 0x111,
 	VENDOR_ERR_RX_ATB_SGE_MISSCONFIG                = 0x143,
 	VENDOR_ERR_RX_ATB_WQE_MISCONFIG                 = 0x145,
+	VENDOR_ERR_RX_INVALID_REQ_NAK                   = 0x161,
+	VENDOR_ERR_RX_REMOTE_ACCESS_NAK                 = 0x162,
+	VENDOR_ERR_RX_REMOTE_OP_ERR_NAK                 = 0x163,
+	VENDOR_ERR_RX_RNR_NAK                           = 0x164,
 	VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT                = 0x183,
 	VENDOR_ERR_RX_ATB_WQE_ADDR_RIGHT                = 0x185,
 	VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE                = 0x1c3,
 	VENDOR_ERR_RX_ATB_WQE_ADDR_RANGE                = 0x1c5,
+	VENDOR_ERR_TX_RETRY_LIMIT_EXCEEDED              = 0x1c6,
 	VENDOR_ERR_RX_NOT_EMPTY_ON_DISABLE              = 0x1c7,
 	VENDOR_ERR_TX_GDMA_CORRUPTED_WQE                = 0x201,
 	VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION          = 0x202,
@@ -681,6 +700,14 @@ enum mana_ib_error_code {
 	VENDOR_ERR_TX_RDMA_WQE_LEN_ERR                  = 0x216,
 	VENDOR_ERR_TX_RDMA_MTU_ERR                      = 0x217,
 	VENDOR_ERR_TX_RDMA_VFID_MISMATCH                = 0x218,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_MISS                 = 0x220,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_IDX_ERROR            = 0x221,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_TAG_MISMATCH_ERROR   = 0x222,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_PDID_MISMATCH_ERROR  = 0x223,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_AR_ERROR             = 0x224,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_PT_OVF               = 0x225,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_PT_LENGHT_MISMATCH   = 0x226,
+	VENDOR_ERR_TX_RDMA_ATB_CMD_ILLEGAL_CMD          = 0x227,
 	VENDOR_ERR_HW_MAX                               = 0x3ff,
 	/* SW vendor errors */
 	VENDOR_ERR_SW_FLUSHED				= 0xfff,
@@ -695,6 +722,7 @@ enum mana_ib_cqe_type {
 	CQE_TYPE_RC_WRITE_IMM = 6,
 	CQE_TYPE_ARMED_CMPL = 7,
 	CQE_TYPE_LWR = 8,
+	CQE_TYPE_ERROR = 34,
 }; /* HW DATA */
 
 struct mana_rdma_cqe {
@@ -727,6 +755,19 @@ struct mana_rdma_cqe {
 			u32 imm_data;
 			u32 rx_wqe_offset;
 		} rc_recv;
+		struct {
+			u32 cqe_type		: 8;
+			u32 vendor_error	: 10;
+			u32 reserved1		: 14;
+			u32 msn			: 24;
+			u32 syndrome		: 8;
+			u32 psn			: 24;
+			u32 opcode		: 8;
+			u32 rsp_msn		: 24;
+			u32 reserved2		: 8;
+			u32 rsp_psn		: 24;
+			u32 reserved3		: 8;
+		} error;
 		struct {
 			u32 cqe_type		: 8;
 			u32 reserved1		: 24;
@@ -1024,6 +1065,7 @@ int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 void mana_drain_gsi_sqs(struct mana_ib_dev *mdev);
 int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
+void mana_ib_cq_clean(struct mana_ib_cq *cq, struct mana_ib_qp *qp);
 
 int mana_ib_alloc_mw(struct ib_mw *mw, struct ib_udata *udata);
 int mana_ib_dealloc_mw(struct ib_mw *mw);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 18242e1a6360..c6ab152de01f 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -5,6 +5,8 @@
 
 #include "mana_ib.h"
 
+static void mana_ib_qp_error_work(struct work_struct *work);
+
 static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 				      struct net_device *ndev,
 				      mana_handle_t default_rxobj,
@@ -546,6 +548,7 @@ static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
 {
 	mana_put_qp_ref(qp);
 	wait_for_completion(&qp->free);
+	flush_work(&qp->error_work);
 }
 
 static int mana_table_store_qp_qid(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
@@ -801,6 +804,7 @@ static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
 	list_del_init(&qp->send_err_node);
 	/* Keep shadow reset serialized with hardware polling and SW flushing. */
 	if (reset) {
+		mana_ib_cq_clean(send_cq, qp);
 		reset_shadow_queue(&qp->shadow_sq);
 		reset_shadow_queue(&qp->shadow_mmq);
 	}
@@ -808,8 +812,11 @@ static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
 
 	spin_lock_irqsave(&recv_cq->cq_lock, flags);
 	list_del_init(&qp->recv_err_node);
-	if (reset)
+	if (reset) {
+		if (recv_cq != send_cq)
+			mana_ib_cq_clean(recv_cq, qp);
 		reset_shadow_queue(&qp->shadow_rq);
+	}
 	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);
 }
 
@@ -988,6 +995,8 @@ int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	spin_lock_init(&qp->rq_lock);
 	spin_lock_init(&qp->sq_lock);
 	mutex_init(&qp->modify_lock);
+	INIT_WORK(&qp->error_work, mana_ib_qp_error_work);
+	atomic_set(&qp->error_pending, 0);
 	INIT_LIST_HEAD(&qp->send_err_node);
 	INIT_LIST_HEAD(&qp->recv_err_node);
 
@@ -1109,6 +1118,8 @@ static bool mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		switch (attr->qp_state) {
 		case IB_QPS_RESET:
 			mana_remove_qp_from_cqs(qp, true);
+			/* Both CQs are clean; no old CQE can queue another error. */
+			atomic_set(&qp->error_pending, 0);
 			break;
 		default:
 			break;
@@ -1148,22 +1159,27 @@ static void mana_ib_notify_error_cqs(struct mana_ib_qp *qp)
 		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
 }
 
-int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		      int attr_mask, struct ib_udata *udata)
+static int mana_ib_modify_qp_common(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+				    int attr_mask, struct ib_udata *udata,
+				    bool error_work)
 {
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 	bool notify = false;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&qp->modify_lock);
 
+	if (error_work && !atomic_xchg(&qp->error_pending, 0))
+		goto out_unlock;
+
 	switch (ibqp->qp_type) {
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		ret = mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
-		if (ret)
+		/* Error CQEs guarantee whole-QP DMA shutdown. */
+		if (ret && !error_work)
 			goto out_unlock;
 		break;
 	default:
@@ -1182,6 +1198,26 @@ out_unlock:
 	return ret;
 }
 
+int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata)
+{
+	return mana_ib_modify_qp_common(ibqp, attr, attr_mask, udata, false);
+}
+
+static void mana_ib_qp_error_work(struct work_struct *work)
+{
+	struct mana_ib_qp *qp = container_of(work, struct mana_ib_qp, error_work);
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	int ret;
+
+	ret = mana_ib_modify_qp_common(&qp->ibqp, &attr, IB_QP_STATE, NULL, true);
+	if (ret)
+		ibdev_err(qp->ibqp.device, "Failed to move QP %u to ERR: %d\n",
+			  qp->ibqp.qp_num, ret);
+
+	mana_put_qp_ref(qp);
+}
+
 static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
 				  struct ib_rwq_ind_table *ind_tbl,
 				  struct ib_udata *udata)
-- 
2.43.0
