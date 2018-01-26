From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/16] IB/hfi1: Look up ibport using a pointer in
 receive path
Date: Fri, 26 Jan 2018 06:32:46 -0800
Message-ID: <20180126143243.6868.38566.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In the receive path, hfi1_ibport is looked up by indexing into an
array. A profile shows this to be expensive. The receive context
data has a pointer to the ibport data, use that pointer instead.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   14 ++++++++------
 drivers/infiniband/hw/hfi1/rc.c     |   36 ++++++++++++++++++++---------------
 drivers/infiniband/hw/hfi1/verbs.h  |    3 +--
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 7ef8634..bdae9fb 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -634,9 +634,10 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 	}
 }
 
-static void process_rcv_qp_work(struct hfi1_ctxtdata *rcd)
+static void process_rcv_qp_work(struct hfi1_packet *packet)
 {
 	struct rvt_qp *qp, *nqp;
+	struct hfi1_ctxtdata *rcd = packet->rcd;
 
 	/*
 	 * Iterate over all QPs waiting to respond.
@@ -646,7 +647,8 @@ static void process_rcv_qp_work(struct hfi1_ctxtdata *rcd)
 		list_del_init(&qp->rspwait);
 		if (qp->r_flags & RVT_R_RSP_NAK) {
 			qp->r_flags &= ~RVT_R_RSP_NAK;
-			hfi1_send_rc_ack(rcd, qp, 0);
+			packet->qp = qp;
+			hfi1_send_rc_ack(packet, 0);
 		}
 		if (qp->r_flags & RVT_R_RSP_SEND) {
 			unsigned long flags;
@@ -667,7 +669,7 @@ static noinline int max_packet_exceeded(struct hfi1_packet *packet, int thread)
 	if (thread) {
 		if ((packet->numpkt & (MAX_PKT_RECV_THREAD - 1)) == 0)
 			/* allow defered processing */
-			process_rcv_qp_work(packet->rcd);
+			process_rcv_qp_work(packet);
 		cond_resched();
 		return RCV_PKT_OK;
 	} else {
@@ -809,7 +811,7 @@ int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
-	process_rcv_qp_work(rcd);
+	process_rcv_qp_work(&packet);
 	rcd->head = packet.rhqoff;
 bail:
 	finish_packet(&packet);
@@ -838,7 +840,7 @@ int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
-	process_rcv_qp_work(rcd);
+	process_rcv_qp_work(&packet);
 	rcd->head = packet.rhqoff;
 bail:
 	finish_packet(&packet);
@@ -1068,7 +1070,7 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 		process_rcv_update(last, &packet);
 	}
 
-	process_rcv_qp_work(rcd);
+	process_rcv_qp_work(&packet);
 	rcd->head = packet.rhqoff;
 
 bail:
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 70aa82b..daf50cc 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -730,14 +730,16 @@ static inline void hfi1_make_bth_aeth(struct rvt_qp *qp,
 	ohdr->bth[2] = cpu_to_be32(mask_psn(qp->r_ack_psn));
 }
 
-static inline void hfi1_queue_rc_ack(struct rvt_qp *qp, bool is_fecn)
+static inline void hfi1_queue_rc_ack(struct hfi1_packet *packet, bool is_fecn)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct rvt_qp *qp = packet->qp;
+	struct hfi1_ibport *ibp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto unlock;
+	ibp = rcd_to_iport(packet->rcd);
 	this_cpu_inc(*ibp->rvp.rc_qacks);
 	qp->s_flags |= RVT_S_ACK_PENDING | RVT_S_RESP_PENDING;
 	qp->s_nak_state = qp->r_nak_state;
