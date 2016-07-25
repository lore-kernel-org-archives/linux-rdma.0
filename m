From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 24/28] IB/hfi1: Rename struct ahg_ib_header to struct
 hfi1_ahg_info
Date: Mon, 25 Jul 2016 13:40:16 -0700
Message-ID: <20160725204015.4800.86943.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

struct ahg_ib_header has no header specific information.
Rename it to struct hfi1_ahg_info

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |    7 ++++---
 drivers/infiniband/hw/hfi1/qp.h    |    2 +-
 drivers/infiniband/hw/hfi1/ruc.c   |   28 ++++++++++++++--------------
 drivers/infiniband/hw/hfi1/ud.c    |    6 +++---
 drivers/infiniband/hw/hfi1/verbs.c |   20 ++++++++++----------
 drivers/infiniband/hw/hfi1/verbs.h |    4 ++--
 6 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index ad8ad33..a5aa351 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -806,8 +806,9 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 
 	priv->owner = qp;
 
-	priv->s_hdr = kzalloc_node(sizeof(*priv->s_hdr), gfp, rdi->dparms.node);
-	if (!priv->s_hdr) {
+	priv->s_ahg = kzalloc_node(sizeof(*priv->s_ahg), gfp,
+				   rdi->dparms.node);
+	if (!priv->s_ahg) {
 		kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -820,7 +821,7 @@ void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
-	kfree(priv->s_hdr);
+	kfree(priv->s_ahg);
 	kfree(priv);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index ddf8298..587d84d 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -63,7 +63,7 @@ static inline void clear_ahg(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
-	priv->s_hdr->ahgcount = 0;
+	priv->s_ahg->ahgcount = 0;
 	qp->s_flags &= ~(RVT_S_AHG_VALID | RVT_S_AHG_CLEAR);
 	if (priv->s_sde && qp->s_ahgidx >= 0)
 		sdma_ahg_free(priv->s_sde, qp->s_ahgidx);
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index c7c2f48..ea7977d 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -711,7 +711,7 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 #define BTH2_OFFSET (offsetof(struct hfi1_pio_header, hdr.u.oth.bth[2]) / 4)
 
 /**
- * build_ahg - create ahg in s_hdr
+ * build_ahg - create ahg in s_ahg
  * @qp: a pointer to QP
  * @npsn: the next PSN for the request/response
  *
@@ -733,18 +733,18 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 			qp->s_ahgidx = sdma_ahg_alloc(priv->s_sde);
 		if (qp->s_ahgidx >= 0) {
 			qp->s_ahgpsn = npsn;
-			priv->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
+			priv->s_ahg->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
 			/* save to protect a change in another thread */
-			priv->s_hdr->ahgidx = qp->s_ahgidx;
+			priv->s_ahg->ahgidx = qp->s_ahgidx;
 			qp->s_flags |= RVT_S_AHG_VALID;
 		}
 	} else {
 		/* subsequent middle after valid */
 		if (qp->s_ahgidx >= 0) {
-			priv->s_hdr->tx_flags |= SDMA_TXREQ_F_USE_AHG;
-			priv->s_hdr->ahgidx = qp->s_ahgidx;
-			priv->s_hdr->ahgcount++;
-			priv->s_hdr->ahgdesc[0] =
+			priv->s_ahg->tx_flags |= SDMA_TXREQ_F_USE_AHG;
+			priv->s_ahg->ahgidx = qp->s_ahgidx;
+			priv->s_ahg->ahgcount++;
+			priv->s_ahg->ahgdesc[0] =
 				sdma_build_ahg_descriptor(
 					(__force u16)cpu_to_be16((u16)npsn),
 					BTH2_OFFSET,
@@ -752,8 +752,8 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 					16);
 			if ((npsn & 0xffff0000) !=
 					(qp->s_ahgpsn & 0xffff0000)) {
-				priv->s_hdr->ahgcount++;
-				priv->s_hdr->ahgdesc[1] =
+				priv->s_ahg->ahgcount++;
+				priv->s_ahg->ahgdesc[1] =
 					sdma_build_ahg_descriptor(
 						(__force u16)cpu_to_be16(
 							(u16)(npsn >> 16)),
@@ -790,7 +790,7 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	}
 	lrh0 |= (priv->s_sc & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
 	/*
-	 * reset s_hdr/AHG fields
+	 * reset s_ahg/AHG fields
 	 *
 	 * This insures that the ahgentry/ahgcount
 	 * are at a non-AHG default to protect
@@ -800,9 +800,9 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	 * build_ahg() will modify as appropriate
 	 * to use the AHG feature.
 	 */
-	priv->s_hdr->tx_flags = 0;
-	priv->s_hdr->ahgcount = 0;
-	priv->s_hdr->ahgidx = 0;
+	priv->s_ahg->tx_flags = 0;
+	priv->s_ahg->ahgcount = 0;
+	priv->s_ahg->ahgidx = 0;
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	else
@@ -913,7 +913,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 			 */
 			if (hfi1_verbs_send(qp, &ps))
 				return;
-			/* Record that s_hdr is empty. */
+			/* Record that s_ahg is empty. */
 			qp->s_hdrwords = 0;
 			/* allow other tasks to run */
 			if (unlikely(time_after(jiffies, timeout))) {
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index d4afb1d..08a9c12 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -430,9 +430,9 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 					 qp->qkey : wqe->ud_wr.remote_qkey);
 	ohdr->u.ud.deth[1] = cpu_to_be32(qp->ibqp.qp_num);
 	/* disarm any ahg */
-	priv->s_hdr->ahgcount = 0;
-	priv->s_hdr->ahgidx = 0;
-	priv->s_hdr->tx_flags = 0;
+	priv->s_ahg->ahgcount = 0;
+	priv->s_ahg->ahgidx = 0;
+	priv->s_ahg->tx_flags = 0;
 	/* pbc */
 	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 9578565..2b3fa40 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -816,19 +816,19 @@ static int build_verbs_tx_desc(
 	struct rvt_sge_state *ss,
 	u32 length,
 	struct verbs_txreq *tx,
-	struct ahg_ib_header *ahdr,
+	struct hfi1_ahg_info *ahg_info,
 	u64 pbc)
 {
 	int ret = 0;
 	struct hfi1_pio_header *phdr = &tx->phdr;
 	u16 hdrbytes = tx->hdr_dwords << 2;
 
-	if (!ahdr->ahgcount) {
+	if (!ahg_info->ahgcount) {
 		ret = sdma_txinit_ahg(
 			&tx->txreq,
-			ahdr->tx_flags,
+			ahg_info->tx_flags,
 			hdrbytes + length,
-			ahdr->ahgidx,
+			ahg_info->ahgidx,
 			0,
 			NULL,
 			0,
@@ -846,11 +846,11 @@ static int build_verbs_tx_desc(
 	} else {
 		ret = sdma_txinit_ahg(
 			&tx->txreq,
-			ahdr->tx_flags,
+			ahg_info->tx_flags,
 			length,
-			ahdr->ahgidx,
-			ahdr->ahgcount,
-			ahdr->ahgdesc,
+			ahg_info->ahgidx,
+			ahg_info->ahgcount,
+			ahg_info->ahgdesc,
 			hdrbytes,
 			verbs_sdma_complete);
 		if (ret)
@@ -868,7 +868,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct ahg_ib_header *ahdr = priv->s_hdr;
+	struct hfi1_ahg_info *ahg_info = priv->s_ahg;
 	u32 hdrwords = qp->s_hdrwords;
 	struct rvt_sge_state *ss = qp->s_cur_sge;
 	u32 len = qp->s_cur_size;
@@ -896,7 +896,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 					 plen);
 		}
 		tx->wqe = qp->s_wqe;
-		ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
+		ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahg_info, pbc);
 		if (unlikely(ret))
 			goto bail_build;
 	}
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 4bd1cd4..d44550f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -178,7 +178,7 @@ struct hfi1_ib_header {
 	} u;
 } __packed;
 
-struct ahg_ib_header {
+struct hfi1_ahg_info {
 	u32 ahgdesc[2];
 	u16 tx_flags;
 	u8 ahgcount;
@@ -195,7 +195,7 @@ struct hfi1_pio_header {
  * pair is made common
  */
 struct hfi1_qp_priv {
-	struct ahg_ib_header *s_hdr;              /* next header to send */
+	struct hfi1_ahg_info *s_ahg;              /* ahg info for next header */
 	struct sdma_engine *s_sde;                /* current sde */
 	struct send_context *s_sendcontext;       /* current sendcontext */
 	u8 s_sc;		                  /* SC[0..4] for next packet */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
