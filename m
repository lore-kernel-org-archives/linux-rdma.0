From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] IB/hfi1: Fix ECN processing in prescan_rxq
Date: Tue, 25 Oct 2016 13:12:23 -0700
Message-ID: <20161025201222.15765.59174.stgit@scvm10.sc.intel.com>
References: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025194241.15765.8903.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When processing ECN via the prescan_rxq path, some fields in the packet
structure are passed uninitialized. This can potentially
cause NULL pointer exceptions during ECN handling.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index dadd35e..c5efff2 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -599,7 +599,6 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 					 dd->rhf_offset;
 		struct rvt_qp *qp;
 		struct ib_header *hdr;
-		struct ib_other_headers *ohdr;
 		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 		u64 rhf = rhf_to_cpu(rhf_addr);
 		u32 etype = rhf_rcv_type(rhf), qpn, bth1;
@@ -615,18 +614,21 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		if (etype != RHF_RCV_TYPE_IB)
 			goto next;
 
-		hdr = hfi1_get_msgheader(dd, rhf_addr);
+		packet->hdr = hfi1_get_msgheader(dd, rhf_addr);
+		hdr = packet->hdr;
 
 		lnh = be16_to_cpu(hdr->lrh[0]) & 3;
 
-		if (lnh == HFI1_LRH_BTH)
-			ohdr = &hdr->u.oth;
-		else if (lnh == HFI1_LRH_GRH)
-			ohdr = &hdr->u.l.oth;
-		else
+		if (lnh == HFI1_LRH_BTH) {
+			packet->ohdr = &hdr->u.oth;
+		} else if (lnh == HFI1_LRH_GRH) {
+			packet->ohdr = &hdr->u.l.oth;
+			packet->rcv_flags |= HFI1_HAS_GRH;
+		} else {
 			goto next; /* just in case */
+		}
 
-		bth1 = be32_to_cpu(ohdr->bth[1]);
+		bth1 = be32_to_cpu(packet->ohdr->bth[1]);
 		is_ecn = !!(bth1 & (HFI1_FECN_SMASK | HFI1_BECN_SMASK));
 
 		if (!is_ecn)
@@ -646,7 +648,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 
 		/* turn off BECN, FECN */
 		bth1 &= ~(HFI1_FECN_SMASK | HFI1_BECN_SMASK);
-		ohdr->bth[1] = cpu_to_be32(bth1);
+		packet->ohdr->bth[1] = cpu_to_be32(bth1);
 next:
 		update_ps_mdata(&mdata, rcd);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
