From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/16] staging/rdma/hfi1: Remove header memcpy from sdma
 send path.
Date: Sun, 14 Feb 2016 12:44:43 -0800
Message-ID: <20160214204440.29247.24773.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of writing the header into a buffer then copying it into another
buffer to be sent, remove that memcpy and instead build the header directly
into the tx request that will be sent.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c        |   20 ++++++----
 drivers/staging/rdma/hfi1/rc.c          |   42 ++++++++++++++-------
 drivers/staging/rdma/hfi1/ruc.c         |   22 ++++++-----
 drivers/staging/rdma/hfi1/uc.c          |   30 ++++++++++-----
 drivers/staging/rdma/hfi1/ud.c          |   56 ++++++++++++++++++----------
 drivers/staging/rdma/hfi1/verbs.c       |   63 ++++++++++++++-----------------
 drivers/staging/rdma/hfi1/verbs.h       |   18 +++------
 drivers/staging/rdma/hfi1/verbs_txreq.h |    1 
 8 files changed, 148 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index bfce812..9523dc1 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -70,6 +70,7 @@
 #include "hfi.h"
 #include "device.h"
 #include "common.h"
+#include "verbs_txreq.h"
 #include "trace.h"
 
 #undef pr_fmt
@@ -1682,8 +1683,6 @@ int snoop_send_dma_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			   u64 pbc)
 {
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct ahg_ib_header *ahdr = priv->s_hdr;
 	u32 hdrwords = qp->s_hdrwords;
 	struct rvt_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
@@ -1691,7 +1690,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	u32 plen = hdrwords + dwords + 2; /* includes pbc */
 	struct hfi1_pportdata *ppd = ps->ppd;
 	struct snoop_packet *s_packet = NULL;
-	u32 *hdr = (u32 *)&ahdr->ibh;
+	u32 *hdr = (u32 *)&ps->s_txreq->phdr.hdr;
 	u32 length = 0;
 	struct rvt_sge_state temp_ss;
 	void *data = NULL;
@@ -1702,7 +1701,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct capture_md md;
 	u32 vl;
 	u32 hdr_len = hdrwords << 2;
-	u32 tlen = HFI1_GET_PKT_LEN(&ahdr->ibh);
+	u32 tlen = HFI1_GET_PKT_LEN(&ps->s_txreq->phdr.hdr);
 
 	md.u.pbc = 0;
 
@@ -1729,7 +1728,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		md.port = 1;
 		md.dir = PKT_DIR_EGRESS;
 		if (likely(pbc == 0)) {
-			vl = be16_to_cpu(ahdr->ibh.lrh[0]) >> 12;
+			vl = be16_to_cpu(ps->s_txreq->phdr.hdr.lrh[0]) >> 12;
 			md.u.pbc = create_pbc(ppd, 0, qp->s_srate, vl, plen);
 		} else {
 			md.u.pbc = 0;
@@ -1791,7 +1790,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		ret = HFI1_FILTER_HIT;
 	} else {
 		ret = ppd->dd->hfi1_snoop.filter_callback(
-					&ahdr->ibh,
+					&ps->s_txreq->phdr.hdr,
 					NULL,
 					ppd->dd->hfi1_snoop.filter_value);
 	}
@@ -1823,9 +1822,16 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 				spin_unlock_irqrestore(&qp->s_lock, flags);
 			} else if (qp->ibqp.qp_type == IB_QPT_RC) {
 				spin_lock_irqsave(&qp->s_lock, flags);
-				hfi1_rc_send_complete(qp, &ahdr->ibh);
+				hfi1_rc_send_complete(qp,
+						      &ps->s_txreq->phdr.hdr);
 				spin_unlock_irqrestore(&qp->s_lock, flags);
 			}
+
+			/*
+			 * If snoop is dropping the packet we need to put the
+			 * txreq back because no one else will.
+			 */
+			hfi1_put_txreq(ps->s_txreq);
 			return 0;
 		}
 		break;
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index a62c942..75d70d5 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -54,7 +54,7 @@
 
 #include "hfi.h"
 #include "qp.h"
