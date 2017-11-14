From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/hfi1: Initialize bth1 in 16B rc ack builder
Date: Tue, 14 Nov 2017 04:34:23 -0800
Message-ID: <20171114123421.10579.19151.stgit@scvm10.sc.intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114122859.10579.79788.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is possible the bth1 variable could be used uninitialized so going
ahead and giving it a default value.

Fixes: 5b6cabb0db77 ("IB/hfi1: Add 16B RC/UC support")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index e6fa936..68d5c3c 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -814,7 +814,7 @@ static inline void hfi1_make_rc_ack_16B(struct rvt_qp *qp,
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_16b_header *hdr = &opa_hdr->opah;
 	struct ib_other_headers *ohdr;
-	u32 bth0, bth1;
+	u32 bth0, bth1 = 0;
 	u16 len, pkey;
 	u8 becn = !!is_fecn;
 	u8 l4 = OPA_16B_L4_IB_LOCAL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
