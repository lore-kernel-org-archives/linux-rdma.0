From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/23] IB/hfi1: Remove dependence on qp->s_cur_size
Date: Wed, 07 Dec 2016 19:33:00 -0800
Message-ID: <20161208033258.21135.46245.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The qp->s_cur_size field assumes that the S_BUSY bit protects
the field from modification after the slock is dropped. Scaling the
send engine to multiple cores would break that assumption.

Correct the issue by carrying the payload size in the txreq structure.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c          |    4 ++--
 drivers/infiniband/hw/hfi1/ruc.c         |    4 ++--
 drivers/infiniband/hw/hfi1/uc.c          |    2 +-
 drivers/infiniband/hw/hfi1/ud.c          |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c       |    6 +++---
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    1 +
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index df2f94d..1fe996c 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -351,7 +351,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	qp->s_rdma_ack_cnt++;
 	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
-	qp->s_cur_size = len;
+	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
 	/* pbc */
 	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
@@ -802,7 +802,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = ss;
-	qp->s_cur_size = len;
+	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(
 		qp,
 		ohdr,
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 5a70e91..2ec3e90 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -767,8 +767,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 	u32 bth1;
 
 	/* Construct the header. */
-	extra_bytes = -qp->s_cur_size & 3;
-	nwords = (qp->s_cur_size + extra_bytes) >> 2;
+	extra_bytes = -ps->s_txreq->s_cur_size & 3;
+	nwords = (ps->s_txreq->s_cur_size + extra_bytes) >> 2;
 	lrh0 = HFI1_LRH_BTH;
 	if (unlikely(qp->remote_ah_attr.ah_flags & IB_AH_GRH)) {
 		qp->s_hdrwords += hfi1_make_grh(ibp,
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 5e6d1ba..d062c35 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -259,7 +259,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	qp->s_hdrwords = hwords;
 	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = &qp->s_sge;
-	qp->s_cur_size = len;
+	ps->s_txreq->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
 			     mask_psn(qp->s_psn++), middle, ps);
 	/* pbc */
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 97ae24b..d742ac1 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -354,7 +354,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 
 	/* header size in 32-bit words LRH+BTH+DETH = (8+12+8)/4. */
 	qp->s_hdrwords = 7;
-	qp->s_cur_size = wqe->length;
+	ps->s_txreq->s_cur_size = wqe->length;
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_srate = ah_attr->static_rate;
 	qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 0913258..65f2f1d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -895,7 +895,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_ahg_info *ahg_info = priv->s_ahg;
 	u32 hdrwords = qp->s_hdrwords;
 	struct rvt_sge_state *ss = qp->s_cur_sge;
-	u32 len = qp->s_cur_size;
+	u32 len = ps->s_txreq->s_cur_size;
 	u32 plen = hdrwords + ((len + 3) >> 2) + 2; /* includes pbc */
 	struct hfi1_ibdev *dev = ps->dev;
 	struct hfi1_pportdata *ppd = ps->ppd;
@@ -1012,7 +1012,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_qp_priv *priv = qp->priv;
 	u32 hdrwords = qp->s_hdrwords;
 	struct rvt_sge_state *ss = qp->s_cur_sge;
-	u32 len = qp->s_cur_size;
+	u32 len = ps->s_txreq->s_cur_size;
 	u32 dwords = (len + 3) >> 2;
 	u32 plen = hdrwords + dwords + 2; /* includes pbc */
 	struct hfi1_pportdata *ppd = ps->ppd;
@@ -1240,7 +1240,7 @@ static inline send_routine get_send_routine(struct rvt_qp *qp,
 		u8 op = get_opcode(h);
 
 		if (piothreshold &&
-		    qp->s_cur_size <= min(piothreshold, qp->pmtu) &&
+		    tx->s_cur_size <= min(piothreshold, qp->pmtu) &&
 		    (BIT(op & OPMASK) & pio_opmask[op >> 5]) &&
 		    iowait_sdma_pending(&priv->s_iowait) == 0 &&
 		    !sdma_txreq_built(&tx->txreq))
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index 5660897..76216f2 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -65,6 +65,7 @@ struct verbs_txreq {
 	struct sdma_engine     *sde;
 	struct send_context     *psc;
 	u16                     hdr_dwords;
+	u16			s_cur_size;
 };
 
 struct hfi1_ibdev;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
