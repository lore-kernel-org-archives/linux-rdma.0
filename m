From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 20/27] IB/hfi1: Add support to process 16B header
 errors
Date: Fri, 04 Aug 2017 13:54:10 -0700
Message-ID: <20170804205409.17853.54638.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Enhance hdr_rcverr() to also handle errors during
16B bypass packet receive.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   58 ++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/hfi.h    |   13 +++++++-
 drivers/infiniband/hw/hfi1/ruc.c    |   31 ++++++++++++-------
 drivers/infiniband/hw/hfi1/ud.c     |    3 +-
 drivers/infiniband/hw/hfi1/verbs.c  |   39 +++++++++++++++++++-----
 drivers/infiniband/hw/hfi1/verbs.h  |    1 +
 6 files changed, 112 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 5280d82..ae6a90d 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -269,8 +269,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 {
 	struct ib_header *rhdr = packet->hdr;
 	u32 rte = rhf_rcv_type_err(packet->rhf);
-	u8 lnh = ib_get_lnh(rhdr);
-	bool has_grh = false;
+	u32 mlid_base;
 	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_devdata *dd = ppd->dd;
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
@@ -278,14 +277,20 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 	if (packet->rhf & (RHF_VCRC_ERR | RHF_ICRC_ERR))
 		return;
 
-	if (lnh == HFI1_LRH_BTH) {
-		packet->ohdr = &rhdr->u.oth;
-	} else if (lnh == HFI1_LRH_GRH) {
-		has_grh = true;
-		packet->ohdr = &rhdr->u.l.oth;
-		packet->grh = &rhdr->u.l.grh;
-	} else {
+	if (packet->etype == RHF_RCV_TYPE_BYPASS) {
 		goto drop;
+	} else {
+		u8 lnh = ib_get_lnh(rhdr);
+
+		mlid_base = be16_to_cpu(IB_MULTICAST_LID_BASE);
+		if (lnh == HFI1_LRH_BTH) {
+			packet->ohdr = &rhdr->u.oth;
+		} else if (lnh == HFI1_LRH_GRH) {
+			packet->ohdr = &rhdr->u.l.oth;
+			packet->grh = &rhdr->u.l.grh;
+		} else {
+			goto drop;
+		}
 	}
 
 	if (packet->rhf & RHF_TID_ERR) {
@@ -293,14 +298,13 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		u32 tlen = rhf_pkt_len(packet->rhf); /* in bytes */
 		u32 dlid = ib_get_dlid(rhdr);
 		u32 qp_num;
-		u32 mlid_base = be16_to_cpu(IB_MULTICAST_LID_BASE);
 
 		/* Sanity check packet */
 		if (tlen < 24)
 			goto drop;
 
 		/* Check for GRH */
-		if (has_grh) {
+		if (packet->grh) {
 			u32 vtf;
 			struct ib_grh *grh = packet->grh;
 
@@ -1370,6 +1374,35 @@ static inline void hfi1_setup_ib_header(struct hfi1_packet *packet)
 	packet->hlen = (u8 *)packet->rhf_addr - (u8 *)packet->hdr;
 }
 
+static int hfi1_bypass_ingress_pkt_check(struct hfi1_packet *packet)
+{
+	struct hfi1_pportdata *ppd = packet->rcd->ppd;
+
+	/* slid and dlid cannot be 0 */
+	if ((!packet->slid) || (!packet->dlid))
+		return -EINVAL;
+
+	/* Compare port lid with incoming packet dlid */
+	if ((!(hfi1_is_16B_mcast(packet->dlid))) &&
+	    (packet->dlid !=
+		opa_get_lid(be32_to_cpu(OPA_LID_PERMISSIVE), 16B))) {
+		if (packet->dlid != ppd->lid)
+			return -EINVAL;
+	}
+
+	/* No multicast packets with SC15 */
+	if ((hfi1_is_16B_mcast(packet->dlid)) && (packet->sc == 0xF))
+		return -EINVAL;
+
+	/* Packets with permissive DLID always on SC15 */
+	if ((packet->dlid == opa_get_lid(be32_to_cpu(OPA_LID_PERMISSIVE),
+					 16B)) &&
+	    (packet->sc != 0xF))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int hfi1_setup_9B_packet(struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp = rcd_to_iport(packet->rcd);
@@ -1479,6 +1512,9 @@ static int hfi1_setup_bypass_packet(struct hfi1_packet *packet)
 	packet->fecn = hfi1_16B_get_fecn(packet->hdr);
 	packet->becn = hfi1_16B_get_becn(packet->hdr);
 
+	if (hfi1_bypass_ingress_pkt_check(packet))
+		goto drop;
+
 	return 0;
 drop:
 	hfi1_cdbg(PKT, "%s: packet dropped\n", __func__);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index dbbad76..ee19660 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -372,6 +372,10 @@ struct hfi1_packet {
 #define OPA_16B_FECN_SHIFT      28
 #define OPA_16B_L2_MASK		0x60000000ull
 #define OPA_16B_L2_SHIFT	29
+#define OPA_16B_PKEY_MASK	0xFFFF0000ull
+#define OPA_16B_PKEY_SHIFT	16
+#define OPA_16B_LEN_MASK	0x7FF00000ull
+#define OPA_16B_LEN_SHIFT	20
 
 /*
  * OPA 16B L2/L4 Encodings
@@ -420,6 +424,11 @@ static inline u8 hfi1_16B_get_l2(struct hfi1_16b_header *hdr)
 	return (u8)((hdr->lrh[1] & OPA_16B_L2_MASK) >> OPA_16B_L2_SHIFT);
 }
 
+static inline u16 hfi1_16B_get_pkey(struct hfi1_16b_header *hdr)
+{
+	return (u16)((hdr->lrh[2] & OPA_16B_PKEY_MASK) >> OPA_16B_PKEY_SHIFT);
+}
+
 /*
  * BTH
  */
@@ -1597,9 +1606,9 @@ static void ingress_pkey_table_fail(struct hfi1_pportdata *ppd, u16 pkey,
  * by HW and rcv_pkey_check function should be called instead.
  */
 static inline int ingress_pkey_check(struct hfi1_pportdata *ppd, u16 pkey,
-				     u8 sc5, u8 idx, u16 slid)
+				     u8 sc5, u8 idx, u32 slid, bool force)
 {
-	if (!(ppd->part_enforce & HFI1_PART_ENFORCE_IN))
+	if (!(force) && !(ppd->part_enforce & HFI1_PART_ENFORCE_IN))
 		return 0;
 
 	/* If SC15, pkey[0:14] must be 0x7fff */
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index e30c64f..d252f8f 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -227,15 +227,23 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 	u32 sl = packet->sl;
 	int migrated;
 	u32 bth0, bth1;
+	u16 pkey;
 
 	bth0 = be32_to_cpu(packet->ohdr->bth[0]);
 	bth1 = be32_to_cpu(packet->ohdr->bth[1]);
-	migrated = bth0 & IB_BTH_MIG_REQ;
+	if (packet->etype == RHF_RCV_TYPE_BYPASS) {
+		pkey = hfi1_16B_get_pkey(packet->hdr);
+		migrated = bth1 & OPA_BTH_MIG_REQ;
+	} else {
+		pkey = ib_bth_get_pkey(packet->ohdr);
+		migrated = bth0 & IB_BTH_MIG_REQ;
+	}
 
 	if (qp->s_mig_state == IB_MIG_ARMED && migrated) {
 		if (!packet->grh) {
-			if (rdma_ah_get_ah_flags(&qp->alt_ah_attr) &
-			    IB_AH_GRH)
+			if ((rdma_ah_get_ah_flags(&qp->alt_ah_attr) &
+			     IB_AH_GRH) &&
+			    (packet->etype != RHF_RCV_TYPE_BYPASS))
 				return 1;
 		} else {
 			const struct ib_global_route *grh;
@@ -254,10 +262,10 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 				grh->dgid.global.interface_id))
 				return 1;
 		}
-		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
+		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), pkey,
 					    sc5, slid))) {
-			hfi1_bad_pkey(ibp, (u16)bth0, sl,
-				      0, qp->ibqp.qp_num, slid, dlid);
+			hfi1_bad_pkey(ibp, pkey, sl, 0, qp->ibqp.qp_num,
+				      slid, dlid);
 			return 1;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
@@ -270,8 +278,9 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 	} else {
 		if (!packet->grh) {
-			if (rdma_ah_get_ah_flags(&qp->remote_ah_attr) &
-						 IB_AH_GRH)
+			if ((rdma_ah_get_ah_flags(&qp->remote_ah_attr) &
+			     IB_AH_GRH) &&
+			    (packet->etype != RHF_RCV_TYPE_BYPASS))
 				return 1;
 		} else {
 			const struct ib_global_route *grh;
@@ -290,10 +299,10 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 			     grh->dgid.global.interface_id))
 				return 1;
 		}
-		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
+		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), pkey,
 					    sc5, slid))) {
-			hfi1_bad_pkey(ibp, (u16)bth0, sl,
-				      0, qp->ibqp.qp_num, slid, dlid);
+			hfi1_bad_pkey(ibp, pkey, sl, 0, qp->ibqp.qp_num,
+				      slid, dlid);
 			return 1;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 2af993c..b708376 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -109,7 +109,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		slid = ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
 				   ((1 << ppd->lmc) - 1));
 		if (unlikely(ingress_pkey_check(ppd, pkey, sc5,
-						qp->s_pkey_index, slid))) {
+						qp->s_pkey_index,
+						slid, false))) {
 			hfi1_bad_pkey(ibp, pkey,
 				      rdma_ah_get_sl(ah_attr),
 				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 750996a..df4103d 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -568,6 +568,24 @@ static u64 hfi1_fault_tx(struct rvt_qp *qp, u8 opcode, u64 pbc)
 	return pbc;
 }
 
+static int hfi1_do_pkey_check(struct hfi1_packet *packet)
+{
+	struct hfi1_ctxtdata *rcd = packet->rcd;
+	struct hfi1_pportdata *ppd = rcd->ppd;
+	struct hfi1_16b_header *hdr = packet->hdr;
+	u16 pkey;
+
+	/* Pkey check needed only for bypass packets */
+	if (packet->etype != RHF_RCV_TYPE_BYPASS)
+		return 0;
+
+	/* Perform pkey check */
+	pkey = hfi1_16B_get_pkey(hdr);
+	return ingress_pkey_check(ppd, pkey, packet->sc,
+				  packet->qp->s_pkey_index,
+				  packet->slid, true);
+}
+
 static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 				      bool is_mcast)
 {
@@ -594,6 +612,8 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 			goto drop;
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
+			if (hfi1_do_pkey_check(packet))
+				goto drop;
 			spin_lock_irqsave(&packet->qp->r_lock, flags);
 			packet_handler = qp_ok(packet);
 			if (likely(packet_handler))
@@ -613,15 +633,16 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 		qp_num = ib_bth_get_qpn(packet->ohdr);
 		rcu_read_lock();
 		packet->qp = rvt_lookup_qpn(rdi, &ibp->rvp, qp_num);
-		if (!packet->qp) {
-			rcu_read_unlock();
-			goto drop;
-		}
+		if (!packet->qp)
+			goto unlock_drop;
+
+		if (hfi1_do_pkey_check(packet))
+			goto unlock_drop;
+
 		if (unlikely(hfi1_dbg_fault_opcode(packet->qp, packet->opcode,
-						   true))) {
-			rcu_read_unlock();
-			goto drop;
-		}
+						   true)))
+			goto unlock_drop;
+
 		spin_lock_irqsave(&packet->qp->r_lock, flags);
 		packet_handler = qp_ok(packet);
 		if (likely(packet_handler))
@@ -632,6 +653,8 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 		rcu_read_unlock();
 	}
 	return;
+unlock_drop:
+	rcu_read_unlock();
 drop:
 	ibp->rvp.n_pkt_drops++;
 }
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 2022410..68577a0 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -95,6 +95,7 @@
 #define HFI1_VENDOR_IPG		cpu_to_be16(0xFFA0)
 
 #define IB_DEFAULT_GID_PREFIX	cpu_to_be64(0xfe80000000000000ULL)
+#define OPA_BTH_MIG_REQ		BIT(31)
 
 #define RC_OP(x) IB_OPCODE_RC_##x
 #define UC_OP(x) IB_OPCODE_UC_##x

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
