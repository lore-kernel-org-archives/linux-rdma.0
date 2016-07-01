From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/hfi1: Correct issues with sc5 computation
Date: Fri, 01 Jul 2016 15:57:02 -0700
Message-ID: <20160701225701.19381.65376.stgit@scvm10.sc.intel.com>
References: <20160701225447.19381.90323.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225447.19381.90323.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are several computatations of the sc in the
ud receive routine.

Besides the code duplication, all are wrong when the
sc is greater than 15.   In that case the code incorrectly
or's a 1 into the computed sc instead of 1 shifted left
by 4.

Fix precomputed sc5 by using an already implemented routine
hdr2sc() and deleting flawed duplicated code.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.6+
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ud.c |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 1e503ad..be91f6f 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -678,8 +678,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
-	bool sc4_bit = has_sc4_bit(packet);
-	u8 sc;
+	u8 sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
 	u32 bth1;
 	int is_mcast;
 	struct ib_grh *grh = NULL;
@@ -697,10 +696,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		 */
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 		u32 lqpn =  be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
-		u8 sl, sc5;
+		u8 sl;
 
-		sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-		sc5 |= sc4_bit;
 		sl = ibp->sc_to_sl[sc5];
 
 		process_becn(ppd, sl, 0, lqpn, 0, IB_CC_SVCTYPE_UD);
@@ -717,10 +714,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 
 	if (!is_mcast && (opcode != IB_OPCODE_CNP) && bth1 & HFI1_FECN_SMASK) {
 		u16 slid = be16_to_cpu(hdr->lrh[3]);
-		u8 sc5;
-
-		sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-		sc5 |= sc4_bit;
 
 		return_cnp(ibp, qp, src_qp, pkey, dlid, slid, sc5, grh);
 	}
@@ -745,10 +738,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		if (qp->ibqp.qp_num > 1) {
 			struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 			u16 slid;
-			u8 sc5;
-
-			sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-			sc5 |= sc4_bit;
 
 			slid = be16_to_cpu(hdr->lrh[3]);
 			if (unlikely(rcv_pkey_check(ppd, pkey, sc5, slid))) {
@@ -790,10 +779,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		/* Received on QP0, and so by definition, this is an SMP */
 		struct opa_smp *smp = (struct opa_smp *)data;
 		u16 slid = be16_to_cpu(hdr->lrh[3]);
-		u8 sc5;
-
-		sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-		sc5 |= sc4_bit;
 
 		if (opa_smp_check(ibp, pkey, sc5, qp, slid, smp))
 			goto drop;
@@ -890,9 +875,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	}
 
 	wc.slid = be16_to_cpu(hdr->lrh[3]);
-	sc = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-	sc |= sc4_bit;
-	wc.sl = ibp->sc_to_sl[sc];
+	wc.sl = ibp->sc_to_sl[sc5];
 
 	/*
 	 * Save the LMC lower bits if the destination LID is a unicast LID.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
