From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] IB/hfi1: Fix adaptive pio packet corruption
Date: Mon, 07 Mar 2016 11:35:41 -0800
Message-ID: <20160307193540.4913.80363.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The adaptive pio heuristic missed a case that causes a corrupted
packet on the wire.

The case is if SDMA egress had been chosen for a pio-able packet and
then encountered a ring space wait, the packet is queued.   The sge
cursor had been incremented as part of the packet build out for SDMA.

After the send engine restart, the heuristic might now chose pio based
on the sdma count being zero and start the mmio copy using the already
incremented sge cursor.

Fix this by forcing SDMA egress when the SDMA descriptor has already
been built.

Additionally, the code to wait for a QPs pio count to zero when
switching to SDMA was missing.  Add it.

There is also an issue with UD QPs, in that the different SLs can pick
a different egress send context.  For now, just insure the UD/GSI
always go through SDMA.

Reviewed-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 7acaa25..62755af 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1179,10 +1179,11 @@ bad:
  * and size
  */
 static inline send_routine get_send_routine(struct rvt_qp *qp,
-					    struct hfi1_ib_header *h)
+					    struct verbs_txreq *tx)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
+	struct hfi1_ib_header *h = &tx->phdr.hdr;
 
 	if (unlikely(!(dd->flags & HFI1_HAS_SEND_DMA)))
 		return dd->process_pio_send;
@@ -1191,21 +1192,21 @@ static inline send_routine get_send_routine(struct rvt_qp *qp,
 		return dd->process_pio_send;
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
-		if (piothreshold && qp->s_cur_size <= piothreshold)
-			return dd->process_pio_send;
 		break;
 	case IB_QPT_RC:
 		if (piothreshold &&
 		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
 		    (BIT(get_opcode(h) & 0x1f) & rc_only_opcode) &&
-		    iowait_sdma_pending(&priv->s_iowait) == 0)
+		    iowait_sdma_pending(&priv->s_iowait) == 0 &&
+		    !sdma_txreq_built(&tx->txreq))
 			return dd->process_pio_send;
 		break;
 	case IB_QPT_UC:
 		if (piothreshold &&
 		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
 		    (BIT(get_opcode(h) & 0x1f) & uc_only_opcode) &&
-		    iowait_sdma_pending(&priv->s_iowait) == 0)
+		    iowait_sdma_pending(&priv->s_iowait) == 0 &&
+		    !sdma_txreq_built(&tx->txreq))
 			return dd->process_pio_send;
 		break;
 	default:
@@ -1225,10 +1226,11 @@ static inline send_routine get_send_routine(struct rvt_qp *qp,
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+	struct hfi1_qp_priv *priv = qp->priv;
 	send_routine sr;
 	int ret;
 
-	sr = get_send_routine(qp, &ps->s_txreq->phdr.hdr);
+	sr = get_send_routine(qp, ps->s_txreq);
 	ret = egress_pkey_check(dd->pport, &ps->s_txreq->phdr.hdr, qp);
 	if (unlikely(ret)) {
 		/*
@@ -1250,6 +1252,11 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		}
 		return -EINVAL;
 	}
+	if (sr == dd->process_dma_send && iowait_pio_pending(&priv->s_iowait))
+		return pio_wait(qp,
+				ps->s_txreq->psc,
+				ps,
+				RVT_S_WAIT_PIO_DRAIN);
 	return sr(qp, ps, 0);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
