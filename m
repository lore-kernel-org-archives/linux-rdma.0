From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 9/9] staging/rdma/hfi: pre-compute sc and sde for RC/UC QPs
Date: Fri, 30 Oct 2015 18:41:58 -0400
Message-ID: <1446244918-12089-10-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Now that we have a multi-threaded work queue we precomputed and store the SC
and SDE on RC and UC QPs for faster access.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    | 27 +++++++++++++++++++++------
 drivers/staging/rdma/hfi1/qp.h    |  1 -
 drivers/staging/rdma/hfi1/ruc.c   | 10 ++--------
 drivers/staging/rdma/hfi1/ud.c    |  1 +
 drivers/staging/rdma/hfi1/verbs.c | 14 +++-----------
 drivers/staging/rdma/hfi1/verbs.h |  3 ++-
 6 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 6e6c9a8f6b6f..87aa49227bf6 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -617,7 +617,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	int mig = 0;
 	int ret;
 	u32 pmtu = 0; /* for gcc warning only */
-	struct hfi1_devdata *dd;
+	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	spin_lock_irq(&qp->r_lock);
 	spin_lock(&qp->s_lock);
@@ -631,23 +631,35 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto inval;
 
 	if (attr_mask & IB_QP_AV) {
+		u8 sc;
+
 		if (attr->ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
+		sc = ah_to_sc(ibqp->device, &attr->ah_attr);
+		if (!qp_to_sdma_engine(qp, sc) &&
+				dd->flags & HFI1_HAS_SEND_DMA)
+			goto inval;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
+		u8 sc;
+
 		if (attr->alt_ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
-		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd_from_dev(dev)))
+		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd))
+			goto inval;
+		sc = ah_to_sc(ibqp->device, &attr->alt_ah_attr);
+		if (!qp_to_sdma_engine(qp, sc) &&
+				dd->flags & HFI1_HAS_SEND_DMA)
 			goto inval;
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
-		if (attr->pkey_index >= hfi1_get_npkeys(dd_from_dev(dev)))
+		if (attr->pkey_index >= hfi1_get_npkeys(dd))
 			goto inval;
 
 	if (attr_mask & IB_QP_MIN_RNR_TIMER)
@@ -792,6 +804,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		qp->remote_ah_attr = attr->ah_attr;
 		qp->s_srate = attr->ah_attr.static_rate;
 		qp->srate_mbps = ib_rate_to_mbps(qp->s_srate);
+		qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+		qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
@@ -806,6 +820,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			qp->port_num = qp->alt_ah_attr.port_num;
 			qp->s_pkey_index = qp->s_alt_pkey_index;
 			qp->s_flags |= HFI1_S_AHG_CLEAR;
+			qp->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
+			qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 		}
 	}
 