@@ -751,13 +753,14 @@ static inline void hfi1_queue_rc_ack(struct rvt_qp *qp, bool is_fecn)
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
-static inline void hfi1_make_rc_ack_9B(struct rvt_qp *qp,
+static inline void hfi1_make_rc_ack_9B(struct hfi1_packet *packet,
 				       struct hfi1_opa_header *opa_hdr,
 				       u8 sc5, bool is_fecn,
 				       u64 *pbc_flags, u32 *hwords,
 				       u32 *nwords)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct rvt_qp *qp = packet->qp;
+	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct ib_header *hdr = &opa_hdr->ibh;
 	struct ib_other_headers *ohdr;
@@ -798,13 +801,14 @@ static inline void hfi1_make_rc_ack_9B(struct rvt_qp *qp,
 	hfi1_make_bth_aeth(qp, ohdr, bth0, bth1);
 }
 
-static inline void hfi1_make_rc_ack_16B(struct rvt_qp *qp,
+static inline void hfi1_make_rc_ack_16B(struct hfi1_packet *packet,
 					struct hfi1_opa_header *opa_hdr,
 					u8 sc5, bool is_fecn,
 					u64 *pbc_flags, u32 *hwords,
 					u32 *nwords)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct rvt_qp *qp = packet->qp;
+	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_16b_header *hdr = &opa_hdr->opah;
 	struct ib_other_headers *ohdr;
@@ -850,7 +854,7 @@ static inline void hfi1_make_rc_ack_16B(struct rvt_qp *qp,
 	hfi1_make_bth_aeth(qp, ohdr, bth0, bth1);
 }
 
-typedef void (*hfi1_make_rc_ack)(struct rvt_qp *qp,
+typedef void (*hfi1_make_rc_ack)(struct hfi1_packet *packet,
 				 struct hfi1_opa_header *opa_hdr,
 				 u8 sc5, bool is_fecn,
 				 u64 *pbc_flags, u32 *hwords,
@@ -870,9 +874,10 @@ typedef void (*hfi1_make_rc_ack)(struct rvt_qp *qp,
  * Note that RDMA reads and atomics are handled in the
  * send side QP state and send engine.
  */
-void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd,
-		      struct rvt_qp *qp, bool is_fecn)
+void hfi1_send_rc_ack(struct hfi1_packet *packet, bool is_fecn)
 {
+	struct hfi1_ctxtdata *rcd = packet->rcd;
+	struct rvt_qp *qp = packet->qp;
 	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -889,14 +894,14 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd,
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
 	if (qp->s_flags & RVT_S_RESP_PENDING) {
-		hfi1_queue_rc_ack(qp, is_fecn);
+		hfi1_queue_rc_ack(packet, is_fecn);
 		return;
 	}
 
 	/* Ensure s_rdma_ack_cnt changes are committed */
 	smp_read_barrier_depends();
 	if (qp->s_rdma_ack_cnt) {
-		hfi1_queue_rc_ack(qp, is_fecn);
+		hfi1_queue_rc_ack(packet, is_fecn);
 		return;
 	}
 
@@ -905,7 +910,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd,
 		return;
 
 	/* Make the appropriate header */
-	hfi1_make_rc_ack_tbl[priv->hdr_type](qp, &opa_hdr, sc5, is_fecn,
+	hfi1_make_rc_ack_tbl[priv->hdr_type](packet, &opa_hdr, sc5, is_fecn,
 					     &pbc_flags, &hwords, &nwords);
 
 	plen = 2 /* PBC */ + hwords + nwords;
@@ -919,7 +924,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd,
 		 * so that when enough buffer space becomes available,
 		 * the ACK is sent ahead of other outgoing packets.
 		 */
-		hfi1_queue_rc_ack(qp, is_fecn);
+		hfi1_queue_rc_ack(packet, is_fecn);
 		return;
 	}
 	trace_ack_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
@@ -1537,7 +1542,7 @@ static void rc_rcv_resp(struct hfi1_packet *packet)
 	void *data = packet->payload;
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_ibport *ibp;
 	struct ib_other_headers *ohdr = packet->ohdr;
 	struct rvt_swqe *wqe;
 	enum ib_wc_status status;
@@ -1695,6 +1700,7 @@ static void rc_rcv_resp(struct hfi1_packet *packet)
 	goto ack_err;
 
 ack_seq_err:
+	ibp = rcd_to_iport(rcd);
 	rdma_seq_err(qp, ibp, psn, rcd);
 	goto ack_done;
 
@@ -2476,7 +2482,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 send_ack:
-	hfi1_send_rc_ack(rcd, qp, is_fecn);
+	hfi1_send_rc_ack(packet, is_fecn);
 }
 
 void hfi1_rc_hdrerr(
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 90a170e..ec26ed2 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -363,8 +363,7 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status);
 
-void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
-		      bool is_fecn);
+void hfi1_send_rc_ack(struct hfi1_packet *packet, bool is_fecn);
 
 int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
