From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/hfi1: Clean up interrupt source mask initialization
Date: Thu,  3 Mar 2016 20:55:27 -0500
Message-ID: <1457056527-27547-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up the sdma interrupt source mask initialization code in
sdma_init() for better readability.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
To be squashed into 2fd9621 staging/hfi1: add per SDMA engine stats to hfistats

 drivers/staging/rdma/hfi1/sdma.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index cb66bd0..4eb55fa 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1062,18 +1062,17 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		sde->sdma_shift = ilog2(descq_cnt);
 		sde->sdma_mask = (1 << sde->sdma_shift) - 1;
 
-		/* Create a mask for all 3 chip interrupt sources */
-		sde->imask = (u64)1 << (0*TXE_NUM_SDMA_ENGINES + this_idx)
-			| (u64)1 << (1*TXE_NUM_SDMA_ENGINES + this_idx)
-			| (u64)1 << (2*TXE_NUM_SDMA_ENGINES + this_idx);
-		/* Create a mask specifically for sdma_idle */
-		sde->idle_mask =
-			(u64)1 << (2*TXE_NUM_SDMA_ENGINES + this_idx);
-		/* Create a mask specifically for sdma_progress */
-		sde->progress_mask =
-			(u64)1 << (TXE_NUM_SDMA_ENGINES + this_idx);
-		sde->int_mask =
-			(u64)1 << (0 * TXE_NUM_SDMA_ENGINES + this_idx);
+		/* Create a mask specifically for each interrupt source */
+		sde->int_mask = (u64)1 << (0 * TXE_NUM_SDMA_ENGINES +
+					   this_idx);
+		sde->progress_mask = (u64)1 << (1 * TXE_NUM_SDMA_ENGINES +
+						this_idx);
+		sde->idle_mask = (u64)1 << (2 * TXE_NUM_SDMA_ENGINES +
+					    this_idx);
+		/* Create a combined mask to cover all 3 interrupt sources */
+		sde->imask = sde->int_mask | sde->progress_mask |
+			     sde->idle_mask;
+
 		spin_lock_init(&sde->tail_lock);
 		seqlock_init(&sde->head_lock);
 		spin_lock_init(&sde->senddmactrl_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
