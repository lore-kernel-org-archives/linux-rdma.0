From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/16] IB/hfi1: Make use of mm consistent
Date: Thu, 28 Jul 2016 15:21:19 -0400
Message-ID: <1469733687-31738-9-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The hfi1 driver registers a mmu_notifier callback when /dev/hfi1_* is
opened, and unregisters it when the device is closed.  The driver
incorrectly assumes that the close will always happen from the same
context as the open.  In particular, closes due to SIGKILL or OOM killer
activity may happen from a different context.  In these cases, the wrong
mm is passed to mmu_notifier_unregister(), which causes improper reference
counting for the victim mm, and eventual memory corruption.

Preserve the mm for all open file descriptors and use this mm rather than
current->mm for memory operations for the lifetime of that fd.  Note: this
patch leaves 1 use of current->mm in place.  This use is removed in a
follow on patch because other functional changes were required prior to
that use being removed.

If registration fails, there is no reason to keep the handler object
around.  Free the handler object rather than add it to the list to
prevent any mmu_notifier operations, including unregister, when
registration fails.

Suggested-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |  6 ++++--
 drivers/infiniband/hw/hfi1/hfi.h          |  8 +++++---
 drivers/infiniband/hw/hfi1/mmu_rb.c       | 18 ++++++++++++++----
 drivers/infiniband/hw/hfi1/mmu_rb.h       |  3 ++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 15 ++++++++-------
 drivers/infiniband/hw/hfi1/user_pages.c   | 19 ++++++++++---------
 drivers/infiniband/hw/hfi1/user_sdma.c    | 11 ++++++-----
 drivers/infiniband/hw/hfi1/user_sdma.h    |  1 +
 8 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 1f4cd5aa2071..302f0cdd8119 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -180,8 +180,10 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 
 	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
 
-	if (fd) /* no cpu affinity by default */
-		fd->rec_cpu_num = -1;
+	if (fd) {
+		fd->rec_cpu_num = -1; /* no cpu affinity by default */
+		fd->mm = current->mm;
+	}
 
 	fp->private_data = fd;
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 36e6b8e0c735..67f37c9ea960 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1205,6 +1205,7 @@ struct hfi1_filedata {
 	u32 invalid_tid_idx;
 	/* protect invalid_tids array and invalid_tid_idx */
 	spinlock_t invalid_lock;
+	struct mm_struct *mm;
 };
 
 extern struct list_head hfi1_dev_list;
@@ -1700,9 +1701,10 @@ void shutdown_led_override(struct hfi1_pportdata *ppd);
  */
 #define DEFAULT_RCVHDR_ENTSIZE 32
 
-bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages);
-int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
-			    struct page **pages);
+bool hfi1_can_pin_pages(struct hfi1_devdata *dd, struct mm_struct *mm,
+			u32 nlocked, u32 npages);
+int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr,
+			    size_t npages, bool writable, struct page **pages);
 void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
 			     size_t npages, bool dirty);
 
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 1c7e25b90a2c..e5c5ef4cf06c 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -58,6 +58,7 @@ struct mmu_rb_handler {
 	struct rb_root *root;
 	spinlock_t lock;        /* protect the RB tree */
 	struct mmu_rb_ops *ops;
+	struct mm_struct *mm;
 };
 
 static LIST_HEAD(mmu_rb_handlers);
@@ -95,9 +96,11 @@ static unsigned long mmu_node_last(struct mmu_rb_node *node)
 	return PAGE_ALIGN(node->addr + node->len) - 1;
 }
 
-int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
+int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
+			 struct mmu_rb_ops *ops)
 {
 	struct mmu_rb_handler *handlr;
+	int ret;
 
 	handlr = kmalloc(sizeof(*handlr), GFP_KERNEL);
 	if (!handlr)
@@ -108,11 +111,19 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 	INIT_HLIST_NODE(&handlr->mn.hlist);
 	spin_lock_init(&handlr->lock);
 	handlr->mn.ops = &mn_opts;
+	handlr->mm = mm;
+
+	ret = mmu_notifier_register(&handlr->mn, handlr->mm);
+	if (ret) {
+		kfree(handlr);
+		return ret;
+	}
+
 	spin_lock(&mmu_rb_lock);
 	list_add_tail_rcu(&handlr->list, &mmu_rb_handlers);
 	spin_unlock(&mmu_rb_lock);
 
-	return mmu_notifier_register(&handlr->mn, current->mm);
+	return ret;
 }
 
 void hfi1_mmu_rb_unregister(struct rb_root *root)
