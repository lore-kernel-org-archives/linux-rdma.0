From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 10/13] staging/rdma/hfi1: Add MMU notifier callback function
Date: Fri,  5 Feb 2016 11:57:55 -0500
Message-ID: <1454691478-15444-11-git-send-email-ira.weiny@intel.com>
References: <1454691478-15444-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454691478-15444-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

TID caching will rely on the MMU notifier to be told
when memory is being invalidated. When the callback
is called, the driver will find all RcvArray entries
that span the invalidated buffer and "schedule" them
to be freed by the PSM library.

This function is currently unused and is being added
in preparation for the TID caching feature.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 67 +++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 843023e2e2c7..1787c55d21d6 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -104,7 +104,7 @@ static int set_rcvarray_entry(struct file *, unsigned long, u32,
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
 static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
-						 unsigned long) __maybe_unused;
+						 unsigned long);
 static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *,
 							 u32);
 static int mmu_rb_insert_by_addr(struct rb_root *, struct mmu_rb_node *);
@@ -683,7 +683,70 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 					unsigned long start, unsigned long end,
 					enum mmu_call_types type)
 {
-	/* Stub for now */
+	struct hfi1_filedata *fd = container_of(mn, struct hfi1_filedata, mn);
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct rb_root *root = &fd->tid_rb_root;
+	struct mmu_rb_node *node;
+	unsigned long addr = start;
+
+	spin_lock(&fd->rb_lock);
+	while (addr < end) {
+		node = mmu_rb_search_by_addr(root, addr);
+
+		if (!node) {
+			/*
+			 * Didn't find a node at this address. However, the
+			 * range could be bigger than what we have registered
+			 * so we have to keep looking.
+			 */
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
+				 * hfi1_set_uevent_bits() sets a user event flag
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
 }
 
 static inline int mmu_addr_cmp(struct mmu_rb_node *node, unsigned long addr,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
