From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/20] IB/hfi1: Use defines from common headers
Date: Sun, 09 Apr 2017 10:16:28 -0700
Message-ID: <20170409171627.10579.11361.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move FECN and BECN related defines to common header files

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/common.h       |    6 ------
 drivers/infiniband/hw/hfi1/driver.c       |    8 ++++----
 drivers/infiniband/hw/hfi1/hfi.h          |    4 ++--
 drivers/infiniband/hw/hfi1/rc.c           |    2 +-
 drivers/infiniband/hw/hfi1/ruc.c          |    2 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |    8 ++++----
 drivers/infiniband/hw/hfi1/ud.c           |    2 +-
 include/rdma/ib_hdrs.h                    |    6 ++++++
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
index 804150f..995d62c 100644
--- a/drivers/infiniband/hw/hfi1/common.h
+++ b/drivers/infiniband/hw/hfi1/common.h
@@ -331,12 +331,6 @@ struct diag_pkt {
 #define FULL_MGMT_P_KEY      0xFFFF
 
 #define DEFAULT_P_KEY LIM_MGMT_P_KEY
-#define HFI1_FECN_SHIFT 31
-#define HFI1_FECN_MASK 1
-#define HFI1_FECN_SMASK BIT(HFI1_FECN_SHIFT)
-#define HFI1_BECN_SHIFT 30
-#define HFI1_BECN_MASK 1
-#define HFI1_BECN_SMASK BIT(HFI1_BECN_SHIFT)
 
 /**
  * 0xF8 - 4 bits of multicast range and 1 bit for collective range
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 7e6d86b..fc5753c 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -495,13 +495,13 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	sc = hfi1_9B_get_sc5(hdr, pkt->rhf);
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
-	if (do_cnp && (bth1 & HFI1_FECN_SMASK)) {
+	if (do_cnp && (bth1 & IB_FECN_SMASK)) {
 		u16 pkey = (u16)be32_to_cpu(ohdr->bth[0]);
 
 		return_cnp(ibp, qp, rqpn, pkey, dlid, rlid, sc, grh);
 	}
 
-	if (!is_mcast && (bth1 & HFI1_BECN_SMASK)) {
+	if (!is_mcast && (bth1 & IB_BECN_SMASK)) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 		u32 lqpn = bth1 & RVT_QPN_MASK;
 		u8 sl = ibp->sc_to_sl[sc];
@@ -634,7 +634,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		}
 
 		bth1 = be32_to_cpu(packet->ohdr->bth[1]);
-		is_ecn = !!(bth1 & (HFI1_FECN_SMASK | HFI1_BECN_SMASK));
+		is_ecn = !!(bth1 & (IB_FECN_SMASK | IB_BECN_SMASK));
 
 		if (!is_ecn)
 			goto next;
@@ -652,7 +652,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		rcu_read_unlock();
 
 		/* turn off BECN, FECN */
-		bth1 &= ~(HFI1_FECN_SMASK | HFI1_BECN_SMASK);
+		bth1 &= ~(IB_FECN_SMASK | IB_BECN_SMASK);
 		packet->ohdr->bth[1] = cpu_to_be32(bth1);
 next:
 		update_ps_mdata(&mdata, rcd);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1d9436c..79c4289 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1597,9 +1597,9 @@ static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	u32 bth1;
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
-	if (unlikely(bth1 & (HFI1_BECN_SMASK | HFI1_FECN_SMASK))) {
+	if (unlikely(bth1 & (IB_BECN_SMASK | IB_FECN_SMASK))) {
 		hfi1_process_ecn_slowpath(qp, pkt, do_cnp);
-		return bth1 & HFI1_FECN_SMASK;
+		return bth1 & IB_FECN_SMASK;
 	}
 	return false;
 }
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 623209a..da968b7 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -773,7 +773,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	hdr.lrh[3] = cpu_to_be16(ppd->lid | qp->remote_ah_attr.src_path_bits);
 	ohdr->bth[0] = cpu_to_be32(bth0);
 	ohdr->bth[1] = cpu_to_be32(qp->remote_qpn);
-	ohdr->bth[1] |= cpu_to_be32((!!is_fecn) << HFI1_BECN_SHIFT);
+	ohdr->bth[1] |= cpu_to_be32((!!is_fecn) << IB_BECN_SHIFT);
 	ohdr->bth[2] = cpu_to_be32(mask_psn(qp->r_ack_psn));
 
 	/* Don't try to send ACKs if the link isn't ACTIVE */
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 2730915..879eb9b 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -775,7 +775,7 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 	if (qp->s_flags & RVT_S_ECN) {
 		qp->s_flags &= ~RVT_S_ECN;
 		/* we recently received a FECN, so return a BECN */
-		bth1 |= (HFI1_BECN_MASK << HFI1_BECN_SHIFT);
+		bth1 |= (IB_BECN_MASK << IB_BECN_SHIFT);
 	}
 	ohdr->bth[1] = cpu_to_be32(bth1);
 	ohdr->bth[2] = cpu_to_be32(bth2);
diff --git a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
index 382fcda..090f6b5 100644
--- a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
+++ b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
@@ -139,11 +139,11 @@
 			__entry->pkey =
 			be32_to_cpu(ohdr->bth[0]) & 0xffff;
 			__entry->f =
-			(be32_to_cpu(ohdr->bth[1]) >> HFI1_FECN_SHIFT) &
-			HFI1_FECN_MASK;
+			(be32_to_cpu(ohdr->bth[1]) >> IB_FECN_SHIFT) &
+			IB_FECN_MASK;
 			__entry->b =
-			(be32_to_cpu(ohdr->bth[1]) >> HFI1_BECN_SHIFT) &
-			HFI1_BECN_MASK;
+			(be32_to_cpu(ohdr->bth[1]) >> IB_BECN_SHIFT) &
+			IB_BECN_MASK;
 			__entry->qpn =
 			be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
 			__entry->a =
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 8b3403a..45bc3f0 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -537,7 +537,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
 	bth0 = pkey | (IB_OPCODE_CNP << 24);
 	ohdr->bth[0] = cpu_to_be32(bth0);
 
-	ohdr->bth[1] = cpu_to_be32(remote_qpn | (1 << HFI1_BECN_SHIFT));
+	ohdr->bth[1] = cpu_to_be32(remote_qpn | (1 << IB_BECN_SHIFT));
 	ohdr->bth[2] = 0; /* PSN 0 */
 
 	hdr.lrh[0] = cpu_to_be16(lrh0);
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 9cf42bc..5519f31 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -74,6 +74,12 @@
 #define IB_GRH_FLOW_MASK	0xFFFFF
 #define IB_GRH_FLOW_SHIFT	0
 #define IB_GRH_NEXT_HDR		0x1B
+#define IB_FECN_SHIFT 31
+#define IB_FECN_MASK 1
+#define IB_FECN_SMASK BIT(IB_FECN_SHIFT)
+#define IB_BECN_SHIFT 30
+#define IB_BECN_MASK 1
+#define IB_BECN_SMASK BIT(IB_BECN_SHIFT)
 
 #define IB_AETH_CREDIT_SHIFT	24
 #define IB_AETH_CREDIT_MASK	0x1F

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
