From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 14/22] staging/rdma/hfi1: Implement Expected Receive TID caching
Date: Mon, 19 Oct 2015 22:11:29 -0400
Message-ID: <1445307097-8244-15-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Expected receives work by user-space libraries (PSM) calling into the driver
with information about the user's receive buffer and have the driver DMA-map
that buffer and program the HFI to receive data directly into it.

This is an expensive operation as it requires the driver to pin the pages which
the user's buffer maps to, DMA-map them, and then program the HFI.

When the receive is complete, user-space libraries have to call into the driver
again so the buffer is removed from the HFI, un-mapped, and the pages unpinned.

All of these operations are expensive, considering that a lot of applications
(especially micro-benchmarks) use the same buffer over and over.

In order to get better performance for user-space applications, it is highly
beneficial that they don't continuously call into the driver to register and
unregister the same buffer. Rather, they can register the buffer and cache it
for future work. The buffer can be unregistered when it is freed by the user.

This change implements such buffer caching by making use of the kernel's MMU
notifier API. User-space libraries call into the driver only when the need to
register a new buffer.

Once a buffer is registered, it stays programmed into the HFI until the kernel
notifies the driver that the buffer has been freed by the user. At that time,
the user-space library is notified and it can do the necessary work to remove
the buffer from its cache.

Buffers which have been invalidated by the kernel are not automatically removed
from the HFI and do not have their pages unpinned. Buffers are only completely
removed when the user-space libraries call into the driver to free them.  This
is done to ensure that any ongoing transfers into that buffer are complete.
This is important when a buffer is not completely freed but rather it is
shrunk. The user-space library could still have uncompleted transfers into the
remaining buffer.

With this feature, it is important that systems are setup with reasonable
limits for the amount of lockable memory.  Keeping the limit at "unlimited" (as
we've done up to this point), may result in jobs being killed by the kernel's
OOM due to them taking up excessive amounts of memory.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile       |    2 +-
 drivers/staging/rdma/hfi1/common.h       |   15 +-
 drivers/staging/rdma/hfi1/file_ops.c     |  494 ++-----------
 drivers/staging/rdma/hfi1/hfi.h          |   43 +-
 drivers/staging/rdma/hfi1/init.c         |    5 +-
 drivers/staging/rdma/hfi1/trace.h        |  132 ++--
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 1171 ++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h |   82 +++
 drivers/staging/rdma/hfi1/user_pages.c   |  110 +--
 drivers/staging/rdma/hfi1/user_sdma.c    |   13 +
 drivers/staging/rdma/hfi1/user_sdma.h    |   10 +-
 include/uapi/rdma/hfi/hfi1_user.h        |   42 +-
 12 files changed, 1481 insertions(+), 638 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.h

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 2e5daa6cdcc2..00c47b788666 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o eprom.o file_ops.o firmware.o \
 	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
-	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
+	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
 
 CFLAGS_trace.o = -I$(src)
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index de62cbe2224c..7809093eb55e 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -132,13 +132,14 @@
  * HFI1_CAP_RESERVED_MASK bits.
  */
 #define HFI1_CAP_WRITABLE_MASK   (HFI1_CAP_SDMA_AHG |			\
-				 HFI1_CAP_HDRSUPP |			\
-				 HFI1_CAP_MULTI_PKT_EGR |		\
-				 HFI1_CAP_NODROP_RHQ_FULL |		\
-				 HFI1_CAP_NODROP_EGR_FULL |		\
-				 HFI1_CAP_ALLOW_PERM_JKEY |		\
-				 HFI1_CAP_STATIC_RATE_CTRL |		\
-				 HFI1_CAP_PRINT_UNIMPL)
+				  HFI1_CAP_HDRSUPP |			\
+				  HFI1_CAP_MULTI_PKT_EGR |		\
+				  HFI1_CAP_NODROP_RHQ_FULL |		\
+				  HFI1_CAP_NODROP_EGR_FULL |		\
+				  HFI1_CAP_ALLOW_PERM_JKEY |		\
+				  HFI1_CAP_STATIC_RATE_CTRL |		\
+				  HFI1_CAP_PRINT_UNIMPL |		\
+				  HFI1_CAP_TID_UNMAP)
 /*
  * A set of capability bits that are "global" and are not allowed to be
  * set in the user bitmask.
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 3c9cae6f64a3..61031a0be0dc 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -47,20 +47,10 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
-#include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
-#include <linux/swap.h>
 #include <linux/vmalloc.h>
-#include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
-#include <asm/pgtable.h>
-#include <linux/delay.h>
-#include <linux/export.h>
-#include <linux/module.h>
-#include <linux/cred.h>
-#include <linux/uio.h>
 
 #include "hfi.h"
 #include "pio.h"
@@ -68,6 +58,7 @@
 #include "common.h"
 #include "trace.h"
 #include "user_sdma.h"
+#include "user_exp_rcv.h"
 #include "eprom.h"
 
 #undef pr_fmt
@@ -105,9 +96,6 @@ static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
 static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
 static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
 static int vma_fault(struct vm_area_struct *, struct vm_fault *);
-static int exp_tid_setup(struct file *, struct hfi1_tid_info *);
-static int exp_tid_free(struct file *, struct hfi1_tid_info *);
-static void unlock_exp_tids(struct hfi1_ctxtdata *);
 
 static const struct file_operations hfi1_file_ops = {
 	.owner = THIS_MODULE,
@@ -170,18 +158,6 @@ enum mmap_types {
 	HFI1_MMAP_TOKEN_SET(SUBCTXT, subctxt) | \
 	HFI1_MMAP_TOKEN_SET(OFFSET, (offset_in_page(addr))))
 
-#define EXP_TID_SET(field, value)			\
-	(((value) & EXP_TID_TID##field##_MASK) <<	\
-	 EXP_TID_TID##field##_SHIFT)
-#define EXP_TID_CLEAR(tid, field) {					\
-		(tid) &= ~(EXP_TID_TID##field##_MASK <<			\
-			   EXP_TID_TID##field##_SHIFT);			\
-			}
-#define EXP_TID_RESET(tid, field, value) do {				\
-		EXP_TID_CLEAR(tid, field);				\
-		(tid) |= EXP_TID_SET(field, value);			\
-	} while (0)
-
 #define dbg(fmt, ...)				\
 	pr_info(fmt, ##__VA_ARGS__)
 
@@ -195,8 +171,12 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 {
 	/* The real work is performed later in assign_ctxt() */
 	fp->private_data = kzalloc(sizeof(struct hfi1_filedata), GFP_KERNEL);
-	if (fp->private_data) /* no cpu affinity by default */
-		((struct hfi1_filedata *)fp->private_data)->rec_cpu_num = -1;
+	if (fp->private_data) {
+		struct hfi1_filedata *fd = fp->private_data;
+
+		/* no cpu affinity by default */
+		fd->rec_cpu_num = -1;
+	}
 	return fp->private_data ? 0 : -ENOMEM;
 }
 
@@ -208,6 +188,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 	struct hfi1_cmd cmd;
 	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
+	unsigned long addr;
 	ssize_t consumed = 0, copy = 0, ret = 0;
 	void *dest = NULL;
 	__u64 user_val = 0;
@@ -239,6 +220,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 		break;
 	case HFI1_CMD_TID_UPDATE:
 	case HFI1_CMD_TID_FREE:
+	case HFI1_CMD_TID_INVAL_READ:
 		copy = sizeof(tinfo);
 		dest = &tinfo;
 		break;
@@ -317,9 +299,8 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 			sc_return_credits(uctxt->sc);
 		break;
 	case HFI1_CMD_TID_UPDATE:
-		ret = exp_tid_setup(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_setup(fp, &tinfo);
 		if (!ret) {
-			unsigned long addr;
 			/*
 			 * Copy the number of tidlist entries we used
 			 * and the length of the buffer we registered.
@@ -334,8 +315,23 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 				ret = -EFAULT;
 		}
 		break;
+	case HFI1_CMD_TID_INVAL_READ:
+		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
+		if (!ret) {
+			addr = (unsigned long)cmd.addr +
+				offsetof(struct hfi1_tid_info, tidcnt);
+			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+					 sizeof(tinfo.tidcnt)))
+				ret = -EFAULT;
+		}
+		break;
 	case HFI1_CMD_TID_FREE:
-		ret = exp_tid_free(fp, &tinfo);
+		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
+		addr = (unsigned long)cmd.addr +
+			offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			ret = -EFAULT;
 		break;
 	case HFI1_CMD_RECV_CTRL:
 		ret = manage_rcvq(uctxt, subctxt_fp(fp), (int)user_val);
@@ -607,9 +603,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = ((unsigned long)dd->events +
-			   ((uctxt->ctxt - dd->first_user_ctxt) *
-			    HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
+		memaddr = (unsigned long)(dd->events +
+					  ((uctxt->ctxt - dd->first_user_ctxt) *
+					   HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
 		memlen = PAGE_SIZE;
 		/*
 		 * v3.7 removes VM_RESERVED but the effect is kept by
@@ -760,6 +756,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	mutex_lock(&hfi1_mutex);
 
 	flush_wc();
+
 	/* drain user sdma queue */
 	if (fdata->pq)
 		hfi1_user_sdma_free_queues(fdata);
@@ -809,12 +806,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	uctxt->pionowait = 0;
 	uctxt->event_flags = 0;
 
-	hfi1_clear_tids(uctxt);
+	hfi1_user_exp_rcv_free(fdata);
 	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
 
-	if (uctxt->tid_pg_list)
-		unlock_exp_tids(uctxt);
-
 	hfi1_stats.sps_ctxts--;
 	dd->freectxts++;
 	mutex_unlock(&hfi1_mutex);
@@ -1016,6 +1010,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	ret = sc_enable(uctxt->sc);
 	if (ret)
 		return ret;
+
 	/*
 	 * Setup shared context resources if the user-level has requested
 	 * shared contexts and this is the 'master' process.
@@ -1050,22 +1045,19 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo)
 {
-	int ret = 0;
 	unsigned num_subctxts;
 
 	num_subctxts = uinfo->subctxt_cnt;
-	if (num_subctxts > HFI1_MAX_SHARED_CTXTS) {
-		ret = -EINVAL;
-		goto bail;
-	}
+	if (num_subctxts > HFI1_MAX_SHARED_CTXTS)
+		return -EINVAL;
 
 	uctxt->subctxt_cnt = uinfo->subctxt_cnt;
 	uctxt->subctxt_id = uinfo->subctxt_id;
 	uctxt->active_slaves = 1;
 	uctxt->redirect_seq_cnt = 1;
 	set_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
-bail:
-	return ret;
+
+	return 0;
 }
 
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
@@ -1122,7 +1114,7 @@ static int user_init(struct file *fp)
 		ret = wait_event_interruptible(uctxt->wait,
 			!test_bit(HFI1_CTXT_MASTER_UNINIT,
 			&uctxt->event_flags));
-		goto done;
+		goto expected;
 	}
 
 	/* initialize poll variables... */
@@ -1169,8 +1161,18 @@ static int user_init(struct file *fp)
 		clear_bit(HFI1_CTXT_MASTER_UNINIT, &uctxt->event_flags);
 		wake_up(&uctxt->wait);
 	}
-	ret = 0;
 
+expected:
+	/*
+	 * Expected receive has to be setup for all processes (including
+	 * shared contexts). However, it has to be done after the master
+	 * context has been fully configured as it depends on the
+	 * eager/expected split of the RcvArray entries.
+	 * Setting it up here ensures that the subcontexts will be waiting
+	 * (due to the above wait_event_interruptible() until the master
+	 * is setup.
+	 */
+	ret = hfi1_user_exp_rcv_init(fp);
 done:
 	return ret;
 }
