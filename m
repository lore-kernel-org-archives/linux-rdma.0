From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 27/28] IB/hfi1: Use hdr2sc function to calculate 5-bit SC
Date: Mon, 25 Jul 2016 13:40:34 -0700
Message-ID: <20160725204033.4800.41045.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The interface is used to compute the 5-bit SC field from the
LRH and the RHF bits. Modify code to use the interface instead.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    4 +---
 drivers/infiniband/hw/hfi1/hfi.h    |    7 +------
 drivers/infiniband/hw/hfi1/verbs.c  |    7 ++-----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 4dbadf7..8246dc7 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -392,9 +392,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			u16 rlid;
 			u8 svc_type, sl, sc5;
 
-			sc5  = (be16_to_cpu(rhdr->lrh[0]) >> 12) & 0xf;
-			if (rhf_dc_info(packet->rhf))
-				sc5 |= 0x10;
+			sc5 = hdr2sc(rhdr, packet->rhf);
 			sl = ibp->sc_to_sl[sc5];
 
 			lqpn = be32_to_cpu(bth[1]) & RVT_QPN_MASK;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index d22876d..df43732 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -368,11 +368,6 @@ struct hfi1_packet {
 	u8 etype;
 };
 
-static inline bool has_sc4_bit(struct hfi1_packet *p)
-{
-	return !!rhf_dc_info(p->rhf);
-}
-
 /*
  * Private data for snoop/capture support.
  */
@@ -1273,7 +1268,7 @@ void receive_interrupt_work(struct work_struct *work);
 static inline int hdr2sc(struct hfi1_message_header *hdr, u64 rhf)
 {
 	return ((be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf) |
-	       ((!!(rhf & RHF_DC_INFO_SMASK)) << 4);
+	       ((!!(rhf_dc_info(rhf))) << 4);
 }
 
 static inline u16 generate_jkey(kuid_t uid)
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 67810e3..5265d16 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1743,8 +1743,7 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 	struct rvt_qp *qp = packet->qp;
 	u32 lqpn, rqpn = 0;
 	u16 rlid = 0;
-	u8 sl, sc5, sc4_bit, svc_type;
-	bool sc4_set = has_sc4_bit(packet);
+	u8 sl, sc5, svc_type;
 
 	switch (packet->qp->ibqp.qp_type) {
 	case IB_QPT_UC:
@@ -1767,9 +1766,7 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 		return;
 	}
 
-	sc4_bit = sc4_set << 4;
-	sc5 = (be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf;
-	sc5 |= sc4_bit;
+	sc5 = hdr2sc((struct hfi1_message_header *)hdr, packet->rhf);
 	sl = ibp->sc_to_sl[sc5];
 	lqpn = qp->ibqp.qp_num;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
