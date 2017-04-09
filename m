From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/20] IB/hfi1: Rename hdr2sc to hfi1_9B_get_sc5
Date: Sun, 09 Apr 2017 10:16:15 -0700
Message-ID: <20170409171614.10579.67858.stgit@scvm10.sc.intel.com>
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

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The function really returned the 5-bit sc value from
the header and rhf. hdr2sc didn't quite describe what it did.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    7 ++++---
 drivers/infiniband/hw/hfi1/hfi.h    |    2 +-
 drivers/infiniband/hw/hfi1/ud.c     |    2 +-
 drivers/infiniband/hw/hfi1/verbs.c  |    2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 64bdbce..d731b5e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -397,7 +397,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			u16 rlid;
 			u8 svc_type, sl, sc5;
 
-			sc5 = hdr2sc(rhdr, packet->rhf);
+			sc5 = hfi1_9B_get_sc5(rhdr, packet->rhf);
 			sl = ibp->sc_to_sl[sc5];
 
 			lqpn = be32_to_cpu(bth[1]) & RVT_QPN_MASK;
@@ -492,7 +492,7 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 		return;
 	}
 
-	sc = hdr2sc(hdr, pkt->rhf);
+	sc = hfi1_9B_get_sc5(hdr, pkt->rhf);
 
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	if (do_cnp && (bth1 & HFI1_FECN_SMASK)) {
@@ -909,7 +909,8 @@ static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
 						   packet->rhf_addr);
 	u8 etype = rhf_rcv_type(packet->rhf);
 
-	if (etype == RHF_RCV_TYPE_IB && hdr2sc(hdr, packet->rhf) != 0xf) {
+	if (etype == RHF_RCV_TYPE_IB &&
+	    hfi1_9B_get_sc5(hdr, packet->rhf) != 0xf) {
 		int hwstate = read_logical_state(dd);
 
 		if (hwstate != LSTATE_ACTIVE) {
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index a31638c..8509502 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1261,7 +1261,7 @@ static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 void receive_interrupt_work(struct work_struct *work);
 
 /* extract service channel from header and rhf */
-static inline int hdr2sc(struct ib_header *hdr, u64 rhf)
+static inline int hfi1_9B_get_sc5(struct ib_header *hdr, u64 rhf)
 {
 	return ((be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf) |
 	       ((!!(rhf_dc_info(rhf))) << 4);
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 13ea4eb..fd105cf 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -680,7 +680,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct rvt_qp *qp = packet->qp;
 	bool has_grh = rcv_flags & HFI1_HAS_GRH;
-	u8 sc5 = hdr2sc(hdr, packet->rhf);
+	u8 sc5 = hfi1_9B_get_sc5(hdr, packet->rhf);
 	u32 bth1;
 	u8 sl_from_sc, sl;
 	u16 slid;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index f74abb1..66a2378 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1928,7 +1928,7 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 		return;
 	}
 
-	sc5 = hdr2sc(hdr, packet->rhf);
+	sc5 = hfi1_9B_get_sc5(hdr, packet->rhf);
 	sl = ibp->sc_to_sl[sc5];
 	lqpn = qp->ibqp.qp_num;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