-#include "sdma.h"
+#include "verbs_txreq.h"
 #include "trace.h"
 
 /* cut down ridiculously long IB macro names */
@@ -201,13 +201,15 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
  * @qp: a pointer to the QP
  * @ohdr: a pointer to the IB header being constructed
  * @pmtu: the path MTU
+ * @ps: the xmit packet state
  *
  * Return 1 if constructed; otherwise, return 0.
  * Note that we are in the responder's side of the QP context.
  * Note the QP s_lock must be held.
  */
 static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
-		       struct hfi1_other_headers *ohdr, u32 pmtu)
+		       struct hfi1_other_headers *ohdr, u32 pmtu,
+		       struct hfi1_pkt_state *ps)
 {
 	struct rvt_ack_entry *e;
 	u32 hwords;
@@ -347,7 +349,7 @@ normal:
 	qp->s_rdma_ack_cnt++;
 	qp->s_hdrwords = hwords;
 	qp->s_cur_size = len;
-	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle);
+	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
 	return 1;
 
 bail:
@@ -371,7 +373,7 @@ bail:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_rc_req(struct rvt_qp *qp)
+int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
@@ -385,18 +387,21 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	u32 bth2;
 	u32 pmtu = qp->pmtu;
 	char newreq;
-	int ret = 0;
 	int middle = 0;
 	int delta;
 
-	ohdr = &priv->s_hdr->ibh.u.oth;
+	ps->s_txreq = get_txreq(ps->dev, qp);
+	if (IS_ERR(ps->s_txreq))
+		goto bail_no_tx;
+
+	ohdr = &ps->s_txreq->phdr.hdr.u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &priv->s_hdr->ibh.u.l.oth;
+		ohdr = &ps->s_txreq->phdr.hdr.u.l.oth;
 
 	/* Sending responses has higher priority over sending requests. */
 	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
-	    make_rc_ack(dev, qp, ohdr, pmtu))
-		goto done;
+	    make_rc_ack(dev, qp, ohdr, pmtu, ps))
+		return 1;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
@@ -415,7 +420,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		hfi1_send_complete(qp, wqe, qp->s_last != qp->s_acked ?
 			IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR);
 		/* will get called again */
-		goto done;
+		goto done_free_tx;
 	}
 
 	if (qp->s_flags & (RVT_S_WAIT_RNR | RVT_S_WAIT_ACK))
@@ -752,12 +757,23 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		ohdr,
 		bth0 | (qp->s_state << 24),
 		bth2,
-		middle);
-done:
+		middle,
+		ps);
 	return 1;
+
+done_free_tx:
+	hfi1_put_txreq(ps->s_txreq);
+	ps->s_txreq = NULL;
+	return 1;
+
 bail:
+	hfi1_put_txreq(ps->s_txreq);
+
+bail_no_tx:
+	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	return ret;
+	qp->s_hdrwords = 0;
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 7c6feff..70d1d34 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -54,6 +54,7 @@
 #include "mad.h"
 #include "qp.h"
 #include "verbs_txreq.h"
