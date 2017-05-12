From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/5] libbnxt_re: reset head and tail when moving to RST
Date: Fri, 12 May 2017 06:24:26 -0400
Message-ID: <1494584666-11064-6-git-send-email-devesh.sharma@broadcom.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the QP is moving to RESET state from any state
the head and tail of SQ and RQ(if present) should move
to initial state (which is 0).
This patch adds the code to handle reseting head and tail.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/verbs.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index d337514..1fe7967 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -419,6 +419,11 @@ static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
 	ibvwc->wc_flags = 0;
 	if (is_imm) {
 		ibvwc->wc_flags |= IBV_WC_WITH_IMM;
+		/* Completion reports the raw-data in LE format, While
+		 * user expects it in BE format. Thus, swapping on outgoing
+		 * data is needed. On a BE platform le32toh will do the swap
+		 * while on LE platform htobe32 will do the job.
+		 */
 		ibvwc->imm_data = htobe32(le32toh(rcqe->imm_key));
 		if (is_rdma)
 			ibvwc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
@@ -917,9 +922,18 @@ int bnxt_re_modify_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
 
 	rc = ibv_cmd_modify_qp(ibvqp, attr, attr_mask, &cmd, sizeof(cmd));
 	if (!rc) {
-		if (attr_mask & IBV_QP_STATE)
+		if (attr_mask & IBV_QP_STATE) {
 			qp->qpst = attr->qp_state;
-
+			/* transition to reset */
+			if (qp->qpst == IBV_QPS_RESET) {
+				qp->sqq->head = 0;
+				qp->sqq->tail = 0;
+				if (qp->rqq) {
+					qp->rqq->head = 0;
+					qp->rqq->tail = 0;
+				}
+			}
+		}
 		if (attr_mask & IBV_QP_SQ_PSN)
 			qp->sq_psn = attr->sq_psn;
 		if (attr_mask & IBV_QP_PATH_MTU)
@@ -1200,6 +1214,11 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 						  qp->cap.sqsig);
 		switch (wr->opcode) {
 		case IBV_WR_SEND_WITH_IMM:
+			/* Since our h/w is LE and user supplies raw-data in
+			 * BE format. Swapping on incoming data is needed.
+			 * On a BE platform htole32 will do the swap while on
+			 * LE platform be32toh will do the job.
+			 */
 			hdr->key_immd = htole32(be32toh(wr->imm_data));
 		case IBV_WR_SEND:
 			if (qp->qptyp == IBV_QPT_UD)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
