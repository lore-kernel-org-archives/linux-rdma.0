From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] RDMA/nes: Fix for fast memory registration length
Date: Fri, 6 Jan 2012 18:15:01 -0600
Message-ID: <20120107001501.GA8056@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, donald.e.wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Zero high order word of fast memory registration (FMR) length field.
FMR length field is 32 bits, so high word should always be zero.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Donald Wood <Donald.E.Wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5095bc4..ba2eb00 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3428,6 +3428,8 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					    NES_IWARP_SQ_FMR_WQE_LENGTH_LOW_IDX,
 					    ib_wr->wr.fast_reg.length);
 			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_LENGTH_HIGH_IDX, 0);
+			set_wqe_32bit_value(wqe->wqe_words,
 					    NES_IWARP_SQ_FMR_WQE_MR_STAG_IDX,
 					    ib_wr->wr.fast_reg.rkey);
 			/* Set page size: */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