+#include "trace.h"
 
 /*
  * Convert the AETH RNR timeout code into the number of microseconds.
@@ -698,6 +699,7 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
+
 	if (unlikely(qp->s_flags & RVT_S_AHG_CLEAR))
 		clear_ahg(qp);
 	if (!(qp->s_flags & RVT_S_AHG_VALID)) {
@@ -740,10 +742,11 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 }
 
 void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
-			  u32 bth0, u32 bth2, int middle)
+			  u32 bth0, u32 bth2, int middle,
+			  struct hfi1_pkt_state *ps)
 {
-	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct hfi1_qp_priv *priv = qp->priv;
+	struct hfi1_ibport *ibp = ps->ibp;
 	u16 lrh0;
 	u32 nwords;
 	u32 extra_bytes;
@@ -754,7 +757,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	nwords = (qp->s_cur_size + extra_bytes) >> 2;
 	lrh0 = HFI1_LRH_BTH;
 	if (unlikely(qp->remote_ah_attr.ah_flags & IB_AH_GRH)) {
-		qp->s_hdrwords += hfi1_make_grh(ibp, &priv->s_hdr->ibh.u.l.grh,
+		qp->s_hdrwords += hfi1_make_grh(ibp,
+						&ps->s_txreq->phdr.hdr.u.l.grh,
 						&qp->remote_ah_attr.grh,
 						qp->s_hdrwords, nwords);
 		lrh0 = HFI1_LRH_GRH;
@@ -784,11 +788,11 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 		build_ahg(qp, bth2);
 	else
 		qp->s_flags &= ~RVT_S_AHG_VALID;
-	priv->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
-	priv->s_hdr->ibh.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
-	priv->s_hdr->ibh.lrh[2] =
+	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
+	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	ps->s_txreq->phdr.hdr.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
-	priv->s_hdr->ibh.lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
+	ps->s_txreq->phdr.hdr.lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
 				       qp->remote_ah_attr.src_path_bits);
 	bth0 |= hfi1_get_pkey(ibp, qp->s_pkey_index);
 	bth0 |= extra_bytes << 20;
@@ -826,7 +830,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 {
 	struct hfi1_pkt_state ps;
 	struct hfi1_qp_priv *priv = qp->priv;
-	int (*make_req)(struct rvt_qp *qp);
+	int (*make_req)(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 	unsigned long flags;
 	unsigned long timeout;
 	unsigned long timeout_int;
@@ -906,7 +910,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 			}
 			spin_lock_irqsave(&qp->s_lock, flags);
 		}
-	} while (make_req(qp));
+	} while (make_req(qp, &ps));
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index f884b5c..77431b1 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -49,7 +49,7 @@
  */
 
 #include "hfi.h"
-#include "sdma.h"
+#include "verbs_txreq.h"
 #include "qp.h"
 
 /* cut down ridiculously long IB macro names */
@@ -63,7 +63,7 @@
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_uc_req(struct rvt_qp *qp)
+int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
@@ -72,9 +72,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 	u32 bth0 = 0;
 	u32 len;
 	u32 pmtu = qp->pmtu;
-	int ret = 0;
 	int middle = 0;
 
+	ps->s_txreq = get_txreq(ps->dev, qp);
+	if (IS_ERR(ps->s_txreq))
+		goto bail_no_tx;
+
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
@@ -90,12 +93,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 		clear_ahg(qp);
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		hfi1_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
-		goto done;
+		goto done_free_tx;
 	}
 
-	ohdr = &priv->s_hdr->ibh.u.oth;
+	ohdr = &ps->s_txreq->phdr.hdr.u.oth;
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
-		ohdr = &priv->s_hdr->ibh.u.l.oth;
+		ohdr = &ps->s_txreq->phdr.hdr.u.l.oth;
 
 	/* Get the next send request. */
 	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
@@ -235,13 +238,22 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
-			     mask_psn(qp->s_psn++), middle);
-done:
+			     mask_psn(qp->s_psn++), middle, ps);
+	return 1;
+
+done_free_tx:
+	hfi1_put_txreq(ps->s_txreq);
+	ps->s_txreq = NULL;
 	return 1;
 
 bail:
+	hfi1_put_txreq(ps->s_txreq);
+
+bail_no_tx:
+	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	return ret;
+	qp->s_hdrwords = 0;
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index ba78e2e..a7118bc 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -54,6 +54,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "qp.h"
+#include "verbs_txreq.h"
 
 /**
  * ud_loopback - handle send on loopback QPs
@@ -265,7 +266,7 @@ drop:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int hfi1_make_ud_req(struct rvt_qp *qp)
+int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
@@ -278,10 +279,13 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	u32 bth0;
 	u16 lrh0;
 	u16 lid;
-	int ret = 0;
 	int next_cur;
 	u8 sc5;
 
+	ps->s_txreq = get_txreq(ps->dev, qp);
+	if (IS_ERR(ps->s_txreq))
+		goto bail_no_tx;
+
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
@@ -296,7 +300,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 		}
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		hfi1_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
-		goto done;
+		goto done_free_tx;
 	}
 
 	/* see post_one_send() */
