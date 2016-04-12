From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/12] IB/hfi1: Prevent NULL pointer deferences in caching
 code
Date: Tue, 12 Apr 2016 10:45:57 -0700
Message-ID: <20160412174556.19295.18644.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a potential kernel crash when the MMU notifier calls the
invalidation routines in the hfi1 pinned page caching code for sdma.

The invalidation routine could call the remove callback
for the node, which in turn ends up dereferencing the
current task_struct to get a pointer to the mm_struct.
However, the mm_struct pointer could be NULL resulting in
the following backtrace:

    BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
    IP: [<ffffffffa041f75a>] sdma_rb_remove+0xaa/0x100 [hfi1]
    15
    task: ffff88085e66e080 ti: ffff88085c244000 task.ti: ffff88085c244000
    RIP: 0010:[<ffffffffa041f75a>]  [<ffffffffa041f75a>] sdma_rb_remove+0xaa/0x100 [hfi1]
    RSP: 0000:ffff88085c245878  EFLAGS: 00010002
    RAX: 0000000000000000 RBX: ffff88105b9bbd40 RCX: ffffea003931a830
    RDX: 0000000000000004 RSI: ffff88105754a9c0 RDI: ffff88105754a9c0
    RBP: ffff88085c245890 R08: ffff88105b9bbd70 R09: 00000000fffffffb
    R10: ffff88105b9bbd58 R11: 0000000000000013 R12: ffff88105754a9c0
    R13: 0000000000000001 R14: 0000000000000001 R15: ffff88105b9bbd40
    FS:  0000000000000000(0000) GS:ffff88107ef40000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00000000000000a8 CR3: 0000000001a0b000 CR4: 00000000001407e0
    Stack:
     ffff88105b9bbd40 ffff88080ec481a8 ffff88080ec481b8 ffff88085c2458c0
     ffffffffa03fa00e ffff88080ec48190 ffff88080ed9cd00 0000000001024000
     0000000000000000 ffff88085c245920 ffffffffa03fa0e7 0000000000000282
    Call Trace:
     [<ffffffffa03fa00e>] __mmu_rb_remove.isra.5+0x5e/0x70 [hfi1]
     [<ffffffffa03fa0e7>] mmu_notifier_mem_invalidate+0xc7/0xf0 [hfi1]
     [<ffffffffa03fa143>] mmu_notifier_page+0x13/0x20 [hfi1]
     [<ffffffff81156dd0>] __mmu_notifier_invalidate_page+0x50/0x70
     [<ffffffff81140bbb>] try_to_unmap_one+0x20b/0x470
     [<ffffffff81141ee7>] try_to_unmap_anon+0xa7/0x120
     [<ffffffff81141fad>] try_to_unmap+0x4d/0x60
     [<ffffffff8111fd7b>] shrink_page_list+0x2eb/0x9d0
     [<ffffffff81120ab3>] shrink_inactive_list+0x243/0x490
     [<ffffffff81121491>] shrink_lruvec+0x4c1/0x640
     [<ffffffff81121641>] shrink_zone+0x31/0x100
     [<ffffffff81121b0f>] kswapd_shrink_zone.constprop.62+0xef/0x1c0
     [<ffffffff811229e3>] kswapd+0x403/0x7e0
     [<ffffffff811225e0>] ? shrink_all_memory+0xf0/0xf0
     [<ffffffff81068ac0>] kthread+0xc0/0xd0
     [<ffffffff81068a00>] ? insert_kthread_work+0x40/0x40
     [<ffffffff814ff8ec>] ret_from_fork+0x7c/0xb0
     [<ffffffff81068a00>] ? insert_kthread_work+0x40/0x40

To correct this, the mm_struct passed to us by the MMU notifier is
used (which is what should have been done to begin with). This avoids
the broken derefences and ensures that the correct mm_struct is used.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c       |   24 ++++++++++++++----------
 drivers/staging/rdma/hfi1/mmu_rb.h       |    3 ++-
 drivers/staging/rdma/hfi1/user_exp_rcv.c |    9 +++++----
 drivers/staging/rdma/hfi1/user_sdma.c    |   24 ++++++++++++++++--------
 4 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index c7ad016..eac4d04 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -71,6 +71,7 @@ static inline void mmu_notifier_range_start(struct mmu_notifier *,
 					    struct mm_struct *,
 					    unsigned long, unsigned long);
 static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
+					struct mm_struct *,
 					unsigned long, unsigned long);
 static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *,
 					   unsigned long, unsigned long);
@@ -137,7 +138,7 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 			rbnode = rb_entry(node, struct mmu_rb_node, node);
 			rb_erase(node, root);
 			if (handler->ops->remove)
-				handler->ops->remove(root, rbnode, false);
+				handler->ops->remove(root, rbnode, NULL);
 		}
 	}
 
@@ -201,14 +202,14 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 }
 
 static void __mmu_rb_remove(struct mmu_rb_handler *handler,
-			    struct mmu_rb_node *node, bool arg)
+			    struct mmu_rb_node *node, struct mm_struct *mm)
 {
 	/* Validity of handler and node pointers has been checked by caller. */
 	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
 		  node->len);
 	__mmu_int_rb_remove(node, handler->root);
 	if (handler->ops->remove)
-		handler->ops->remove(handler->root, node, arg);
+		handler->ops->remove(handler->root, node, mm);
 }
 
 struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
@@ -237,7 +238,7 @@ void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 		return;
 
 	spin_lock_irqsave(&handler->lock, flags);
-	__mmu_rb_remove(handler, node, false);
+	__mmu_rb_remove(handler, node, NULL);
 	spin_unlock_irqrestore(&handler->lock, flags);
 }
 