@@ -1223,6 +1225,7 @@ static int setup_ctxt(struct file *fp)
 	 * is not requested or by the master process.
 	 */
 	if (!uctxt->subctxt_cnt || !subctxt_fp(fp)) {
+
 		ret = hfi1_init_ctxt(uctxt->sc);
 		if (ret)
 			goto done;
@@ -1239,46 +1242,6 @@ static int setup_ctxt(struct file *fp)
 			if (ret)
 				goto done;
 		}
-		/* Setup Expected Rcv memories */
-		uctxt->tid_pg_list = vzalloc(uctxt->expected_count *
-					     sizeof(struct page **));
-		if (!uctxt->tid_pg_list) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		uctxt->physshadow = vzalloc(uctxt->expected_count *
-					    sizeof(*uctxt->physshadow));
-		if (!uctxt->physshadow) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		/* allocate expected TID map and initialize the cursor */
-		atomic_set(&uctxt->tidcursor, 0);
-		uctxt->numtidgroups = uctxt->expected_count /
-			dd->rcv_entries.group_size;
-		uctxt->tidmapcnt = uctxt->numtidgroups / BITS_PER_LONG +
-			!!(uctxt->numtidgroups % BITS_PER_LONG);
-		uctxt->tidusemap = kzalloc_node(uctxt->tidmapcnt *
-						sizeof(*uctxt->tidusemap),
-						GFP_KERNEL, uctxt->numa_id);
-		if (!uctxt->tidusemap) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		/*
-		 * In case that the number of groups is not a multiple of
-		 * 64 (the number of groups in a tidusemap element), mark
-		 * the extra ones as used. This will effectively make them
-		 * permanently used and should never be assigned. Otherwise,
-		 * the code which checks how many free groups we have will
-		 * get completely confused about the state of the bits.
-		 */
-		if (uctxt->numtidgroups % BITS_PER_LONG)
-			uctxt->tidusemap[uctxt->tidmapcnt - 1] =
-				~((1ULL << (uctxt->numtidgroups %
-					    BITS_PER_LONG)) - 1);
-		trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 0,
-				       uctxt->tidusemap, uctxt->tidmapcnt);
 	}
 	ret = hfi1_user_sdma_alloc_queues(uctxt, fp);
 	if (ret)
@@ -1514,365 +1477,6 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
 	return 0;
 }
 
