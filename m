From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/3] staging/rdma/hfi1: don't cache "prescan head"
Date: Wed,  4 Nov 2015 21:10:09 -0500
Message-ID: <1446689411-22263-2-git-send-email-ira.weiny@intel.com>
References: <1446689411-22263-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446689411-22263-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When HFI1_CAP_DMA_RTAIL is toggled off the "prescan head" can get out of sync
with the receive context's "head". This happens when, after prescan_rxq() newly
arrived packets are then received, and processed by an RX interrupt handler.
This is an unavoidable race, and to avoid getting out of sync we always start
prescanning at the current "rcd->head" entry.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c | 13 +++----------
 drivers/staging/rdma/hfi1/hfi.h    | 13 -------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce69141b56cb..cfcbe417fde9 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -509,14 +509,10 @@ static inline void init_ps_mdata(struct ps_mdata *mdata,
 	mdata->rsize = packet->rsize;
 	mdata->maxcnt = packet->maxcnt;
 
-	if (rcd->ps_state.initialized == 0) {
-		mdata->ps_head = packet->rhqoff;
-		rcd->ps_state.initialized++;
-	} else
-		mdata->ps_head = rcd->ps_state.ps_head;
+	mdata->ps_head = packet->rhqoff;
 
 	if (HFI1_CAP_IS_KSET(DMA_RTAIL)) {
-		mdata->ps_tail = packet->hdrqtail;
+		mdata->ps_tail = get_rcvhdrtail(rcd);
 		mdata->ps_seq = 0; /* not used with DMA_RTAIL */
 	} else {
 		mdata->ps_tail = 0; /* used only with DMA_RTAIL*/
@@ -533,12 +529,9 @@ static inline int ps_done(struct ps_mdata *mdata, u64 rhf)
 
 static inline void update_ps_mdata(struct ps_mdata *mdata)
 {
-	struct hfi1_ctxtdata *rcd = mdata->rcd;
-
 	mdata->ps_head += mdata->rsize;
-	if (mdata->ps_head > mdata->maxcnt)
+	if (mdata->ps_head >= mdata->maxcnt)
 		mdata->ps_head = 0;
-	rcd->ps_state.ps_head = mdata->ps_head;
 	if (!HFI1_CAP_IS_KSET(DMA_RTAIL)) {
 		if (++mdata->ps_seq > 13)
 			mdata->ps_seq = 1;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 190f7a2f6773..96135b813fba 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -139,15 +139,6 @@ extern const struct pci_error_handlers hfi1_pci_err_handler;
 struct hfi1_opcode_stats_perctx;
 #endif
 
-/*
- * struct ps_state keeps state associated with RX queue "prescanning"
- * (prescanning for FECNs, and BECNs), if prescanning is in use.
- */
-struct ps_state {
-	u32 ps_head;
-	int initialized;
-};
-
 struct ctxt_eager_bufs {
 	ssize_t size;            /* total size of eager buffers */
 	u32 count;               /* size of buffers array */
@@ -302,10 +293,6 @@ struct hfi1_ctxtdata {
 	struct list_head sdma_queues;
 	spinlock_t sdma_qlock;
 
-#ifdef CONFIG_PRESCAN_RXQ
-	struct ps_state ps_state;
-#endif /* CONFIG_PRESCAN_RXQ */
-
 	/*
 	 * The interrupt handler for a particular receive context can vary
 	 * throughout it's lifetime. This is not a lock protected data member so
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
