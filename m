From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/28] IB/hfi1: Pull FECN/BECN processing to a common place
Date: Mon, 25 Jul 2016 13:38:07 -0700
Message-ID: <20160725203806.4800.64955.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There were multiple places where FECN/BECN processing was
being done for the different types of QPs. All of that code
was very similar, which meant that it could be pulled into
a single function used by the different QP types.

To retain the performance in the fastpath, the common code
starts with an inline function, which only calls the slow
path if the packet has any of the [FB]ECN bits set.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   47 +++++++++++++++++++----------------
 drivers/infiniband/hw/hfi1/hfi.h    |   16 ++++++++++++
 drivers/infiniband/hw/hfi1/rc.c     |   19 +-------------
 drivers/infiniband/hw/hfi1/uc.c     |   36 +--------------------------
 drivers/infiniband/hw/hfi1/ud.c     |   24 +-----------------
 5 files changed, 45 insertions(+), 97 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 6c81d15..4dbadf7 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -450,14 +450,20 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 	packet->rcv_flags = 0;
 }
 
-static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
-			struct hfi1_other_headers *ohdr,
-			u64 rhf, u32 bth1, struct ib_grh *grh)
+void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
+			       bool do_cnp)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	u32 rqpn = 0;
-	u16 rlid;
-	u8 sc5, svc_type;
+	struct hfi1_ib_header *hdr = pkt->hdr;
+	struct hfi1_other_headers *ohdr = pkt->ohdr;
+	struct ib_grh *grh = NULL;
+	u32 rqpn = 0, bth1;
+	u16 rlid, dlid = be16_to_cpu(hdr->lrh[1]);
+	u8 sc, svc_type;
+	bool is_mcast = false;
+
+	if (pkt->rcv_flags & HFI1_HAS_GRH)
+		grh = &hdr->u.l.grh;
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_SMI:
@@ -466,6 +472,8 @@ static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 		rlid = be16_to_cpu(hdr->lrh[3]);
 		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 		svc_type = IB_CC_SVCTYPE_UD;
+		is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
 		break;
 	case IB_QPT_UC:
 		rlid = qp->remote_ah_attr.dlid;
@@ -481,24 +489,23 @@ static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 		return;
 	}
 
-	sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-	if (rhf_dc_info(rhf))
-		sc5 |= 0x10;
+	sc = hdr2sc((struct hfi1_message_header *)hdr, pkt->rhf);
 
-	if (bth1 & HFI1_FECN_SMASK) {
+	bth1 = be32_to_cpu(ohdr->bth[1]);
+	if (do_cnp && (bth1 & HFI1_FECN_SMASK)) {
 		u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
-		u16 dlid = be16_to_cpu(hdr->lrh[1]);
 
-		return_cnp(ibp, qp, rqpn, pkey, dlid, rlid, sc5, grh);
+		return_cnp(ibp, qp, rqpn, pkey, dlid, rlid, sc, grh);
 	}
 
-	if (bth1 & HFI1_BECN_SMASK) {
+	if (!is_mcast && (bth1 & HFI1_BECN_SMASK)) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 		u32 lqpn = bth1 & RVT_QPN_MASK;
-		u8 sl = ibp->sc_to_sl[sc5];
+		u8 sl = ibp->sc_to_sl[sc];
 
 		process_becn(ppd, sl, rlid, lqpn, rqpn, svc_type);
 	}
+
 }
 
 struct ps_mdata {
@@ -596,7 +603,6 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		struct rvt_qp *qp;
 		struct hfi1_ib_header *hdr;
 		struct hfi1_other_headers *ohdr;
-		struct ib_grh *grh = NULL;
 		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 		u64 rhf = rhf_to_cpu(rhf_addr);
 		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
@@ -616,14 +622,13 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 			hfi1_get_msgheader(dd, rhf_addr);
 		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
 
-		if (lnh == HFI1_LRH_BTH) {
+		if (lnh == HFI1_LRH_BTH)
 			ohdr = &hdr->u.oth;
-		} else if (lnh == HFI1_LRH_GRH) {
+		else if (lnh == HFI1_LRH_GRH)
 			ohdr = &hdr->u.l.oth;
-			grh = &hdr->u.l.grh;
-		} else {
+		else
 			goto next; /* just in case */
-		}
+
 		bth1 = be32_to_cpu(ohdr->bth[1]);
 		is_ecn = !!(bth1 & (HFI1_FECN_SMASK | HFI1_BECN_SMASK));
 
@@ -639,7 +644,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 			goto next;
 		}
 
-		process_ecn(qp, hdr, ohdr, rhf, bth1, grh);
+		process_ecn(qp, packet, true);
 		rcu_read_unlock();
 
 		/* turn off BECN, FECN */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index c433eb8..7df4cb2 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1583,6 +1583,22 @@ static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u8 port)
 	return &dd->pport[pidx].ibport_data;
 }
 
