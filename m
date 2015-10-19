From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/23] staging/rdma/hfi1: optionally prescan rx queue for {B,F}ECNs - UC, RC
Date: Mon, 19 Oct 2015 12:43:31 -0400
Message-ID: <1445273027-29634-8-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

(This patch adds RC, and UC processing based on commit 48c479f.)

To more rapidly respond to Explicit Congestion Notifications,
prescan the receive queue, and process FECNs, and BECNs first.
When a UC, or RC packet containing a FECN, or BECN is found,
immediately react to the ECN (either by returning a CNP, or
adjusting the injection rate). Afterward, the packet will be
processed normally.

During testing a bug was found where, when HFI1_CAP_DMA_RTAIL
is toggled off the "prescan head" can get out of sync with the
receive context's "head". This happens when, after prescan_rxq()
newly arrived packets are then received, and processed by an
RX interrupt handler. This is an unavoidable race, and to avoid
getting out of sync we always start prescanning at the current
"rcd->head" entry.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c | 77 +++++++++++++++++---------------------
 drivers/staging/rdma/hfi1/hfi.h    | 13 -------
 drivers/staging/rdma/hfi1/rc.c     | 10 ++---
 drivers/staging/rdma/hfi1/uc.c     | 15 +++++---
 drivers/staging/rdma/hfi1/verbs.c  | 41 +++++++++++++++++---
 5 files changed, 84 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index c0a59001e5cd..4ccc2c87b196 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -436,59 +436,58 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 
 #ifndef CONFIG_PRESCAN_RXQ
 static void prescan_rxq(struct hfi1_packet *packet) {}
-#else /* CONFIG_PRESCAN_RXQ */
+#else /* !CONFIG_PRESCAN_RXQ */
 static int prescan_receive_queue;
 
 static void process_ecn(struct hfi1_qp *qp, struct hfi1_ib_header *hdr,
 			struct hfi1_other_headers *ohdr,
-			u64 rhf, struct ib_grh *grh)
+			u64 rhf, u32 bth1, struct ib_grh *grh)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	u32 bth1;
+	u32 rqpn = 0;
+	u16 rlid;
 	u8 sc5, svc_type;
-	int is_fecn, is_becn;
 
 	switch (qp->ibqp.qp_type) {
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
 	case IB_QPT_UD:
+		rlid = be16_to_cpu(hdr->lrh[3]);
+		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & HFI1_QPN_MASK;
 		svc_type = IB_CC_SVCTYPE_UD;
 		break;
-	case IB_QPT_UC:	/* LATER */
-	case IB_QPT_RC:	/* LATER */
+	case IB_QPT_UC:
+		rlid = qp->remote_ah_attr.dlid;
+		rqpn = qp->remote_qpn;
+		svc_type = IB_CC_SVCTYPE_UC;
+		break;
+	case IB_QPT_RC:
+		rlid = qp->remote_ah_attr.dlid;
+		rqpn = qp->remote_qpn;
+		svc_type = IB_CC_SVCTYPE_RC;
+		break;
 	default:
 		return;
 	}
 
-	is_fecn = (be32_to_cpu(ohdr->bth[1]) >> HFI1_FECN_SHIFT) &
-			HFI1_FECN_MASK;
-	is_becn = (be32_to_cpu(ohdr->bth[1]) >> HFI1_BECN_SHIFT) &
-			HFI1_BECN_MASK;
-
 	sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
 	if (rhf_dc_info(rhf))
 		sc5 |= 0x10;
 
