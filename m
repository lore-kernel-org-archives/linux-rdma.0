From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] RDMA/nes: set assume_alligned_header  bit
Date: Tue, 2 Mar 2010 17:22:51 -0600
Message-ID: <20100302232251.GA40928@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

set assume_alligned_header bit set in qp context as requested by hardware group.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2 change:
As recommended by Roland, Combine NES_QPCONTEXT_ORDIRD_AAH with the
NES_QPCONTEXT_ORDIRD_ALSMM for ird_ord_sizes.

 drivers/infiniband/hw/nes/nes_verbs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 64d3136..d87b32e 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1323,6 +1323,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			nesqp->nesqp_context->aeq_token_low =  cpu_to_le32((u32)((unsigned long)(nesqp)));
 			nesqp->nesqp_context->aeq_token_high =  cpu_to_le32((u32)(upper_32_bits((unsigned long)(nesqp))));
 			nesqp->nesqp_context->ird_ord_sizes = cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
+					NES_QPCONTEXT_ORDIRD_AAH |
 					((((u32)nesadapter->max_irrq_wr) <<
 					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) & NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));
 			if (disable_mpa_crc) {
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