@@ -1528,9 +1544,6 @@ struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5)
 	if (!(dd->flags & HFI1_HAS_SEND_DMA))
 		return NULL;
 	switch (qp->ibqp.qp_type) {
-	case IB_QPT_UC:
-	case IB_QPT_RC:
-		break;
 	case IB_QPT_SMI:
 		return NULL;
 	default:
@@ -1699,6 +1712,8 @@ void hfi1_migrate_qp(struct hfi1_qp *qp)
 	qp->port_num = qp->alt_ah_attr.port_num;
 	qp->s_pkey_index = qp->s_alt_pkey_index;
 	qp->s_flags |= HFI1_S_AHG_CLEAR;
+	qp->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
+	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 
 	ev.device = qp->ibqp.device;
 	ev.element.qp = &qp->ibqp;
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index ca70a0e662d0..5e1def523f61 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -128,7 +128,6 @@ static inline void clear_ahg(struct hfi1_qp *qp)
 	if (qp->s_sde && qp->s_ahgidx >= 0)
 		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
 	qp->s_ahgidx = -1;
-	qp->s_sde = NULL;
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 947ea27332ff..7b11c61ac5d6 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -694,11 +694,8 @@ static inline void build_ahg(struct hfi1_qp *qp, u32 npsn)
 		clear_ahg(qp);
 	if (!(qp->s_flags & HFI1_S_AHG_VALID)) {
 		/* first middle that needs copy  */
-		if (qp->s_ahgidx < 0) {
-			if (!qp->s_sde)
-				qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
+		if (qp->s_ahgidx < 0)
 			qp->s_ahgidx = sdma_ahg_alloc(qp->s_sde);
-		}
 		if (qp->s_ahgidx >= 0) {
 			qp->s_ahgpsn = npsn;
 			qp->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
@@ -741,7 +738,6 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 	u16 lrh0;
 	u32 nwords;
 	u32 extra_bytes;
-	u8 sc5;
 	u32 bth1;
 
 	/* Construct the header. */
@@ -755,9 +751,7 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 		lrh0 = HFI1_LRH_GRH;
 		middle = 0;
 	}
-	sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
-	lrh0 |= (sc5 & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
-	qp->s_sc = sc5;
+	lrh0 |= (qp->s_sc & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
 	/*
 	 * reset s_hdr/AHG fields
 	 *
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index d40d1a1e10aa..d6b4ba8a811e 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -383,6 +383,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 		lrh0 |= (sc5 & 0xf) << 12;
 		qp->s_sc = sc5;
 	}
+	qp->s_sde = qp_to_sdma_engine(qp, qp->s_sc);
 	qp->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
 	qp->s_hdr->ibh.lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
 	qp->s_hdr->ibh.lrh[2] =
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index f43a8646af1b..2c7cf783f24d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -999,7 +999,6 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	struct verbs_txreq *tx;
 	struct sdma_txreq *stx;
 	u64 pbc_flags = 0;
-	struct sdma_engine *sde;
 	u8 sc5 = qp->s_sc;
 	int ret;
 
@@ -1020,12 +1019,7 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	if (IS_ERR(tx))
 		goto bail_tx;
 
-	if (!qp->s_hdr->sde) {
-		tx->sde = sde = qp_to_sdma_engine(qp, sc5);
-		if (!sde)
-			goto bail_no_sde;
-	} else
-		tx->sde = sde = qp->s_hdr->sde;
+	tx->sde = qp->s_sde;
 
 	if (likely(pbc == 0)) {
 		u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
@@ -1040,17 +1034,15 @@ int hfi1_verbs_send_dma(struct hfi1_qp *qp, struct ahg_ib_header *ahdr,
 	if (qp->s_rdma_mr)
 		qp->s_rdma_mr = NULL;
 	tx->hdr_dwords = hdrwords + 2;
-	ret = build_verbs_tx_desc(sde, ss, len, tx, ahdr, pbc);
+	ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
 	if (unlikely(ret))
 		goto bail_build;
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &ahdr->ibh);
-	ret =  sdma_send_txreq(sde, &qp->s_iowait, &tx->txreq);
+	ret =  sdma_send_txreq(tx->sde, &qp->s_iowait, &tx->txreq);
 	if (unlikely(ret == -ECOMM))
 		goto bail_ecomm;
 	return ret;
 
-bail_no_sde:
-	hfi1_put_txreq(tx);
 bail_ecomm:
 	/* The current one got "sent" */
 	return 0;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index fb8ea5c892c6..62c6e38cca45 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -436,7 +436,8 @@ struct hfi1_qp {
 	struct hfi1_swqe *s_wq;  /* send work queue */
 	struct hfi1_mmap_info *ip;
 	struct ahg_ib_header *s_hdr;     /* next packet header to send */
-	u8 s_sc;			/* SC[0..4] for next packet */
+	/* sc for UC/RC QPs - based on ah for UD */
+	u8 s_sc;
 	unsigned long timeout_jiffies;  /* computed from timeout */
 
 	enum ib_mtu path_mtu;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
