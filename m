From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/16] IB/hfi1: Notify remove MMU/RB callback of calling
 context
Date: Tue, 08 Mar 2016 11:14:48 -0800
Message-ID: <20160308191447.30542.76805.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tell the remove MMU/RB callback if it's being called as
part of a memory invalidation or not. This can be important
in preventing a deadlock if the remove callback attempts to
take the map_sem semaphore because the kernel's MMU
invalidation functions have already taken it.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c       |   10 +++++-----
 drivers/infiniband/hw/hfi1/mmu_rb.h       |    2 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    9 +++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index a3515d7..29d6d3e 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -122,7 +122,7 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 			rbnode = rb_entry(node, struct mmu_rb_node, node);
 			rb_erase(node, root);
 			if (handler->ops->remove)
-				handler->ops->remove(root, rbnode);
+				handler->ops->remove(root, rbnode, false);
 		}
 	}
 
@@ -196,12 +196,12 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 }
 
 static void __mmu_rb_remove(struct mmu_rb_handler *handler,
-			    struct mmu_rb_node *node)
+			    struct mmu_rb_node *node, bool arg)
 {
 	/* Validity of handler and node pointers has been checked by caller. */
 	rb_erase(&node->node, handler->root);
 	if (handler->ops->remove)
-		handler->ops->remove(handler->root, node);
+		handler->ops->remove(handler->root, node, arg);
 }
 
 struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
@@ -230,7 +230,7 @@ void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 		return;
 
 	spin_lock_irqsave(&handler->lock, flags);
-	__mmu_rb_remove(handler, node);
+	__mmu_rb_remove(handler, node, false);
 	spin_unlock_irqrestore(&handler->lock, flags);
 }
 
@@ -299,7 +299,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		naddr = node->addr;
 		nlen = node->len;
 		if (handler->ops->invalidate(root, node))
-			__mmu_rb_remove(handler, node);
+			__mmu_rb_remove(handler, node, true);
 
 		/*
 		 * The next address to be looked up is computed based
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 9fe1076..fdd9787 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -59,7 +59,7 @@ struct mmu_rb_ops {
 	int (*compare)(struct mmu_rb_node *, unsigned long,
 		       unsigned long);
 	int (*insert)(struct rb_root *, struct mmu_rb_node *);
-	void (*remove)(struct rb_root *, struct mmu_rb_node *);
+	void (*remove)(struct rb_root *, struct mmu_rb_node *, bool);
 	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);
 };
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index b0b193f..1d971c0 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -89,7 +89,7 @@ static int set_rcvarray_entry(struct file *, unsigned long, u32,
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
 static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
+static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
 static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
@@ -897,7 +897,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
+		mmu_rb_remove(&fd->tid_rb_root, &node->mmu, false);
 	else
 		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
 
@@ -962,7 +962,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 					continue;
 				if (HFI1_CAP_IS_USET(TID_UNMAP))
 					mmu_rb_remove(&fd->tid_rb_root,
-						      &node->mmu);
+						      &node->mmu, false);
 				else
 					hfi1_mmu_rb_remove(&fd->tid_rb_root,
 							   &node->mmu);
@@ -1039,7 +1039,8 @@ static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 	return 0;
 }
 
-static void mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
+static void mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node,
+			  bool notifier)
 {
 	struct hfi1_filedata *fdata =
 		container_of(root, struct hfi1_filedata, tid_rb_root);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
