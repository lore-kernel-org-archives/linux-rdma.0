From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/21] IB/hfi1: Check P_KEY for all sent packets from user
 mode
Date: Tue, 12 Apr 2016 11:22:21 -0700
Message-ID: <20160412182209.23989.6931.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mikto Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add the P_KEY check for user-context mechanism for
both PIO and SDMA. For PIO, the
SendCtxtCheckEnable.DisallowKDETHPackets is set by
default. When the P_KEY is set,
SendCtxtCheckEnable.DisallowKDETHPackets is cleared.
For SDMA, a software check was included. This change
requires user processes to set the P_KEY before sending
any packets, otherwise, the sent packet will fail. The
original submission didn't have this check but it's
required.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mikto Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |    1 
 drivers/staging/rdma/hfi1/hfi.h       |    4 +
 drivers/staging/rdma/hfi1/user_sdma.c |    7 ++
 drivers/staging/rdma/hfi1/verbs.c     |  106 ++++++++++++++++++++-------------
 4 files changed, 77 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 56753c6..b0a0a0d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13751,6 +13751,7 @@ int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
 	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_PARTITION_KEY, reg);
 	reg = read_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE);
 	reg |= SEND_CTXT_CHECK_ENABLE_CHECK_PARTITION_KEY_SMASK;
+	reg &= ~SEND_CTXT_CHECK_ENABLE_DISALLOW_KDETH_PACKETS_SMASK;
 	write_kctxt_csr(dd, sctxt, SEND_CTXT_CHECK_ENABLE, reg);
 done:
 	return ret;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index ff04593..b1d4f60 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1333,6 +1333,9 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl,  u16 rlid, u32 lqpn,
 void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 		u32 pkey, u32 slid, u32 dlid, u8 sc5,
 		const struct ib_grh *old_grh);
+#define PKEY_CHECK_INVALID -1
+int egress_pkey_check(struct hfi1_pportdata *ppd, __be16 *lrh, __be32 *bth,
+		      u8 sc5, int8_t s_pkey_index);
 
 #define PACKET_EGRESS_TIMEOUT 350
 static inline void pause_for_credit_return(struct hfi1_devdata *dd)
@@ -1776,6 +1779,7 @@ extern struct mutex hfi1_mutex;
 
 #define HFI1_PKT_USER_SC_INTEGRITY					    \
 	(SEND_CTXT_CHECK_ENABLE_DISALLOW_NON_KDETH_PACKETS_SMASK	    \
+	| SEND_CTXT_CHECK_ENABLE_DISALLOW_KDETH_PACKETS_SMASK		\
 	| SEND_CTXT_CHECK_ENABLE_DISALLOW_BYPASS_SMASK		    \
 	| SEND_CTXT_CHECK_ENABLE_DISALLOW_GRH_SMASK)
 
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 635ddf8..0014c9c 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -600,6 +600,13 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		goto free_req;
 	}
 
