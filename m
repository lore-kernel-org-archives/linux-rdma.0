From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/nes: set assume_alligned_header bit
Date: Fri, 19 Feb 2010 15:06:35 -0600
Message-ID: <20100219210635.GA59096@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

set assume bit alligned bit in qp context as recommended by hardware group.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 64d3136..dba659a 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1325,6 +1325,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			nesqp->nesqp_context->ird_ord_sizes = cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
 					((((u32)nesadapter->max_irrq_wr) <<
 					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) & NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));
+			nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(NES_QPCONTEXT_ORDIRD_AAH);
 			if (disable_mpa_crc) {
 				nes_debug(NES_DBG_QP, "Disabling MPA crc checking due to module option.\n");
 				nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(NES_QPCONTEXT_ORDIRD_RNMC);
-- 
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
