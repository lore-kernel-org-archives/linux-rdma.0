From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/6] IB/hfi1: Add functions to parse BTH/IB headers
Date: Fri, 12 May 2017 09:19:55 -0700
Message-ID: <20170512161952.1290.31552.stgit@scvm10.sc.intel.com>
References: <20170512161106.1290.45891.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512161106.1290.45891.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Improve code readablity by adding inline functions
to read specific BTH/IB fields without knowledge of
byte offsets.

Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    6 +--
 drivers/infiniband/hw/hfi1/rc.c     |    8 ++-
 drivers/infiniband/hw/hfi1/uc.c     |    2 -
 drivers/infiniband/hw/hfi1/ud.c     |    6 +--
 drivers/infiniband/hw/hfi1/verbs.c  |    6 +--
 include/rdma/ib_hdrs.h              |   84 +++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h             |    2 +
 include/rdma/rdmavt_qp.h            |    2 -
 8 files changed, 101 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index a50870e..0583479 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -286,7 +286,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			goto drop;
 		}
 		/* Get the destination QP number. */
-		qp_num = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
+		qp_num = ib_bth_get_qpn(ohdr);
 		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 			struct rvt_qp *qp;
 			unsigned long flags;
@@ -438,7 +438,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	case IB_QPT_GSI:
 	case IB_QPT_UD:
 		rlid = ib_get_slid(hdr);
-		rqpn = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
+		rqpn = ib_get_sqpn(ohdr);
 		svc_type = IB_CC_SVCTYPE_UD;
 		is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
 			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
@@ -461,7 +461,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	if (do_cnp && (bth1 & IB_FECN_SMASK)) {
-		u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
+		u16 pkey = ib_bth_get_pkey(ohdr);
 
 		return_cnp(ibp, qp, rqpn, pkey, dlid, rlid, sc, grh);
 	}
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 1080778..66e6843 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -765,7 +765,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 		ohdr->u.aeth = rvt_compute_aeth(qp);
 	sc5 = ibp->sl_to_sc[rdma_ah_get_sl(&qp->remote_ah_attr)];
 	/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-	pbc_flags |= ((!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT);
+	pbc_flags |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 	lrh0 |= (sc5 & 0xf) << 12 | (rdma_ah_get_sl(&qp->remote_ah_attr)
 				     & 0xf) << 4;
 	hdr.lrh[0] = cpu_to_be16(lrh0);
@@ -1009,7 +1009,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		return;
 	}
 
-	psn = be32_to_cpu(ohdr->bth[2]);
+	psn = ib_bth_get_psn(ohdr);
 	reset_sending_psn(qp, psn);
 
 	/*
@@ -1943,7 +1943,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 
 	is_fecn = process_ecn(qp, packet, false);
 
-	psn = be32_to_cpu(ohdr->bth[2]);
+	psn = ib_bth_get_psn(ohdr);
 	opcode = ib_bth_get_opcode(ohdr);
 
 	/*
@@ -2388,7 +2388,7 @@ void hfi1_rc_hdrerr(
 	if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, bth0))
 		return;
 
-	psn = be32_to_cpu(ohdr->bth[2]);
+	psn = ib_bth_get_psn(ohdr);
 	opcode = ib_bth_get_opcode(ohdr);
 
 	/* Only deal with RDMA Writes for now */
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 5da1e45..2a5650f 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -319,7 +319,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 
 	process_ecn(qp, packet, true);
 
-	psn = be32_to_cpu(ohdr->bth[2]);
+	psn = ib_bth_get_psn(ohdr);
 	opcode = ib_bth_get_opcode(ohdr);
 
 	/* Compare the PSN verses the expected PSN. */
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 6a4e95c..49fe179 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -549,7 +549,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	hdr.lrh[3] = cpu_to_be16(slid);
 
 	plen = 2 /* PBC */ + hwords;