-#define num_user_pages(vaddr, len)					\
-	(1 + (((((unsigned long)(vaddr) +				\
-		 (unsigned long)(len) - 1) & PAGE_MASK) -		\
-	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
-
-/**
- * tzcnt - count the number of trailing zeros in a 64bit value
- * @value: the value to be examined
- *
- * Returns the number of trailing least significant zeros in the
- * the input value. If the value is zero, return the number of
- * bits of the value.
- */
-static inline u8 tzcnt(u64 value)
-{
-	return value ? __builtin_ctzl(value) : sizeof(value) * 8;
-}
-
-static inline unsigned num_free_groups(unsigned long map, u16 *start)
-{
-	unsigned free;
-	u16 bitidx = *start;
-
-	if (bitidx >= BITS_PER_LONG)
-		return 0;
-	/* "Turn off" any bits set before our bit index */
-	map &= ~((1ULL << bitidx) - 1);
-	free = tzcnt(map) - bitidx;
-	while (!free && bitidx < BITS_PER_LONG) {
-		/* Zero out the last set bit so we look at the rest */
-		map &= ~(1ULL << bitidx);
-		/*
-		 * Account for the previously checked bits and advance
-		 * the bit index. We don't have to check for bitidx
-		 * getting bigger than BITS_PER_LONG here as it would
-		 * mean extra instructions that we don't need. If it
-		 * did happen, it would push free to a negative value
-		 * which will break the loop.
-		 */
-		free = tzcnt(map) - ++bitidx;
-	}
-	*start = bitidx;
-	return free;
-}
-
-static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
-{
-	int ret = 0;
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tid, mapped = 0, npages, ngroups, exp_groups,
-		tidpairs = uctxt->expected_count / 2;
-	struct page **pages;
-	unsigned long vaddr, tidmap[uctxt->tidmapcnt];
-	dma_addr_t *phys;
-	u32 tidlist[tidpairs], pairidx = 0, tidcursor;
-	u16 useidx, idx, bitidx, tidcnt = 0;
-
-	vaddr = tinfo->vaddr;
-
-	if (offset_in_page(vaddr)) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	npages = num_user_pages(vaddr, tinfo->length);
-	if (!npages) {
-		ret = -EINVAL;
-		goto bail;
-	}
-	if (!access_ok(VERIFY_WRITE, (void __user *)vaddr,
-		       npages * PAGE_SIZE)) {
-		dd_dev_err(dd, "Fail vaddr %p, %u pages, !access_ok\n",
-			   (void *)vaddr, npages);
-		ret = -EFAULT;
-		goto bail;
-	}
-
-	memset(tidmap, 0, sizeof(tidmap[0]) * uctxt->tidmapcnt);
-	memset(tidlist, 0, sizeof(tidlist[0]) * tidpairs);
-
-	exp_groups = uctxt->expected_count / dd->rcv_entries.group_size;
-	/* which group set do we look at first? */
-	tidcursor = atomic_read(&uctxt->tidcursor);
-	useidx = (tidcursor >> 16) & 0xffff;
-	bitidx = tidcursor & 0xffff;
-
-	/*
-	 * Keep going until we've mapped all pages or we've exhausted all
-	 * RcvArray entries.
-	 * This iterates over the number of tidmaps + 1
-	 * (idx <= uctxt->tidmapcnt) so we check the bitmap which we
-	 * started from one more time for any free bits before the
-	 * starting point bit.
-	 */
-	for (mapped = 0, idx = 0;
-	     mapped < npages && idx <= uctxt->tidmapcnt;) {
-		u64 i, offset = 0;
-		unsigned free, pinned, pmapped = 0, bits_used;
-		u16 grp;
-
-		/*
-		 * "Reserve" the needed group bits under lock so other
-		 * processes can't step in the middle of it. Once
-		 * reserved, we don't need the lock anymore since we
-		 * are guaranteed the groups.
-		 */
-		spin_lock(&uctxt->exp_lock);
-		if (uctxt->tidusemap[useidx] == -1ULL ||
-		    bitidx >= BITS_PER_LONG) {
-			/* no free groups in the set, use the next */
-			useidx = (useidx + 1) % uctxt->tidmapcnt;
-			idx++;
-			bitidx = 0;
-			spin_unlock(&uctxt->exp_lock);
-			continue;
-		}
-		ngroups = ((npages - mapped) / dd->rcv_entries.group_size) +
-			!!((npages - mapped) % dd->rcv_entries.group_size);
-
-		/*
-		 * If we've gotten here, the current set of groups does have
-		 * one or more free groups.
-		 */
-		free = num_free_groups(uctxt->tidusemap[useidx], &bitidx);
-		if (!free) {
-			/*
-			 * Despite the check above, free could still come back
-			 * as 0 because we don't check the entire bitmap but
-			 * we start from bitidx.
-			 */
-			spin_unlock(&uctxt->exp_lock);
-			continue;
-		}
-		bits_used = min(free, ngroups);
-		tidmap[useidx] |= ((1ULL << bits_used) - 1) << bitidx;
-		uctxt->tidusemap[useidx] |= tidmap[useidx];
-		spin_unlock(&uctxt->exp_lock);
-
-		/*
-		 * At this point, we know where in the map we have free bits.
-		 * properly offset into the various "shadow" arrays and compute
-		 * the RcvArray entry index.
-		 */
-		offset = ((useidx * BITS_PER_LONG) + bitidx) *
-			dd->rcv_entries.group_size;
-		pages = uctxt->tid_pg_list + offset;
-		phys = uctxt->physshadow + offset;
-		tid = uctxt->expected_base + offset;
-
-		/* Calculate how many pages we can pin based on free bits */
-		pinned = min((bits_used * dd->rcv_entries.group_size),
-			     (npages - mapped));
-		/*
-		 * Now that we know how many free RcvArray entries we have,
-		 * we can pin that many user pages.
-		 */
-		ret = hfi1_get_user_pages(vaddr + (mapped * PAGE_SIZE),
-					  pinned, pages);
-		if (ret) {
-			/*
-			 * We can't continue because the pages array won't be
-			 * initialized. This should never happen,
-			 * unless perhaps the user has mpin'ed the pages
-			 * themselves.
-			 */
-			dd_dev_info(dd,
-				    "Failed to lock addr %p, %u pages: errno %d\n",
-				    (void *) vaddr, pinned, -ret);
-			/*
-			 * Let go of the bits that we reserved since we are not
-			 * going to use them.
-			 */
-			spin_lock(&uctxt->exp_lock);
-			uctxt->tidusemap[useidx] &=
-				~(((1ULL << bits_used) - 1) << bitidx);
-			spin_unlock(&uctxt->exp_lock);
-			goto done;
-		}
-		/*
-		 * How many groups do we need based on how many pages we have
-		 * pinned?
-		 */
-		ngroups = (pinned / dd->rcv_entries.group_size) +
-			!!(pinned % dd->rcv_entries.group_size);
-		/*
-		 * Keep programming RcvArray entries for all the <ngroups> free
-		 * groups.
-		 */
-		for (i = 0, grp = 0; grp < ngroups; i++, grp++) {
-			unsigned j;
-			u32 pair_size = 0, tidsize;
-			/*
-			 * This inner loop will program an entire group or the
-			 * array of pinned pages (which ever limit is hit
-			 * first).
-			 */
-			for (j = 0; j < dd->rcv_entries.group_size &&
-				     pmapped < pinned; j++, pmapped++, tid++) {
-				tidsize = PAGE_SIZE;
-				phys[pmapped] = hfi1_map_page(dd->pcidev,
-						   pages[pmapped], 0,
-						   tidsize, PCI_DMA_FROMDEVICE);
-				trace_hfi1_exp_rcv_set(uctxt->ctxt,
-						       subctxt_fp(fp),
-						       tid, vaddr,
-						       phys[pmapped],
-						       pages[pmapped]);
-				/*
-				 * Each RcvArray entry is programmed with one
-				 * page * worth of memory. This will handle
-				 * the 8K MTU as well as anything smaller
-				 * due to the fact that both entries in the
-				 * RcvTidPair are programmed with a page.
-				 * PSM currently does not handle anything
-				 * bigger than 8K MTU, so should we even worry
-				 * about 10K here?
-				 */
-				hfi1_put_tid(dd, tid, PT_EXPECTED,
-					     phys[pmapped],
-					     ilog2(tidsize >> PAGE_SHIFT) + 1);
-				pair_size += tidsize >> PAGE_SHIFT;
-				EXP_TID_RESET(tidlist[pairidx], LEN, pair_size);
-				if (!(tid % 2)) {
-					tidlist[pairidx] |=
-					   EXP_TID_SET(IDX,
-						(tid - uctxt->expected_base)
-						       / 2);
-					tidlist[pairidx] |=
-						EXP_TID_SET(CTRL, 1);
-					tidcnt++;
-				} else {
-					tidlist[pairidx] |=
-						EXP_TID_SET(CTRL, 2);
-					pair_size = 0;
-					pairidx++;
-				}
-			}
-			/*
-			 * We've programmed the entire group (or as much of the
-			 * group as we'll use. Now, it's time to push it out...
-			 */
-			flush_wc();
-		}
-		mapped += pinned;
-		atomic_set(&uctxt->tidcursor,
-			   (((useidx & 0xffffff) << 16) |
-			    ((bitidx + bits_used) & 0xffffff)));
-	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 0, uctxt->tidusemap,
-			       uctxt->tidmapcnt);
-
-done:
-	/* If we've mapped anything, copy relevant info to user */
-	if (mapped) {
-		if (copy_to_user((void __user *)(unsigned long)tinfo->tidlist,
-				 tidlist, sizeof(tidlist[0]) * tidcnt)) {
-			ret = -EFAULT;
-			goto done;
-		}
-		/* copy TID info to user */
-		if (copy_to_user((void __user *)(unsigned long)tinfo->tidmap,
-				 tidmap, sizeof(tidmap[0]) * uctxt->tidmapcnt))
-			ret = -EFAULT;
-	}
-bail:
-	/*
-	 * Calculate mapped length. New Exp TID protocol does not "unwind" and
-	 * report an error if it can't map the entire buffer. It just reports
-	 * the length that was mapped.
-	 */
-	tinfo->length = mapped * PAGE_SIZE;
-	tinfo->tidcnt = tidcnt;
-	return ret;
-}
-
-static int exp_tid_free(struct file *fp, struct hfi1_tid_info *tinfo)
-{
-	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned long tidmap[uctxt->tidmapcnt];
-	struct page **pages;
-	dma_addr_t *phys;
-	u16 idx, bitidx, tid;
-	int ret = 0;
-
-	if (copy_from_user(&tidmap, (void __user *)(unsigned long)
-			   tinfo->tidmap,
-			   sizeof(tidmap[0]) * uctxt->tidmapcnt)) {
-		ret = -EFAULT;
-		goto done;
-	}
-	for (idx = 0; idx < uctxt->tidmapcnt; idx++) {
-		unsigned long map;
-
-		bitidx = 0;
-		if (!tidmap[idx])
-			continue;
-		map = tidmap[idx];
-		while ((bitidx = tzcnt(map)) < BITS_PER_LONG) {
-			int i, pcount = 0;
-			struct page *pshadow[dd->rcv_entries.group_size];
-			unsigned offset = ((idx * BITS_PER_LONG) + bitidx) *
-				dd->rcv_entries.group_size;
-
-			pages = uctxt->tid_pg_list + offset;
-			phys = uctxt->physshadow + offset;
-			tid = uctxt->expected_base + offset;
-			for (i = 0; i < dd->rcv_entries.group_size;
-			     i++, tid++) {
-				if (pages[i]) {
-					hfi1_put_tid(dd, tid, PT_INVALID,
-						      0, 0);
-					trace_hfi1_exp_rcv_free(uctxt->ctxt,
-								subctxt_fp(fp),
-								tid, phys[i],
-								pages[i]);
-					pci_unmap_page(dd->pcidev, phys[i],
-					      PAGE_SIZE, PCI_DMA_FROMDEVICE);
-					pshadow[pcount] = pages[i];
-					pages[i] = NULL;
-					pcount++;
-					phys[i] = 0;
-				}
-			}
-			flush_wc();
-			hfi1_release_user_pages(pshadow, pcount);
-			clear_bit(bitidx, &uctxt->tidusemap[idx]);
-			map &= ~(1ULL<<bitidx);
-		}
-	}
-	trace_hfi1_exp_tid_map(uctxt->ctxt, subctxt_fp(fp), 1, uctxt->tidusemap,
-			       uctxt->tidmapcnt);
-done:
-	return ret;
-}
-
-static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt)
-{
-	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tid;
-
-	dd_dev_info(dd, "ctxt %u unlocking any locked expTID pages\n",
-		    uctxt->ctxt);
-	for (tid = 0; tid < uctxt->expected_count; tid++) {
-		struct page *p = uctxt->tid_pg_list[tid];
-		dma_addr_t phys;
-
-		if (!p)
-			continue;
-
-		phys = uctxt->physshadow[tid];
-		uctxt->physshadow[tid] = 0;
-		uctxt->tid_pg_list[tid] = NULL;
-		pci_unmap_page(dd->pcidev, phys, PAGE_SIZE, PCI_DMA_FROMDEVICE);
-		hfi1_release_user_pages(&p, 1);
-	}
-}
-
 static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
 			 u16 pkey)
 {
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 16110149991e..550d72356fd9 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -65,6 +65,8 @@
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/mmu_notifier.h>
+#include <linux/rbtree.h>
 
 #include "chip_registers.h"
 #include "common.h"
@@ -166,6 +168,11 @@ struct ctxt_eager_bufs {
 	} *rcvtids;
 };
 
+struct exp_tid_set {
+	struct list_head list;
+	u32 count;
+};
+
 struct hfi1_ctxtdata {
 	/* shadow the ctxt's RcvCtrl register */
 	u64 rcvctrl;
@@ -222,20 +229,13 @@ struct hfi1_ctxtdata {
 	u32 expected_count;
 	/* index of first expected TID entry. */
 	u32 expected_base;
-	/* cursor into the exp group sets */
-	atomic_t tidcursor;
-	/* number of exp TID groups assigned to the ctxt */
-	u16 numtidgroups;
-	/* size of exp TID group fields in tidusemap */
-	u16 tidmapcnt;
-	/* exp TID group usage bitfield array */
-	unsigned long *tidusemap;
-	/* pinned pages for exp sends, allocated at open */
-	struct page **tid_pg_list;
-	/* dma handles for exp tid pages */
-	dma_addr_t *physshadow;
+
+	struct exp_tid_set tid_group_list;
+	struct exp_tid_set tid_used_list;
+	struct exp_tid_set tid_full_list;
+
 	/* lock protecting all Expected TID data */
-	spinlock_t exp_lock;
+	struct mutex exp_lock;
 	/* number of pio bufs for this ctxt (all procs, if shared) */
 	u32 piocnt;
 	/* first pio buffer for this ctxt */
@@ -1094,6 +1094,8 @@ struct hfi1_devdata {
 #define PT_EAGER    1
 #define PT_INVALID  2
 
+struct mmu_rb_node;
+
 /* Private data for file operations */
 struct hfi1_filedata {
 	struct hfi1_ctxtdata *uctxt;
@@ -1102,6 +1104,15 @@ struct hfi1_filedata {
 	struct hfi1_user_sdma_pkt_q *pq;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
+	struct mmu_notifier mn;
+	struct rb_root tid_rb_root;
+	u32 tid_limit;
+	u32 tid_used;
+	spinlock_t rb_lock;
+	u32 *invalid_tids;
+	u32 invalid_tid_idx;
+	spinlock_t invalid_lock;
+	int (*mmu_rb_insert)(struct rb_root *, struct mmu_rb_node *);
 };
 
 /* for use in system calls, where we want to know device type, etc. */
@@ -1556,8 +1567,8 @@ void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int val);
  */
 #define DEFAULT_RCVHDR_ENTSIZE 32
 
-int hfi1_get_user_pages(unsigned long, size_t, struct page **);
-void hfi1_release_user_pages(struct page **, size_t);
+int hfi1_acquire_user_pages(unsigned long, size_t, bool, struct page **);
+void hfi1_release_user_pages(struct page **, size_t, bool);
 
 static inline void clear_rcvhdrtail(const struct hfi1_ctxtdata *rcd)
 {
@@ -1606,8 +1617,6 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 			enum platform_config_table_type_encoding table_type,
 			int table_index, int field_index, u32 *data, u32 len);
 
-dma_addr_t hfi1_map_page(struct pci_dev *, struct page *, unsigned long,
-			 size_t, int);
 const char *get_unit_name(int unit);
 
 /*
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cd1508ec0914..62aa7718b6d6 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -219,7 +219,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		rcd->numa_id = numa_node_id();
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 
-		spin_lock_init(&rcd->exp_lock);
+		mutex_init(&rcd->exp_lock);
 
 		/*
 		 * Calculate the context's RcvArray entry starting point.
@@ -941,13 +941,10 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	kfree(rcd->egrbufs.buffers);
 
 	sc_free(rcd->sc);
-	vfree(rcd->physshadow);
-	vfree(rcd->tid_pg_list);
 	vfree(rcd->user_event_mask);
 	vfree(rcd->subctxt_uregbase);
 	vfree(rcd->subctxt_rcvegrbuf);
 	vfree(rcd->subctxt_rcvhdr_base);
-	kfree(rcd->tidusemap);
 	kfree(rcd->opstats);
 	kfree(rcd);
 }
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index d7851c0a0171..0354dca9a6f4 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -153,92 +153,130 @@ TRACE_EVENT(hfi1_receive_interrupt,
 	)
 );
 
-const char *print_u64_array(struct trace_seq *, u64 *, int);
+TRACE_EVENT(hfi1_exp_tid_reg,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr,
+		     u32 npages, unsigned long va, unsigned long pa,
+		     dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
+	    TP_STRUCT__entry(
+		    __field(unsigned, ctxt)
+		    __field(u16, subctxt)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(unsigned long, va)
+		    __field(unsigned long, pa)
+		    __field(dma_addr_t, dma)
+		    ),
+	    TP_fast_assign(
+		    __entry->ctxt = ctxt;
+		    __entry->subctxt = subctxt;
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->va = va;
+		    __entry->pa = pa;
+		    __entry->dma = dma;
+		    ),
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx, va:0x%lx dma:0x%llx",
+		      __entry->ctxt,
+		      __entry->subctxt,
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->pa,
+		      __entry->va,
+		      __entry->dma
+		    )
+	);
 
-TRACE_EVENT(hfi1_exp_tid_map,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, int dir,
-		     unsigned long *maps, u16 count),
-	    TP_ARGS(ctxt, subctxt, dir, maps, count),
+TRACE_EVENT(hfi1_exp_tid_unreg,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr, u32 npages,
+		     unsigned long va, unsigned long pa, dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(int, dir)
-		    __field(u16, count)
-		    __dynamic_array(unsigned long, maps, sizeof(*maps) * count)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(unsigned long, va)
+		    __field(unsigned long, pa)
+		    __field(dma_addr_t, dma)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->dir = dir;
-		    __entry->count = count;
-		    memcpy(__get_dynamic_array(maps), maps,
-			   sizeof(*maps) * count);
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->va = va;
+		    __entry->pa = pa;
+		    __entry->dma = dma;
 		    ),
-	    TP_printk("[%3u:%02u] %s tidmaps %s",
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx, va:0x%lx dma:0x%llx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      (__entry->dir ? ">" : "<"),
-		      print_u64_array(p, __get_dynamic_array(maps),
-				      __entry->count)
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->pa,
+		      __entry->va,
+		      __entry->dma
 		    )
 	);
 
-TRACE_EVENT(hfi1_exp_rcv_set,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 tid,
-		     unsigned long vaddr, u64 phys_addr, void *page),
-	    TP_ARGS(ctxt, subctxt, tid, vaddr, phys_addr, page),
+TRACE_EVENT(hfi1_exp_tid_inval,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, unsigned long va, u32 rarr,
+		     u32 npages, dma_addr_t dma),
+	    TP_ARGS(ctxt, subctxt, va, rarr, npages, dma),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(u32, tid)
-		    __field(unsigned long, vaddr)
-		    __field(u64, phys_addr)
-		    __field(void *, page)
+		    __field(unsigned long, va)
+		    __field(u32, rarr)
+		    __field(u32, npages)
+		    __field(dma_addr_t, dma)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->tid = tid;
-		    __entry->vaddr = vaddr;
-		    __entry->phys_addr = phys_addr;
-		    __entry->page = page;
+		    __entry->va = va;
+		    __entry->rarr = rarr;
+		    __entry->npages = npages;
+		    __entry->dma = dma;
 		    ),
-	    TP_printk("[%u:%u] TID %u, vaddrs 0x%lx, physaddr 0x%llx, pgp %p",
+	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx dma: 0x%llx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      __entry->tid,
-		      __entry->vaddr,
-		      __entry->phys_addr,
-		      __entry->page
+		      __entry->rarr,
+		      __entry->npages,
+		      __entry->va,
+		      __entry->dma
 		    )
 	);
 
-TRACE_EVENT(hfi1_exp_rcv_free,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 tid,
-		     unsigned long phys, void *page),
-	    TP_ARGS(ctxt, subctxt, tid, phys, page),
+TRACE_EVENT(hfi1_mmu_invalidate,
+	    TP_PROTO(unsigned ctxt, u16 subctxt, const char *type,
+		     unsigned long start, unsigned long end),
+	    TP_ARGS(ctxt, subctxt, type, start, end),
 	    TP_STRUCT__entry(
 		    __field(unsigned, ctxt)
 		    __field(u16, subctxt)
-		    __field(u32, tid)
-		    __field(unsigned long, phys)
-		    __field(void *, page)
+		    __string(type, type)
+		    __field(unsigned long, start)
+		    __field(unsigned long, end)
 		    ),
 	    TP_fast_assign(
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
-		    __entry->tid = tid;
-		    __entry->phys = phys;
-		    __entry->page = page;
+		    __assign_str(type, type);
+		    __entry->start = start;
+		    __entry->end = end;
 		    ),
-	    TP_printk("[%u:%u] freeing TID %u, 0x%lx, pgp %p",
+	    TP_printk("[%3u:%02u] MMU Invalidate (%s) 0x%lx - 0x%lx",
 		      __entry->ctxt,
 		      __entry->subctxt,
-		      __entry->tid,
-		      __entry->phys,
-		      __entry->page
+		      __get_str(type),
+		      __entry->start,
+		      __entry->end
 		    )
 	);
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_tx
 
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
new file mode 100644
index 000000000000..5274a9f4c3eb
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -0,0 +1,1171 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#include <asm/page.h>
+
+#include "user_exp_rcv.h"
+#include "trace.h"
+
+struct tid_group {
+	struct list_head list;
+	unsigned base;
+	u8 size;
+	u8 used;
+	u8 map;
+};
+
+struct mmu_rb_node {
+	struct rb_node rbnode;
+	unsigned long virt;
+	unsigned long phys;
+	unsigned long len;
+	struct tid_group *grp;
+	u32 rcventry;
+	dma_addr_t dma_addr;
+	bool freed;
+	unsigned npages;
+	struct page *pages[0];
+};
+
+enum mmu_call_types {
+	MMU_INVALIDATE_PAGE = 0,
+	MMU_INVALIDATE_RANGE = 1
+};
+
+static const char * const mmu_types[] = {
+	"PAGE",
+	"RANGE"
+};
+
+struct tid_pageset {
+	u16 idx;
+	u16 count;
+};
+
+
+#define EXP_TID_SET_EMPTY(set) (set.count == 0 && list_empty(&set.list))
+
+#define num_user_pages(vaddr, len)					\
+	(1 + (((((unsigned long)(vaddr) +				\
+		 (unsigned long)(len) - 1) & PAGE_MASK) -		\
+	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
+
+static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
+			    struct rb_root *);
+static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
+static int set_rcvarray_entry(struct file *, unsigned long, u32,
+			      struct tid_group *, struct page **, unsigned);
+
+static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
+			       unsigned long);
+static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
+						 unsigned long);
+static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *,
+							 u32);
+static int mmu_rb_insert_by_addr(struct rb_root *, struct mmu_rb_node *);
+static int mmu_rb_insert_by_entry(struct rb_root *, struct mmu_rb_node *);
+static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
+					unsigned long, unsigned long,
+					enum mmu_call_types);
+static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
+				     unsigned long);
+static inline void mmu_notifier_range_start(struct mmu_notifier *,
+					    struct mm_struct *,
+					    unsigned long, unsigned long);
+static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
+			    struct tid_pageset *, unsigned, u16, struct page **,
+			    u32 *, unsigned *, unsigned *);
+static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
+static void clear_tid_node(struct hfi1_filedata *, u16, struct mmu_rb_node *);
+
+static inline u32 rcventry2tidinfo(u32 rcventry)
+{
+	u32 pair = rcventry & ~0x1;
+
+	return EXP_TID_SET(IDX, pair >> 1) |
+		EXP_TID_SET(CTRL, 1 << (rcventry - pair));
+}
+
+static inline void exp_tid_group_init(struct exp_tid_set *set)
+{
+	INIT_LIST_HEAD(&set->list);
+	set->count = 0;
+}
+
+static inline void tid_group_remove(struct tid_group *grp,
+				    struct exp_tid_set *set)
+{
+	list_del_init(&grp->list);
+	set->count--;
+}
+
+static inline void tid_group_add_tail(struct tid_group *grp,
+				      struct exp_tid_set *set)
+{
+	list_add_tail(&grp->list, &set->list);
+	set->count++;
+}
+
+static inline struct tid_group *tid_group_pop(struct exp_tid_set *set)
+{
+	struct tid_group *grp =
+		list_first_entry(&set->list, struct tid_group, list);
+	list_del_init(&grp->list);
+	set->count--;
+	return grp;
+}
+
+static inline void tid_group_move(struct tid_group *group,
+				  struct exp_tid_set *s1,
+				  struct exp_tid_set *s2)
+{
+	tid_group_remove(group, s1);
+	tid_group_add_tail(group, s2);
+}
+
+static struct mmu_notifier_ops mn_opts = {
+	.invalidate_page = mmu_notifier_page,
+	.invalidate_range_start = mmu_notifier_range_start,
+};
+
+/*
+ * Initialize context and file private data needed for Expected
+ * receive caching. This needs to be done after the context has
+ * been configured with the eager/expected RcvEntry counts.
+ */
+int hfi1_user_exp_rcv_init(struct file *fp)
+{
+	struct hfi1_filedata *fd = fp_to_fd(fp);
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_devdata *dd = uctxt->dd;
+	unsigned tidbase;
+	int i, ret = 0;
+
+	INIT_HLIST_NODE(&fd->mn.hlist);
+	spin_lock_init(&fd->rb_lock);
+	spin_lock_init(&fd->invalid_lock);
+	fd->mn.ops = &mn_opts;
+	fd->tid_rb_root = RB_ROOT;
+
+	if (!uctxt->subctxt_cnt || !subctxt_fp(fp)) {
+		exp_tid_group_init(&uctxt->tid_group_list);
+		exp_tid_group_init(&uctxt->tid_used_list);
+		exp_tid_group_init(&uctxt->tid_full_list);
+
+		tidbase = uctxt->expected_base;
+		for (i = 0; i < uctxt->expected_count /
+			     dd->rcv_entries.group_size; i++) {
+			struct tid_group *grp;
+
+			grp = kzalloc(sizeof(*grp), GFP_KERNEL);
+			if (!grp) {
+				/*
+				 * If we fail here, the groups already
+				 * allocated will be freed by the close
+				 * call.
+				 */
+				ret = -ENOMEM;
+				goto done;
+			}
+			grp->size = dd->rcv_entries.group_size;
+			grp->base = tidbase;
+			tid_group_add_tail(grp, &uctxt->tid_group_list);
+			tidbase += dd->rcv_entries.group_size;
+		}
+	}
+
+	if (!HFI1_CAP_IS_USET(TID_UNMAP)) {
+		fd->invalid_tid_idx = 0;
+		fd->invalid_tids = kzalloc(uctxt->expected_count *
+					   sizeof(u32), GFP_KERNEL);
+		if (!fd->invalid_tids) {
+			ret = -ENOMEM;
+			goto done;
+		} else {
+			/*
+			 * Register MMU notifier callbacks. If the registration
+			 * fails, continue but turn off the TID caching for
+			 * all user contexts.
+			 */
+			ret = mmu_notifier_register(&notifier_fp(fp),
+						    current->mm);
+			if (ret) {
+				dd_dev_info(dd,
+					    "Failed MMU notifier registration %d\n",
+					    ret);
+				HFI1_CAP_USET(TID_UNMAP);
+				ret = 0;
+			}
+		}
+	}
+
+	if (HFI1_CAP_IS_USET(TID_UNMAP))
+		fd->mmu_rb_insert = mmu_rb_insert_by_entry;
+	else
+		fd->mmu_rb_insert = mmu_rb_insert_by_addr;
+
+	/*
+	 * PSM does not have a good way to separate, count, and
+	 * effectively enforce a limit on RcvArray entries used by
+	 * subctxts (when context sharing is used) when TID caching
+	 * is enabled. To help with that, we calculate a per-process
+	 * RcvArray entry share and enforce that.
+	 * If TID caching is not in use, PSM deals with usage on its
+	 * own. In that case, we allow any subctxt to take all of the
+	 * entries.
+	 *
+	 * Make sure that we set the tid counts only after successful
+	 * init.
+	 */
+	if (uctxt->subctxt_cnt && !HFI1_CAP_IS_USET(TID_UNMAP)) {
+		u16 remainder;
+
+		fd->tid_limit = uctxt->expected_count / uctxt->subctxt_cnt;
+		remainder = uctxt->expected_count % uctxt->subctxt_cnt;
+		if (remainder && subctxt_fp(fp) < remainder)
+			fd->tid_limit++;
+	} else
+		fd->tid_limit = uctxt->expected_count;
+done:
+	return ret;
+}
+
+int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct tid_group *grp, *gptr;
+
+	/*
+	 * The notifier would have been removed when the process'es mm
+	 * was freed.
+	 */
+	if (current->mm && !HFI1_CAP_IS_USET(TID_UNMAP))
+		mmu_notifier_unregister(&fd->mn, current->mm);
+
+	kfree(fd->invalid_tids);
+
+	if (!uctxt->cnt) {
+		if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
+			unlock_exp_tids(uctxt, &uctxt->tid_full_list,
+					&fd->tid_rb_root);
+		if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
+			unlock_exp_tids(uctxt, &uctxt->tid_used_list,
+					&fd->tid_rb_root);
+		list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
+					 list) {
+			list_del_init(&grp->list);
+			kfree(grp);
+		}
+		spin_lock(&fd->rb_lock);
+		if (!RB_EMPTY_ROOT(&fd->tid_rb_root)) {
+			struct rb_node *node;
+			struct mmu_rb_node *rbnode;
+
+			while ((node = rb_first(&fd->tid_rb_root))) {
+				rbnode = rb_entry(node, struct mmu_rb_node,
+						  rbnode);
+				rb_erase(&rbnode->rbnode, &fd->tid_rb_root);
+				kfree(rbnode);
+			}
+		}
+		spin_unlock(&fd->rb_lock);
+		hfi1_clear_tids(uctxt);
+	}
+	return 0;
+}
+
+/*
+ * Write an "empty" RcvArray entry.
+ * This function exists so the TID registaration code can use it
+ * to write to unused/unneeded entries and still take advantage
+ * of the WC performance improvements. The HFI will ignore this
+ * write to the RcvArray entry.
+ */
+static inline void rcv_array_wc_fill(struct hfi1_devdata *dd, u32 index)
+{
+	/* Doing the WC fill writes only makes sense if the device is
+	 * present and the RcvArray has been mapped as WC memory. */
+	if ((dd->flags & HFI1_PRESENT) && dd->rcvarray_wc)
+		writeq(0, dd->rcvarray_wc + (index * 8));
+}
+
+/*
+ * RcvArray entry allocation for Expected Receives is done by the
+ * following algorithm:
+ *
+ * The context keeps 3 lists of groups of RcvArray entries:
+ *   1. List of empty groups - tid_group_list
+ *      This list is created during user context creation and
+ *      contains elements which describe sets (of 8) of empty
+ *      RcvArray entries.
+ *   2. List of partially used groups - tid_used_list
+ *      This list contains sets of RcvArray entries which are
+ *      not completely used up. Another mapping request could
+ *      use some of all of the remaining entries.
+ *   3. List of full groups - tid_full_list
+ *      This is the list where sets that are completely used
+ *      up go.
+ *
+ * An attempt to optimize the usage of RcvArray entries is
+ * made by finding all sets of physically contiguous pages in a
+ * user's buffer.
+ * These physically contiguous sets are further split into
+ * sizes supported by the receive engine of the HFI. The
+ * resulting sets of pages are stored in struct tid_pageset,
+ * which describes the sets as:
+ *    * .count - number of pages in this set
+ *    * .idx - starting index into struct page ** array
+ *                    of this set
+ *
+ * From this point on, the algorithm deals with the page sets
+ * described above. The number of pagesets is divided by the
+ * RcvArray group size to produce the number of full groups
+ * needed.
+ *
+ * Groups from the 3 lists are manipulated using the following
+ * rules:
+ *   1. For each set of 8 pagesets, a complete group from
+ *      tid_group_list is taken, programmed, and moved to
+ *      the tid_full_list list.
+ *   2. For all remaining pagesets:
+ *      2.1 If the tid_used_list is empty and the tid_group_list
+ *          is empty, stop processing pageset and return only
+ *          what has been programmed up to this point.
+ *      2.2 If the tid_used_list is empty and the tid_group_list
+ *          is not empty, move a group from tid_group_list to
+ *          tid_used_list.
+ *      2.3 For each group is tid_used_group, program as much as
+ *          can fit into the group. If the group becomes fully
+ *          used, move it to tid_full_list.
+ */
+int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	int ret = 0, need_group = 0, pinned;
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_devdata *dd = uctxt->dd;
+	unsigned npages, ngroups, pageidx = 0, pageset_count, npagesets,
+		tididx = 0, mapped, mapped_pages = 0;
+	unsigned long vaddr = tinfo->vaddr;
+	struct page **pages = NULL;
+	u32 *tidlist = NULL;
+	struct tid_pageset *pagesets = NULL;
+
+	/* Get the number of pages the user buffer spans */
+	npages = num_user_pages(vaddr, tinfo->length);
+	if (!npages) {
+		ret = -EINVAL;
+		goto bail;
+	}
+
+	if (npages > uctxt->expected_count) {
+		dd_dev_err(dd, "Expected buffer too big\n");
+		ret = -EINVAL;
+		goto bail;
+	}
+
+	pagesets = kcalloc(uctxt->expected_count, sizeof(*pagesets),
+			   GFP_KERNEL);
+	if (!pagesets) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
+	/* Verify that access is OK for the user buffer */
+	if (!access_ok(VERIFY_WRITE, (void __user *)vaddr,
+		       npages * PAGE_SIZE)) {
+		dd_dev_err(dd, "Fail vaddr %p, %u pages, !access_ok\n",
+			   (void *)vaddr, npages);
+		ret = -EFAULT;
+		goto bail;
+	}
+
+	/* Allocate the array of struct page pointers needed for pinning */
+	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
+	/*
+	 * Pin all the pages of the user buffer. If we can't pin all the
+	 * pages, accept the amount pinned so far and program only that.
+	 * User space knows how to deal with partially programmed buffers.
+	 */
+	pinned = hfi1_acquire_user_pages(vaddr, npages, true, pages);
+	if (pinned <= 0) {
+		/*
+		 * -EDQUOT has a special meaning (we can't lock any more
+		 * pages), which user space knows how to deal with. We
+		 * don't need an error message.
+		 */
+		if (pinned != -EDQUOT)
+			dd_dev_err(dd,
+				   "Failed to lock addr %p, %u pages: errno %d\n",
+				   (void *) vaddr, npages, pinned);
+		ret = pinned;
+		goto bail;
+	}
+
+	/* Find sets of physically contiguous pages */
+	npagesets = find_phys_blocks(pages, pinned, pagesets);
+
+	/*
+	 * We don't need to access this under a lock since tid_used is per
+	 * process and the same process cannot be in hfi1_user_exp_rcv_clear()
+	 * and hfi1_user_exp_rcv_setup() at the same time.
+	 */
+	if (fp_to_fd(fp)->tid_used + npagesets > fp_to_fd(fp)->tid_limit)
+		pageset_count = fp_to_fd(fp)->tid_limit -
+			fp_to_fd(fp)->tid_used;
+	else
+		pageset_count = npagesets;
+
+	if (!pageset_count)
+		goto bail;
+
+	ngroups = pageset_count / dd->rcv_entries.group_size;
+	tidlist = kcalloc(pageset_count, sizeof(*tidlist), GFP_KERNEL);
+	if (!tidlist) {
+		ret = -ENOMEM;
+		goto nomem;
+	}
+
+	tididx = 0;
+
+	/* From this point on, we are going to be using shared (between master
+	 * and subcontexts) context resources. We need to take the lock. */
+	mutex_lock(&uctxt->exp_lock);
+	/* The first step is to program the RcvArray entries which are complete
+	 * groups. */
+	while (ngroups && uctxt->tid_group_list.count) {
+		struct tid_group *grp =
+			tid_group_pop(&uctxt->tid_group_list);
+
+		ret = program_rcvarray(fp, vaddr, grp, pagesets,
+				       pageidx, dd->rcv_entries.group_size,
+				       pages, tidlist, &tididx, &mapped);
+		/*
+		 * If there was a failure to program the RcvArray
+		 * entries for the entire group, reset the grp fields
+		 * and add the grp back to the free group list.
+		 */
+		if (ret <= 0) {
+			tid_group_add_tail(grp, &uctxt->tid_group_list);
+			hfi1_cdbg(TID,
+				  "Failed to program RcvArray group %d", ret);
+			goto unlock;
+		}
+
+		tid_group_add_tail(grp, &uctxt->tid_full_list);
+		ngroups--;
+		pageidx += ret;
+		mapped_pages += mapped;
+	}
+
+	while (pageidx < pageset_count) {
+		struct tid_group *grp, *ptr;
+		/*
+		 * If we don't have any partially used tid groups, check
+		 * if we have empty groups. If so, take one from there and
+		 * put in the partially used list.
+		 */
+		if (!uctxt->tid_used_list.count || need_group) {
+			if (!uctxt->tid_group_list.count)
+				goto unlock;
+
+			grp = tid_group_pop(&uctxt->tid_group_list);
+			tid_group_add_tail(grp, &uctxt->tid_used_list);
+			need_group = 0;
+		}
+		/*
+		 * There is an optimization opportunity here - instead of
+		 * fitting as many page sets as we can, check for a group
+		 * later on in the list that could fit all of them.
+		 */
+		list_for_each_entry_safe(grp, ptr, &uctxt->tid_used_list.list,
+					 list) {
+			unsigned use = min_t(unsigned, pageset_count - pageidx,
+					     grp->size - grp->used);
+
+			ret = program_rcvarray(fp, vaddr, grp, pagesets,
+					       pageidx, use, pages, tidlist,
+					       &tididx, &mapped);
+			if (ret < 0) {
+				hfi1_cdbg(TID,
+					  "Failed to program RcvArray entries %d",
+					  ret);
+				ret = -EFAULT;
+				goto unlock;
+			} else if (ret > 0) {
+				if (grp->used == grp->size)
+					tid_group_move(grp,
+						       &uctxt->tid_used_list,
+						       &uctxt->tid_full_list);
+				pageidx += ret;
+				mapped_pages += mapped;
+				need_group = 0;
+				/* Check if we are done so we break out early */
+				if (pageidx >= pageset_count)
+					break;
+			} else if (WARN_ON(ret == 0)) {
+				/*
+				 * If ret is 0, we did not program any entries
+				 * into this group, which can only happen if
+				 * we've screwed up the accounting somewhere.
+				 * Warn and try to continue.
+				 */
+				need_group = 1;
+			}
+		}
+	}
+unlock:
+	mutex_unlock(&uctxt->exp_lock);
+nomem:
+	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
+		  mapped_pages, ret);
+	if (tididx) {
+		fp_to_fd(fp)->tid_used += tididx;
+		tinfo->tidcnt = tididx;
+		tinfo->length = mapped_pages * PAGE_SIZE;
+
+		if (copy_to_user((void __user *)(unsigned long)tinfo->tidlist,
+				 tidlist, sizeof(tidlist[0]) * tididx)) {
+			/* On failure to copy to the user level, we need to undo
+			 * everything done so far so we don't leak resources. */
+			tinfo->tidlist = (unsigned long)&tidlist;
+			hfi1_user_exp_rcv_clear(fp, tinfo);
+			tinfo->tidlist = 0;
+			ret = -EFAULT;
+			goto bail;
+		}
+	}
+
+	/*
+	 * If not everything was mapped (due to insufficient RcvArray entries,
+	 * for example), unpin all unmapped pages so we can pin them nex time.
+	 */
+	if (mapped_pages != pinned)
+		hfi1_release_user_pages(&pages[mapped_pages],
+					pinned - mapped_pages,
+					false);
+bail:
+	kfree(pagesets);
+	kfree(pages);
+	kfree(tidlist);
+	return ret > 0 ? 0 : ret;
+}
+
+int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	int ret = 0;
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	u32 *tidinfo;
+	unsigned tididx;
+
+	tidinfo = kcalloc(tinfo->tidcnt, sizeof(*tidinfo), GFP_KERNEL);
+	if (!tidinfo)
+		return -ENOMEM;
+
+	if (copy_from_user(tidinfo, (void __user *)(unsigned long)
+			   tinfo->tidlist, sizeof(tidinfo[0]) *
+			   tinfo->tidcnt)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	mutex_lock(&uctxt->exp_lock);
+	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
+		ret = unprogram_rcvarray(fp, tidinfo[tididx], NULL);
+		if (ret) {
+			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
+				  ret);
+			break;
+		}
+	}
+	fp_to_fd(fp)->tid_used -= tididx;
+	tinfo->tidcnt = tididx;
+	mutex_unlock(&uctxt->exp_lock);
+done:
+	kfree(tidinfo);
+	return ret;
+}
+
+int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	struct hfi1_filedata *fd = fp_to_fd(fp);
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	unsigned long *ev = uctxt->dd->events +
+		(((uctxt->ctxt - uctxt->dd->first_user_ctxt) *
+		  HFI1_MAX_SHARED_CTXTS) + subctxt_fp(fp));
+	u32 *array;
+	int ret = 0;
+
+	if (!fd->invalid_tids) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * copy_to_user() can sleep, which will leave the invalid_lock
+	 * locked and cause the MMU notifier to be blocked on the lock
+	 * for a long time.
+	 * Copy the data to a local buffer so we can release the lock.
+	 */
+	array = kcalloc(uctxt->expected_count, sizeof(*array), GFP_KERNEL);
+	if (!array) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	spin_lock(&fp_to_fd(fp)->invalid_lock);
+	if (fd->invalid_tid_idx) {
+		memcpy(array, fd->invalid_tids, sizeof(*array) *
+		       fd->invalid_tid_idx);
+		memset(fd->invalid_tids, 0, sizeof(*fd->invalid_tids) *
+		       fd->invalid_tid_idx);
+		tinfo->tidcnt = fd->invalid_tid_idx;
+		fd->invalid_tid_idx = 0;
+		/* Reset the user flag while still holding the lock.
+		 * Otherwise, PSM can miss events. */
+		clear_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
+	} else
+		tinfo->tidcnt = 0;
+	spin_unlock(&fp_to_fd(fp)->invalid_lock);
+
+	if (tinfo->tidcnt) {
+		if (copy_to_user((void __user *)tinfo->tidlist,
+				 array, sizeof(*array) * tinfo->tidcnt))
+			ret = -EFAULT;
+	}
+	kfree(array);
+done:
+	return ret;
+}
+
+static u32 find_phys_blocks(struct page **pages, unsigned npages,
+			    struct tid_pageset *list)
+{
+	unsigned pagecount, pageidx, setcount = 0, i;
+	unsigned long pfn, this_pfn;
+
+	if (!npages)
+		return 0;
+
+	/*
+	 * Look for sets of physically contiguous pages in the user buffer.
+	 * This will allow us to optimize Expected RcvArray entry usage by
+	 * using the bigger supported sizes.
+	 */
+	pfn = page_to_pfn(pages[0]);
+	for (pageidx = 0, pagecount = 1, i = 1; i <= npages; i++) {
+		this_pfn = i < npages ? page_to_pfn(pages[i]) : 0;
+
+		/* If the pfn's are not sequential, pages are not physically
+		 * contiguous. */
+		if (this_pfn != ++pfn) {
+			/*
+			 * At this point we have to loop over the set of
+			 * physically contiguous pages and break them down it
+			 * sizes supported by the HW.
+			 * There are two main constraints:
+			 *     1. The max buffer size is MAX_EXPECTED_BUFFER.
+			 *        If the total set size is bigger than that
+			 *        program only a MAX_EXPECTED_BUFFER chunk.
+			 *     2. The buffer size has to be a power of two. If
+			 *        it is not, round down to the closes power of
+			 *        2 and program that size.
+			 */
+			while (pagecount) {
+				int maxpages = pagecount;
+				u32 bufsize = pagecount * PAGE_SIZE;
+
+				if (bufsize > MAX_EXPECTED_BUFFER)
+					maxpages =
+						MAX_EXPECTED_BUFFER >>
+						PAGE_SHIFT;
+				else if (!is_power_of_2(bufsize))
+					maxpages =
+						rounddown_pow_of_two(bufsize) >>
+						PAGE_SHIFT;
+
+				list[setcount].idx = pageidx;
+				list[setcount].count = maxpages;
+				pagecount -= maxpages;
+				pageidx += maxpages;
+				setcount++;
+			}
+			pageidx = i;
+			pagecount = 1;
+			pfn = this_pfn;
+		} else
+			pagecount++;
+	}
+	return setcount;
+}
+
+static int program_rcvarray(struct file *fp, unsigned long vaddr,
+			    struct tid_group *grp,
+			    struct tid_pageset *sets,
+			    unsigned start, u16 count, struct page **pages,
+			    u32 *tidlist, unsigned *tididx, unsigned *pmapped)
+{
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_devdata *dd = uctxt->dd;
+	u16 idx;
+	u32 tidinfo = 0, rcventry, useidx = 0;
+	int mapped = 0;
+
+	/* Count should never be larger than the group size */
+	if (count > grp->size)
+		return -EINVAL;
+
+	/* Find the first unused entry in the group */
+	for (idx = 0; idx < grp->size; idx++) {
+		if (!(grp->map & (1 << idx))) {
+			useidx = idx;
+			break;
+		}
+		rcv_array_wc_fill(dd, grp->base + idx);
+	}
+
+	idx = 0;
+	while (idx < count) {
+		u16 npages, pageidx, setidx = start + idx;
+		int ret = 0;
+
+		/*
+		 * If this entry in the group is used, move to the next one.
+		 * If we go past the end of the group, exit the loop.
+		 */
+		if (useidx >= grp->size)
+			break;
+		else if (grp->map & (1 << useidx)) {
+			rcv_array_wc_fill(dd, grp->base + useidx);
+			useidx++;
+			continue;
+		}
+
+		rcventry = grp->base + useidx;
+		npages = sets[setidx].count;
+		pageidx = sets[setidx].idx;
+
+		ret = set_rcvarray_entry(fp, vaddr + (pageidx * PAGE_SIZE),
+					 rcventry, grp, pages + pageidx,
+					 npages);
+		if (ret)
+			return ret;
+		mapped += npages;
+
+		tidinfo = rcventry2tidinfo(rcventry - uctxt->expected_base) |
+			EXP_TID_SET(LEN, npages);
+		tidlist[(*tididx)++] = tidinfo;
+		grp->used++;
+		grp->map |= 1 << useidx++;
+		idx++;
+	}
+
+	/* Fill the rest of the group with "blank" writes */
+	for (; useidx < grp->size; useidx++)
+		rcv_array_wc_fill(dd, grp->base + useidx);
+	*pmapped = mapped;
+	return idx;
+}
+
+static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
+			      u32 rcventry, struct tid_group *grp,
+			      struct page **pages, unsigned npages)
+{
+	int ret;
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct mmu_rb_node *node;
+	struct hfi1_devdata *dd = uctxt->dd;
+	struct rb_root *root = &rb_fp(fp);
+	dma_addr_t phys;
+
+	/*
+	 * Allocate the node first so we can handle a potential
+	 * failure before we've programmed anything.
+	 */
+	node = kzalloc(sizeof(*node) + (sizeof(struct page *) * npages),
+		       GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	phys = pci_map_single(dd->pcidev,
+			      __va(page_to_phys(pages[0])),
+			      npages * PAGE_SIZE, PCI_DMA_FROMDEVICE);
+	if (dma_mapping_error(&dd->pcidev->dev, phys)) {
+		dd_dev_err(dd, "Failed to DMA map Exp Rcv pages 0x%llx\n",
+			   phys);
+		kfree(node);
+		return -EFAULT;
+	}
+
+	node->virt = vaddr;
+	node->phys = page_to_phys(pages[0]);
+	node->len = npages * PAGE_SIZE;
+	node->npages = npages;
+	node->rcventry = rcventry;
+	node->dma_addr = phys;
+	node->grp = grp;
+	node->freed = false;
+	memcpy(node->pages, pages, sizeof(struct page *) * npages);
+
+	spin_lock(&fp_to_fd(fp)->rb_lock);
+	ret = fp_to_fd(fp)->mmu_rb_insert(root, node);
+	spin_unlock(&fp_to_fd(fp)->rb_lock);
+
+	if (ret) {
+		hfi1_cdbg(TID, "Failed to insert RB node %u 0x%lx, 0x%lx %d",
+			  node->rcventry, node->virt, node->phys, ret);
+		pci_unmap_single(dd->pcidev, phys, npages * PAGE_SIZE,
+				 PCI_DMA_FROMDEVICE);
+		kfree(node);
+		return -EFAULT;
+	}
+	hfi1_put_tid(dd, rcventry, PT_EXPECTED, phys, ilog2(npages) + 1);
+	trace_hfi1_exp_tid_reg(uctxt->ctxt, subctxt_fp(fp), rcventry,
+			       npages, node->virt, node->phys, phys);
+	return 0;
+}
+
+static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
+			      struct tid_group **grp)
+{
+	struct hfi1_ctxtdata *uctxt = ctxt_fp(fp);
+	struct hfi1_devdata *dd = uctxt->dd;
+	struct mmu_rb_node *node;
+	u8 tidctrl = EXP_TID_GET(tidinfo, CTRL);
+	u32 tidbase = uctxt->expected_base,
+		tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
+
+	if (tididx > uctxt->expected_count) {
+		dd_dev_err(dd, "Invalid RcvArray entry (%u) index for ctxt %u\n",
+			   tididx, uctxt->ctxt);
+		return -EINVAL;
+	}
+
+	if (tidctrl == 0x3)
+		return -EINVAL;
+
+	rcventry = tidbase + tididx + (tidctrl - 1);
+
+	spin_lock(&fp_to_fd(fp)->rb_lock);
+	node = mmu_rb_search_by_entry(&rb_fp(fp), rcventry);
+	if (!node) {
+		spin_unlock(&fp_to_fd(fp)->rb_lock);
+		return -EBADF;
+	}
+	rb_erase(&node->rbnode, &rb_fp(fp));
+	spin_unlock(&fp_to_fd(fp)->rb_lock);
+	if (grp)
+		*grp = node->grp;
+	clear_tid_node(fp_to_fd(fp), subctxt_fp(fp), node);
+	return 0;
+}
+
+static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
+			   struct mmu_rb_node *node)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+
+	trace_hfi1_exp_tid_unreg(uctxt->ctxt, fd->subctxt, node->rcventry,
+				 node->npages, node->virt, node->phys,
+				 node->dma_addr);
+
+	hfi1_put_tid(dd, node->rcventry, PT_INVALID, 0, 0);
+	/* Make sure device has seen the write before we unpin the
+	 * pages */
+	flush_wc();
+
+	pci_unmap_single(dd->pcidev, node->dma_addr, node->len,
+			 PCI_DMA_FROMDEVICE);
+	hfi1_release_user_pages(node->pages, node->npages, true);
+
+	node->grp->used--;
+	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));
+
+	if (node->grp->used == node->grp->size - 1)
+		tid_group_move(node->grp, &uctxt->tid_full_list,
+			       &uctxt->tid_used_list);
+	else if (!node->grp->used)
+		tid_group_move(node->grp, &uctxt->tid_used_list,
+			       &uctxt->tid_group_list);
+	kfree(node);
+}
+
+static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
+			    struct exp_tid_set *set, struct rb_root *root)
+{
+	struct tid_group *grp, *ptr;
+	struct hfi1_filedata *fd = container_of(root, struct hfi1_filedata,
+						tid_rb_root);
+	int i;
+
+	list_for_each_entry_safe(grp, ptr, &set->list, list) {
+		list_del_init(&grp->list);
+
+		spin_lock(&fd->rb_lock);
+		for (i = 0; i < grp->size; i++) {
+			if (grp->map & (1 << i)) {
+				u16 rcventry = grp->base + i;
+				struct mmu_rb_node *node;
+
+				node = mmu_rb_search_by_entry(root, rcventry);
+				if (!node)
+					continue;
+				rb_erase(&node->rbnode, root);
+				clear_tid_node(fd, -1, node);
+			}
+		}
+		spin_unlock(&fd->rb_lock);
+	}
+}
+
+static inline void mmu_notifier_page(struct mmu_notifier *mn,
+				     struct mm_struct *mm, unsigned long addr)
+{
+	mmu_notifier_mem_invalidate(mn, addr, addr + PAGE_SIZE,
+				    MMU_INVALIDATE_PAGE);
+}
+
+static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
+					    struct mm_struct *mm,
+					    unsigned long start,
+					    unsigned long end)
+{
+	mmu_notifier_mem_invalidate(mn, start, end, MMU_INVALIDATE_RANGE);
+}
+
+static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
+					unsigned long start, unsigned long end,
+					enum mmu_call_types type)
+{
+	struct hfi1_filedata *fd = container_of(mn, struct hfi1_filedata, mn);
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct rb_root *root = &fd->tid_rb_root;
+	struct mmu_rb_node *node;
+	unsigned long addr = start;
+
+	trace_hfi1_mmu_invalidate(uctxt->ctxt, fd->subctxt, mmu_types[type],
+				  start, end);
+
+	spin_lock(&fd->rb_lock);
+	while (addr < end) {
+		node = mmu_rb_search_by_addr(root, addr);
+
+		if (!node) {
+			/* Didn't find a node at this address. However, the
+			 * range could be bigger than what we have registered
+			 * so we have to keep looking. */
+			addr += PAGE_SIZE;
+			continue;
+		}
+
+		/*
+		 * The next address to be looked up is computed based
+		 * on the node's starting address. This is due to the
+		 * fact that the range where we start might be in the
+		 * middle of the node's buffer so simply incrementing
+		 * the address by the node's size would result is a
+		 * bad address.
+		 */
+		addr = node->virt + (node->npages * PAGE_SIZE);
+		if (node->freed)
+			continue;
+
+		trace_hfi1_exp_tid_inval(uctxt->ctxt, fd->subctxt, node->virt,
+					 node->rcventry, node->npages,
+					 node->dma_addr);
+		node->freed = true;
+
+		spin_lock(&fd->invalid_lock);
+		if (fd->invalid_tid_idx < uctxt->expected_count) {
+			fd->invalid_tids[fd->invalid_tid_idx] =
+				rcventry2tidinfo(node->rcventry -
+						 uctxt->expected_base);
+			fd->invalid_tids[fd->invalid_tid_idx] |=
+				EXP_TID_SET(LEN, node->npages);
+			if (!fd->invalid_tid_idx) {
+				unsigned long *ev;
+
+				/*
+				 * hfi1_set_uevent_bits() sets a user even flag
+				 * for all processes. Because calling into the
+				 * driver to process TID cache invalidations is
+				 * expensive and TID cache invalidations are
+				 * handled on a per-process basis, we can
+				 * optimize this to set the flag only for the
+				 * process in question.
+				 */
+				ev = uctxt->dd->events +
+					(((uctxt->ctxt -
+					   uctxt->dd->first_user_ctxt) *
+					  HFI1_MAX_SHARED_CTXTS) + fd->subctxt);
+				set_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
+			}
+			fd->invalid_tid_idx++;
+		}
+		spin_unlock(&fd->invalid_lock);
+	}
+	spin_unlock(&fd->rb_lock);
+}
+
+static inline int mmu_addr_cmp(struct mmu_rb_node *node, unsigned long addr,
+			       unsigned long len)
+{
+	if ((addr + len) <= node->virt)
+		return -1;
+	else if (addr >= node->virt && addr < (node->virt + node->len))
+		return 0;
+	else
+		return 1;
+}
+
+static inline int mmu_entry_cmp(struct mmu_rb_node *node, u32 entry)
+{
+	if (entry < node->rcventry)
+		return -1;
+	else if (entry > node->rcventry)
+		return 1;
+	else
+		return 0;
+}
+
+static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *root,
+						 unsigned long addr)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct mmu_rb_node *mnode =
+			container_of(node, struct mmu_rb_node, rbnode);
+		/*
+		 * When searching, use at least one page length for size. The
+		 * MMU notifier will not give us anything less than that. We
+		 * also don't need anything more than a page because we are
+		 * guaranteed to have non-overlapping buffers in the tree.
+		 */
+		int result = mmu_addr_cmp(mnode, addr, PAGE_SIZE);
+
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			return mnode;
+	}
+	return NULL;
+}
+
+static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *root,
+							 u32 index)
+{
+	struct mmu_rb_node *rbnode;
+	struct rb_node *node;
+
+	if (root && !RB_EMPTY_ROOT(root))
+		for (node = rb_first(root); node; node = rb_next(node)) {
+			rbnode = rb_entry(node, struct mmu_rb_node, rbnode);
+			if (rbnode->rcventry == index)
+				return rbnode;
+		}
+	return NULL;
+}
+
+static int mmu_rb_insert_by_entry(struct rb_root *root,
+				  struct mmu_rb_node *node)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct mmu_rb_node *this =
+			container_of(*new, struct mmu_rb_node, rbnode);
+		int result = mmu_entry_cmp(this, node->rcventry);
+
+		parent = *new;
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else
+			return 1;
+	}
+
+	rb_link_node(&node->rbnode, parent, new);
+	rb_insert_color(&node->rbnode, root);
+	return 0;
+}
+
+static int mmu_rb_insert_by_addr(struct rb_root *root, struct mmu_rb_node *node)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		struct mmu_rb_node *this =
+			container_of(*new, struct mmu_rb_node, rbnode);
+		int result = mmu_addr_cmp(this, node->virt, node->len);
+
+		parent = *new;
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else
+			return 1;
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&node->rbnode, parent, new);
+	rb_insert_color(&node->rbnode, root);
+
+	return 0;
+}
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.h b/drivers/staging/rdma/hfi1/user_exp_rcv.h
new file mode 100644
index 000000000000..28ef98a45a1e
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.h
@@ -0,0 +1,82 @@
+#ifndef _HFI1_USER_EXP_RCV_H
+#define _HFI1_USER_EXP_RCV_H
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include "hfi.h"
+
+#define EXP_TID_TIDLEN_MASK   0x7FFULL
+#define EXP_TID_TIDLEN_SHIFT  0
+#define EXP_TID_TIDCTRL_MASK  0x3ULL
+#define EXP_TID_TIDCTRL_SHIFT 20
+#define EXP_TID_TIDIDX_MASK   0x3FFULL
+#define EXP_TID_TIDIDX_SHIFT  22
+#define EXP_TID_GET(tid, field)	\
+	(((tid) >> EXP_TID_TID##field##_SHIFT) & EXP_TID_TID##field##_MASK)
+
+#define EXP_TID_SET(field, value)			\
+	(((value) & EXP_TID_TID##field##_MASK) <<	\
+	 EXP_TID_TID##field##_SHIFT)
+#define EXP_TID_CLEAR(tid, field) ({					\
+		(tid) &= ~(EXP_TID_TID##field##_MASK <<			\
+			   EXP_TID_TID##field##_SHIFT);			\
+		})
+#define EXP_TID_RESET(tid, field, value) do {				\
+		EXP_TID_CLEAR(tid, field);				\
+		(tid) |= EXP_TID_SET(field, (value));			\
+	} while (0)
+
+int hfi1_user_exp_rcv_init(struct file *);
+int hfi1_user_exp_rcv_free(struct hfi1_filedata *);
+int hfi1_user_exp_rcv_setup(struct file *, struct hfi1_tid_info *);
+int hfi1_user_exp_rcv_clear(struct file *, struct hfi1_tid_info *);
+int hfi1_user_exp_rcv_invalid(struct file *, struct hfi1_tid_info *);
+
+#endif /* _HFI1_USER_EXP_RCV_H */
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/staging/rdma/hfi1/user_pages.c
index 9071afbd7bf4..ec84cc63743e 100644
--- a/drivers/staging/rdma/hfi1/user_pages.c
+++ b/drivers/staging/rdma/hfi1/user_pages.c
@@ -47,110 +47,48 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
-
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/device.h>
-
 #include "hfi.h"
 
-static void __hfi1_release_user_pages(struct page **p, size_t num_pages,
-				      int dirty)
+int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
+			    struct page **pages)
 {
-	size_t i;
-
-	for (i = 0; i < num_pages; i++) {
-		if (dirty)
-			set_page_dirty_lock(p[i]);
-		put_page(p[i]);
-	}
-}
-
-/*
- * Call with current->mm->mmap_sem held.
- */
-static int __hfi1_get_user_pages(unsigned long start_page, size_t num_pages,
-				 struct page **p)
-{
-	unsigned long lock_limit;
-	size_t got;
+	unsigned long pinned, lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	bool can_lock = capable(CAP_IPC_LOCK);
 	int ret;
 
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (num_pages > lock_limit && !capable(CAP_IPC_LOCK)) {
-		ret = -ENOMEM;
-		goto bail;
-	}
-
-	for (got = 0; got < num_pages; got += ret) {
-		ret = get_user_pages(current, current->mm,
-				     start_page + got * PAGE_SIZE,
-				     num_pages - got, 1, 1,
-				     p + got, NULL);
-		if (ret < 0)
-			goto bail_release;
-	}
-
-	current->mm->pinned_vm += num_pages;
-
-	ret = 0;
-	goto bail;
-
-bail_release:
-	__hfi1_release_user_pages(p, got, 0);
-bail:
-	return ret;
-}
-
-/**
- * hfi1_map_page - a safety wrapper around pci_map_page()
- *
- */
-dma_addr_t hfi1_map_page(struct pci_dev *hwdev, struct page *page,
-			 unsigned long offset, size_t size, int direction)
-{
-	dma_addr_t phys;
+	down_read(&current->mm->mmap_sem);
+	pinned = current->mm->pinned_vm;
+	up_read(&current->mm->mmap_sem);
 
-	phys = pci_map_page(hwdev, page, offset, size, direction);
+	if (pinned + npages > lock_limit && !can_lock)
+		return -EDQUOT;
 
-	return phys;
-}
-
-/**
- * hfi1_get_user_pages - lock user pages into memory
- * @start_page: the start page
- * @num_pages: the number of pages
- * @p: the output page structures
- *
- * This function takes a given start page (page aligned user virtual
- * address) and pins it and the following specified number of pages.  For
- * now, num_pages is always 1, but that will probably change at some point
- * (because caller is doing expected sends on a single virtually contiguous
- * buffer, so we can do all pages at once).
- */
-int hfi1_get_user_pages(unsigned long start_page, size_t num_pages,
-			struct page **p)
-{
-	int ret;
+	ret = get_user_pages_fast(vaddr, npages, writable, pages);
+	if (ret < 0)
+		return ret;
 
 	down_write(&current->mm->mmap_sem);
-
-	ret = __hfi1_get_user_pages(start_page, num_pages, p);
-
+	current->mm->pinned_vm += ret;
 	up_write(&current->mm->mmap_sem);
-
 	return ret;
 }
 
-void hfi1_release_user_pages(struct page **p, size_t num_pages)
+void hfi1_release_user_pages(struct page **p, size_t npages, bool dirty)
 {
-	if (current->mm) /* during close after signal, mm can be NULL */
-		down_write(&current->mm->mmap_sem);
+	size_t i;
 
-	__hfi1_release_user_pages(p, num_pages, 1);
+	for (i = 0; i < npages; i++) {
+		if (dirty)
+			set_page_dirty_lock(p[i]);
+		put_page(p[i]);
+	}
 
-	if (current->mm) {
-		current->mm->pinned_vm -= num_pages;
+	if (current->mm) { /* during close after signal, mm can be NULL */
+		down_write(&current->mm->mmap_sem);
+		current->mm->pinned_vm -= npages;
 		up_write(&current->mm->mmap_sem);
 	}
 }
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 36c838dcf023..2355ce7b17b7 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1055,6 +1055,12 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	/* If called by the kernel thread, use the user's mm */
 	if (current->flags & PF_KTHREAD)
 		use_mm(req->user_proc->mm);
+	/*
+	 * We should be calling hfi1_acquire_user_pages() so we can keep
+	 * the number of pinned pages up-to-date. However, we can't do
+	 * that because we can't use hfi1_release_user_pages() (see
+	 * comment in unpin_vector_pages()).
+	 */
 	pinned = get_user_pages_fast(
 		(unsigned long)iovec->iov.iov_base,
 		iovec->npages, 0, iovec->pages);
@@ -1084,6 +1090,13 @@ static void unpin_vector_pages(struct user_sdma_iovec *iovec)
 			  iovec->offset, iovec->iov.iov_len);
 		return;
 	}