-	if (is_fecn) {
-		u32 src_qpn = be32_to_cpu(ohdr->u.ud.deth[1]) & HFI1_QPN_MASK;
+	if (bth1 & HFI1_FECN_SMASK) {
 		u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
 		u16 dlid = be16_to_cpu(hdr->lrh[1]);
-		u16 slid = be16_to_cpu(hdr->lrh[3]);
 
-		return_cnp(ibp, qp, src_qpn, pkey, dlid, slid, sc5, grh);
+		return_cnp(ibp, qp, rqpn, pkey, dlid, rlid, sc5, grh);
 	}
 
-	if (is_becn) {
+	if (bth1 & HFI1_BECN_SMASK) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+		u32 lqpn = bth1 & HFI1_QPN_MASK;
 		u8 sl = ibp->sc_to_sl[sc5];
 
-		process_becn(ppd, sl, 0, lqpn, 0, svc_type);
+		process_becn(ppd, sl, rlid, lqpn, rqpn, svc_type);
 	}
-
-	/* turn off BECN, or FECN */
-	bth1 = be32_to_cpu(ohdr->bth[1]);
-	bth1 &= ~(HFI1_FECN_MASK << HFI1_FECN_SHIFT);
-	bth1 &= ~(HFI1_BECN_MASK << HFI1_BECN_SHIFT);
-	ohdr->bth[1] = cpu_to_be32(bth1);
 }
 
 struct ps_mdata {
@@ -508,15 +507,10 @@ static inline void init_ps_mdata(struct ps_mdata *mdata,
 	mdata->rcd = rcd;
 	mdata->rsize = packet->rsize;
 	mdata->maxcnt = packet->maxcnt;
-
-	if (rcd->ps_state.initialized == 0) {
-		mdata->ps_head = packet->rhqoff;
-		rcd->ps_state.initialized++;
-	} else
-		mdata->ps_head = rcd->ps_state.ps_head;
+	mdata->ps_head = packet->rhqoff;
 
 	if (HFI1_CAP_IS_KSET(DMA_RTAIL)) {
-		mdata->ps_tail = packet->hdrqtail;
+		mdata->ps_tail = get_rcvhdrtail(rcd);
 		mdata->ps_seq = 0; /* not used with DMA_RTAIL */
 	} else {
 		mdata->ps_tail = 0; /* used only with DMA_RTAIL*/
@@ -533,12 +527,9 @@ static inline int ps_done(struct ps_mdata *mdata, u64 rhf)
 
 static inline void update_ps_mdata(struct ps_mdata *mdata)
 {
-	struct hfi1_ctxtdata *rcd = mdata->rcd;
-
 	mdata->ps_head += mdata->rsize;
-	if (mdata->ps_head > mdata->maxcnt)
+	if (mdata->ps_head >= mdata->maxcnt)
 		mdata->ps_head = 0;
-	rcd->ps_state.ps_head = mdata->ps_head;
 	if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
 		if (++mdata->ps_seq > 13)
 			mdata->ps_seq = 1;
@@ -571,7 +562,7 @@ static void prescan_rxq(struct hfi1_packet *packet)
 		struct hfi1_other_headers *ohdr;
 		struct ib_grh *grh = NULL;
 		u64 rhf = rhf_to_cpu(rhf_addr);
-		u32 etype = rhf_rcv_type(rhf), qpn;
+		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
 		int is_ecn = 0;
 		u8 lnh;
 
@@ -593,15 +584,13 @@ static void prescan_rxq(struct hfi1_packet *packet)
 		} else
 			goto next; /* just in case */
 
-		is_ecn |= be32_to_cpu(ohdr->bth[1]) &
-			(HFI1_FECN_MASK << HFI1_FECN_SHIFT);
-		is_ecn |= be32_to_cpu(ohdr->bth[1]) &
-			(HFI1_BECN_MASK << HFI1_BECN_SHIFT);
+		bth1 = be32_to_cpu(ohdr->bth[1]);
+		is_ecn = !!(bth1 & (HFI1_FECN_SMASK | HFI1_BECN_SMASK));
 
 		if (!is_ecn)
 			goto next;
 
-		qpn = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
+		qpn = bth1 & HFI1_QPN_MASK;
 		rcu_read_lock();
 		qp = hfi1_lookup_qpn(ibp, qpn);
 
@@ -610,8 +599,12 @@ static void prescan_rxq(struct hfi1_packet *packet)
 			goto next;
 		}
 
-		process_ecn(qp, hdr, ohdr, rhf, grh);
+		process_ecn(qp, hdr, ohdr, rhf, bth1, grh);
 		rcu_read_unlock();
+
+		/* turn off BECN, FECN */
+		bth1 &= ~(HFI1_FECN_SMASK | HFI1_BECN_SMASK);
+		ohdr->bth[1] = cpu_to_be32(bth1);
 next:
 		update_ps_mdata(&mdata);
 	}
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 8ca171bf3e36..60f4b3d88671 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -139,15 +139,6 @@ extern const struct pci_error_handlers hfi1_pci_err_handler;
 struct hfi1_opcode_stats_perctx;
 #endif
 
-/*
- * struct ps_state keeps state associated with RX queue "prescanning"
- * (prescanning for FECNs, and BECNs), if prescanning is in use.
- */
-struct ps_state {
-	u32 ps_head;
-	int initialized;
-};
-
 struct ctxt_eager_bufs {
 	ssize_t size;            /* total size of eager buffers */
 	u32 count;               /* size of buffers array */
@@ -302,10 +293,6 @@ struct hfi1_ctxtdata {
 	struct list_head sdma_queues;
 	spinlock_t sdma_qlock;
 
-#ifdef CONFIG_PRESCAN_RXQ
-	struct ps_state ps_state;
-#endif /* CONFIG_PRESCAN_RXQ */
-
 	/*
 	 * The interrupt handler for a particular receive context can vary
 	 * throughout it's lifetime. This is not a lock protected data member so
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 1e9caebb0281..6931ebe99b3b 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1971,7 +1971,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	}
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode = bth0 >> 24;
+	opcode = (bth0 >> 24) & 0xff;
 
 	/*
 	 * Process responses (ACKs) before anything else.  Note that the
@@ -2384,19 +2384,19 @@ void hfi1_rc_hdrerr(
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	int diff;
 	u32 opcode;
-	u32 psn;
+	u32 psn, bth0;
 
 	/* Check for GRH */
 	ohdr = &hdr->u.oth;
 	if (has_grh)
 		ohdr = &hdr->u.l.oth;
 
-	opcode = be32_to_cpu(ohdr->bth[0]);
-	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, opcode))
+	bth0 = be32_to_cpu(ohdr->bth[0]);
+	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, bth0))
 		return;
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode >>= 24;
+	opcode = (bth0 >> 24) & 0xff;
 
 	/* Only deal with RDMA Writes for now */
 	if (opcode < IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST) {
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index b536f397737c..d785878d8b90 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -268,7 +268,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct hfi1_qp *qp = packet->qp;
 	struct hfi1_other_headers *ohdr = packet->ohdr;
-	u32 opcode;
+	u32 bth0, opcode;
 	u32 hdrsize = packet->hlen;
 	u32 psn;
 	u32 pad;
@@ -278,10 +278,9 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	int has_grh = rcv_flags & HFI1_HAS_GRH;
 	int ret;
 	u32 bth1;
-	struct ib_grh *grh = NULL;
 
-	opcode = be32_to_cpu(ohdr->bth[0]);
-	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, opcode))
+	bth0 = be32_to_cpu(ohdr->bth[0]);
+	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, bth0))
 		return;
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
@@ -303,6 +302,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		}
 
 		if (bth1 & HFI1_FECN_SMASK) {
+			struct ib_grh *grh = NULL;
 			u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
 			u16 slid = be16_to_cpu(hdr->lrh[3]);
 			u16 dlid = be16_to_cpu(hdr->lrh[1]);
@@ -310,13 +310,16 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 			u8 sc5;
 
 			sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
+			if (has_grh)
+				grh = &hdr->u.l.grh;
 
-			return_cnp(ibp, qp, src_qp, pkey, dlid, slid, sc5, grh);
+			return_cnp(ibp, qp, src_qp, pkey, dlid, slid, sc5,
+				   grh);
 		}
 	}
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode >>= 24;
+	opcode = (bth0 >> 24) & 0xff;
 
 	/* Compare the PSN verses the expected PSN. */
 	if (unlikely(cmp_psn(psn, qp->r_psn) != 0)) {
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a43fccd68a73..8456e82b2ab1 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2136,11 +2136,40 @@ void hfi1_schedule_send(struct hfi1_qp *qp)
 void hfi1_cnp_rcv(struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
-
-	if (packet->qp->ibqp.qp_type == IB_QPT_UC)
-		hfi1_uc_rcv(packet);
-	else if (packet->qp->ibqp.qp_type == IB_QPT_UD)
-		hfi1_ud_rcv(packet);
-	else
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_ib_header *hdr = packet->hdr;
+	struct hfi1_qp *qp = packet->qp;
+	u32 lqpn, rqpn = 0;
+	u16 rlid = 0;
+	u8 sl, sc5, sc4_bit, svc_type;
+	bool sc4_set = has_sc4_bit(packet);
+
+	switch (packet->qp->ibqp.qp_type) {
+	case IB_QPT_UC:
+		rlid = qp->remote_ah_attr.dlid;
+		rqpn = qp->remote_qpn;
+		svc_type = IB_CC_SVCTYPE_UC;
+		break;
+	case IB_QPT_RC:
+		rlid = qp->remote_ah_attr.dlid;
+		rqpn = qp->remote_qpn;
+		svc_type = IB_CC_SVCTYPE_RC;
+		break;
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	case IB_QPT_UD:
+		svc_type = IB_CC_SVCTYPE_UD;
+		break;
+	default:
 		ibp->n_pkt_drops++;
+		return;
+	}
+
+	sc4_bit = sc4_set << 4;
+	sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
+	sc5 |= sc4_bit;
+	sl = ibp->sc_to_sl[sc5];
+	lqpn = qp->ibqp.qp_num;
+
+	process_becn(ppd, sl, rlid, lqpn, rqpn, svc_type);
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
