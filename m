From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 16/23] staging/rdma/hfi1: Allow tuning of SDMA interrupt rate
Date: Mon, 19 Oct 2015 12:43:40 -0400
Message-ID: <1445273027-29634-17-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The SDMA engines were configured to generate progrss interrupts every time they
processed N/2 descriptors (where N is the size of the descriptor queue). This
interval was too infrequent, leading to degraded performance.

This commit adds a module parameter, which allows for the tuning of the
interrupt frequency until an optimal frequency is found for both PSM and Verbs.
At that time, the parameter could be pulled out, if desired.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 53b3e4d9518b..452e7edcee7a 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -80,6 +80,10 @@ uint mod_num_sdma;
 module_param_named(num_sdma, mod_num_sdma, uint, S_IRUGO);
 MODULE_PARM_DESC(num_sdma, "Set max number SDMA engines to use");
 
+static uint sdma_desct_intr;
+module_param_named(desct_intr, sdma_desct_intr, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(desct_intr, "Number of SDMA descriptor before interrupt");
+
 #define SDMA_WAIT_BATCH_SIZE 20
 /* max wait time for a SDMA engine to indicate it has halted */
 #define SDMA_ERR_HALT_TIMEOUT 10 /* ms */
@@ -1046,6 +1050,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		return -ENOMEM;
 
 	idle_cnt = ns_to_cclock(dd, idle_cnt);
+	if (!sdma_desct_intr)
+		sdma_desct_intr = descq_cnt / 2;
 	/* Allocate memory for SendDMA descriptor FIFOs */
 	for (this_idx = 0; this_idx < num_engines; ++this_idx) {
 		sde = &dd->per_sdma[this_idx];
@@ -1548,7 +1554,7 @@ void sdma_engine_interrupt(struct sdma_engine *sde, u64 status)
 {
 	trace_hfi1_sdma_engine_interrupt(sde, status);
 	write_seqlock(&sde->head_lock);
-	sdma_set_desc_cnt(sde, sde->descq_cnt / 2);
+	sdma_set_desc_cnt(sde, sdma_desct_intr);
 	sdma_make_progress(sde, status);
 	write_sequnlock(&sde->head_lock);
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
