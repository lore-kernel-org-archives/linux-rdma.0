From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/19] IB/hfi1: Add functions to parse 9B headers
Date: Fri, 28 Apr 2017 10:39:44 -0700
Message-ID: <20170428173942.23960.11221.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428173443.23960.32602.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These inline functions improve code readability by
enabling callers to read specific fields from the
header without knowledge of byte offsets.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   13 ++++----
 drivers/infiniband/hw/hfi1/hfi.h    |    3 +-
 drivers/infiniband/hw/hfi1/rc.c     |   14 ++++----
 drivers/infiniband/hw/hfi1/ruc.c    |   24 +++++++-------
 drivers/infiniband/hw/hfi1/trace.c  |    5 +--
 drivers/infiniband/hw/hfi1/uc.c     |    8 ++---
 drivers/infiniband/hw/hfi1/ud.c     |   14 ++++----
 drivers/infiniband/hw/hfi1/verbs.c  |    8 ++---
 include/rdma/ib_hdrs.h              |   60 +++++++++++++++++++++++++++++++++++
 9 files changed, 102 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index d731b5e..7e6d86b 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -284,7 +284,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 {
 	struct ib_header *rhdr = packet->hdr;
 	u32 rte = rhf_rcv_type_err(packet->rhf);
-	int lnh = be16_to_cpu(rhdr->lrh[0]) & 3;
+	int lnh = ib_get_lnh(rhdr);
 	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_devdata *dd = ppd->dd;
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
@@ -296,7 +296,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		/* For TIDERR and RC QPs preemptively schedule a NAK */
 		struct ib_other_headers *ohdr = NULL;
 		u32 tlen = rhf_pkt_len(packet->rhf); /* in bytes */
-		u16 lid  = be16_to_cpu(rhdr->lrh[1]);
+		u16 lid  = ib_get_dlid(rhdr);
 		u32 qp_num;
 		u32 rcv_flags = 0;
 
@@ -415,7 +415,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 				svc_type = IB_CC_SVCTYPE_UD;
 				break;
 			case IB_QPT_UC:
-				rlid = be16_to_cpu(rhdr->lrh[3]);
+				rlid = ib_get_slid(rhdr);
 				rqpn = qp->remote_qpn;
 				svc_type = IB_CC_SVCTYPE_UC;
 				break;
@@ -461,7 +461,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	struct ib_other_headers *ohdr = pkt->ohdr;
 	struct ib_grh *grh = NULL;
 	u32 rqpn = 0, bth1;
-	u16 rlid, dlid = be16_to_cpu(hdr->lrh[1]);
+	u16 rlid, dlid = ib_get_dlid(hdr);
 	u8 sc, svc_type;
 	bool is_mcast = false;
 
@@ -472,7 +472,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
-		rlid = be16_to_cpu(hdr->lrh[3]);
+		rlid = ib_get_slid(hdr);
 		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 		svc_type = IB_CC_SVCTYPE_UD;
 		is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
@@ -622,8 +622,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 
 		packet->hdr = hfi1_get_msgheader(dd, rhf_addr);
 		hdr = packet->hdr;
-
-		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+		lnh = ib_get_lnh(hdr);
 
 		if (lnh == HFI1_LRH_BTH) {
 			packet->ohdr = &hdr->u.oth;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 8509502..1d9436c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1263,8 +1263,7 @@ static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 /* extract service channel from header and rhf */
 static inline int hfi1_9B_get_sc5(struct ib_header *hdr, u64 rhf)
 {
-	return ((be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf) |
-	       ((!!(rhf_dc_info(rhf))) << 4);
+	return ib_get_sc(hdr) | ((!!(rhf_dc_info(rhf))) << 4);
 }
 
 #define HFI1_JKEY_WIDTH       16
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 0e56578..623209a 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -994,12 +994,12 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		return;
 
 	/* Find out where the BTH is */
-	if ((be16_to_cpu(hdr->lrh[0]) & 3) == HFI1_LRH_BTH)
+	if (ib_get_lnh(hdr) == HFI1_LRH_BTH)
 		ohdr = &hdr->u.oth;
 	else
 		ohdr = &hdr->u.l.oth;
 
-	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
+	opcode = ib_bth_get_opcode(ohdr);
 	if (opcode >= OP(RDMA_READ_RESPONSE_FIRST) &&
 	    opcode <= OP(ATOMIC_ACKNOWLEDGE)) {
 		WARN_ON(!qp->s_rdma_ack_cnt);
@@ -1524,7 +1524,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		if (!do_rc_ack(qp, aeth, psn, opcode, 0, rcd))
 			goto ack_done;
 		/* Get the number of bytes the message was padded by. */
-		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/*
 		 * Check that the data size is >= 0 && <= pmtu.
 		 * Remember to account for ICRC (4).
@@ -1548,7 +1548,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
 			goto ack_op_err;
 		/* Get the number of bytes the message was padded by. */
-		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/*
 		 * Check that the data size is >= 1 && <= pmtu.
 		 * Remember to account for ICRC (4).
@@ -1942,7 +1942,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	is_fecn = process_ecn(qp, packet, false);
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode = (bth0 >> 24) & 0xff;
+	opcode = ib_bth_get_opcode(ohdr);
 
 	/*
 	 * Process responses (ACKs) before anything else.  Note that the
@@ -2073,7 +2073,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		wc.ex.imm_data = 0;
 send_last:
 		/* Get the number of bytes the message was padded by. */
-		pad = (bth0 >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/* Check for invalid length. */
 		/* LAST len should be >= 1 */
 		if (unlikely(tlen < (hdrsize + pad + 4)))
@@ -2386,7 +2386,7 @@ void hfi1_rc_hdrerr(
 		return;
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode = (bth0 >> 24) & 0xff;
+	opcode = ib_bth_get_opcode(ohdr);
 
 	/* Only deal with RDMA Writes for now */
 	if (opcode < IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST) {
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index eeb650d..2730915 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -238,18 +238,18 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 				qp->alt_ah_attr.grh.dgid.global.interface_id))
 				goto err;
 		}
-		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
-					    sc5, be16_to_cpu(hdr->lrh[3])))) {
+		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0, sc5,
+					    ib_get_slid(hdr)))) {
 			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
 				       (u16)bth0,
-				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
+				       ib_get_sl(hdr),
 				       0, qp->ibqp.qp_num,
-				       be16_to_cpu(hdr->lrh[3]),
-				       be16_to_cpu(hdr->lrh[1]));
+				       ib_get_slid(hdr),
+				       ib_get_dlid(hdr));
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->alt_ah_attr.dlid ||
+		if (ib_get_slid(hdr) != qp->alt_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->alt_ah_attr.port_num)
 			goto err;
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -273,18 +273,18 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 			     qp->remote_ah_attr.grh.dgid.global.interface_id))
 				goto err;
 		}
