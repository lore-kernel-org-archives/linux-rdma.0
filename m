From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/hfi1: Mask the path bits with the LMC for
 16B RC Acks
Date: Tue, 14 Nov 2017 04:34:16 -0800
Message-ID: <20171114123413.10579.33655.stgit@scvm10.sc.intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114122859.10579.79788.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

16B packets require that the path bits are masked with the LMC.
This mask is done correctly in all 16B header creation but was
left out for the RC Acknowledge.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index fd01a76..e6fa936 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -843,11 +843,11 @@ static inline void hfi1_make_rc_ack_16B(struct rvt_qp *qp,
 	/* Convert dwords to flits */
 	len = (*hwords + *nwords) >> 1;
 
-	hfi1_make_16b_hdr(hdr,
-			  ppd->lid | rdma_ah_get_path_bits(&qp->remote_ah_attr),
+	hfi1_make_16b_hdr(hdr, ppd->lid |
+			  (rdma_ah_get_path_bits(&qp->remote_ah_attr) &
+			  ((1 << ppd->lmc) - 1)),
 			  opa_get_lid(rdma_ah_get_dlid(&qp->remote_ah_attr),
-				      16B),
-			  len, pkey, becn, 0, l4, sc5);
+				      16B), len, pkey, becn, 0, l4, sc5);
 
 	bth0 = pkey | (OP(ACKNOWLEDGE) << 24);
 	bth0 |= extra_bytes << 20;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
