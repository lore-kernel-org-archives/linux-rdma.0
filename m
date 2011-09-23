From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] IB/qib: Optimize RC/UC code by IB operation
Date: Fri, 23 Sep 2011 13:16:29 -0400
Message-ID: <20110923171629.14542.82485.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The memset for zeroing the work completion had been unconditional.

This patch removes the memset and moves the zeroing into the work
completion with a more explicit field by field set.   With this patch,
non-ONLY/non-LAST packets will avoid the overhead since they will
not generate a completion.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c |   19 +++++++++++++------
 drivers/infiniband/hw/qib/qib_uc.c |   14 +++++++++++---
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index eca0c41..5c1c49b 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1955,8 +1955,6 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 		break;
 	}
 
-	memset(&wc, 0, sizeof wc);
-
 	if (qp->state == IB_QPS_RTR && !(qp->r_flags & QIB_R_COMM_EST)) {
 		qp->r_flags |= QIB_R_COMM_EST;
 		if (qp->ibqp.event_handler) {
@@ -2009,16 +2007,19 @@ send_middle:
 			goto rnr_nak;
 		qp->r_rcv_len = 0;
 		if (opcode == OP(SEND_ONLY))
-			goto send_last;
-		/* FALLTHROUGH */
+			goto no_immediate_data;
+		/* FALLTHROUGH for SEND_ONLY_WITH_IMMEDIATE */
 	case OP(SEND_LAST_WITH_IMMEDIATE):
 send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
 		hdrsize += 4;
 		wc.wc_flags = IB_WC_WITH_IMM;
-		/* FALLTHROUGH */
+		goto send_last;
 	case OP(SEND_LAST):
 	case OP(RDMA_WRITE_LAST):
+no_immediate_data:
+		wc.wc_flags = 0;
+		wc.ex.imm_data = 0;
 send_last:
 		/* Get the number of bytes the message was padded by. */
 		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
@@ -2051,6 +2052,12 @@ send_last:
 		wc.src_qp = qp->remote_qpn;
 		wc.slid = qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
+		/* zero fields that are N/A */
+		wc.vendor_err = 0;
+		wc.pkey_index = 0;
+		wc.dlid_path_bits = 0;
+		wc.port_num = 0;
+		wc.csum_ok = 0;
 		/* Signal completion event if the solicited bit is set. */
 		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &
@@ -2089,7 +2096,7 @@ send_last:
 		if (opcode == OP(RDMA_WRITE_FIRST))
 			goto send_middle;
 		else if (opcode == OP(RDMA_WRITE_ONLY))
-			goto send_last;
+			goto no_immediate_data;
 		ret = qib_get_rwqe(qp, 1);
 		if (ret < 0)
 			goto nack_op_err;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 32ccf3c..d31f33a 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -270,7 +270,6 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 
 	psn = be32_to_cpu(ohdr->bth[2]);
 	opcode >>= 24;
-	memset(&wc, 0, sizeof wc);
 
 	/* Compare the PSN verses the expected PSN. */
 	if (unlikely(qib_cmp24(psn, qp->r_psn) != 0)) {
@@ -370,7 +369,7 @@ send_first:
 		}
 		qp->r_rcv_len = 0;
 		if (opcode == OP(SEND_ONLY))
-			goto send_last;
+			goto no_immediate_data;
 		else if (opcode == OP(SEND_ONLY_WITH_IMMEDIATE))
 			goto send_last_imm;
 		/* FALLTHROUGH */
@@ -389,8 +388,11 @@ send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
 		hdrsize += 4;
 		wc.wc_flags = IB_WC_WITH_IMM;
-		/* FALLTHROUGH */
+		goto send_last;
 	case OP(SEND_LAST):
+no_immediate_data:
+		wc.ex.imm_data = 0;
+		wc.wc_flags = 0;
 send_last:
 		/* Get the number of bytes the message was padded by. */
 		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
@@ -418,6 +420,12 @@ last_imm:
 		wc.src_qp = qp->remote_qpn;
 		wc.slid = qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
+		/* zero fields that are N/A */
+		wc.vendor_err = 0;
+		wc.pkey_index = 0;
+		wc.dlid_path_bits = 0;
+		wc.port_num = 0;
+		wc.csum_ok = 0;
 		/* Signal completion event if the solicited bit is set. */
 		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