-		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
-					    sc5, be16_to_cpu(hdr->lrh[3])))) {
+		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0, sc5,
+					    ib_get_slid(hdr)))) {
 			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
 				       (u16)bth0,
-				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
+				       ib_get_sl(hdr),
 				       0, qp->ibqp.qp_num,
-				       be16_to_cpu(hdr->lrh[3]),
-				       be16_to_cpu(hdr->lrh[1]));
+				       ib_get_slid(hdr),
+				       ib_get_dlid(hdr));
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->remote_ah_attr.dlid ||
+		if (ib_get_slid(hdr) != qp->remote_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->port_num)
 			goto err;
 		if (qp->s_mig_state == IB_MIG_REARM &&
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index e86798a..eafae48 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -51,13 +51,12 @@ u8 ibhdr_exhdr_len(struct ib_header *hdr)
 {
 	struct ib_other_headers *ohdr;
 	u8 opcode;
-	u8 lnh = (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
 
-	if (lnh == HFI1_LRH_BTH)
+	if (ib_get_lnh(hdr) == HFI1_LRH_BTH)
 		ohdr = &hdr->u.oth;
 	else
 		ohdr = &hdr->u.l.oth;
-	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
+	opcode = ib_bth_get_opcode(ohdr);
 	return hdr_len_by_opcode[opcode] == 0 ?
 	       0 : hdr_len_by_opcode[opcode] - (12 + 8);
 }
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 4b2a840..f0bdb10 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -320,7 +320,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	process_ecn(qp, packet, true);
 
 	psn = be32_to_cpu(ohdr->bth[2]);
-	opcode = (bth0 >> 24) & 0xff;
+	opcode = ib_bth_get_opcode(ohdr);
 
 	/* Compare the PSN verses the expected PSN. */
 	if (unlikely(cmp_psn(psn, qp->r_psn) != 0)) {
@@ -433,7 +433,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.wc_flags = 0;
 send_last:
 		/* Get the number of bytes the message was padded by. */
-		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/* Check for invalid length. */
 		/* LAST len should be >= 1 */
 		if (unlikely(tlen < (hdrsize + pad + 4)))
@@ -528,7 +528,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.wc_flags = IB_WC_WITH_IMM;
 
 		/* Get the number of bytes the message was padded by. */
-		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/* Check for invalid length. */
 		/* LAST len should be >= 1 */
 		if (unlikely(tlen < (hdrsize + pad + 4)))
@@ -555,7 +555,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	case OP(RDMA_WRITE_LAST):
 rdma_last:
 		/* Get the number of bytes the message was padded by. */
-		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		pad = ib_bth_get_pad(ohdr);
 		/* Check for invalid length. */
 		/* LAST len should be >= 1 */
 		if (unlikely(tlen < (hdrsize + pad + 4)))
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index fd105cf..8b3403a 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -688,18 +688,16 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
 	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
-	dlid = be16_to_cpu(hdr->lrh[1]);
+	dlid = ib_get_dlid(hdr);
 	bth1 = be32_to_cpu(ohdr->bth[1]);
-	slid = be16_to_cpu(hdr->lrh[3]);
-	pkey = (u16)be32_to_cpu(ohdr->bth[0]);
-	sl = (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
-	extra_bytes = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+	slid = ib_get_slid(hdr);
+	pkey = ib_bth_get_pkey(ohdr);
+	opcode = ib_bth_get_opcode(ohdr);
+	sl = ib_get_sl(hdr);
+	extra_bytes = ib_bth_get_pad(ohdr);
 	extra_bytes += (SIZE_OF_CRC << 2);
 	sl_from_sc = ibp->sc_to_sl[sc5];
 
-	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
-	opcode &= 0xff;
-
 	process_ecn(qp, packet, (opcode != IB_OPCODE_CNP));
 	/*
 	 * Get the number of bytes the message was padded by
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 66a2378..7f49719 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -571,7 +571,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	u16 lid;
 
 	/* Check for GRH */
-	lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+	lnh = ib_get_lnh(hdr);
 	if (lnh == HFI1_LRH_BTH) {
 		packet->ohdr = &hdr->u.oth;
 	} else if (lnh == HFI1_LRH_GRH) {
@@ -590,12 +590,12 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 
 	trace_input_ibhdr(rcd->dd, hdr);
 
-	opcode = (be32_to_cpu(packet->ohdr->bth[0]) >> 24);
+	opcode = ib_bth_get_opcode(packet->ohdr);
 	inc_opstats(tlen, &rcd->opstats->stats[opcode]);
 
 	/* Get the destination QP number. */
 	qp_num = be32_to_cpu(packet->ohdr->bth[1]) & RVT_QPN_MASK;
-	lid = be16_to_cpu(hdr->lrh[1]);
+	lid = ib_get_dlid(hdr);
 	if (unlikely((lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
 		     (lid != be16_to_cpu(IB_LID_PERMISSIVE)))) {
 		struct rvt_mcast *mcast;
@@ -1230,7 +1230,7 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 
 	hdr = &ps->s_txreq->phdr.hdr;
 	/* locate the pkey within the headers */
-	lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+	lnh = ib_get_lnh(hdr);
 	if (lnh == HFI1_LRH_GRH)
 		ohdr = &hdr->u.l.oth;
 	else
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index c755325..9cf42bc 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -181,4 +181,64 @@ static inline void put_ib_ateth_compare(u64 val, struct ib_atomic_eth *ateth)
 	ib_u64_put(val, &ateth->compare_data);
 }
 
+/*
+ * 9B/IB Packet Format
+ */
+#define IB_LNH_MASK		3
+#define IB_SC_MASK		0xf
+#define IB_SC_SHIFT		12
+#define IB_SL_MASK		0xf
+#define IB_SL_SHIFT		4
+
+static inline u8 ib_get_lnh(struct ib_header *hdr)
+{
+	return (be16_to_cpu(hdr->lrh[0]) & IB_LNH_MASK);
+}
+
+static inline u8 ib_get_sc(struct ib_header *hdr)
+{
+	return ((be16_to_cpu(hdr->lrh[0]) >> IB_SC_SHIFT) & IB_SC_MASK);
+}
+
+static inline u8 ib_get_sl(struct ib_header *hdr)
+{
+	return ((be16_to_cpu(hdr->lrh[0]) >> IB_SL_SHIFT) & IB_SL_MASK);
+}
+
+static inline u16 ib_get_dlid(struct ib_header *hdr)
+{
+	return (be16_to_cpu(hdr->lrh[1]));
+}
+
+static inline u16 ib_get_slid(struct ib_header *hdr)
+{
+	return (be16_to_cpu(hdr->lrh[3]));
+}
+
+/*
+ * BTH
+ */
+#define IB_BTH_OPCODE_MASK	0xff
+#define IB_BTH_OPCODE_SHIFT	24
+#define IB_BTH_PAD_MASK	3
+#define IB_BTH_PKEY_MASK	0xffff
+#define IB_BTH_PAD_SHIFT	20
+
+static inline u8 ib_bth_get_pad(struct ib_other_headers *ohdr)
+{
+	return ((be32_to_cpu(ohdr->bth[0]) >> IB_BTH_PAD_SHIFT) &
+		   IB_BTH_PAD_MASK);
+}
+
+static inline u16 ib_bth_get_pkey(struct ib_other_headers *ohdr)
+{
+	return (be32_to_cpu(ohdr->bth[0]) & IB_BTH_PKEY_MASK);
+}
+
+static inline u8 ib_bth_get_opcode(struct ib_other_headers *ohdr)
+{
+	return ((be32_to_cpu(ohdr->bth[0]) >> IB_BTH_OPCODE_SHIFT) &
+		   IB_BTH_OPCODE_MASK);
+}
+
 #endif                          /* IB_HDRS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
