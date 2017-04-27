From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 5/5] RDMA/qedr: add support for send+invalidate in poll CQ
Date: Thu, 27 Apr 2017 13:35:35 +0300
Message-ID: <1493289335-29350-6-git-send-email-Ram.Amrani@cavium.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Split the poll responder CQ into two functions.
Add support for send+invalidate in poll CQ.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr.h  |  3 +-
 drivers/infiniband/hw/qedr/verbs.c | 98 ++++++++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 4e4495f..762e4ff 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -430,7 +430,8 @@ struct qedr_mr {
 			 RDMA_CQE_RESPONDER_IMM_FLG_SHIFT)
 #define QEDR_RESP_RDMA	(RDMA_CQE_RESPONDER_RDMA_FLG_MASK << \
 			 RDMA_CQE_RESPONDER_RDMA_FLG_SHIFT)
-#define QEDR_RESP_RDMA_IMM (QEDR_RESP_IMM | QEDR_RESP_RDMA)
+#define QEDR_RESP_INV	(RDMA_CQE_RESPONDER_INV_FLG_MASK << \
+			 RDMA_CQE_RESPONDER_INV_FLG_SHIFT)
 
 static inline void qedr_inc_sw_cons(struct qedr_qp_hwq_info *info)
 {
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 2028c14..f7a5f41 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3330,57 +3330,81 @@ static int qedr_poll_cq_req(struct qedr_dev *dev,
 	return cnt;
 }
 
-static void __process_resp_one(struct qedr_dev *dev, struct qedr_qp *qp,
-			       struct qedr_cq *cq, struct ib_wc *wc,
-			       struct rdma_cqe_responder *resp, u64 wr_id)
+static inline int qedr_cqe_resp_status_to_ib(u8 status)
 {
-	enum ib_wc_status wc_status = IB_WC_SUCCESS;
-	u8 flags;
-
-	wc->opcode = IB_WC_RECV;
-	wc->wc_flags = 0;
-
-	switch (resp->status) {
+	switch (status) {
 	case RDMA_CQE_RESP_STS_LOCAL_ACCESS_ERR:
-		wc_status = IB_WC_LOC_ACCESS_ERR;
-		break;
+		return IB_WC_LOC_ACCESS_ERR;
 	case RDMA_CQE_RESP_STS_LOCAL_LENGTH_ERR:
-		wc_status = IB_WC_LOC_LEN_ERR;
-		break;
+		return IB_WC_LOC_LEN_ERR;
 	case RDMA_CQE_RESP_STS_LOCAL_QP_OPERATION_ERR:
-		wc_status = IB_WC_LOC_QP_OP_ERR;
-		break;
+		return IB_WC_LOC_QP_OP_ERR;
 	case RDMA_CQE_RESP_STS_LOCAL_PROTECTION_ERR:
-		wc_status = IB_WC_LOC_PROT_ERR;
-		break;
+		return IB_WC_LOC_PROT_ERR;
 	case RDMA_CQE_RESP_STS_MEMORY_MGT_OPERATION_ERR:
-		wc_status = IB_WC_MW_BIND_ERR;
-		break;
+		return IB_WC_MW_BIND_ERR;
 	case RDMA_CQE_RESP_STS_REMOTE_INVALID_REQUEST_ERR:
-		wc_status = IB_WC_REM_INV_RD_REQ_ERR;
-		break;
+		return IB_WC_REM_INV_RD_REQ_ERR;
 	case RDMA_CQE_RESP_STS_OK:
-		wc_status = IB_WC_SUCCESS;
-		wc->byte_len = le32_to_cpu(resp->length);
+		return IB_WC_SUCCESS;
+	default:
+		return IB_WC_GENERAL_ERR;
+	}
+}
 
-		flags = resp->flags & QEDR_RESP_RDMA_IMM;
+static inline int qedr_set_ok_cqe_resp_wc(struct rdma_cqe_responder *resp,
+					  struct ib_wc *wc)
+{
+	wc->status = IB_WC_SUCCESS;
+	wc->byte_len = le32_to_cpu(resp->length);
 
-		if (flags == QEDR_RESP_RDMA_IMM)
+	if (resp->flags & QEDR_RESP_IMM) {
+		wc->ex.imm_data = le32_to_cpu(resp->imm_data_or_inv_r_Key);
+		wc->wc_flags |= IB_WC_WITH_IMM;
+
+		if (resp->flags & QEDR_RESP_RDMA)
 			wc->opcode = IB_WC_RECV_RDMA_WITH_IMM;
 
-		if (flags == QEDR_RESP_RDMA_IMM || flags == QEDR_RESP_IMM) {
-			wc->ex.imm_data =
-				le32_to_cpu(resp->imm_data_or_inv_r_Key);
-			wc->wc_flags |= IB_WC_WITH_IMM;
-		}
-		break;
-	default:
-		wc->status = IB_WC_GENERAL_ERR;
-		DP_ERR(dev, "Invalid CQE status detected\n");
+		if (resp->flags & QEDR_RESP_INV)
+			return -EINVAL;
+
+	} else if (resp->flags & QEDR_RESP_INV) {
+		wc->ex.imm_data = le32_to_cpu(resp->imm_data_or_inv_r_Key);
+		wc->wc_flags |= IB_WC_WITH_INVALIDATE;
+
+		if (resp->flags & QEDR_RESP_RDMA)
+			return -EINVAL;
+
+	} else if (resp->flags & QEDR_RESP_RDMA) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __process_resp_one(struct qedr_dev *dev, struct qedr_qp *qp,
+			       struct qedr_cq *cq, struct ib_wc *wc,
+			       struct rdma_cqe_responder *resp, u64 wr_id)
+{
+	/* Must fill fields before qedr_set_ok_cqe_resp_wc() */
+	wc->opcode = IB_WC_RECV;
+	wc->wc_flags = 0;
+
+	if (likely(resp->status == RDMA_CQE_RESP_STS_OK)) {
+		if (qedr_set_ok_cqe_resp_wc(resp, wc))
+			DP_ERR(dev,
+			       "CQ %p (icid=%d) has invalid CQE responder flags=0x%x\n",
+			       cq, cq->icid, resp->flags);
+
+	} else {
+		wc->status = qedr_cqe_resp_status_to_ib(resp->status);
+		if (wc->status == IB_WC_GENERAL_ERR)
+			DP_ERR(dev,
+			       "CQ %p (icid=%d) contains an invalid CQE status %d\n",
+			       cq, cq->icid, resp->status);
 	}
 
-	/* fill WC */
-	wc->status = wc_status;
+	/* Fill the rest of the WC */
 	wc->vendor_err = 0;
 	wc->src_qp = qp->id;
 	wc->qp = &qp->ibqp;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
