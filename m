From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next v2 03/16] IB/hfi1: Remove dependence on
 qp->s_hdrwords
Date: Fri, 26 Jan 2018 13:29:13 -0800
Message-ID: <20180126212910.12097.70235.stgit@scvm10.sc.intel.com>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126211126.12097.47410.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The s_hdrwords variable was used to indicate whether a
packet was already built on a previous iteration of the
send engine. This variable assumed the protection of the
QP's RVT_S_BUSY flag, which was required since the the
QP's s_lock was dropped just prior to the packet being
queued on the one of the egress mechanisms.

Support for multiple send engine instantiations require
that the field not be used due to concurency issues.
The ps.txreq signals the "already built" without the
potential concurency issues.

Fix by getting rid of all s_hdrword usage.   A wrapper
is added to test for the already built case that used to
use s_hdrwords.

What used to be stored in s_hdrwords is now in the txreq.
The PBC is not counted, but is added in the pio/sdma code
paths prior to posting the packet.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/iowait.h      |    9 +++++++++
 drivers/infiniband/hw/hfi1/qp.c          |    4 +---
 drivers/infiniband/hw/hfi1/qp.h          |   13 +++++++++++++
 drivers/infiniband/hw/hfi1/rc.c          |   10 ++--------
 drivers/infiniband/hw/hfi1/ruc.c         |   23 +++++++++++------------
 drivers/infiniband/hw/hfi1/uc.c          |    6 +-----
 drivers/infiniband/hw/hfi1/ud.c          |   27 ++++++++++++---------------
 drivers/infiniband/hw/hfi1/verbs.c       |   10 +++++-----
 drivers/infiniband/hw/hfi1/verbs.h       |   11 -----------
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    7 +++++++
 10 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/iowait.h b/drivers/infiniband/hw/hfi1/iowait.h
index 591697d..3d9c32c 100644
--- a/drivers/infiniband/hw/hfi1/iowait.h
+++ b/drivers/infiniband/hw/hfi1/iowait.h
@@ -371,4 +371,13 @@ static inline void iowait_starve_find_max(struct iowait *w, u8 *max,
 	}
 }
 
+/**
+ * iowait_packet_queued() - determine if a packet is already built
+ * @wait: the wait structure
+ */
+static inline bool iowait_packet_queued(struct iowait *wait)
+{
+	return !list_empty(&wait->tx_head);
+}
+
 #endif
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 5507910..d30dd1a 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -565,7 +565,7 @@ void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 	if (qp->s_ack_queue)
 		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
 	seq_printf(s,
-		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d OS %x %x E %x %x %x RNR %d %s %d\n",
+		   "N %d %s QP %x R %u %s %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d OS %x %x E %x %x %x RNR %d %s %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -573,7 +573,6 @@ void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 		   qp_type_str[qp->ibqp.qp_type],
 		   qp->state,
 		   wqe ? wqe->wr.opcode : 0,
-		   qp->s_hdrwords,
 		   qp->s_flags,
 		   iowait_sdma_pending(&priv->s_iowait),
 		   iowait_pio_pending(&priv->s_iowait),
@@ -795,7 +794,6 @@ void notify_error_qp(struct rvt_qp *qp)
 	}
 
 	if (!(qp->s_flags & RVT_S_BUSY)) {
-		qp->s_hdrwords = 0;
 		if (qp->s_rdma_mr) {
 			rvt_put_mr(qp->s_rdma_mr);
 			qp->s_rdma_mr = NULL;
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index c06d2f8..b2d4cba 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -51,12 +51,25 @@
 #include <rdma/rdmavt_qp.h>
 #include "verbs.h"
 #include "sdma.h"
+#include "verbs_txreq.h"
 
 extern unsigned int hfi1_qp_table_size;
 
 extern const struct rvt_operation_params hfi1_post_parms[];
 
 /*
+ * Send if not busy or waiting for I/O and either
+ * a RC response is pending or we can process send work requests.
+ */
+static inline int hfi1_send_ok(struct rvt_qp *qp)
+{
+	return !(qp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT_IO)) &&
+		(verbs_txreq_queued(qp) ||
+		(qp->s_flags & RVT_S_RESP_PENDING) ||
+		 !(qp->s_flags & RVT_S_ANY_WAIT_SEND));
+}
+
+/*
  * free_ahg - clear ahg from QP
  */
 static inline void clear_ahg(struct rvt_qp *qp)
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 68d5c3c..524c12f 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -226,12 +226,10 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		bth2 = mask_psn(qp->s_ack_psn);
 	}
 	qp->s_rdma_ack_cnt++;
