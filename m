From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 09/12] IB/hfi1: Inline common calculation
Date: Tue, 26 Sep 2017 07:00:56 -0700
Message-ID: <20170926140055.15601.9019.stgit@scvm10.sc.intel.com>
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

Calculating the offset to a context is done several times throughout
the code.  Create a common inlined function for doing this
calculation.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |   21 ++++++++-------------
 drivers/infiniband/hw/hfi1/hfi.h          |    6 ++++++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    6 ++----
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index d9a1e98..c200a5c 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -595,9 +595,8 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)(dd->events +
-				  ((uctxt->ctxt - dd->first_dyn_alloc_ctxt) *
-				   HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
+		memaddr = (unsigned long)
+			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
 		memlen = PAGE_SIZE;
 		/*
 		 * v3.7 removes VM_RESERVED but the effect is kept by
@@ -779,8 +778,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	 * Clear any left over, unhandled events so the next process that
 	 * gets this context doesn't get confused.
 	 */
-	ev = dd->events + ((uctxt->ctxt - dd->first_dyn_alloc_ctxt) *
-			   HFI1_MAX_SHARED_CTXTS) + fdata->subctxt;
+	ev = dd->events + uctxt_offset(uctxt) + fdata->subctxt;
 	*ev = 0;
 
 	spin_lock_irqsave(&dd->uctxt_lock, flags);
@@ -1392,9 +1390,8 @@ static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 	 */
 	binfo.user_regbase = HFI1_MMAP_TOKEN(UREGS, uctxt->ctxt,
 					    fd->subctxt, 0);
-	offset = offset_in_page((((uctxt->ctxt - dd->first_dyn_alloc_ctxt) *
-		    HFI1_MAX_SHARED_CTXTS) + fd->subctxt) *
-		  sizeof(*dd->events));
+	offset = offset_in_page((uctxt_offset(uctxt) + fd->subctxt) *
+				sizeof(*dd->events));
 	binfo.events_bufbase = HFI1_MMAP_TOKEN(EVENTS, uctxt->ctxt,
 					      fd->subctxt,
 					      offset);
@@ -1485,14 +1482,13 @@ int hfi1_set_uevent_bits(struct hfi1_pportdata *ppd, const int evtbit)
 	     ctxt++) {
 		uctxt = hfi1_rcd_get_by_index(dd, ctxt);
 		if (uctxt) {
-			unsigned long *evs = dd->events +
-				(uctxt->ctxt - dd->first_dyn_alloc_ctxt) *
-				HFI1_MAX_SHARED_CTXTS;
+			unsigned long *evs;
 			int i;
 			/*
 			 * subctxt_cnt is 0 if not shared, so do base
 			 * separately, first, then remaining subctxt, if any
 			 */
+			evs = dd->events + uctxt_offset(uctxt);
 			set_bit(evtbit, evs);
 			for (i = 1; i < uctxt->subctxt_cnt; i++)
 				set_bit(evtbit, evs + i);
@@ -1558,8 +1554,7 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 	if (!dd->events)
 		return 0;
 
-	evs = dd->events + ((uctxt->ctxt - dd->first_dyn_alloc_ctxt) *
-			    HFI1_MAX_SHARED_CTXTS) + subctxt;
+	evs = dd->events + uctxt_offset(uctxt) + subctxt;
 
 	for (i = 0; i <= _HFI1_MAX_EVENT_BIT; i++) {
 		if (!test_bit(i, &events))
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 611eeba..fc1ee8d 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1374,6 +1374,12 @@ struct hfi1_filedata {
 extern u32 hfi1_cpulist_count;
 extern unsigned long *hfi1_cpulist;
 
+static inline unsigned long uctxt_offset(struct hfi1_ctxtdata *uctxt)
+{
+	return (uctxt->ctxt - uctxt->dd->first_dyn_alloc_ctxt) *
+		HFI1_MAX_SHARED_CTXTS;
+}
+
 int hfi1_init(struct hfi1_devdata *dd, int reinit);
 int hfi1_count_active_units(void);
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 6f6c14d..ff9ad69 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -542,8 +542,7 @@ int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	unsigned long *ev = uctxt->dd->events +
-		(((uctxt->ctxt - uctxt->dd->first_dyn_alloc_ctxt) *
-		  HFI1_MAX_SHARED_CTXTS) + fd->subctxt);
+		(uctxt_offset(uctxt) + fd->subctxt);
 	u32 *array;
 	int ret = 0;
 
@@ -942,8 +941,7 @@ static int tid_rb_invalidate(void *arg, struct mmu_rb_node *mnode)
 			 * process in question.
 			 */
 			ev = uctxt->dd->events +
-			  (((uctxt->ctxt - uctxt->dd->first_dyn_alloc_ctxt) *
-			    HFI1_MAX_SHARED_CTXTS) + fdata->subctxt);
+				(uctxt_offset(uctxt) + fdata->subctxt);
 			set_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
 		}
 		fdata->invalid_tid_idx++;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
