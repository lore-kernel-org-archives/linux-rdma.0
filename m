From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] RDMA/nes: Fix for incorrect address of ip header
Date: Fri, 2 Nov 2012 18:17:34 -0500
Message-ID: <20121102231734.GA2780@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for incorrect ip header address when forwarding fpdus to hardware 

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_mgt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 3ba7be3..8cf74fd 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -447,7 +447,7 @@ static int forward_fpdus(struct nes_vnic *nesvnic, struct nes_qp *nesqp)
 		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG0_LOW_IDX,
 				    lower_32_bits(u64tmp));
 		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG0_HIGH_IDX,
-				    upper_32_bits(u64tmp >> 32));
+				    upper_32_bits(u64tmp));
 
 		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_NIC_SQ_WQE_FRAG1_LOW_IDX,
 				    lower_32_bits(fpdu_info->frags[0].physaddr));
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