@@ -337,7 +341,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 			ud_loopback(qp, wqe);
 			spin_lock_irqsave(&qp->s_lock, flags);
 			hfi1_send_complete(qp, wqe, IB_WC_SUCCESS);
-			goto done;
+			goto done_free_tx;
 		}
 	}
 
@@ -359,11 +363,12 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		/* Header size in 32-bit words. */
-		qp->s_hdrwords += hfi1_make_grh(ibp, &priv->s_hdr->ibh.u.l.grh,
-					       &ah_attr->grh,
-					       qp->s_hdrwords, nwords);
+		qp->s_hdrwords += hfi1_make_grh(ibp,
+						&ps->s_txreq->phdr.hdr.u.l.grh,
+						&ah_attr->grh,
+						qp->s_hdrwords, nwords);
 		lrh0 = HFI1_LRH_GRH;
-		ohdr = &priv->s_hdr->ibh.u.l.oth;
+		ohdr = &ps->s_txreq->phdr.hdr.u.l.oth;
 		/*
 		 * Don't worry about sending to locally attached multicast
 		 * QPs.  It is unspecified by the spec. what happens.
@@ -371,7 +376,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	} else {
 		/* Header size in 32-bit words. */
 		lrh0 = HFI1_LRH_BTH;
-		ohdr = &priv->s_hdr->ibh.u.oth;
+		ohdr = &ps->s_txreq->phdr.hdr.u.oth;
 	}
 	if (wqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
 		qp->s_hdrwords++;
@@ -389,19 +394,20 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 		priv->s_sc = sc5;
 	}
 	priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
-	priv->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
-	priv->s_hdr->ibh.lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
-	priv->s_hdr->ibh.lrh[2] =
+	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
+	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(ah_attr->dlid);
+	ps->s_txreq->phdr.hdr.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
-	if (ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE))
-		priv->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
-	else {
+	if (ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
+		ps->s_txreq->phdr.hdr.lrh[3] = IB_LID_PERMISSIVE;
+	} else {
 		lid = ppd->lid;
 		if (lid) {
 			lid |= ah_attr->src_path_bits & ((1 << ppd->lmc) - 1);
-			priv->s_hdr->ibh.lrh[3] = cpu_to_be16(lid);
-		} else
-			priv->s_hdr->ibh.lrh[3] = IB_LID_PERMISSIVE;
+			ps->s_txreq->phdr.hdr.lrh[3] = cpu_to_be16(lid);
+		} else {
+			ps->s_txreq->phdr.hdr.lrh[3] = IB_LID_PERMISSIVE;
+		}
 	}
 	if (wqe->wr.send_flags & IB_SEND_SOLICITED)
 		bth0 |= IB_BTH_SOLICITED;
@@ -426,11 +432,21 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	priv->s_hdr->tx_flags = 0;
 	priv->s_hdr->sde = NULL;
 
-done:
 	return 1;
+
+done_free_tx:
+	hfi1_put_txreq(ps->s_txreq);
+	ps->s_txreq = NULL;
+	return 1;
+
 bail:
+	hfi1_put_txreq(ps->s_txreq);
+
+bail_no_tx:
+	ps->s_txreq = NULL;
 	qp->s_flags &= ~RVT_S_BUSY;
-	return ret;
+	qp->s_hdrwords = 0;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 7838b21..8cf1d6b 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -622,8 +622,7 @@ bail_txadd:
  * NOTE: DMA mapping is held in the tx until completed in the ring or
  *       the tx desc is freed without having been submitted to the ring
  *
