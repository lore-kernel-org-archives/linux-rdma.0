From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/28] IB/hfi1: Cleanup UD packet handler.
Date: Mon, 25 Jul 2016 13:40:28 -0700
Message-ID: <20160725204027.4800.25840.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Cleanup hfi1_ud_rcv to not have to look at the packet
header fields multiple times. The fields are looked up
once and used throughout the function. Also fix sc
computation when validating MAD packets.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ud.c |   51 ++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 08a9c12..852c20f 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -664,13 +664,13 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	struct hfi1_other_headers *ohdr = packet->ohdr;
 	int opcode;
 	u32 hdrsize = packet->hlen;
-	u32 pad;
 	struct ib_wc wc;
 	u32 qkey;
 	u32 src_qp;
 	u16 dlid, pkey;
 	int mgmt_pkey_idx = -1;
 	struct hfi1_ibport *ibp = &packet->rcd->ppd->ibport_data;
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_ib_header *hdr = packet->hdr;
 	u32 rcv_flags = packet->rcv_flags;
 	void *data = packet->ebuf;
@@ -678,31 +678,34 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
 	u8 sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
+	u32 bth1;
+	u8 sl_from_sc, sl;
+	u16 slid;
+	u8 extra_bytes;
 
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
 	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & RVT_QPN_MASK;
 	dlid = be16_to_cpu(hdr->lrh[1]);
+	bth1 = be32_to_cpu(ohdr->bth[1]);
+	slid = be16_to_cpu(hdr->lrh[3]);
+	pkey = (u16)be32_to_cpu(ohdr->bth[0]);
+	sl = (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
+	extra_bytes = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+	extra_bytes += (SIZE_OF_CRC << 2);
+	sl_from_sc = ibp->sc_to_sl[sc5];
 
-	/*
-	 * The opcode is in the low byte when its in network order
-	 * (top byte when in host order).
-	 */
 	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
 	opcode &= 0xff;
 
-	pkey = (u16)be32_to_cpu(ohdr->bth[0]);
-
 	process_ecn(qp, packet, (opcode != IB_OPCODE_CNP));
-
 	/*
 	 * Get the number of bytes the message was padded by
 	 * and drop incomplete packets.
 	 */
-	pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
-	if (unlikely(tlen < (hdrsize + pad + 4)))
+	if (unlikely(tlen < (hdrsize + extra_bytes)))
 		goto drop;
 
-	tlen -= hdrsize + pad + 4;
+	tlen -= hdrsize + extra_bytes;
 
 	/*
 	 * Check that the permissive LID is only used on QP0
@@ -713,10 +716,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 			     hdr->lrh[3] == IB_LID_PERMISSIVE))
 			goto drop;
 		if (qp->ibqp.qp_num > 1) {
-			struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-			u16 slid;
-
-			slid = be16_to_cpu(hdr->lrh[3]);
 			if (unlikely(rcv_pkey_check(ppd, pkey, sc5, slid))) {
 				/*
 				 * Traps will not be sent for packets dropped
@@ -725,12 +724,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 				 * IB spec (release 1.3, section 10.9.4)
 				 */
 				hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
-					       pkey,
-					       (be16_to_cpu(hdr->lrh[0]) >> 4) &
-						0xF,
+					       pkey, sl,
 					       src_qp, qp->ibqp.qp_num,
-					       be16_to_cpu(hdr->lrh[3]),
-					       be16_to_cpu(hdr->lrh[1]));
+					       slid, dlid);
 				return;
 			}
 		} else {
@@ -740,22 +736,18 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 				goto drop;
 		}
 		if (unlikely(qkey != qp->qkey)) {
-			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey,
-				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey, sl,
 				       src_qp, qp->ibqp.qp_num,
-				       be16_to_cpu(hdr->lrh[3]),
-				       be16_to_cpu(hdr->lrh[1]));
+				       slid, dlid);
 			return;
 		}
 		/* Drop invalid MAD packets (see 13.5.3.1). */
 		if (unlikely(qp->ibqp.qp_num == 1 &&
-			     (tlen > 2048 ||
-			      (be16_to_cpu(hdr->lrh[0]) >> 12) == 15)))
+			     (tlen > 2048 || (sc5 == 0xF))))
 			goto drop;
 	} else {
 		/* Received on QP0, and so by definition, this is an SMP */
 		struct opa_smp *smp = (struct opa_smp *)data;
-		u16 slid = be16_to_cpu(hdr->lrh[3]);
 
 		if (opa_smp_check(ibp, pkey, sc5, qp, slid, smp))
 			goto drop;
@@ -838,7 +830,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	    qp->ibqp.qp_type == IB_QPT_SMI) {
 		if (mgmt_pkey_idx < 0) {
 			if (net_ratelimit()) {
-				struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 				struct hfi1_devdata *dd = ppd->dd;
 
 				dd_dev_err(dd, "QP type %d mgmt_pkey_idx < 0 and packet not dropped???\n",
@@ -851,8 +842,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		wc.pkey_index = 0;
 	}
 
-	wc.slid = be16_to_cpu(hdr->lrh[3]);
-	wc.sl = ibp->sc_to_sl[sc5];
+	wc.slid = slid;
+	wc.sl = sl_from_sc;
 
 	/*
 	 * Save the LMC lower bits if the destination LID is a unicast LID.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