-	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
 	ps->s_txreq->s_cur_size = len;
+	ps->s_txreq->hdr_dwords = hwords;
 	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
-	/* pbc */
-	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 bail:
@@ -387,7 +385,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 						       : IB_WC_SUCCESS);
 				if (local_ops)
 					atomic_dec(&qp->local_ops_pending);
-				qp->s_hdrwords = 0;
 				goto done_free_tx;
 			}
 
@@ -690,7 +687,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		bth2 |= IB_BTH_REQ_ACK;
 	}
 	qp->s_len -= len;
-	qp->s_hdrwords = hwords;
+	ps->s_txreq->hdr_dwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
 	ps->s_txreq->ss = ss;
 	ps->s_txreq->s_cur_size = len;
@@ -701,8 +698,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		bth2,
 		middle,
 		ps);
-	/* pbc */
-	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 done_free_tx:
@@ -716,7 +711,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 bail_no_tx:
 	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	qp->s_hdrwords = 0;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 2c7fc6e..0cced9a 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -757,8 +757,9 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 	u32 slid;
 	u16 pkey = hfi1_get_pkey(ibp, qp->s_pkey_index);
 	u8 l4 = OPA_16B_L4_IB_LOCAL;
-	u8 extra_bytes = hfi1_get_16b_padding((qp->s_hdrwords << 2),
-				   ps->s_txreq->s_cur_size);
+	u8 extra_bytes = hfi1_get_16b_padding(
+				(ps->s_txreq->hdr_dwords << 2),
+				ps->s_txreq->s_cur_size);
 	u32 nwords = SIZE_OF_CRC + ((ps->s_txreq->s_cur_size +
 				 extra_bytes + SIZE_OF_LT) >> 2);
 	u8 becn = 0;
@@ -778,9 +779,9 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 			grd->sgid_index = 0;
 		grh = &ps->s_txreq->phdr.hdr.opah.u.l.grh;
 		l4 = OPA_16B_L4_IB_GLOBAL;
-		hdrwords = qp->s_hdrwords - 4;
-		qp->s_hdrwords += hfi1_make_grh(ibp, grh, grd,
-						hdrwords, nwords);
+		hdrwords = ps->s_txreq->hdr_dwords - 4;
+		ps->s_txreq->hdr_dwords += hfi1_make_grh(ibp, grh, grd,
+							 hdrwords, nwords);
 		middle = 0;
 	}
 
@@ -814,7 +815,7 @@ static inline void hfi1_make_ruc_header_16B(struct rvt_qp *qp,
 			  slid,
 			  opa_get_lid(rdma_ah_get_dlid(&qp->remote_ah_attr),
 				      16B),
-			  (qp->s_hdrwords + nwords) >> 1,
+			  (ps->s_txreq->hdr_dwords + nwords) >> 1,
 			  pkey, becn, 0, l4, priv->s_sc);
 }
 