@@ -260,7 +261,7 @@ unlock:
 static inline void mmu_notifier_page(struct mmu_notifier *mn,
 				     struct mm_struct *mm, unsigned long addr)
 {
-	mmu_notifier_mem_invalidate(mn, addr, addr + PAGE_SIZE);
+	mmu_notifier_mem_invalidate(mn, mm, addr, addr + PAGE_SIZE);
 }
 
 static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
@@ -268,25 +269,28 @@ static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
 					    unsigned long start,
 					    unsigned long end)
 {
-	mmu_notifier_mem_invalidate(mn, start, end);
+	mmu_notifier_mem_invalidate(mn, mm, start, end);
 }
 
 static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
+					struct mm_struct *mm,
 					unsigned long start, unsigned long end)
 {
 	struct mmu_rb_handler *handler =
 		container_of(mn, struct mmu_rb_handler, mn);
 	struct rb_root *root = handler->root;
-	struct mmu_rb_node *node;
+	struct mmu_rb_node *node, *ptr = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&handler->lock, flags);
-	for (node = __mmu_int_rb_iter_first(root, start, end - 1); node;
-	     node = __mmu_int_rb_iter_next(node, start, end - 1)) {
+	for (node = __mmu_int_rb_iter_first(root, start, end - 1);
+	     node; node = ptr) {
+		/* Guard against node removal. */
+		ptr = __mmu_int_rb_iter_next(node, start, end - 1);
 		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
 			  node->addr, node->len);
 		if (handler->ops->invalidate(root, node))
-			__mmu_rb_remove(handler, node, true);
+			__mmu_rb_remove(handler, node, mm);
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 }
diff --git a/drivers/staging/rdma/hfi1/mmu_rb.h b/drivers/staging/rdma/hfi1/mmu_rb.h
index f8523fd..19a306e 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.h
+++ b/drivers/staging/rdma/hfi1/mmu_rb.h
@@ -59,7 +59,8 @@ struct mmu_rb_node {
 struct mmu_rb_ops {
 	bool (*filter)(struct mmu_rb_node *, unsigned long, unsigned long);
 	int (*insert)(struct rb_root *, struct mmu_rb_node *);
-	void (*remove)(struct rb_root *, struct mmu_rb_node *, bool);
+	void (*remove)(struct rb_root *, struct mmu_rb_node *,
+		       struct mm_struct *);
 	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);
 };
 
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 0861e09..5b72849 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -87,7 +87,8 @@ static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
+static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *,
+			  struct mm_struct *);
 static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
@@ -899,7 +900,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		mmu_rb_remove(&fd->tid_rb_root, &node->mmu, false);
+		mmu_rb_remove(&fd->tid_rb_root, &node->mmu, NULL);
 	else
 		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
 
@@ -965,7 +966,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 					continue;
 				if (HFI1_CAP_IS_USET(TID_UNMAP))
 					mmu_rb_remove(&fd->tid_rb_root,
-						      &node->mmu, false);
+						      &node->mmu, NULL);
 				else
 					hfi1_mmu_rb_remove(&fd->tid_rb_root,
 							   &node->mmu);
@@ -1032,7 +1033,7 @@ static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 }
 
 static void mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node,
-			  bool notifier)
+			  struct mm_struct *mm)
 {
 	struct hfi1_filedata *fdata =
 		container_of(root, struct hfi1_filedata, tid_rb_root);
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index ab6b6a4..e08c74f 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -299,7 +299,8 @@ static int defer_packet_queue(
 static void activate_packet_queue(struct iowait *, int);
 static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
 static int sdma_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void sdma_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
+static void sdma_rb_remove(struct rb_root *, struct mmu_rb_node *,
+			   struct mm_struct *);
 static int sdma_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 
 static struct mmu_rb_ops sdma_rb_ops = {
@@ -1063,8 +1064,10 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	rb_node = hfi1_mmu_rb_search(&pq->sdma_rb_root,
 				     (unsigned long)iovec->iov.iov_base,
 				     iovec->iov.iov_len);
-	if (rb_node)
+	if (rb_node && !IS_ERR(rb_node))
 		node = container_of(rb_node, struct sdma_mmu_node, rb);
+	else
+		rb_node = NULL;
 
 	if (!node) {
 		node = kzalloc(sizeof(*node), GFP_KERNEL);
@@ -1502,7 +1505,7 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 				&req->pq->sdma_rb_root,
 				(unsigned long)req->iovs[i].iov.iov_base,
 				req->iovs[i].iov.iov_len);
-			if (!mnode)
+			if (!mnode || IS_ERR(mnode))
 				continue;
 
 			node = container_of(mnode, struct sdma_mmu_node, rb);
@@ -1547,7 +1550,7 @@ static int sdma_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 }
 
 static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
-			   bool notifier)
+			   struct mm_struct *mm)
 {
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
@@ -1557,14 +1560,19 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 	node->pq->n_locked -= node->npages;
 	spin_unlock(&node->pq->evict_lock);
 
-	unpin_vector_pages(notifier ? NULL : current->mm, node->pages,
-			   node->npages);
+	/*
+	 * If mm is set, we are being called by the MMU notifier and we
+	 * should not pass a mm_struct to unpin_vector_page(). This is to
+	 * prevent a deadlock when hfi1_release_user_pages() attempts to
+	 * take the mmap_sem, which the MMU notifier has already taken.
+	 */
+	unpin_vector_pages(mm ? NULL : current->mm, node->pages, node->npages);
 	/*
 	 * If called by the MMU notifier, we have to adjust the pinned
 	 * page count ourselves.
 	 */
-	if (notifier)
-		current->mm->pinned_vm -= node->npages;
+	if (mm)
+		mm->pinned_vm -= node->npages;
 	kfree(node);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
