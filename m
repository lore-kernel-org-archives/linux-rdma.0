From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/5] libbnxt_re: move rts to rts after a threshold
Date: Fri, 12 May 2017 06:24:24 -0400
Message-ID: <1494584666-11064-4-git-send-email-devesh.sharma@broadcom.com>
References: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494584666-11064-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Due to a know bug, h/w is stopping UD-WQE processing after
0x800000 WQEs. Library needs to move the QP from RTS to RTS
around half-way mark. This patch adds a simple wqe-counter
and modfies the qp to circumvent the problem.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.h  |  3 +++
 providers/bnxt_re/verbs.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index 4cc8abd..9688fec 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -54,6 +54,8 @@
 
 #define DEV	"bnxt_re : "
 
+#define BNXT_RE_UD_QP_HW_STALL 0x400000
+
 struct bnxt_re_dpi {
 	__u32 dpindx;
 	__u64 *dbpage;
@@ -113,6 +115,7 @@ struct bnxt_re_qp {
 	uint32_t tbl_indx;
 	uint32_t sq_psn;
 	uint32_t pending_db;
+	uint64_t wqe_cnt;
 	uint16_t mtu;
 	uint16_t qpst;
 	uint8_t qptyp;
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 7cf0b86..abe4e2e 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1240,8 +1240,20 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		bnxt_re_fill_wrid(wrid, wr, bytes, qp->cap.sqsig);
 		bnxt_re_fill_psns(qp, psns, wr->opcode, bytes);
 		bnxt_re_incr_tail(sq);
+		qp->wqe_cnt++;
 		wr = wr->next;
 		bnxt_re_ring_sq_db(qp);
+		if (qp->wqe_cnt == BNXT_RE_UD_QP_HW_STALL && qp->qptyp ==
+		    IBV_QPT_UD) {
+			/* Move RTS to RTS since it is time. */
+			struct ibv_qp_attr attr;
+			int attr_mask;
+
+			attr_mask = IBV_QP_STATE;
+			attr.qp_state = IBV_QPS_RTS;
+			bnxt_re_modify_qp(&qp->ibvqp, &attr, attr_mask);
+			qp->wqe_cnt = 0;
+		}
 	}
 
 	pthread_spin_unlock(&sq->qlock);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
