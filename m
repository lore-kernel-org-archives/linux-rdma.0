From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/24] IB/qib: Issue pre-emptive NAKs on eager buffer overflow
Date: Tue, 28 Dec 2010 10:28:39 -0500
Message-ID: <20101228152839.19960.42620.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Under congestion resulting in eager buffer overflow attempt to send
pre-emptive NAKs if header queue entries with TID errors are generated and
a valid header is present. This prevents long timeouts and flow restarts if
a trailing set of packets are dropped due to eager overflows. Pre-emptive
NAKs are currently only supported for RDMA Writes.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |  141 +++++++++++++++++++++++++++++++-
 1 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 816a6bd..23e584f 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -289,14 +289,147 @@ static inline void *qib_get_egrbuf(const struct qib_ctxtdata *rcd, u32 etail)
  * Returns 1 if error was a CRC, else 0.
  * Needed for some chip's synthesized error counters.
  */
-static u32 qib_rcv_hdrerr(struct qib_pportdata *ppd, u32 ctxt,
-			  u32 eflags, u32 l, u32 etail, __le32 *rhf_addr,
-			  struct qib_message_header *hdr)
+static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
+			  u32 ctxt, u32 eflags, u32 l, u32 etail,
+			  __le32 *rhf_addr, struct qib_message_header *rhdr)
 {
 	u32 ret = 0;
 
 	if (eflags & (QLOGIC_IB_RHF_H_ICRCERR | QLOGIC_IB_RHF_H_VCRCERR))
 		ret = 1;
+	else if (eflags == QLOGIC_IB_RHF_H_TIDERR) {
+		/* For TIDERR and RC QPs premptively schedule a NAK */
+		struct qib_ib_header *hdr = (struct qib_ib_header *) rhdr;
+		struct qib_other_headers *ohdr = NULL;
+		struct qib_ibport *ibp = &ppd->ibport_data;
+		struct qib_qp *qp = NULL;
+		u32 tlen = qib_hdrget_length_in_bytes(rhf_addr);
+		u16 lid  = be16_to_cpu(hdr->lrh[1]);
+		int lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+		u32 qp_num;
+		u32 opcode;
+		u32 psn;
+		int diff;
+		unsigned long flags;
+
+		/* Sanity check packet */
+		if (tlen < 24)
+			goto drop;
+
+		if (lid < QIB_MULTICAST_LID_BASE) {
+			lid &= ~((1 << ppd->lmc) - 1);
+			if (unlikely(lid != ppd->lid))
+				goto drop;
+		}
+
+		/* Check for GRH */
+		if (lnh == QIB_LRH_BTH)
+			ohdr = &hdr->u.oth;
+		else if (lnh == QIB_LRH_GRH) {
+			u32 vtf;
+
+			ohdr = &hdr->u.l.oth;
+			if (hdr->u.l.grh.next_hdr != IB_GRH_NEXT_HDR)
+				goto drop;
+			vtf = be32_to_cpu(hdr->u.l.grh.version_tclass_flow);
+			if ((vtf >> IB_GRH_VERSION_SHIFT) != IB_GRH_VERSION)
+				goto drop;
+		} else
+			goto drop;
+
+		/* Get opcode and PSN from packet */
+		opcode = be32_to_cpu(ohdr->bth[0]);
+		opcode >>= 24;
+		psn = be32_to_cpu(ohdr->bth[2]);
+
+		/* Get the destination QP number. */
+		qp_num = be32_to_cpu(ohdr->bth[1]) & QIB_QPN_MASK;
+		if (qp_num != QIB_MULTICAST_QPN) {
+			int ruc_res;
+			qp = qib_lookup_qpn(ibp, qp_num);
+			if (!qp)
+				goto drop;
+
+			/*
+			 * Handle only RC QPs - for other QP types drop error
+			 * packet.
+			 */
+			spin_lock(&qp->r_lock);
+
+			/* Check for valid receive state. */
+			if (!(ib_qib_state_ops[qp->state] &
+			      QIB_PROCESS_RECV_OK)) {
+				ibp->n_pkt_drops++;
+				goto unlock;
+			}
+
+			switch (qp->ibqp.qp_type) {
+			case IB_QPT_RC:
+				spin_lock_irqsave(&qp->s_lock, flags);
+				ruc_res =
+					qib_ruc_check_hdr(
+						ibp, hdr,
+						lnh == QIB_LRH_GRH,
+						qp,
+						be32_to_cpu(ohdr->bth[0]));
+				if (ruc_res) {
+					spin_unlock_irqrestore(&qp->s_lock,
+							       flags);
+					goto unlock;
+				}
+				spin_unlock_irqrestore(&qp->s_lock, flags);
+
+				/* Only deal with RDMA Writes for now */
+				if (opcode <
+				    IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST) {
+					diff = qib_cmp24(psn, qp->r_psn);
+					if (!qp->r_nak_state && diff >= 0) {
+						ibp->n_rc_seqnak++;
+						qp->r_nak_state =
+							IB_NAK_PSN_ERROR;
+						/* Use the expected PSN. */
+						qp->r_ack_psn = qp->r_psn;
+						/*
+						 * Wait to send the sequence
+						 * NAK until all packets
+						 * in the receive queue have
+						 * been processed.
+						 * Otherwise, we end up
+						 * propagating congestion.
+						 */
+						if (list_empty(&qp->rspwait)) {
+							qp->r_flags |=
+								QIB_R_RSP_NAK;
+							atomic_inc(
+								&qp->refcount);
+							list_add_tail(
+							 &qp->rspwait,
+							 &rcd->qp_wait_list);
+						}
+					} /* Out of sequence NAK */
+				} /* QP Request NAKs */
+				break;
+			case IB_QPT_SMI:
+			case IB_QPT_GSI:
+			case IB_QPT_UD:
+			case IB_QPT_UC:
+			default:
+				/* For now don't handle any other QP types */
+				break;
+			}
+
+unlock:
+			spin_unlock(&qp->r_lock);
+			/*
+			 * Notify qib_destroy_qp() if it is waiting
+			 * for us to finish.
+			 */
+			if (atomic_dec_and_test(&qp->refcount))
+				wake_up(&qp->wait);
+		} /* Unicast QP */
+	} /* Valid packet with TIDErr */
+
+drop:
 	return ret;
 }
 
@@ -376,7 +509,7 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 		 * packets; only qibhdrerr should be set.
 		 */
 		if (unlikely(eflags))
-			crcs += qib_rcv_hdrerr(ppd, rcd->ctxt, eflags, l,
+			crcs += qib_rcv_hdrerr(rcd, ppd, rcd->ctxt, eflags, l,
 					       etail, rhf_addr, hdr);
 		else if (etype == RCVHQ_RCV_TYPE_NON_KD) {
 			qib_ib_rcv(rcd, hdr, ebuf, tlen);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
