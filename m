From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 14/15] IB/hfi1: Fix an assign/ordering issue with shared
 context IDs
Date: Thu, 04 May 2017 05:15:15 -0700
Message-ID: <20170504121514.32747.42380.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current algorithm for generating sub-context IDs is FILO.  If the
contexts are not closed in that order, the uniqueness of the ID will be
compromised. I.e. logging the creation/deletion of context IDs with an
application that assigns and closes in a FIFO order reveals:

cache_id: assign: uctxt: 3    sub_ctxt: 0
cache_id: assign: uctxt: 3    sub_ctxt: 1
cache_id: assign: uctxt: 3    sub_ctxt: 2
cache_id: close:  uctxt: 3    sub_ctxt: 0
cache_id: assign: uctxt: 3    sub_ctxt: 2 <<<

The sub_ctxt ID 2 is reused incorrectly.

Update the sub-context ID assign algorithm to use a bitmask of in_use
contexts.  The new algorithm will allow the contexts to be closed in any
order, and will only re-use unused contexts.

Size subctxt and subctxt_cnt to match the user API size.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c    |    2 +
 drivers/infiniband/hw/hfi1/file_ops.c  |   51 +++++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/hfi.h       |    8 +++--
 drivers/infiniband/hw/hfi1/init.c      |    3 +-
 drivers/infiniband/hw/hfi1/intr.c      |    3 +-
 drivers/infiniband/hw/hfi1/user_sdma.h |    2 +
 6 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 566d152..a50870e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1289,7 +1289,7 @@ int hfi1_reset_device(int unit)
 	if (dd->rcd)
 		for (i = dd->first_dyn_alloc_ctxt;
 		     i < dd->num_rcv_contexts; i++) {
-			if (!dd->rcd[i] || !dd->rcd[i]->cnt)
+			if (!dd->rcd[i])
 				continue;
 			spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 			ret = -EBUSY;
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 467f876..9c177ef 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -49,6 +49,7 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 #include <linux/sched/mm.h>
+#include <linux/bitmap.h>
 
 #include <rdma/ib.h>
 
@@ -95,11 +96,10 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo);
 static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
 static unsigned int poll_next(struct file *fp, struct poll_table_struct *pt);
-static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
+static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 			  unsigned long events);
-static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
-			 u16 pkey);
-static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, u16 subctxt, u16 pkey);
+static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       int start_stop);
 static int vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
@@ -773,8 +773,8 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 			   HFI1_MAX_SHARED_CTXTS) + fdata->subctxt;
 	*ev = 0;
 
-	if (--uctxt->cnt) {
-		uctxt->active_slaves &= ~(1 << fdata->subctxt);
+	__clear_bit(fdata->subctxt, uctxt->in_use_ctxts);
+	if (!bitmap_empty(uctxt->in_use_ctxts, HFI1_MAX_SHARED_CTXTS)) {
 		mutex_unlock(&hfi1_mutex);
 		goto done;
 	}
@@ -868,7 +868,7 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	}
 
 	/*
-	 * Allocate a base context f context sharing is not required or we
+	 * Allocate a base context if context sharing is not required or we
 	 * couldn't find a sub context.
 	 */
 	if (!ret)
@@ -905,17 +905,24 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	return ret;
 }
 
