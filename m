From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/12] IB/hfi1: Add a safe wrapper for
 _rcd_get_by_index
Date: Tue, 26 Sep 2017 07:01:16 -0700
Message-ID: <20170926140114.15601.60961.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hfi1_rcd_get_by_index assumes that the given index is in the correct
range.  In most cases this is correct because the index is bounded by
a loop.  For these cases, adding a range check to the function is
redundant.

For the use case that is not bounded by the loop range, a _safe wrapper
function is needed to validate the index before accessing the rcd array.

Add a _safe wrapper to _get_by_index to validate the index range.

Update appropriate call sites with the new _safe function.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c    |    2 +-
 drivers/infiniband/hw/hfi1/debugfs.c |    4 ++--
 drivers/infiniband/hw/hfi1/driver.c  |    4 ++--
 drivers/infiniband/hw/hfi1/hfi.h     |    2 ++
 drivers/infiniband/hw/hfi1/init.c    |   21 +++++++++++++++++++++
 5 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 99425ce..680cfd4 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13120,7 +13120,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			me->type = IRQ_SDMA;
 		} else if (first_rx <= i && i < last_rx) {
 			idx = i - first_rx;
-			rcd = hfi1_rcd_get_by_index(dd, idx);
+			rcd = hfi1_rcd_get_by_index_safe(dd, idx);
 			if (rcd) {
 				/*
 				 * Set the interrupt register and mask for this
diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 36ae1fd..24128f4 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -243,7 +243,7 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 	spos = v;
 	i = *spos;
 
-	rcd = hfi1_rcd_get_by_index(dd, i);
+	rcd = hfi1_rcd_get_by_index_safe(dd, i);
 	if (!rcd)
 		return SEQ_SKIP;
 
@@ -402,7 +402,7 @@ static int _rcds_seq_show(struct seq_file *s, void *v)
 	loff_t *spos = v;
 	loff_t i = *spos;
 
-	rcd = hfi1_rcd_get_by_index(dd, i);
+	rcd = hfi1_rcd_get_by_index_safe(dd, i);
 	if (rcd)
 		seqfile_dump_rcd(s, rcd);
 	hfi1_rcd_put(rcd);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 7372cc0..85a425e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -866,7 +866,7 @@ static inline void set_nodma_rtail(struct hfi1_devdata *dd, u16 ctxt)
 	 * interrupt handler for all statically allocated kernel contexts.
 	 */
 	if (ctxt >= dd->first_dyn_alloc_ctxt) {
-		rcd = hfi1_rcd_get_by_index(dd, ctxt);
+		rcd = hfi1_rcd_get_by_index_safe(dd, ctxt);
 		if (rcd) {
 			rcd->do_interrupt =
 				&handle_receive_interrupt_nodma_rtail;
@@ -895,7 +895,7 @@ static inline void set_dma_rtail(struct hfi1_devdata *dd, u16 ctxt)
 	 * interrupt handler for all statically allocated kernel contexts.
 	 */
 	if (ctxt >= dd->first_dyn_alloc_ctxt) {
-		rcd = hfi1_rcd_get_by_index(dd, ctxt);
+		rcd = hfi1_rcd_get_by_index_safe(dd, ctxt);
 		if (rcd) {
 			rcd->do_interrupt =
 				&handle_receive_interrupt_dma_rtail;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1e1140e..cb74ae8 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1398,6 +1398,8 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
 int hfi1_rcd_put(struct hfi1_ctxtdata *rcd);
 void hfi1_rcd_get(struct hfi1_ctxtdata *rcd);
+struct hfi1_ctxtdata *hfi1_rcd_get_by_index_safe(struct hfi1_devdata *dd,
+						 u16 ctxt);
 struct hfi1_ctxtdata *hfi1_rcd_get_by_index(struct hfi1_devdata *dd, u16 ctxt);
 int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread);
 int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 04a383b..36c8a4a 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -284,6 +284,27 @@ static int allocate_rcd_index(struct hfi1_devdata *dd,
 }
 
 /**
+ * hfi1_rcd_get_by_index_safe - validate the ctxt index before accessing the
+ * array
+ * @dd: pointer to a valid devdata structure
+ * @ctxt: the index of an possilbe rcd
+ *
+ * This is a wrapper for hfi1_rcd_get_by_index() to validate that the given
+ * ctxt index is valid.
+ *
+ * The caller is responsible for making the _put().
+ *
+ */
+struct hfi1_ctxtdata *hfi1_rcd_get_by_index_safe(struct hfi1_devdata *dd,
+						 u16 ctxt)
+{
+	if (ctxt < dd->num_rcv_contexts)
+		return hfi1_rcd_get_by_index(dd, ctxt);
+
+	return NULL;
+}
+
+/**
  * hfi1_rcd_get_by_index
  * @dd: pointer to a valid devdata structure
  * @ctxt: the index of an possilbe rcd

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
