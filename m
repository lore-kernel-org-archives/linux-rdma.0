From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 05/20] IB/core: Implement support for MMU notifiers regarding on demand paging regions
Date: Sun,  2 Mar 2014 12:49:23 +0200
Message-ID: <1393757378-16412-6-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Dagan <yuvalda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* Add an interval tree implementation for ODP umems. Create an interval tree
  for each ucontext (including a count of the number of ODP MRs in this
  context, mutex, etc.), and register ODP umems in the interval tree.
* Add MMU notifiers handling functions, using the interval tree to notify only
  the relevant umems and underlying MRs.
* Register to receive MMU notifier events from the MM subsystem upon ODP MR
  registration (and unregister accordingly).
* Add a completion object to synchronize the destruction of ODP umems.
* Add mechanism to abort page faults when there's a concurrent invalidation,
  and modify mlx5_ib to match the new interface to
  ib_umem_odp_map_dma_single_page.

The way we synchronize between concurrent invalidations and page faults is by
keeping a counter of currently running invalidations, and a sequence number
that is incremented whenever an invalidation is caught. The page fault code
checks the counter and also verifies that the sequence number hasn't
progressed before it updates the umem's page tables. This is similar to what
the kvm module does.

There's currently a rare race in the code when registering a umem in the
middle of an ongoing notifier. The proper fix is to either serialize the
insertion to our umem tree with mm_lock_all or use a ucontext wide running
notifiers count for retries decision. Either is ugly and can lead to some sort
of starvation. The current workaround is ugly as well - now the user can end
up with mapped addresses that are not in the user's address space (although it
is highly unlikely).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yuval Dagan <yuvalda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            |   1 +
 drivers/infiniband/core/Makefile      |   2 +-
 drivers/infiniband/core/umem.c        |   2 +-
 drivers/infiniband/core/umem_odp.c    | 317 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/umem_rbtree.c |  94 ++++++++++
 drivers/infiniband/core/uverbs_cmd.c  |  16 ++
 include/rdma/ib_umem_odp.h            |  56 ++++++
 include/rdma/ib_verbs.h               |  16 ++
 8 files changed, 494 insertions(+), 10 deletions(-)
 create mode 100644 drivers/infiniband/core/umem_rbtree.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 089a2c2..b899531 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -41,6 +41,7 @@ config INFINIBAND_USER_MEM
 config INFINIBAND_ON_DEMAND_PAGING
 	bool "InfiniBand on-demand paging support"
 	depends on INFINIBAND_USER_MEM
+	select MMU_NOTIFIER
 	default y
 	---help---
 	  On demand paging support for the InfiniBand subsystem.
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 5af6f4a..021c563 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
-ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o
+ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index e9798e0..014977f 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -72,7 +72,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * ib_umem_get - Pin and DMA map userspace memory.
  *
  * If access flags indicate ODP memory, avoid pinning. Instead, stores
- * the mm for future page fault handling.
+ * the mm for future page fault handling in conjuction with MMU notifiers.
  *
  * @context: userspace context to pin memory for
  * @addr: userspace virtual address to start at
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 67b7816..f16559c 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -41,26 +41,204 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_umem_odp.h>
 