+/*
+ * The hfi1_mutex must be held when this function is called.  It is
+ * necessary to ensure serialized access to the bitmask in_use_ctxts.
+ */
 static int find_sub_ctxt(struct hfi1_filedata *fd,
 			 const struct hfi1_user_info *uinfo)
 {
 	int i;
 	struct hfi1_devdata *dd = fd->dd;
+	u16 subctxt;
 
 	for (i = dd->first_dyn_alloc_ctxt; i < dd->num_rcv_contexts; i++) {
 		struct hfi1_ctxtdata *uctxt = dd->rcd[i];
 
 		/* Skip ctxts which are not yet open */
-		if (!uctxt || !uctxt->cnt)
+		if (!uctxt ||
+		    bitmap_empty(uctxt->in_use_ctxts,
+				 HFI1_MAX_SHARED_CTXTS))
 			continue;
 
 		/* Skip dynamically allocted kernel contexts */
@@ -931,13 +938,19 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
 			continue;
 
 		/* Verify the sharing process matches the master */
-		if (uctxt->userversion != uinfo->userversion ||
-		    uctxt->cnt >= uctxt->subctxt_cnt) {
+		if (uctxt->userversion != uinfo->userversion)
 			return -EINVAL;
-		}
+
+		/* Find an unused context */
+		subctxt = find_first_zero_bit(uctxt->in_use_ctxts,
+					      HFI1_MAX_SHARED_CTXTS);
+		if (subctxt >= uctxt->subctxt_cnt)
+			return -EINVAL;
+
 		fd->uctxt = uctxt;
-		fd->subctxt  = uctxt->cnt++;
-		uctxt->active_slaves |= 1 << fd->subctxt;
+		fd->subctxt = subctxt;
+		__set_bit(fd->subctxt, uctxt->in_use_ctxts);
+
 		return 1;
 	}
 
@@ -1055,7 +1068,7 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo)
 {
-	unsigned num_subctxts;
+	u16 num_subctxts;
 
 	num_subctxts = uinfo->subctxt_cnt;
 	if (num_subctxts > HFI1_MAX_SHARED_CTXTS)
@@ -1063,7 +1076,6 @@ static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 
 	uctxt->subctxt_cnt = uinfo->subctxt_cnt;
 	uctxt->subctxt_id = uinfo->subctxt_id;
-	uctxt->active_slaves = 1;
 	uctxt->redirect_seq_cnt = 1;
 	set_bit(HFI1_CTXT_BASE_UNINIT, &uctxt->event_flags);
 
@@ -1073,7 +1085,7 @@ static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 {
 	int ret = 0;
-	unsigned num_subctxts = uctxt->subctxt_cnt;
+	u16 num_subctxts = uctxt->subctxt_cnt;
 
 	uctxt->subctxt_uregbase = vmalloc_user(PAGE_SIZE);
 	if (!uctxt->subctxt_uregbase)
@@ -1425,7 +1437,7 @@ int hfi1_set_uevent_bits(struct hfi1_pportdata *ppd, const int evtbit)
  * overflow conditions.  start_stop==1 re-enables, to be used to
  * re-init the software copy of the head register
  */
-static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       int start_stop)
 {
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -1460,7 +1472,7 @@ static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
  * User process then performs actions appropriate to bit having been
  * set, if desired, and checks again in future.
  */
-static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
+static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 			  unsigned long events)
 {
 	int i;
@@ -1481,8 +1493,7 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
 	return 0;
 }
 
-static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
-			 u16 pkey)
+static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, u16 subctxt, u16 pkey)
 {
 	int ret = -ENOENT, i, intable = 0;
 	struct hfi1_pportdata *ppd = uctxt->ppd;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1b7203a..f3d75fc 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -228,7 +228,7 @@ struct hfi1_ctxtdata {
 	unsigned ctxt;
 	/*
 	 * non-zero if ctxt can be shared, and defines the maximum number of
-	 * sub contexts allowed.
+	 * sub-contexts for this device context.
 	 */
 	u16 subctxt_cnt;
 	/* non-zero if ctxt is being shared. */
@@ -287,10 +287,10 @@ struct hfi1_ctxtdata {
 	void *subctxt_rcvegrbuf;
 	/* An array of pages for the eager header queue entries * N */
 	void *subctxt_rcvhdr_base;
+	/* Bitmask of in use context(s) */
+	DECLARE_BITMAP(in_use_ctxts, HFI1_MAX_SHARED_CTXTS);
 	/* The version of the library which opened this ctxt */
 	u32 userversion;
-	/* Bitmask of active slaves */
-	u32 active_slaves;
 	/* Type of packets or conditions we want to poll for */
 	u16 poll_type;
 	/* receive packet sequence counter */
@@ -1239,9 +1239,9 @@ static inline bool hfi1_vnic_is_rsm_full(struct hfi1_devdata *dd, int spare)
 struct hfi1_filedata {
 	struct hfi1_devdata *dd;
 	struct hfi1_ctxtdata *uctxt;
-	unsigned subctxt;
 	struct hfi1_user_sdma_comp_q *cq;
 	struct hfi1_user_sdma_pkt_q *pq;
+	u16 subctxt;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
 	u32 tid_n_pinned;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 52a6364..694a8ec 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -53,6 +53,7 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/hrtimer.h>
+#include <linux/bitmap.h>
 #include <rdma/rdma_vt.h>
 
 #include "hfi.h"
@@ -222,7 +223,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 		INIT_LIST_HEAD(&rcd->qp_wait_list);
 		rcd->ppd = ppd;
 		rcd->dd = dd;
-		rcd->cnt = 1;
+		__set_bit(0, rcd->in_use_ctxts);
 		rcd->ctxt = ctxt;
 		dd->rcd[ctxt] = rcd;
 		rcd->numa_id = numa;
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 232014d..ba265d0 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -47,6 +47,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/bitmap.h>
 
 #include "hfi.h"
 #include "common.h"
@@ -189,7 +190,7 @@ void handle_user_interrupt(struct hfi1_ctxtdata *rcd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dd->uctxt_lock, flags);
-	if (!rcd->cnt)
+	if (bitmap_empty(rcd->in_use_ctxts, HFI1_MAX_SHARED_CTXTS))
 		goto done;
 
 	if (test_and_clear_bit(HFI1_CTXT_WAITING_RCV, &rcd->event_flags)) {
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 9181d7c..e5b10ae 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -58,7 +58,7 @@
 struct hfi1_user_sdma_pkt_q {
 	struct list_head list;
 	unsigned ctxt;
-	unsigned subctxt;
+	u16 subctxt;
 	u16 n_max_reqs;
 	atomic_t n_reqs;
 	u16 reqidx;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