@@ -126,8 +137,7 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 		return;
 
 	/* Unregister first so we don't get any more notifications. */
-	if (current->mm)
-		mmu_notifier_unregister(&handler->mn, current->mm);
+	mmu_notifier_unregister(&handler->mn, handler->mm);
 
 	spin_lock(&mmu_rb_lock);
 	list_del_rcu(&handler->list);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 45e7245d813b..489a691856e5 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -65,7 +65,8 @@ struct mmu_rb_ops {
 	int (*invalidate)(struct rb_root *root, struct mmu_rb_node *node);
 };
 
-int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops);
+int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
+			 struct mmu_rb_ops *ops);
 void hfi1_mmu_rb_unregister(struct rb_root *);
 int hfi1_mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
 void hfi1_mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 8283a6a2bb15..a2f7e719dc4d 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -211,7 +211,8 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		 * fails, continue but turn off the TID caching for
 		 * all user contexts.
 		 */
-		ret = hfi1_mmu_rb_register(&fd->tid_rb_root, &tid_rb_ops);
+		ret = hfi1_mmu_rb_register(fd->mm, &fd->tid_rb_root,
+					   &tid_rb_ops);
 		if (ret) {
 			dd_dev_info(dd,
 				    "Failed MMU notifier registration %d\n",
@@ -399,12 +400,12 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 	 * pages, accept the amount pinned so far and program only that.
 	 * User space knows how to deal with partially programmed buffers.
 	 */
-	if (!hfi1_can_pin_pages(dd, fd->tid_n_pinned, npages)) {
+	if (!hfi1_can_pin_pages(dd, fd->mm, fd->tid_n_pinned, npages)) {
 		ret = -ENOMEM;
 		goto bail;
 	}
 
-	pinned = hfi1_acquire_user_pages(vaddr, npages, true, pages);
+	pinned = hfi1_acquire_user_pages(fd->mm, vaddr, npages, true, pages);
 	if (pinned <= 0) {
 		ret = pinned;
 		goto bail;
@@ -559,7 +560,7 @@ nomem:
 	 * for example), unpin all unmapped pages so we can pin them nex time.
 	 */
 	if (mapped_pages != pinned) {
-		hfi1_release_user_pages(current->mm, &pages[mapped_pages],
+		hfi1_release_user_pages(fd->mm, &pages[mapped_pages],
 					pinned - mapped_pages,
 					false);
 		fd->tid_n_pinned -= pinned - mapped_pages;
@@ -905,7 +906,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		tid_rb_remove(&fd->tid_rb_root, &node->mmu, NULL);
+		tid_rb_remove(&fd->tid_rb_root, &node->mmu, fd->mm);
 	else
 		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
 
@@ -933,7 +934,7 @@ static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 
 	pci_unmap_single(dd->pcidev, node->dma_addr, node->mmu.len,
 			 PCI_DMA_FROMDEVICE);
-	hfi1_release_user_pages(current->mm, node->pages, node->npages, true);
+	hfi1_release_user_pages(fd->mm, node->pages, node->npages, true);
 	fd->tid_n_pinned -= node->npages;
 
 	node->grp->used--;
@@ -970,7 +971,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 					continue;
 				if (HFI1_CAP_IS_USET(TID_UNMAP))
 					tid_rb_remove(&fd->tid_rb_root,
-						      &node->mmu, NULL);
+						      &node->mmu, fd->mm);
 				else
 					hfi1_mmu_rb_remove(&fd->tid_rb_root,
 							   &node->mmu);
diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 88e10b5f55f1..20f4ddcac3b0 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -68,7 +68,8 @@ MODULE_PARM_DESC(cache_size, "Send and receive side cache size limit (in MB)");
  * could keeping caching buffers.
  *
  */
-bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages)
+bool hfi1_can_pin_pages(struct hfi1_devdata *dd, struct mm_struct *mm,
+			u32 nlocked, u32 npages)
 {
 	unsigned long ulimit = rlimit(RLIMIT_MEMLOCK), pinned, cache_limit,
 		size = (cache_size * (1UL << 20)); /* convert to bytes */
@@ -89,9 +90,9 @@ bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages)
 	/* Convert to number of pages */
 	size = DIV_ROUND_UP(size, PAGE_SIZE);
 
-	down_read(&current->mm->mmap_sem);
-	pinned = current->mm->pinned_vm;
-	up_read(&current->mm->mmap_sem);
+	down_read(&mm->mmap_sem);
+	pinned = mm->pinned_vm;
+	up_read(&mm->mmap_sem);
 
 	/* First, check the absolute limit against all pinned pages. */
 	if (pinned + npages >= ulimit && !can_lock)
@@ -100,8 +101,8 @@ bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages)
 	return ((nlocked + npages) <= size) || can_lock;
 }
 
-int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
-			    struct page **pages)
+int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t npages,
+			    bool writable, struct page **pages)
 {
 	int ret;
 
@@ -109,9 +110,9 @@ int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
 	if (ret < 0)
 		return ret;
 
-	down_write(&current->mm->mmap_sem);
-	current->mm->pinned_vm += ret;
-	up_write(&current->mm->mmap_sem);
+	down_write(&mm->mmap_sem);
+	mm->pinned_vm += ret;
+	up_write(&mm->mmap_sem);
 
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index e88d555389f4..640c244b665b 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -413,6 +413,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	pq->sdma_rb_root = RB_ROOT;
 	INIT_LIST_HEAD(&pq->evict);
 	spin_lock_init(&pq->evict_lock);
+	pq->mm = fd->mm;
 
 	iowait_init(&pq->busy, 0, NULL, defer_packet_queue,
 		    activate_packet_queue, NULL);
@@ -442,7 +443,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	cq->nentries = hfi1_sdma_comp_ring_size;
 	fd->cq = cq;
 
-	ret = hfi1_mmu_rb_register(&pq->sdma_rb_root, &sdma_rb_ops);
+	ret = hfi1_mmu_rb_register(pq->mm, &pq->sdma_rb_root, &sdma_rb_ops);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
 		goto done;
@@ -1205,12 +1206,12 @@ static int pin_vector_pages(struct user_sdma_request *req,
 			spin_unlock(&pq->evict_lock);
 		}
 retry:
-		if (!hfi1_can_pin_pages(pq->dd, pq->n_locked, npages)) {
+		if (!hfi1_can_pin_pages(pq->dd, pq->mm, pq->n_locked, npages)) {
 			cleared = sdma_cache_evict(pq, npages);
 			if (cleared >= npages)
 				goto retry;
 		}
-		pinned = hfi1_acquire_user_pages(
+		pinned = hfi1_acquire_user_pages(pq->mm,
 			((unsigned long)iovec->iov.iov_base +
 			 (node->npages * PAGE_SIZE)), npages, 0,
 			pages + node->npages);
@@ -1220,7 +1221,7 @@ retry:
 			goto bail;
 		}
 		if (pinned != npages) {
-			unpin_vector_pages(current->mm, pages, node->npages,
+			unpin_vector_pages(pq->mm, pages, node->npages,
 					   pinned);
 			ret = -EFAULT;
 			goto bail;
@@ -1252,7 +1253,7 @@ retry:
 	return 0;
 bail:
 	if (rb_node)
-		unpin_vector_pages(current->mm, node->pages, 0, node->npages);
+		unpin_vector_pages(pq->mm, node->pages, 0, node->npages);
 	kfree(node);
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 20ff846f318b..ff49f74f43f4 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -72,6 +72,7 @@ struct hfi1_user_sdma_pkt_q {
 	u32 n_locked;
 	struct list_head evict;
 	spinlock_t evict_lock; /* protect evict and n_locked */
+	struct mm_struct *mm;
 };
 
 struct hfi1_user_sdma_comp_q {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
