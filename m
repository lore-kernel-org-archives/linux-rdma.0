From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v5 7/8] libbnxt_re: Enable polling for UD completions
Date: Mon, 24 Apr 2017 14:53:14 -0400
Message-ID: <1493059995-636-8-git-send-email-devesh.sharma@broadcom.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493059995-636-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds support to allow polling of send
and recv completions for a UD qp.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/bnxt_re-abi.h |  6 ++++++
 providers/bnxt_re/verbs.c       | 43 +++++++++++++++++++++++++++--------------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index 36b74cd..db11322 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -174,6 +174,12 @@ enum bnxt_re_ud_flags_mask {
 	BNXT_RE_UD_FLAGS_ROCE_IPV6	= 0x03
 };
 
+enum bnxt_re_ud_cqe_mask {
+	BNXT_RE_UD_CQE_MAC_MASK		= 0xFFFFFFFFFFFFULL,
+	BNXT_RE_UD_CQE_SRCQPLO_MASK	= 0xFFFF,
+	BNXT_RE_UD_CQE_SRCQPLO_SHIFT	= 0x30
+};
+
 enum bnxt_re_shpg_offt {
 	BNXT_RE_SHPG_BEG_RESV_OFFT	= 0x00,
 	BNXT_RE_SHPG_AVID_OFFT		= 0x10,
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 54c8906..1f8ff8e 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -338,10 +338,8 @@ static uint8_t bnxt_re_poll_scqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
 	return pcqe;
 }
 
-static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp,
-				 struct ibv_wc *ibvwc,
-				 struct bnxt_re_bcqe *hdr,
-				 struct bnxt_re_rc_cqe *rcqe)
+static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
+				 struct bnxt_re_bcqe *hdr, void *cqe)
 {
 	struct bnxt_re_queue *rq = qp->rqq;
 	struct bnxt_re_wrid *rwrid;
@@ -366,6 +364,10 @@ static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp,
 		ibvwc->qp_num = qp->qpid;
 		ibvwc->opcode = IBV_WC_RECV;
 		ibvwc->byte_len = 0;
+		ibvwc->wc_flags = 0;
+		if (qp->qptyp == IBV_QPT_UD)
+			ibvwc->src_qp = 0;
+
 		bnxt_re_incr_head(qp->rqq);
 		if (qp->qpst != IBV_QPS_ERR)
 			qp->qpst = IBV_QPS_ERR;
@@ -377,16 +379,32 @@ static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp,
 	return 1;
 }
 
+static void bnxt_re_fill_ud_cqe(struct ibv_wc *ibvwc,
+				struct bnxt_re_bcqe *hdr, void *cqe)
+{
+	struct bnxt_re_ud_cqe *ucqe = cqe;
+	uint32_t qpid;
+
+	qpid = ((le32toh(hdr->qphi_rwrid) >> BNXT_RE_BCQE_SRCQP_SHIFT) &
+		 BNXT_RE_BCQE_SRCQP_SHIFT) << 0x10; /* higher 8 bits of 24 */
+	qpid |= (le64toh(ucqe->qplo_mac) >> BNXT_RE_UD_CQE_SRCQPLO_SHIFT) &
+		 BNXT_RE_UD_CQE_SRCQPLO_MASK; /*lower 16 of 24 */
+	ibvwc->src_qp = qpid;
+	ibvwc->wc_flags |= IBV_WC_GRH;
+	/*IB-stack ABI in user do not ask for MAC to be reported. */
+}
+
 static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
 				      struct ibv_wc *ibvwc,
-				      struct bnxt_re_bcqe *hdr,
-				      struct bnxt_re_rc_cqe *rcqe)
+				      struct bnxt_re_bcqe *hdr, void *cqe)
 {
 	struct bnxt_re_queue *rq = qp->rqq;
 	struct bnxt_re_wrid *rwrid;
+	struct bnxt_re_rc_cqe *rcqe;
 	uint32_t head = rq->head;
 	uint8_t flags, is_imm, is_rdma;
 
+	rcqe = cqe;
 	rwrid = &qp->rwrid[head];
 
 	ibvwc->status = IBV_WC_SUCCESS;
@@ -409,6 +427,9 @@ static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
 			ibvwc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
 	}
 
+	if (qp->qptyp == IBV_QPT_UD)
+		bnxt_re_fill_ud_cqe(ibvwc, hdr, cqe);
+
 	bnxt_re_incr_head(rq);
 }
 
@@ -416,19 +437,17 @@ static uint8_t bnxt_re_poll_rcqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
 				 void *cqe, int *cnt)
 {
 	struct bnxt_re_bcqe *hdr;
-	struct bnxt_re_rc_cqe *rcqe;
 	uint8_t status, pcqe = false;
 
-	rcqe = cqe;
 	hdr = cqe + sizeof(struct bnxt_re_rc_cqe);
 
 	status = (le32toh(hdr->flg_st_typ_ph) >> BNXT_RE_BCQE_STATUS_SHIFT) &
 		  BNXT_RE_BCQE_STATUS_MASK;
 	*cnt = 1;
 	if (status == BNXT_RE_RSP_ST_OK)
-		bnxt_re_poll_success_rcqe(qp, ibvwc, hdr, rcqe);
+		bnxt_re_poll_success_rcqe(qp, ibvwc, hdr, cqe);
 	else
-		*cnt = bnxt_re_poll_err_rcqe(qp, ibvwc, hdr, rcqe);
+		*cnt = bnxt_re_poll_err_rcqe(qp, ibvwc, hdr, cqe);
 
 	return pcqe;
 }
@@ -486,9 +505,6 @@ static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
 			     (uintptr_t)le64toh(scqe->qp_handle);
 			if (!qp)
 				break; /*stale cqe. should be rung.*/
-			if (qp->qptyp == IBV_QPT_UD)
-				goto bail; /* TODO: Add UD poll */
-
 			pcqe = bnxt_re_poll_scqe(qp, wc, cqe, &cnt);
 			break;
 		case BNXT_RE_WC_TYPE_RECV_RC:
@@ -503,7 +519,6 @@ static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
 				goto bail; /*TODO: Add SRQ poll */
 
 			pcqe = bnxt_re_poll_rcqe(qp, wc, cqe, &cnt);
-			/* TODO: Process UD rcqe */
 			break;
 		case BNXT_RE_WC_TYPE_RECV_RAW:
 			break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