+void ib_umem_notifier_start_account(struct ib_umem *item)
+{
+	int notifiers_count;
+	mutex_lock(&item->odp_data->umem_mutex);
+	/*
+	 * Avoid performing another locked operation, as we are
+	 * already protected by the wrapping mutex.
+	 */
+	notifiers_count = atomic_read(&item->odp_data->notifiers_count) + 1;
+	if (notifiers_count == 1)
+		reinit_completion(&item->odp_data->notifier_completion);
+	atomic_set(&item->odp_data->notifiers_count,
+		   notifiers_count);
+	mutex_unlock(&item->odp_data->umem_mutex);
+}
+EXPORT_SYMBOL(ib_umem_notifier_start_account);
+
+void ib_umem_notifier_end_account(struct ib_umem *item)
+{
+	int notifiers_count, notifiers_seq;
+	mutex_lock(&item->odp_data->umem_mutex);
+	/*
+	 * This sequence increase will notify the QP page fault that
+	 * the page that is going to be mapped in the spte could have
+	 * been freed.
+	 */
+	notifiers_seq = atomic_read(&item->odp_data->notifiers_seq) + 1;
+	atomic_set(&item->odp_data->notifiers_seq,
+		   notifiers_seq);
+	/*
+	 * The above sequence increase must be visible before the
+	 * below count decrease, which is ensured by the smp_wmb below
+	 * in conjunction with the smp_rmb in mmu_notifier_retry().
+	 */
+	smp_wmb();
+
+	notifiers_count = atomic_read(&item->odp_data->notifiers_count);
+	/*
+	 * This is a workaround for the unlikely case where we register a umem
+	 * in the middle of an ongoing notifier.
+	 */
+	if (notifiers_count > 0)
+		notifiers_count -= 1;
+	else
+		pr_warn("Got notifier end call without a previous start call");
+	atomic_set(&item->odp_data->notifiers_count,
+		   notifiers_count);
+	if (notifiers_count == 0)
+		complete_all(&item->odp_data->notifier_completion);
+	mutex_unlock(&item->odp_data->umem_mutex);
+}
+
+
+static int ib_umem_notifier_release_trampoline(struct ib_umem *item, u64 start,
+					       u64 end, void *cookie) {
+	/*
+	 * Increase the number of notifiers running, to
+	 * prevent any further fault handling on this MR.
+	 */
+	ib_umem_notifier_start_account(item);
+	item->odp_data->dying = 1;
+	/* Make sure that the fact the umem is dying is out before we release
+	 * all pending page faults. */
+	smp_wmb();
+	complete_all(&item->odp_data->notifier_completion);
+	item->context->invalidate_range(item, ib_umem_start(item),
+					ib_umem_end(item));
+	return 0;
+}
+
+static void ib_umem_notifier_release(struct mmu_notifier *mn,
+				     struct mm_struct *mm)
+{
+	struct ib_ucontext *context = container_of(mn, struct ib_ucontext, mn);
+
+	if (!context->invalidate_range)
+		return;
+
+	down_read(&context->umem_mutex);
+
+	rbt_ib_umem_for_each_in_range(&context->umem_tree, 0,
+				      ULLONG_MAX,
+				      ib_umem_notifier_release_trampoline,
+				      NULL);
+
+	up_read(&context->umem_mutex);
+}
+
+static int invalidate_page_trampoline(struct ib_umem *item, u64 start,
+				      u64 end, void *cookie)
+{
+	ib_umem_notifier_start_account(item);
+	item->context->invalidate_range(item, start, start + PAGE_SIZE);
+	ib_umem_notifier_end_account(item);
+	return 0;
+}
+
+static void ib_umem_notifier_invalidate_page(struct mmu_notifier *mn,
+					     struct mm_struct *mm,
+					     unsigned long address)
+{
+	struct ib_ucontext *context = container_of(mn, struct ib_ucontext, mn);
+
+	if (!context->invalidate_range)
+		return;
+
+	down_read(&context->umem_mutex);
+	rbt_ib_umem_for_each_in_range(&context->umem_tree, address,
+				      address + PAGE_SIZE,
+				      invalidate_page_trampoline, NULL);
+	up_read(&context->umem_mutex);
+}
+
+static int invalidate_range_start_trampoline(struct ib_umem *item, u64 start,
+					     u64 end, void *cookie)
+{
+	ib_umem_notifier_start_account(item);
+	item->context->invalidate_range(item, start, end);
+	return 0;
+}
+
+static void ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
+						    struct mm_struct *mm,
+						    unsigned long start,
+						    unsigned long end)
+{
+	struct ib_ucontext *context = container_of(mn, struct ib_ucontext, mn);
+
+	if (!context->invalidate_range)
+		return;
+
+	down_read(&context->umem_mutex);
+	rbt_ib_umem_for_each_in_range(&context->umem_tree, start,
+				      end,
+				      invalidate_range_start_trampoline, NULL);
+	up_read(&context->umem_mutex);
+}
+
+static int invalidate_range_end_trampoline(struct ib_umem *item, u64 start,
+					   u64 end, void *cookie)
+{
+	ib_umem_notifier_end_account(item);
+	return 0;
+}
+
+static void ib_umem_notifier_invalidate_range_end(struct mmu_notifier *mn,
+						  struct mm_struct *mm,
+						  unsigned long start,
+						  unsigned long end)
+{
+	struct ib_ucontext *context = container_of(mn, struct ib_ucontext, mn);
+
+	if (!context->invalidate_range)
+		return;
+
+	down_read(&context->umem_mutex);
+	rbt_ib_umem_for_each_in_range(&context->umem_tree, start,
+				      end,
+				      invalidate_range_end_trampoline, NULL);
+	up_read(&context->umem_mutex);
+}
+
+static struct mmu_notifier_ops ib_umem_notifiers = {
+	.release                    = ib_umem_notifier_release,
+	.invalidate_page            = ib_umem_notifier_invalidate_page,
+	.invalidate_range_start     = ib_umem_notifier_invalidate_range_start,
+	.invalidate_range_end       = ib_umem_notifier_invalidate_range_end,
+};
+
 int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 {
 	int ret_val;
 	struct pid *our_pid;
+	struct mm_struct *mm = get_task_mm(current);
+	BUG_ON(!mm);
 
 	/* Prevent creating ODP MRs in child processes */
 	rcu_read_lock();
 	our_pid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	rcu_read_unlock();
 	put_pid(our_pid);
-	if (context->tgid != our_pid)
-		return -EINVAL;
+	if (context->tgid != our_pid) {
+		ret_val = -EINVAL;
+		goto out_mm;
+	}
 
 	umem->hugetlb = 0;
 	umem->odp_data = kzalloc(sizeof(*umem->odp_data), GFP_KERNEL);
-	if (!umem->odp_data)
-		return -ENOMEM;
+	if (!umem->odp_data) {
+		ret_val = -ENOMEM;
+		goto out_mm;
+	}
+	umem->odp_data->umem = umem;
 
 	mutex_init(&umem->odp_data->umem_mutex);
 
+	init_completion(&umem->odp_data->notifier_completion);
+
 	umem->odp_data->page_list = vzalloc(ib_umem_num_pages(umem) *
 					    sizeof(*umem->odp_data->page_list));
 	if (!umem->odp_data->page_list) {
@@ -75,17 +253,66 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 		goto out_page_list;
 	}
 
+	/*
+	 * When using MMU notifiers, we will get a
+	 * notification before the "current" task (and MM) is
+	 * destroyed. We use the umem_mutex lock to synchronize.
+	 */
+	down_write(&context->umem_mutex);
+	context->odp_mrs_count++;
+	if (likely(ib_umem_start(umem) != ib_umem_end(umem)))
+		rbt_ib_umem_insert(&umem->odp_data->interval_tree,
+				   &context->umem_tree);
+	downgrade_write(&context->umem_mutex);
+
+	if (context->odp_mrs_count == 1) {
+		/*
+		 * Note that at this point, no MMU notifier is running
+		 * for this context!
+		 */
+		INIT_HLIST_NODE(&context->mn.hlist);
+		context->mn.ops = &ib_umem_notifiers;
+		/*
+		 * Lock-dep detects a false positive for mmap_sem vs.
+		 * umem_mutex, due to not grasping downgrade_write correctly.
+		 */
+		lockdep_off();
+		ret_val = mmu_notifier_register(&context->mn, mm);
+		lockdep_on();
+		if (ret_val) {
+			pr_err("Failed to register mmu_notifier %d\n", ret_val);
+			ret_val = -EBUSY;
+			goto out_mutex;
+		}
+	}
+
+	up_read(&context->umem_mutex);
+
+	/*
+	 * Note that doing an mmput can cause a notifier for the relevant mm.
+	 * If the notifier is called while we hold the umem_mutex, this will
+	 * cause a deadlock. Therefore, we release the reference only after we
+	 * released the mutex.
+	 */
+	mmput(mm);
 	return 0;
 
+out_mutex:
+	up_read(&context->umem_mutex);
+	vfree(umem->odp_data->dma_list);
 out_page_list:
 	vfree(umem->odp_data->page_list);
 out_odp_data:
 	kfree(umem->odp_data);
+out_mm:
+	mmput(mm);
 	return ret_val;
 }
 
 void ib_umem_odp_release(struct ib_umem *umem)
 {
+	struct ib_ucontext *context = umem->context;
+
 	/*
 	 * Ensure that no more pages are mapped in the umem.
 	 *
@@ -95,6 +322,49 @@ void ib_umem_odp_release(struct ib_umem *umem)
 	ib_umem_odp_unmap_dma_pages(umem, ib_umem_start(umem),
 				    ib_umem_end(umem));
 
+	down_write(&context->umem_mutex);
+	if (likely(ib_umem_start(umem) != ib_umem_end(umem)))
+		rbt_ib_umem_remove(&umem->odp_data->interval_tree,
+				   &context->umem_tree);
+	context->odp_mrs_count--;
+
+	/*
+	 * Downgrade the lock to a read lock. This ensures that the notifiers
+	 * (who lock the mutex for reading) will be able to finish, and we
+	 * will be able to enventually obtain the mmu notifiers SRCU. Note
+	 * that since we are doing it atomically, no other user could register
+	 * and unregister while we do the check.
+	 */
+	downgrade_write(&context->umem_mutex);
+	if (!context->odp_mrs_count) {
+		struct task_struct *owning_process = NULL;
+		struct mm_struct *owning_mm        = NULL;
+		owning_process = get_pid_task(context->tgid,
+					      PIDTYPE_PID);
+		if (owning_process == NULL)
+			/*
+			 * The process is already dead, notifier were removed
+			 * already.
+			 */
+			goto out;
+
+		owning_mm = get_task_mm(owning_process);
+		if (owning_mm == NULL)
+			/*
+			 * The process' mm is already dead, notifier were
+			 * removed already.
+			 */
+			goto out_put_task;
+		mmu_notifier_unregister(&context->mn, owning_mm);
+
+		mmput(owning_mm);
+
+out_put_task:
+		put_task_struct(owning_process);
+	}
+out:
+	up_read(&context->umem_mutex);
+
 	vfree(umem->odp_data->dma_list);
 	vfree(umem->odp_data->page_list);
 	kfree(umem);
@@ -111,7 +381,8 @@ void ib_umem_odp_release(struct ib_umem *umem)
  *               the sequence number is taken from
  *               umem->odp_data->notifiers_seq.
  *
- * The function returns -EFAULT if the DMA mapping operation fails.
+ * The function returns -EFAULT if the DMA mapping operation fails. It returns
+ * -EAGAIN if a concurrent invalidation prevents us from updating the page. It
  *
  * The page is released via put_page even if the operation failed. For
  * on-demand pinning, the page is released whenever it isn't stored in the
@@ -129,6 +400,15 @@ static int ib_umem_odp_map_dma_single_page(
 	int stored_page = 0;
 	int ret = 0;
 	mutex_lock(&umem->odp_data->umem_mutex);
+	/*
+	 * Note: we avoid writing if seq is different from the initial seq, to
+	 * handle case of a racing notifier. This check also allows us to bail
+	 * early if we have a notifier running in parallel with us.
+	 */
+	if (ib_umem_mmu_notifier_retry(umem, current_seq)) {
+		ret = -EAGAIN;
+		goto out;
+	}
 	if (!(umem->odp_data->dma_list[page_index])) {
 		dma_addr = ib_dma_map_page(dev,
 					   page,
@@ -156,7 +436,8 @@ static int ib_umem_odp_map_dma_single_page(
 out:
 	mutex_unlock(&umem->odp_data->umem_mutex);
 
-	if (!stored_page)
+	/* On Demand Paging - avoid pinning the page */
+	if (umem->context->invalidate_range || !stored_page)
 		put_page(page);
 
 	return ret;
@@ -171,6 +452,8 @@ out:
  *
  * Returns the number of pages mapped in success, negative error code
  * for failure.
+ * An -EAGAIN error code is returned when a concurrent mmu notifier prevents
+ * the function from completing its task.
  *
  * @umem: the umem to map and pin
  * @user_virt: the address from which we need to map.
@@ -285,6 +568,11 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 	struct ib_device *dev = umem->context->device;
 	virt  = max_t(u64, virt,  ib_umem_start(umem));
 	bound = min_t(u64, bound, ib_umem_end(umem));
+	/* Note that during the run of this function, the
+	 * notifiers_count of the MR is > 0, preventing any racing
+	 * faults from completion. We might be racing with other
+	 * invalidations, so we must make sure we free each page only
+	 * once. */
 	for (addr = virt; addr < bound; addr += (u64)umem->page_size) {
 		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
 		mutex_lock(&umem->odp_data->umem_mutex);
@@ -299,8 +587,21 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 			ib_dma_unmap_page(dev, dma_addr, PAGE_SIZE,
 					  DMA_BIDIRECTIONAL);
 			if (umem->writable)
-				set_page_dirty_lock(head_page);
-			put_page(page);
+				/*
+				 * set_page_dirty prefers being called with
+				 * the page lock. However, MMU notifiers are
+				 * called sometimes with and sometimes without
+				 * the lock. We rely on the umem_mutex instead
+				 * to prevent other mmu notifiers from
+				 * continuing and allowing the page mapping to
+				 * be removed.
+				 */
+				set_page_dirty(head_page);
+			/* on demand pinning support */
+			if (!umem->context->invalidate_range)
+				put_page(page);
+			umem->odp_data->page_list[idx] = NULL;
+			umem->odp_data->dma_list[idx] = 0;
 		}
 		mutex_unlock(&umem->odp_data->umem_mutex);
 	}
diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniband/core/umem_rbtree.c
new file mode 100644
index 0000000..727d788
--- /dev/null
+++ b/drivers/infiniband/core/umem_rbtree.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2014 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interval_tree_generic.h>
+#include <linux/sched.h>
+#include <linux/gfp.h>
+#include <rdma/ib_umem_odp.h>
+
+/*
+ * The ib_umem list keeps track of memory regions for which the HW
+ * device request to receive notification when the related memory
+ * mapping is changed.
+ *
+ * ib_umem_lock protects the list.
+ */
+
+static inline u64 node_start(struct umem_odp_node *n)
+{
+	struct ib_umem_odp *umem_odp =
+			container_of(n, struct ib_umem_odp, interval_tree);
+
+	return ib_umem_start(umem_odp->umem);
+}
+
+/* Note that the representation of the intervals in the interval tree
+ * considers the ending point as contained in the interval, while the
+ * function ib_umem_end returns the first address which is not contained
+ * in the umem.
+ */
+static inline u64 node_last(struct umem_odp_node *n)
+{
+	struct ib_umem_odp *umem_odp =
+			container_of(n, struct ib_umem_odp, interval_tree);
+
+	return ib_umem_end(umem_odp->umem) - 1;
+}
+
+INTERVAL_TREE_DEFINE(struct umem_odp_node, rb, u64, __subtree_last,
+		     node_start, node_last, , rbt_ib_umem)
+
+/* @last is not a part of the interval. See comment for function
+ * node_last.
+ */
+int rbt_ib_umem_for_each_in_range(struct rb_root *root,
+				  u64 start, u64 last,
+				  umem_call_back cb,
+				  void *cookie)
+{
+	int ret_val = 0;
+	struct umem_odp_node *node;
+	struct ib_umem_odp *umem;
+
+	if (unlikely(start == last))
+		return ret_val;
+
+	for (node = rbt_ib_umem_iter_first(root, start, last - 1); node;
+			node = rbt_ib_umem_iter_next(node, start, last - 1)) {
+		umem = container_of(node, struct ib_umem_odp, interval_tree);
+		ret_val = cb(umem->umem, start, last, cookie) || ret_val;
+	}
+
+	return ret_val;
+}
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6c6be37..816b85c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -289,6 +289,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	struct ib_uverbs_get_context_resp resp;
 	struct ib_udata                   udata;
 	struct ib_device                 *ibdev = file->device->ib_dev;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	struct ib_device_attr		  dev_attr;
+#endif
 	struct ib_ucontext		 *ucontext;
 	struct file			 *filp;
 	int ret;
@@ -331,6 +334,19 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	rcu_read_unlock();
 	ucontext->closing = 0;
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	ucontext->umem_tree = RB_ROOT;
+	init_rwsem(&ucontext->umem_mutex);
+	ucontext->odp_mrs_count = 0;
+
+	ret = ib_query_device(ibdev, &dev_attr);
+	if (ret)
+		goto err_free;
+	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
+		ucontext->invalidate_range = NULL;
+
+#endif
+
 	resp.num_comp_vectors = file->device->num_comp_vectors;
 
 	ret = get_unused_fd_flags(O_CLOEXEC);
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 375ce28..bcdaa2e 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -34,6 +34,12 @@
 #define IB_UMEM_ODP_H
 
 #include <rdma/ib_umem.h>
+#include <linux/interval_tree.h>
+
+struct umem_odp_node {
+	u64 __subtree_last;
+	struct rb_node rb;
+};
 
 struct ib_umem_odp {
 	/*
@@ -58,6 +64,14 @@ struct ib_umem_odp {
 
 	atomic_t		notifiers_seq;
 	atomic_t		notifiers_count;
+
+	struct ib_umem		*umem;
+
+	/* Tree tracking */
+	struct umem_odp_node	interval_tree;
+
+	struct completion	notifier_completion;
+	int			dying;
 };
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
@@ -85,6 +99,48 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 start_offset, u64 bcnt,
 void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 start_offset,
 				 u64 bound);
 
+void rbt_ib_umem_insert(struct umem_odp_node *node, struct rb_root *root);
+void rbt_ib_umem_remove(struct umem_odp_node *node, struct rb_root *root);
+typedef int (*umem_call_back)(struct ib_umem *item, u64 start, u64 end,
+			      void *cookie);
+/*
+ * Call the callback on each ib_umem in the range. Returns the logical or of
+ * the return values of the functions called.
+ */
+int rbt_ib_umem_for_each_in_range(struct rb_root *root, u64 start, u64 end,
+					      umem_call_back cb, void *cookie);
+
+struct umem_odp_node *rbt_ib_umem_iter_first(struct rb_root *root,
+					     u64 start, u64 last);
+struct umem_odp_node *rbt_ib_umem_iter_next(struct umem_odp_node *node,
+					    u64 start, u64 last);
+
+static inline int ib_umem_mmu_notifier_retry(struct ib_umem *item,
+					     unsigned long mmu_seq)
+{
+	/*
+	 * This code is strongly based on the KVM code from
+	 * mmu_notifier_retry. Should be called with
+	 * item->odp_data->umem_mutex locked.
+	 */
+	if (unlikely(atomic_read(&item->odp_data->notifiers_count)))
+		return 1;
+	/*
+	 * Ensure the read of mmu_notifier_count happens before the read
+	 * of mmu_notifier_seq.  This interacts with the smp_wmb() in
+	 * mmu_notifier_invalidate_range_end to make sure that the caller
+	 * either sees the old (non-zero) value of mmu_notifier_count or
+	 * the new (incremented) value of mmu_notifier_seq.
+	 */
+	smp_rmb();
+	if (atomic_read(&item->odp_data->notifiers_seq) != mmu_seq)
+		return 1;
+	return 0;
+}
+
+void ib_umem_notifier_start_account(struct ib_umem *item);
+void ib_umem_notifier_end_account(struct ib_umem *item);
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 static inline int ib_umem_odp_get(struct ib_ucontext *context,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c557bb5..7dff94d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -51,6 +51,7 @@
 #include <uapi/linux/if_ether.h>
 
 #include <linux/atomic.h>
+#include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
 
 extern struct workqueue_struct *ib_wq;
@@ -1141,6 +1142,8 @@ struct ib_fmr_attr {
 	u8	page_shift;
 };
 
+struct ib_umem;
+
 struct ib_ucontext {
 	struct ib_device       *device;
 	struct list_head	pd_list;
@@ -1156,6 +1159,19 @@ struct ib_ucontext {
 
 	/* For ODP support: */
 	struct pid             *tgid;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	struct rb_root      umem_tree;
+	/*
+	 * Protects .umem_rbroot and tree, as well as odp_mrs_count and
+	 * mmu notifiers registration.
+	 */
+	struct rw_semaphore	umem_mutex;
+	void (*invalidate_range)(struct ib_umem *umem,
+				 unsigned long start, unsigned long end);
+
+	struct mmu_notifier	mn;
+	int                     odp_mrs_count;
+#endif
 };
 
 struct ib_uobject {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
