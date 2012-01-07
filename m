From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] RDMA/nes: Fix for fast memory registration opcode
Date: Fri, 6 Jan 2012 18:17:19 -0600
Message-ID: <20120107001719.GA8516@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, donald.e.wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes fast memory registration incorrect opcode for
local invalidate completion.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Donald Wood <Donald.E.Wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ba2eb00..3875365 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3726,7 +3726,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 						entry->opcode = IB_WC_SEND;
 						break;
 					case NES_IWARP_SQ_OP_LOCINV:
-						entry->opcode = IB_WR_LOCAL_INV;
+						entry->opcode = IB_WC_LOCAL_INV;
 						break;
 					case NES_IWARP_SQ_OP_FAST_REG:
 						entry->opcode = IB_WC_FAST_REG_MR;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
