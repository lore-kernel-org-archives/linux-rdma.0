Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5E7417366;
	Sat, 10 Oct 2026 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615289; cv=none; b=O+cXlV4akwbouzCeNPNX1PklXA5UA3pebcT9+uXb7357H9CSHqV+WNWi27xYtu224lYkklQCtWgQ+QlMfUjAr95nbtB0aQiMBIpwJ8jIGGzKmkM/PPKgh20zLFNtKQ2egKkgGtjfMXm1Jd2MryJo2JPWanRk8hb0Q4lLPjsVD5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615289; c=relaxed/simple;
	bh=uTP7bntK3R9UHedRRZGEnQges1+QHU99Fh1qq+oqZk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCneL6LhO8qwhu3LTwTqKhtBmmjQGN8mhbC1Uun+bO5qdqngZNSPWXHyRIF8mjYEqU/xshjwd00fsOpzju2Fj/SI6f5aDsHPwQs7AotpbWe40p0qR73Ld7o1oVC6Tb0eLktV1ofU2KCs74VmLQiyBBPx5PUa+KaqDqNHJH+Najw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Fh6IPMyb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Fh6IPMyb"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 20A9720B7170; Fri,  9 Oct 2026 23:54:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 20A9720B7170
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791615284;
	bh=9LU1gLU3wYRNP01T1RXX5mX0u6vlKX8nZ47r6dNYcRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fh6IPMybehWuX78bSCFweHctiiDSxp1N0nlxeFWTOVqPPGom85Gt2D2ABoiNwo6Gy
	 lPkEcmPCDgO16D3cZzX0x1EA9uVkmZtVMUhpODJWiA2Tht0jFlIYFnqkdAQWPq8hGb
	 xIhSN/2YR4hzJjplctCwJA+N7s/ABlg9ZpFkWDCw=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 09/10] RDMA/mana_ib: Handle error CQEs for RC QPs
Date: Fri,  9 Oct 2026 23:54:42 -0700
Message-ID: <20261010065443.3554193-10-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Decode hardware error CQEs and process them on the corresponding work
queue. Complete the failing shadow entry with the vendor status from
the CQE.

Defer transitioning RC QPs to the ERR state so that the other work
queues can be flushed.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v2:
- Flush error_work after draining QP references during teardown.

 drivers/infiniband/hw/mana/cq.c      | 91 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h | 41 ++++++++++++-
 drivers/infiniband/hw/mana/qp.c      | 18 ++++++
 3 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 90a43c7feb31..63c92a028785 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -18,6 +18,7 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
 		return IB_WC_SUCCESS;
 	case VENDOR_ERR_RX_PKT_LEN:
 	case VENDOR_ERR_RX_MSG_LEN_OVFL:
+	case VENDOR_ERR_RX_READRESP_LEN_MISMATCH:
 		return IB_WC_LOC_LEN_ERR;
 	case VENDOR_ERR_TX_GDMA_CORRUPTED_WQE:
 	case VENDOR_ERR_TX_PCIE_WQE:
@@ -37,12 +38,30 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
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
@@ -58,6 +77,10 @@ static enum ib_wc_status vendor_error_to_wc_error(uint32_t vendor_error)
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
@@ -493,6 +516,71 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u32 psn,
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
+		mana_fill_wc(qp, poll, shadow_wqe,
+			     send ? shadow_wqe->send_opcode : IB_WC_RECV, vendor_err);
+		shadow_queue_advance_consumer(shadow_q);
+	}
+
+	if (send) {
+		if (list_empty(&qp->send_err_node))
+			list_add_tail(&qp->send_err_node, &cq->send_err_qp_list);
+	} else {
+		if (list_empty(&qp->recv_err_node))
+			list_add_tail(&qp->recv_err_node, &cq->recv_err_qp_list);
+	}
+	if (qp->ibqp.qp_type != IB_QPT_GSI)
+		mana_ib_schedule_qp_error(qp);
+
+	return true;
+}
+
 static bool next_shadow_wqe_is_sq(struct shadow_wqe_header *shadow_wqe_sq,
 				  struct shadow_wqe_header *shadow_wqe_mq)
 {
@@ -524,6 +612,9 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev *mdev,
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
index bea19d1d0dc1..2fbb1c662d93 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -12,6 +12,7 @@
 #include <rdma/mana-abi.h>
 #include <rdma/uverbs_ioctl.h>
 #include <linux/dmapool.h>
+#include <linux/workqueue.h>
 
 #include <net/mana/mana.h>
 #include "shadow_queue.h"
@@ -33,6 +34,11 @@
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
@@ -277,8 +283,9 @@ struct mana_ib_qp {
 	spinlock_t rq_lock;
 	/* Serializes send and memory-management WR posting. */
 	spinlock_t sq_lock;
-	/* Serializes QP modification and error-list transitions. */
+	/* Serializes QP modification and deferred error work. */
 	struct mutex modify_lock;
+	struct work_struct error_work;
 
 	struct list_head send_err_node;
 	struct list_head recv_err_node;
@@ -647,20 +654,30 @@ struct rdma_recv_oob {
 
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
@@ -682,6 +699,14 @@ enum mana_ib_error_code {
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
@@ -696,6 +721,7 @@ enum mana_ib_cqe_type {
 	CQE_TYPE_RC_WRITE_IMM = 6,
 	CQE_TYPE_ARMED_CMPL = 7,
 	CQE_TYPE_LWR = 8,
+	CQE_TYPE_ERROR = 34,
 }; /* HW DATA */
 
 struct mana_rdma_cqe {
@@ -728,6 +754,19 @@ struct mana_rdma_cqe {
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
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index f26f73025d12..3158d41db709 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -5,6 +5,8 @@
 
 #include "mana_ib.h"
 
+static void mana_ib_qp_error_work(struct work_struct *work);
+
 static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 				      struct net_device *ndev,
 				      mana_handle_t default_rxobj,
@@ -511,6 +513,7 @@ static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
 {
 	mana_put_qp_ref(qp);
 	wait_for_completion(&qp->free);
+	flush_work(&qp->error_work);
 }
 
 static int mana_table_store_qp_qid(struct mana_ib_dev *mdev, struct mana_ib_qp *qp,
@@ -945,6 +948,7 @@ int mana_ib_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 	spin_lock_init(&qp->rq_lock);
 	spin_lock_init(&qp->sq_lock);
 	mutex_init(&qp->modify_lock);
+	INIT_WORK(&qp->error_work, mana_ib_qp_error_work);
 	INIT_LIST_HEAD(&qp->send_err_node);
 	INIT_LIST_HEAD(&qp->recv_err_node);
 
@@ -1140,6 +1144,20 @@ out_unlock:
 	return ret;
 }
 
+static void mana_ib_qp_error_work(struct work_struct *work)
+{
+	struct mana_ib_qp *qp = container_of(work, struct mana_ib_qp, error_work);
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	int ret;
+
+	ret = mana_ib_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
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
