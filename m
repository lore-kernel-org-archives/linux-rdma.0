From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/23] IB/hfi1: Remove usage of qp->s_cur_sge
Date: Wed, 07 Dec 2016 19:33:27 -0800
Message-ID: <20161208033325.21135.52785.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The s_cur_sge field in the qp structure holds a pointer to the
SGE of the currently processed WQE. It assumes the protection
of the RVT_S_BUSY flag to prevent the changing of this field
while the send engine is using it. This scheme works as long
as there is only one instance of the send engine running at a
time.

Scaling of the send engine to multiple cores would break this
assumption as there could be multiple instances of the send engine
running on different CPUs. This opens a window where the QP's
RVT_S_BUSY flag is not set but the send engine is still running.

To prevent accidental changing of the s_cur_sge pointer, the QP's
dependence on it is removed. The SGE pointer is now stored in the
verbs_txreq, which is a per-packet data structure. This ensures
that each individual packet has it's own pointer, which is setup
while the RVT_S_BUSY flag is set.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |   10 +++++-----
 drivers/infiniband/hw/hfi1/uc.c    |    2 +-
 drivers/infiniband/hw/hfi1/ud.c    |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c |   14 ++++++--------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 1fe996c..3a31ed7 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -276,7 +276,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 				rvt_get_mr(ps->s_txreq->mr);
 			qp->s_ack_rdma_sge.sge = e->rdma_sge;
 			qp->s_ack_rdma_sge.num_sge = 1;
-			qp->s_cur_sge = &qp->s_ack_rdma_sge;
+			ps->s_txreq->ss = &qp->s_ack_rdma_sge;
 			if (len > pmtu) {
 				len = pmtu;
 				qp->s_ack_state = OP(RDMA_READ_RESPONSE_FIRST);
@@ -290,7 +290,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 			bth2 = mask_psn(qp->s_ack_rdma_psn++);
 		} else {
 			/* COMPARE_SWAP or FETCH_ADD */
-			qp->s_cur_sge = NULL;
+			ps->s_txreq->ss = NULL;
 			len = 0;
 			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
 			ohdr->u.at.aeth = hfi1_compute_aeth(qp);
@@ -306,7 +306,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		qp->s_ack_state = OP(RDMA_READ_RESPONSE_MIDDLE);
 		/* FALLTHROUGH */
 	case OP(RDMA_READ_RESPONSE_MIDDLE):
-		qp->s_cur_sge = &qp->s_ack_rdma_sge;
+		ps->s_txreq->ss = &qp->s_ack_rdma_sge;
 		ps->s_txreq->mr = qp->s_ack_rdma_sge.sge.mr;
 		if (ps->s_txreq->mr)
 			rvt_get_mr(ps->s_txreq->mr);
@@ -335,7 +335,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		 */
 		qp->s_ack_state = OP(SEND_ONLY);
 		qp->s_flags &= ~RVT_S_ACK_PENDING;
-		qp->s_cur_sge = NULL;
+		ps->s_txreq->ss = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
 				cpu_to_be32((qp->r_msn & HFI1_MSN_MASK) |
@@ -801,7 +801,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
-	qp->s_cur_sge = ss;
+	ps->s_txreq->ss = ss;
 	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(
 		qp,
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index d062c35..b141a78 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -258,7 +258,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
-	qp->s_cur_sge = &qp->s_sge;
+	ps->s_txreq->ss = &qp->s_sge;
 	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
 			     mask_psn(qp->s_psn++), middle, ps);
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index d742ac1..c071955 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -355,7 +355,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	/* header size in 32-bit words LRH+BTH+DETH = (8+12+8)/4. */
 	qp->s_hdrwords = 7;
 	ps->s_txreq->s_cur_size = wqe->length;
-	qp->s_cur_sge = &qp->s_sge;
+	ps->s_txreq->ss = &qp->s_sge;
 	qp->s_srate = ah_attr->static_rate;
 	qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
 	qp->s_wqe = wqe;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 65f2f1d..3b7bfd8 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -790,10 +790,10 @@ static int wait_kmem(struct hfi1_ibdev *dev,
  */
 static noinline int build_verbs_ulp_payload(
 	struct sdma_engine *sde,
-	struct rvt_sge_state *ss,
 	u32 length,
 	struct verbs_txreq *tx)
 {
+	struct rvt_sge_state *ss = tx->ss;
 	struct rvt_sge *sg_list = ss->sg_list;
 	struct rvt_sge sge = ss->sge;
 	u8 num_sge = ss->num_sge;
@@ -837,7 +837,6 @@ static noinline int build_verbs_ulp_payload(
 /* New API */
 static int build_verbs_tx_desc(
 	struct sdma_engine *sde,
-	struct rvt_sge_state *ss,
 	u32 length,
 	struct verbs_txreq *tx,
 	struct hfi1_ahg_info *ahg_info,
@@ -881,9 +880,9 @@ static int build_verbs_tx_desc(
 			goto bail_txadd;
 	}
 
-	/* add the ulp payload - if any.  ss can be NULL for acks */
-	if (ss)
-		ret = build_verbs_ulp_payload(sde, ss, length, tx);
+	/* add the ulp payload - if any. tx->ss can be NULL for acks */
+	if (tx->ss)
+		ret = build_verbs_ulp_payload(sde, length, tx);
 bail_txadd:
 	return ret;
 }
@@ -894,7 +893,6 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ahg_info *ahg_info = priv->s_ahg;
 	u32 hdrwords = qp->s_hdrwords;
-	struct rvt_sge_state *ss = qp->s_cur_sge;
 	u32 len = ps->s_txreq->s_cur_size;
 	u32 plen = hdrwords + ((len + 3) >> 2) + 2; /* includes pbc */
 	struct hfi1_ibdev *dev = ps->dev;
@@ -920,7 +918,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 					 plen);
 		}
 		tx->wqe = qp->s_wqe;
-		ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahg_info, pbc);
+		ret = build_verbs_tx_desc(tx->sde, len, tx, ahg_info, pbc);
 		if (unlikely(ret))
 			goto bail_build;
 	}
@@ -1011,7 +1009,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	u32 hdrwords = qp->s_hdrwords;
-	struct rvt_sge_state *ss = qp->s_cur_sge;
+	struct rvt_sge_state *ss = ps->s_txreq->ss;
 	u32 len = ps->s_txreq->s_cur_size;
 	u32 dwords = (len + 3) >> 2;
 	u32 plen = hdrwords + dwords + 2; /* includes pbc */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