+	/* Checking P_KEY for requests from user-space */
+	if (egress_pkey_check(dd->pport, req->hdr.lrh, req->hdr.bth, sc,
+			      PKEY_CHECK_INVALID)) {
+		ret = -EINVAL;
+		goto free_req;
+	}
+
 	/*
 	 * Also should check the BTH.lnh. If it says the next header is GRH then
 	 * the RXE parsing will be off and will land in the middle of the KDETH
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 89f2aad..c56c0cb 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1089,16 +1089,16 @@ bail:
 
 /*
  * egress_pkey_matches_entry - return 1 if the pkey matches ent (ent
- * being an entry from the ingress partition key table), return 0
+ * being an entry from the partition key table), return 0
  * otherwise. Use the matching criteria for egress partition keys
  * specified in the OPAv1 spec., section 9.1l.7.
  */
 static inline int egress_pkey_matches_entry(u16 pkey, u16 ent)
 {
 	u16 mkey = pkey & PKEY_LOW_15_MASK;
-	u16 ment = ent & PKEY_LOW_15_MASK;
+	u16 mentry = ent & PKEY_LOW_15_MASK;
 
-	if (mkey == ment) {
+	if (mkey == mentry) {
 		/*
 		 * If pkey[15] is set (full partition member),
 		 * is bit 15 in the corresponding table element
@@ -1111,32 +1111,32 @@ static inline int egress_pkey_matches_entry(u16 pkey, u16 ent)
 	return 0;
 }
 
-/*
- * egress_pkey_check - return 0 if hdr's pkey matches according to the
- * criteria in the OPAv1 spec., section 9.11.7.
+/**
+ * egress_pkey_check - check P_KEY of a packet
+ * @ppd:    Physical IB port data
+ * @lrh: Local route header
+ * @bth: Base transport header
+ * @sc5:    SC for packet
+ * @s_pkey_index: It will be used for look up optimization for kernel contexts
+ * only. If it is negative value, then it means user contexts is calling this
+ * function.
+ *
+ * It checks if hdr's pkey is valid.
+ *
+ * Return: 0 on success, otherwise, 1
  */
-static inline int egress_pkey_check(struct hfi1_pportdata *ppd,
-				    struct hfi1_ib_header *hdr,
-				    struct rvt_qp *qp)
+int egress_pkey_check(struct hfi1_pportdata *ppd, __be16 *lrh, __be32 *bth,
+		      u8 sc5, int8_t s_pkey_index)
 {
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_other_headers *ohdr;
 	struct hfi1_devdata *dd;
-	int i = 0;
+	int i;
 	u16 pkey;
-	u8 lnh, sc5 = priv->s_sc;
+	int is_user_ctxt_mechanism = (s_pkey_index < 0);
 
 	if (!(ppd->part_enforce & HFI1_PART_ENFORCE_OUT))
 		return 0;
 
-	/* locate the pkey within the headers */
-	lnh = be16_to_cpu(hdr->lrh[0]) & 3;
-	if (lnh == HFI1_LRH_GRH)
-		ohdr = &hdr->u.l.oth;
-	else
-		ohdr = &hdr->u.oth;
-
-	pkey = (u16)be32_to_cpu(ohdr->bth[0]);
+	pkey = (u16)be32_to_cpu(bth[0]);
 
 	/* If SC15, pkey[0:14] must be 0x7fff */
 	if ((sc5 == 0xf) && ((pkey & PKEY_LOW_15_MASK) != PKEY_LOW_15_MASK))
@@ -1146,28 +1146,37 @@ static inline int egress_pkey_check(struct hfi1_pportdata *ppd,
 	if ((pkey & PKEY_LOW_15_MASK) == 0)
 		goto bad;
 
-	/* The most likely matching pkey has index qp->s_pkey_index */
-	if (unlikely(!egress_pkey_matches_entry(pkey,
-						ppd->pkeys
-						[qp->s_pkey_index]))) {
-		/* no match - try the entire table */
-		for (; i < MAX_PKEY_VALUES; i++) {
-			if (egress_pkey_matches_entry(pkey, ppd->pkeys[i]))
-				break;
-		}
+	/*
+	 * For the kernel contexts only, if a qp is passed into the function,
+	 * the most likely matching pkey has index qp->s_pkey_index
+	 */
+	if (!is_user_ctxt_mechanism &&
+	    egress_pkey_matches_entry(pkey, ppd->pkeys[s_pkey_index])) {
+		return 0;
 	}
 
-	if (i < MAX_PKEY_VALUES)
-		return 0;
+	for (i = 0; i < MAX_PKEY_VALUES; i++) {
+		if (egress_pkey_matches_entry(pkey, ppd->pkeys[i]))
+			return 0;
+	}
 bad:
-	incr_cntr64(&ppd->port_xmit_constraint_errors);
-	dd = ppd->dd;
-	if (!(dd->err_info_xmit_constraint.status & OPA_EI_STATUS_SMASK)) {
-		u16 slid = be16_to_cpu(hdr->lrh[3]);
-
-		dd->err_info_xmit_constraint.status |= OPA_EI_STATUS_SMASK;
-		dd->err_info_xmit_constraint.slid = slid;
-		dd->err_info_xmit_constraint.pkey = pkey;
+	/*
+	 * For the user-context mechanism, the P_KEY check would only happen
+	 * once per SDMA request, not once per packet.  Therefore, there's no
+	 * need to increment the counter for the user-context mechanism.
+	 */
+	if (!is_user_ctxt_mechanism) {
+		incr_cntr64(&ppd->port_xmit_constraint_errors);
+		dd = ppd->dd;
+		if (!(dd->err_info_xmit_constraint.status &
+		      OPA_EI_STATUS_SMASK)) {
+			u16 slid = be16_to_cpu(lrh[3]);
+
+			dd->err_info_xmit_constraint.status |=
+				OPA_EI_STATUS_SMASK;
+			dd->err_info_xmit_constraint.slid = slid;
+			dd->err_info_xmit_constraint.pkey = pkey;
+		}
 	}
 	return 1;
 }
@@ -1227,11 +1236,26 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
+	struct hfi1_other_headers *ohdr;
+	struct hfi1_ib_header *hdr;
 	send_routine sr;
 	int ret;
+	u8 lnh;
+
+	hdr = &ps->s_txreq->phdr.hdr;
+	/* locate the pkey within the headers */
+	lnh = be16_to_cpu(hdr->lrh[0]) & 3;
+	if (lnh == HFI1_LRH_GRH)
+		ohdr = &hdr->u.l.oth;
+	else
+		ohdr = &hdr->u.oth;
 
 	sr = get_send_routine(qp, ps->s_txreq);
-	ret = egress_pkey_check(dd->pport, &ps->s_txreq->phdr.hdr, qp);
+	ret = egress_pkey_check(dd->pport,
+				hdr->lrh,
+				ohdr->bth,
+				priv->s_sc,
+				qp->s_pkey_index);
 	if (unlikely(ret)) {
 		/*
 		 * The value we are returning here does not get propagated to

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