+	/*
+	 * We should be calling hfi1_release_user_pages() so we can keep
+	 * the number of pinned pages up-to-date. However, this function
+	 * can be called in IRQ context and this will cause a deadlock
+	 * because hfi1_release_user_pages() takes the mm semaphore,
+	 * (which sleeps).
+	 */
 	for (i = 0; i < iovec->npages; i++)
 		if (iovec->pages[i])
 			put_page(iovec->pages[i]);
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index fa4422553e23..0046ffa774fe 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -52,15 +52,7 @@
 
 #include "common.h"
 #include "iowait.h"
-
-#define EXP_TID_TIDLEN_MASK   0x7FFULL
-#define EXP_TID_TIDLEN_SHIFT  0
-#define EXP_TID_TIDCTRL_MASK  0x3ULL
-#define EXP_TID_TIDCTRL_SHIFT 20
-#define EXP_TID_TIDIDX_MASK   0x7FFULL
-#define EXP_TID_TIDIDX_SHIFT  22
-#define EXP_TID_GET(tid, field)	\
-	(((tid) >> EXP_TID_TID##field##_SHIFT) & EXP_TID_TID##field##_MASK)
+#include "user_exp_rcv.h"
 
 extern uint extended_psn;
 
diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 599562fe5d57..54998e86689b 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -66,7 +66,7 @@
  * The major version changes when data structures change in an incompatible
  * way. The driver must be the same for initialization to succeed.
  */
-#define HFI1_USER_SWMAJOR 4
+#define HFI1_USER_SWMAJOR 5
 
 /*
  * Minor version differences are always compatible
@@ -93,7 +93,7 @@
 #define HFI1_CAP_MULTI_PKT_EGR    (1UL <<  7) /* Enable multi-packet Egr buffs*/
 #define HFI1_CAP_NODROP_RHQ_FULL  (1UL <<  8) /* Don't drop on Hdr Q full */
 #define HFI1_CAP_NODROP_EGR_FULL  (1UL <<  9) /* Don't drop on EGR buffs full */
-#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Enable Expected TID caching */
+#define HFI1_CAP_TID_UNMAP        (1UL << 10) /* Disable Expected TID caching */
 #define HFI1_CAP_PRINT_UNIMPL     (1UL << 11) /* Show for unimplemented feats */
 #define HFI1_CAP_ALLOW_PERM_JKEY  (1UL << 12) /* Allow use of permissive JKEY */
 #define HFI1_CAP_NO_INTEGRITY     (1UL << 13) /* Enable ctxt integrity checks */
@@ -127,13 +127,14 @@
 #define HFI1_CMD_TID_UPDATE      4	/* update expected TID entries */
 #define HFI1_CMD_TID_FREE        5	/* free expected TID entries */
 #define HFI1_CMD_CREDIT_UPD      6	/* force an update of PIO credit */
-#define HFI1_CMD_SDMA_STATUS_UPD 7       /* force update of SDMA status ring */
+#define HFI1_CMD_SDMA_STATUS_UPD 7      /* force update of SDMA status ring */
 
 #define HFI1_CMD_RECV_CTRL       8	/* control receipt of packets */
 #define HFI1_CMD_POLL_TYPE       9	/* set the kind of polling we want */
 #define HFI1_CMD_ACK_EVENT       10	/* ack & clear user status bits */
-#define HFI1_CMD_SET_PKEY        11      /* set context's pkey */
-#define HFI1_CMD_CTXT_RESET      12      /* reset context's HW send context */
+#define HFI1_CMD_SET_PKEY        11     /* set context's pkey */
+#define HFI1_CMD_CTXT_RESET      12     /* reset context's HW send context */
+#define HFI1_CMD_TID_INVAL_READ  13     /* read TID cache invalidations */
 /* separate EPROM commands from normal PSM commands */
 #define HFI1_CMD_EP_INFO         64      /* read EPROM device ID */
 #define HFI1_CMD_EP_ERASE_CHIP   65      /* erase whole EPROM */
@@ -144,18 +145,20 @@
 #define HFI1_CMD_EP_WRITE_P0     70      /* write EPROM partition 0 */
 #define HFI1_CMD_EP_WRITE_P1     71      /* write EPROM partition 1 */
 
-#define _HFI1_EVENT_FROZEN_BIT       0
-#define _HFI1_EVENT_LINKDOWN_BIT     1
-#define _HFI1_EVENT_LID_CHANGE_BIT   2
-#define _HFI1_EVENT_LMC_CHANGE_BIT   3
-#define _HFI1_EVENT_SL2VL_CHANGE_BIT 4
-#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_SL2VL_CHANGE_BIT
-
-#define HFI1_EVENT_FROZEN                (1UL << _HFI1_EVENT_FROZEN_BIT)
-#define HFI1_EVENT_LINKDOWN_BIT		(1UL << _HFI1_EVENT_LINKDOWN_BIT)
-#define HFI1_EVENT_LID_CHANGE_BIT	(1UL << _HFI1_EVENT_LID_CHANGE_BIT)
-#define HFI1_EVENT_LMC_CHANGE_BIT	(1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
-#define HFI1_EVENT_SL2VL_CHANGE_BIT	(1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define _HFI1_EVENT_FROZEN_BIT         0
+#define _HFI1_EVENT_LINKDOWN_BIT       1
+#define _HFI1_EVENT_LID_CHANGE_BIT     2
+#define _HFI1_EVENT_LMC_CHANGE_BIT     3
+#define _HFI1_EVENT_SL2VL_CHANGE_BIT   4
+#define _HFI1_EVENT_TID_MMU_NOTIFY_BIT 5
+#define _HFI1_MAX_EVENT_BIT _HFI1_EVENT_TID_MMU_NOTIFY_BIT
+
+#define HFI1_EVENT_FROZEN            (1UL << _HFI1_EVENT_FROZEN_BIT)
+#define HFI1_EVENT_LINKDOWN          (1UL << _HFI1_EVENT_LINKDOWN_BIT)
+#define HFI1_EVENT_LID_CHANGE        (1UL << _HFI1_EVENT_LID_CHANGE_BIT)
+#define HFI1_EVENT_LMC_CHANGE        (1UL << _HFI1_EVENT_LMC_CHANGE_BIT)
+#define HFI1_EVENT_SL2VL_CHANGE      (1UL << _HFI1_EVENT_SL2VL_CHANGE_BIT)
+#define HFI1_EVENT_TID_MMU_NOTIFY    (1UL << _HFI1_EVENT_TID_MMU_NOTIFY_BIT)
 
 /*
  * These are the status bits readable (in ASCII form, 64bit value)
@@ -240,11 +243,6 @@ struct hfi1_tid_info {
 	__u32 tidcnt;
 	/* length of transfer buffer programmed by this request */
 	__u32 length;
-	/*
-	 * pointer to bitmap of TIDs used for this call;
-	 * checked for being large enough at open
-	 */
-	__u64 tidmap;
 };
 
 struct hfi1_cmd {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