- * This routine insures the following all the helper routine
- * calls succeed.
+ * This routine ensures all the helper routine calls succeed.
  */
 /* New API */
 static int build_verbs_tx_desc(
@@ -635,10 +634,9 @@ static int build_verbs_tx_desc(
 	u64 pbc)
 {
 	int ret = 0;
-	struct hfi1_pio_header *phdr;
+	struct hfi1_pio_header *phdr = &tx->phdr;
 	u16 hdrbytes = tx->hdr_dwords << 2;
 
-	phdr = &tx->phdr;
 	if (!ahdr->ahgcount) {
 		ret = sdma_txinit_ahg(
 			&tx->txreq,
@@ -652,29 +650,14 @@ static int build_verbs_tx_desc(
 		if (ret)
 			goto bail_txadd;
 		phdr->pbc = cpu_to_le64(pbc);
-		memcpy(&phdr->hdr, &ahdr->ibh, hdrbytes - sizeof(phdr->pbc));
-		/* add the header */
 		ret = sdma_txadd_kvaddr(
 			sde->dd,
 			&tx->txreq,
-			&tx->phdr,
-			tx->hdr_dwords << 2);
+			phdr,
+			hdrbytes);
 		if (ret)
 			goto bail_txadd;
 	} else {
-		struct hfi1_other_headers *sohdr = &ahdr->ibh.u.oth;
-		struct hfi1_other_headers *dohdr = &phdr->hdr.u.oth;
-
-		/* needed in rc_send_complete() */
-		phdr->hdr.lrh[0] = ahdr->ibh.lrh[0];
-		if ((be16_to_cpu(phdr->hdr.lrh[0]) & 3) == HFI1_LRH_GRH) {
-			sohdr = &ahdr->ibh.u.l.oth;
-			dohdr = &phdr->hdr.u.l.oth;
-		}
-		/* opcode */
-		dohdr->bth[0] = sohdr->bth[0];
-		/* PSN/ACK  */
-		dohdr->bth[2] = sohdr->bth[2];
 		ret = sdma_txinit_ahg(
 			&tx->txreq,
 			ahdr->tx_flags,
@@ -712,6 +695,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	u8 sc5 = priv->s_sc;
 
 	int ret;
+	struct hfi1_ibdev *tdev;
 
 	if (!list_empty(&priv->s_iowait.tx_head)) {
 		stx = list_first_entry(
@@ -726,7 +710,10 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		return ret;
 	}
 
-	tx = get_txreq(dev, qp);
+	tx = ps->s_txreq;
+
+	tdev = to_idev(qp->ibqp.device);
+
 	if (IS_ERR(tx))
 		goto bail_tx;
 
@@ -748,7 +735,8 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
 	if (unlikely(ret))
 		goto bail_build;
-	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
+	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
+			   &ps->s_txreq->phdr.hdr);
 	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
 	if (unlikely(ret == -ECOMM))
 		goto bail_ecomm;
@@ -824,27 +812,29 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct ahg_ib_header *ahdr = priv->s_hdr;
 	u32 hdrwords = qp->s_hdrwords;
 	struct rvt_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
 	u32 dwords = (len + 3) >> 2;
 	u32 plen = hdrwords + dwords + 2; /* includes pbc */
 	struct hfi1_pportdata *ppd = ps->ppd;
-	u32 *hdr = (u32 *)&ahdr->ibh;
+	u32 *hdr = (u32 *)&ps->s_txreq->phdr.hdr;
 	u64 pbc_flags = 0;
 	u32 sc5;
 	unsigned long flags = 0;
 	struct send_context *sc;
 	struct pio_buf *pbuf;
 	int wc_status = IB_WC_SUCCESS;
+	int ret = 0;
 
 	/* vl15 special case taken care of in ud.c */
 	sc5 = priv->s_sc;
 	sc = qp_to_send_context(qp, sc5);
 
-	if (!sc)
-		return -EINVAL;
+	if (!sc) {
+		ret = -EINVAL;
+		goto bail;
+	}
 	if (likely(pbc == 0)) {
 		u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
 		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
@@ -872,7 +862,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			 * so lets continue to queue the request.
 			 */
 			hfi1_cdbg(PIO, "alloc failed. state active, queuing");
-			return no_bufs_available(qp, sc);
+			ret = no_bufs_available(qp, sc);
+			goto bail;
 		}
 	}
 
@@ -895,7 +886,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		}
 	}
 
-	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
+	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
+			   &ps->s_txreq->phdr.hdr);
 
 	if (qp->s_rdma_mr) {
 		rvt_put_mr(qp->s_rdma_mr);
@@ -909,10 +901,15 @@ pio_bail:
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 	} else if (qp->ibqp.qp_type == IB_QPT_RC) {
 		spin_lock_irqsave(&qp->s_lock, flags);
-		hfi1_rc_send_complete(qp, &ahdr->ibh);
+		hfi1_rc_send_complete(qp, &ps->s_txreq->phdr.hdr);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 	}
-	return 0;
+
+	ret = 0;
+
+bail:
+	hfi1_put_txreq(ps->s_txreq);
+	return ret;
 }
 
 /*
@@ -1011,8 +1008,6 @@ bad:
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct ahg_ib_header *ahdr = priv->s_hdr;
 	int ret;
 	int pio = 0;
 	unsigned long flags = 0;
@@ -1026,7 +1021,7 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	    !(dd->flags & HFI1_HAS_SEND_DMA))
 		pio = 1;
 
-	ret = egress_pkey_check(dd->pport, &ahdr->ibh, qp);
+	ret = egress_pkey_check(dd->pport, &ps->s_txreq->phdr.hdr, qp);
 	if (unlikely(ret)) {
 		/*
 		 * The value we are returning here does not get propagated to
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index d00c55d..73f471a 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -59,6 +59,7 @@
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
 #include <linux/completion.h>
+#include <linux/slab.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_mad.h>
@@ -194,13 +195,6 @@ struct hfi1_pio_header {
 } __packed;
 
 /*
- * used for force cacheline alignment for AHG
- */
-struct tx_pio_header {
-	struct hfi1_pio_header phdr;
-} ____cacheline_aligned;
-
-/*
  * hfi1 specific data structures that will be hidden from rvt after the queue
  * pair is made common
  */