+void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
+			       bool do_cnp);
+static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
+			       bool do_cnp)
+{
+	struct hfi1_other_headers *ohdr = pkt->ohdr;
+	u32 bth1;
+
+	bth1 = be32_to_cpu(ohdr->bth[1]);
+	if (unlikely(bth1 & (HFI1_BECN_SMASK | HFI1_FECN_SMASK))) {
+		hfi1_process_ecn_slowpath(qp, pkt, do_cnp);
+		return bth1 & HFI1_FECN_SMASK;
+	}
+	return false;
+}
+
 /*
  * Return the indexed PKEY from the port PKEY table.
  */
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 3aeb832..bd4baa4 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2086,7 +2086,6 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_other_headers *ohdr = packet->ohdr;
 	u32 bth0, opcode;
 	u32 hdrsize = packet->hlen;
@@ -2097,7 +2096,6 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	int diff;
 	struct ib_reth *reth;
 	unsigned long flags;
-	u32 bth1;
 	int ret, is_fecn = 0;
 	int copy_last = 0;
 
@@ -2105,22 +2103,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	if (hfi1_ruc_check_hdr(ibp, hdr, rcv_flags & HFI1_HAS_GRH, qp, bth0))
 		return;
 
-	bth1 = be32_to_cpu(ohdr->bth[1]);
-	if (unlikely(bth1 & (HFI1_BECN_SMASK | HFI1_FECN_SMASK))) {
-		if (bth1 & HFI1_BECN_SMASK) {
-			u16 rlid = qp->remote_ah_attr.dlid;
-			u32 lqpn, rqpn;
-
-			lqpn = qp->ibqp.qp_num;
-			rqpn = qp->remote_qpn;
-			process_becn(
-				ppd,
-				qp->remote_ah_attr.sl,
-				rlid, lqpn, rqpn,
-				IB_CC_SVCTYPE_RC);
-		}
-		is_fecn = bth1 & HFI1_FECN_SMASK;
-	}
+	is_fecn = process_ecn(qp, packet, false);
 
 	psn = be32_to_cpu(ohdr->bth[2]);
 	opcode = (bth0 >> 24) & 0xff;
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index df773d4..b7a2531 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -294,46 +294,12 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	struct ib_reth *reth;
 	int has_grh = rcv_flags & HFI1_HAS_GRH;
 	int ret;
-	u32 bth1;
 
 	bth0 = be32_to_cpu(ohdr->bth[0]);
 	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, bth0))
 		return;
 
-	bth1 = be32_to_cpu(ohdr->bth[1]);
-	if (unlikely(bth1 & (HFI1_BECN_SMASK | HFI1_FECN_SMASK))) {
-		if (bth1 & HFI1_BECN_SMASK) {
-			struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-			u32 rqpn, lqpn;
-			u16 rlid = be16_to_cpu(hdr->lrh[3]);
-			u8 sl, sc5;
-
-			lqpn = bth1 & RVT_QPN_MASK;
-			rqpn = qp->remote_qpn;
-
-			sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
-			sl = ibp->sc_to_sl[sc5];
-
-			process_becn(ppd, sl, rlid, lqpn, rqpn,
-				     IB_CC_SVCTYPE_UC);
-		}
-
-		if (bth1 & HFI1_FECN_SMASK) {
-			struct ib_grh *grh = NULL;
-			u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
-			u16 slid = be16_to_cpu(hdr->lrh[3]);
-			u16 dlid = be16_to_cpu(hdr->lrh[1]);
-			u32 src_qp = qp->remote_qpn;
-			u8 sc5;
-
-			sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
-			if (has_grh)
-				grh = &hdr->u.l.grh;
-
-			return_cnp(ibp, qp, src_qp, pkey, dlid, slid, sc5,
-				   grh);
-		}
-	}
+	process_ecn(qp, packet, true);
 
 	psn = be32_to_cpu(ohdr->bth[2]);
 	opcode = (bth0 >> 24) & 0xff;
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index be91f6f..02488c6 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -679,29 +679,10 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
 	u8 sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
-	u32 bth1;
-	int is_mcast;
-	struct ib_grh *grh = NULL;
 
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
 	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 	dlid = be16_to_cpu(hdr->lrh[1]);
-	is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
-			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
-	bth1 = be32_to_cpu(ohdr->bth[1]);
-	if (unlikely(bth1 & HFI1_BECN_SMASK)) {
-		/*
-		 * In pre-B0 h/w the CNP_OPCODE is handled via an
-		 * error path.
-		 */
-		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
-		u8 sl;
-
-		sl = ibp->sc_to_sl[sc5];
-
-		process_becn(ppd, sl, 0, lqpn, 0, IB_CC_SVCTYPE_UD);
-	}
 
 	/*
 	 * The opcode is in the low byte when its in network order
@@ -712,11 +693,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 
 	pkey = (u16)be32_to_cpu(ohdr->bth[0]);
 
-	if (!is_mcast && (opcode != IB_OPCODE_CNP) && bth1 & HFI1_FECN_SMASK) {
-		u16 slid = be16_to_cpu(hdr->lrh[3]);
+	process_ecn(qp, packet, (opcode != IB_OPCODE_CNP));
 
-		return_cnp(ibp, qp, src_qp, pkey, dlid, slid, sc5, grh);
-	}
 	/*
 	 * Get the number of bytes the message was padded by
 	 * and drop incomplete packets.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