-	pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+	pbc_flags |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 	vl = sc_to_vlt(ppd->dd, sc5);
 	pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	if (ctxt) {
@@ -689,8 +689,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	u16 slid;
 	u8 extra_bytes;
 
-	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
-	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
+	qkey = ib_get_qkey(ohdr);
+	src_qp = ib_get_sqpn(ohdr);
 	dlid = ib_get_dlid(hdr);
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	slid = ib_get_slid(hdr);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 90e7b77..128d291 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -595,7 +595,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	inc_opstats(tlen, &rcd->opstats->stats[opcode]);
 
 	/* Get the destination QP number. */
-	qp_num = be32_to_cpu(packet->ohdr->bth[1]) & RVT_QPN_MASK;
+	qp_num = ib_bth_get_qpn(packet->ohdr);
 	lid = ib_get_dlid(hdr);
 	if (unlikely((lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
 		     (lid != be16_to_cpu(IB_LID_PERMISSIVE)))) {
@@ -863,7 +863,7 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 			/* No vl15 here */
 			/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-			pbc |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+			pbc |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 
 			if (unlikely(hfi1_dbg_fault_opcode(qp, opcode, false)))
 				pbc = hfi1_fault_tx(qp, opcode, pbc);
@@ -999,7 +999,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		u8 opcode = get_opcode(&tx->phdr.hdr);
 
 		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-		pbc |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+		pbc |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 		if (unlikely(hfi1_dbg_fault_opcode(qp, opcode, false)))
 			pbc = hfi1_fault_tx(qp, opcode, pbc);
 		pbc = create_pbc(ppd, pbc, qp->srate_mbps, vl, plen);
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 5519f31..c124d51 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -193,8 +193,12 @@ static inline void put_ib_ateth_compare(u64 val, struct ib_atomic_eth *ateth)
 #define IB_LNH_MASK		3
 #define IB_SC_MASK		0xf
 #define IB_SC_SHIFT		12
+#define IB_SC5_MASK		0x10
 #define IB_SL_MASK		0xf
 #define IB_SL_SHIFT		4
+#define IB_SL_SHIFT		4
+#define IB_LVER_MASK	0xf
+#define IB_LVER_SHIFT	8
 
 static inline u8 ib_get_lnh(struct ib_header *hdr)
 {
@@ -206,6 +210,11 @@ static inline u8 ib_get_sc(struct ib_header *hdr)
 	return ((be16_to_cpu(hdr->lrh[0]) >> IB_SC_SHIFT) & IB_SC_MASK);
 }
 
+static inline bool ib_is_sc5(u16 sc5)
+{
+	return !!(sc5 & IB_SC5_MASK);
+}
+
 static inline u8 ib_get_sl(struct ib_header *hdr)
 {
 	return ((be16_to_cpu(hdr->lrh[0]) >> IB_SL_SHIFT) & IB_SL_MASK);
@@ -221,6 +230,27 @@ static inline u16 ib_get_slid(struct ib_header *hdr)
 	return (be16_to_cpu(hdr->lrh[3]));
 }
 
+static inline u8 ib_get_lver(struct ib_header *hdr)
+{
+	return (u8)((be16_to_cpu(hdr->lrh[0]) >> IB_LVER_SHIFT) &
+		   IB_LVER_MASK);
+}
+
+static inline u16 ib_get_len(struct ib_header *hdr)
+{
+	return (u16)(be16_to_cpu(hdr->lrh[2]));
+}
+
+static inline u32 ib_get_qkey(struct ib_other_headers *ohdr)
+{
+	return be32_to_cpu(ohdr->u.ud.deth[0]);
+}
+
+static inline u32 ib_get_sqpn(struct ib_other_headers *ohdr)
+{
+	return ((be32_to_cpu(ohdr->u.ud.deth[1])) & IB_QPN_MASK);
+}
+
 /*
  * BTH
  */
@@ -229,6 +259,14 @@ static inline u16 ib_get_slid(struct ib_header *hdr)
 #define IB_BTH_PAD_MASK	3
 #define IB_BTH_PKEY_MASK	0xffff
 #define IB_BTH_PAD_SHIFT	20
+#define IB_BTH_A_MASK		1
+#define IB_BTH_A_SHIFT		31
+#define IB_BTH_M_MASK		1
+#define IB_BTH_M_SHIFT		22
+#define IB_BTH_SE_MASK		1
+#define IB_BTH_SE_SHIFT	23
+#define IB_BTH_TVER_MASK	0xf
+#define IB_BTH_TVER_SHIFT	16
 
 static inline u8 ib_bth_get_pad(struct ib_other_headers *ohdr)
 {
@@ -247,4 +285,50 @@ static inline u8 ib_bth_get_opcode(struct ib_other_headers *ohdr)
 		   IB_BTH_OPCODE_MASK);
 }
 
+static inline u8 ib_bth_get_ackreq(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[2]) >> IB_BTH_A_SHIFT) &
+		   IB_BTH_A_MASK);
+}
+
+static inline u8 ib_bth_get_migreq(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[0]) >> IB_BTH_M_SHIFT) &
+		    IB_BTH_M_MASK);
+}
+
+static inline u8 ib_bth_get_se(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[0]) >> IB_BTH_SE_SHIFT) &
+		    IB_BTH_SE_MASK);
+}
+
+static inline u32 ib_bth_get_psn(struct ib_other_headers *ohdr)
+{
+	return (u32)(be32_to_cpu(ohdr->bth[2]));
+}
+
+static inline u32 ib_bth_get_qpn(struct ib_other_headers *ohdr)
+{
+	return (u32)((be32_to_cpu(ohdr->bth[1])) & IB_QPN_MASK);
+}
+
+static inline u8 ib_bth_get_becn(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[1]) >> IB_BECN_SHIFT) &
+		     IB_BECN_MASK);
+}
+
+static inline u8 ib_bth_get_fecn(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[1]) >> IB_FECN_SHIFT) &
+		    IB_FECN_MASK);
+}
+
+static inline u8 ib_bth_get_tver(struct ib_other_headers *ohdr)
+{
+	return (u8)((be32_to_cpu(ohdr->bth[0]) >> IB_BTH_TVER_SHIFT)  &
+		    IB_BTH_TVER_MASK);
+}
+
 #endif                          /* IB_HDRS_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f0cb490..785e927 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -663,6 +663,8 @@ struct ib_grh {
 	};
 };
 
+#define IB_QPN_MASK		0xFFFFFF
+
 enum {
 	IB_MULTICAST_QPN = 0xffffff
 };
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index be6472e..13f43b3 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -396,7 +396,7 @@ struct rvt_srq {
 #define RVT_QPNMAP_ENTRIES          (RVT_QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
 #define RVT_BITS_PER_PAGE           (PAGE_SIZE * BITS_PER_BYTE)
 #define RVT_BITS_PER_PAGE_MASK      (RVT_BITS_PER_PAGE - 1)
-#define RVT_QPN_MASK		    0xFFFFFF
+#define RVT_QPN_MASK		    IB_QPN_MASK
 
 /*
  * QPN-map pages start out as NULL, they get allocated upon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
