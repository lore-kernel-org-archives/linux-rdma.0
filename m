From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Reversing commit bca1935ccdec to silence
 allmodconfig build warning
Date: Wed, 17 Jul 2013 16:41:57 -0500
Message-ID: <20130717214156.GA2460@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reversing commit "Fix compilation error when nes_debug is enabled"
which removes variables nes_tcp_state_str and nes_iwarp_state_str, assuming that they aren't defined. 
However, they are defined within a #ifdef NES_DEBUG statement, which if enabled
causes "defined but not used" compiler warning, when the variables are removed.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 418004c..9020024 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3570,10 +3570,10 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 	tcp_state = (aeq_info & NES_AEQE_TCP_STATE_MASK) >> NES_AEQE_TCP_STATE_SHIFT;
 	iwarp_state = (aeq_info & NES_AEQE_IWARP_STATE_MASK) >> NES_AEQE_IWARP_STATE_SHIFT;
 	nes_debug(NES_DBG_AEQ, "aeid = 0x%04X, qp-cq id = %d, aeqe = %p,"
-			" Tcp state = %d, iWARP state = %d\n",
+			" Tcp state = %s, iWARP state = %s\n",
 			async_event_id,
 			le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]), aeqe,
-			tcp_state, iwarp_state);
+			nes_tcp_state_str[tcp_state], nes_iwarp_state_str[iwarp_state]);
 
 	aeqe_cq_id = le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]);
 	if (aeq_info & NES_AEQE_QP) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