@@ -222,6 +216,7 @@ struct hfi1_pkt_state {
 	struct hfi1_ibdev *dev;
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
+	struct verbs_txreq *s_txreq;
 };
 
 #define HFI1_PSN_CREDIT  16
@@ -436,7 +431,8 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 		  struct ib_global_route *grh, u32 hwords, u32 nwords);
 
 void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
-			  u32 bth0, u32 bth2, int middle);
+			  u32 bth0, u32 bth2, int middle,
+			  struct hfi1_pkt_state *ps);
 
 void _hfi1_do_send(struct work_struct *work);
 
@@ -447,11 +443,11 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 
 void hfi1_send_rc_ack(struct hfi1_ctxtdata *, struct rvt_qp *qp, int is_fecn);
 
-int hfi1_make_rc_req(struct rvt_qp *qp);
+int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 
-int hfi1_make_uc_req(struct rvt_qp *qp);
+int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 
-int hfi1_make_ud_req(struct rvt_qp *qp);
+int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 
 int hfi1_register_ib_device(struct hfi1_devdata *);
 
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/staging/rdma/hfi1/verbs_txreq.h
index 387882a..d89d29b 100644
--- a/drivers/staging/rdma/hfi1/verbs_txreq.h
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.h
@@ -63,7 +63,6 @@ struct verbs_txreq {
 	struct rvt_mregion	*mr;
 	struct rvt_sge_state    *ss;
 	struct sdma_engine     *sde;
-	struct send_context     *psc;
 	u16                     hdr_dwords;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