@@ -834,10 +835,10 @@ static inline void hfi1_make_ruc_header_9B(struct rvt_qp *qp,
 
 	if (unlikely(rdma_ah_get_ah_flags(&qp->remote_ah_attr) & IB_AH_GRH)) {
 		struct ib_grh *grh = &ps->s_txreq->phdr.hdr.ibh.u.l.grh;
-		int hdrwords = qp->s_hdrwords - 2;
+		int hdrwords = ps->s_txreq->hdr_dwords - 2;
 
 		lrh0 = HFI1_LRH_GRH;
-		qp->s_hdrwords +=
+		ps->s_txreq->hdr_dwords +=
 			hfi1_make_grh(ibp, grh,
 				      rdma_ah_read_grh(&qp->remote_ah_attr),
 				      hdrwords, nwords);
@@ -866,7 +867,7 @@ static inline void hfi1_make_ruc_header_9B(struct rvt_qp *qp,
 	hfi1_make_ruc_bth(qp, ohdr, bth0, bth1, bth2);
 	hfi1_make_ib_hdr(&ps->s_txreq->phdr.hdr.ibh,
 			 lrh0,
-			 qp->s_hdrwords + nwords,
+			 ps->s_txreq->hdr_dwords + nwords,
 			 opa_get_lid(rdma_ah_get_dlid(&qp->remote_ah_attr), 9B),
 			 ppd_from_ibp(ibp)->lid |
 				rdma_ah_get_path_bits(&qp->remote_ah_attr));
@@ -1031,7 +1032,7 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 	ps.s_txreq = get_waiting_verbs_txreq(qp);
 	do {
 		/* Check for a constructed packet to be sent. */
-		if (qp->s_hdrwords != 0) {
+		if (ps.s_txreq) {
 			spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 			/*
 			 * If the packet cannot be sent now, return and
@@ -1039,8 +1040,6 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 			 */
 			if (hfi1_verbs_send(qp, &ps))
 				return;
-			/* Record that s_ahg is empty. */
-			qp->s_hdrwords = 0;
 			/* allow other tasks to run */
 			if (schedule_send_yield(qp, &ps))
 				return;
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 991bbee..fef69d9 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -146,7 +146,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 							: IB_WC_SUCCESS);
 			if (local_ops)
 				atomic_dec(&qp->local_ops_pending);
-			qp->s_hdrwords = 0;
 			goto done_free_tx;
 		}
 		/*
@@ -269,14 +268,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		break;
 	}
 	qp->s_len -= len;
-	qp->s_hdrwords = hwords;
+	ps->s_txreq->hdr_dwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
 	ps->s_txreq->ss = &qp->s_sge;
 	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
 			     mask_psn(qp->s_psn++), middle, ps);
-	/* pbc */
-	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 done_free_tx:
@@ -290,7 +287,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 bail_no_tx:
 	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	qp->s_hdrwords = 0;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index beb5091..6b5cd3a 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -340,15 +340,15 @@ void hfi1_make_ud_req_9B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	extra_bytes = -wqe->length & 3;
 	nwords = ((wqe->length + extra_bytes) >> 2) + SIZE_OF_CRC;
 	/* header size in dwords LRH+BTH+DETH = (8+12+8)/4. */
-	qp->s_hdrwords = 7;
+	ps->s_txreq->hdr_dwords = 7;
 	if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM)
-		qp->s_hdrwords++;
+		ps->s_txreq->hdr_dwords++;
 
 	if (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) {
 		grh = &ps->s_txreq->phdr.hdr.ibh.u.l.grh;
-		qp->s_hdrwords += hfi1_make_grh(ibp, grh,
-						rdma_ah_read_grh(ah_attr),
-						qp->s_hdrwords - 2, nwords);
+		ps->s_txreq->hdr_dwords +=
+			hfi1_make_grh(ibp, grh, rdma_ah_read_grh(ah_attr),
+				      ps->s_txreq->hdr_dwords - 2, nwords);
 		lrh0 = HFI1_LRH_GRH;
 		ohdr = &ps->s_txreq->phdr.hdr.ibh.u.l.oth;
 	} else {
@@ -381,7 +381,7 @@ void hfi1_make_ud_req_9B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		}
 	}
 	hfi1_make_bth_deth(qp, wqe, ohdr, &pkey, extra_bytes, false);
-	len = qp->s_hdrwords + nwords;
+	len = ps->s_txreq->hdr_dwords + nwords;
 
 	/* Setup the packet */
 	ps->s_txreq->phdr.hdr.hdr_type = HFI1_PKT_TYPE_9B;
@@ -405,12 +405,12 @@ void hfi1_make_ud_req_16B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	ppd = ppd_from_ibp(ibp);
 	ah_attr = &ibah_to_rvtah(wqe->ud_wr.ah)->attr;
 	/* header size in dwords 16B LRH+BTH+DETH = (16+12+8)/4. */
-	qp->s_hdrwords = 9;
+	ps->s_txreq->hdr_dwords = 9;
 	if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM)
-		qp->s_hdrwords++;
+		ps->s_txreq->hdr_dwords++;
 
 	/* SW provides space for CRC and LT for bypass packets. */
-	extra_bytes = hfi1_get_16b_padding((qp->s_hdrwords << 2),
+	extra_bytes = hfi1_get_16b_padding((ps->s_txreq->hdr_dwords << 2),
 					   wqe->length);
 	nwords = ((wqe->length + extra_bytes + SIZE_OF_LT) >> 2) + SIZE_OF_CRC;
 
@@ -428,8 +428,8 @@ void hfi1_make_ud_req_16B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			grd->sgid_index = 0;
 		}
 		grh = &ps->s_txreq->phdr.hdr.opah.u.l.grh;
-		qp->s_hdrwords += hfi1_make_grh(ibp, grh, grd,
-					qp->s_hdrwords - 4, nwords);
+		ps->s_txreq->hdr_dwords += hfi1_make_grh(ibp, grh, grd,
+					ps->s_txreq->hdr_dwords - 4, nwords);
 		ohdr = &ps->s_txreq->phdr.hdr.opah.u.l.oth;
 		l4 = OPA_16B_L4_IB_GLOBAL;
 	} else {
@@ -452,7 +452,7 @@ void hfi1_make_ud_req_16B(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 	hfi1_make_bth_deth(qp, wqe, ohdr, &pkey, extra_bytes, true);
 	/* Convert dwords to flits */
-	len = (qp->s_hdrwords + nwords) >> 1;
+	len = (ps->s_txreq->hdr_dwords + nwords) >> 1;
 
 	/* Setup the packet */
 	ps->s_txreq->phdr.hdr.hdr_type = HFI1_PKT_TYPE_16B;
@@ -564,8 +564,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	priv->s_ahg->ahgcount = 0;
 	priv->s_ahg->ahgidx = 0;
 	priv->s_ahg->tx_flags = 0;
-	/* pbc */
-	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 
 	return 1;
 
@@ -580,7 +578,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 bail_no_tx:
 	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	qp->s_hdrwords = 0;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index b8776a3..471d55c 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -835,7 +835,7 @@ static int build_verbs_tx_desc(
 {
 	int ret = 0;
 	struct hfi1_sdma_header *phdr = &tx->phdr;
-	u16 hdrbytes = tx->hdr_dwords << 2;
+	u16 hdrbytes = (tx->hdr_dwords + sizeof(pbc) / 4) << 2;
 	u8 extra_bytes = 0;
 
 	if (tx->phdr.hdr.hdr_type) {
@@ -901,7 +901,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ahg_info *ahg_info = priv->s_ahg;
-	u32 hdrwords = qp->s_hdrwords;
+	u32 hdrwords = ps->s_txreq->hdr_dwords;
 	u32 len = ps->s_txreq->s_cur_size;
 	u32 plen;
 	struct hfi1_ibdev *dev = ps->dev;
@@ -919,7 +919,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	} else {
 		dwords = (len + 3) >> 2;
 	}
-	plen = hdrwords + dwords + 2;
+	plen = hdrwords + dwords + sizeof(pbc) / 4;
 
 	tx = ps->s_txreq;
 	if (!sdma_txreq_built(&tx->txreq)) {
@@ -1038,7 +1038,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	u32 hdrwords = qp->s_hdrwords;
+	u32 hdrwords = ps->s_txreq->hdr_dwords;
 	struct rvt_sge_state *ss = ps->s_txreq->ss;
 	u32 len = ps->s_txreq->s_cur_size;
 	u32 dwords;
@@ -1064,7 +1064,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		dwords = (len + 3) >> 2;
 		hdr = (u32 *)&ps->s_txreq->phdr.hdr.ibh;
 	}
-	plen = hdrwords + dwords + 2;
+	plen = hdrwords + dwords + sizeof(pbc) / 4;
 
 	/* only RC/UC use complete */
 	switch (qp->ibqp.qp_type) {
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 87d1285..c2aeb32 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -246,17 +246,6 @@ struct hfi1_ibdev {
 }
 
 /*
- * Send if not busy or waiting for I/O and either
- * a RC response is pending or we can process send work requests.
- */
-static inline int hfi1_send_ok(struct rvt_qp *qp)
-{
-	return !(qp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT_IO)) &&
-		(qp->s_hdrwords || (qp->s_flags & RVT_S_RESP_PENDING) ||
-		 !(qp->s_flags & RVT_S_ANY_WAIT_SEND));
-}
-
-/*
  * This must be called with s_lock held.
  */
 void hfi1_bad_pkey(struct hfi1_ibport *ibp, u32 key, u32 sl,
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index cec7a4b..729244c 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -113,6 +113,13 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	return NULL;
 }
 
+static inline bool verbs_txreq_queued(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	return iowait_packet_queued(&priv->s_iowait);
+}
+
 void hfi1_put_txreq(struct verbs_txreq *tx);
 int verbs_txreq_init(struct hfi1_ibdev *dev);
 void verbs_txreq_exit(struct hfi1_ibdev *dev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
