From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/16] IB/hfi1: Remove compare callback
Date: Tue, 08 Mar 2016 11:15:04 -0800
Message-ID: <20160308191504.30542.45937.stgit@scvm10.sc.intel.com>
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

Interval RB trees provide their own searching function,
which also takes care of determining the path through
the tree that should be taken.

This make the compare callback unnecessary.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c       |    2 +-
 drivers/infiniband/hw/hfi1/mmu_rb.h       |    2 --
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   14 --------------
 3 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index c30373d..5d27fee 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -98,7 +98,7 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 	struct mmu_rb_handler *handlr;
 	unsigned long flags;
 
-	if (!ops->compare || !ops->invalidate)
+	if (!ops->invalidate)
 		return -EINVAL;
 
 	handlr = kmalloc(sizeof(*handlr), GFP_KERNEL);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index abed3a6..9c26009 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -57,8 +57,6 @@ struct mmu_rb_node {
 };
 
 struct mmu_rb_ops {
-	int (*compare)(struct mmu_rb_node *, unsigned long,
-		       unsigned long);
 	int (*insert)(struct rb_root *, struct mmu_rb_node *);
 	void (*remove)(struct rb_root *, struct mmu_rb_node *, bool);
 	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 1d971c0..bf670cb 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -86,8 +86,6 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
 static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
-static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
-			       unsigned long);
 static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
 static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
 static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
@@ -98,7 +96,6 @@ static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
 static void clear_tid_node(struct hfi1_filedata *, u16, struct tid_rb_node *);
 
 static struct mmu_rb_ops tid_rb_ops = {
-	.compare = mmu_addr_cmp,
 	.insert = mmu_rb_insert,
 	.remove = mmu_rb_remove,
 	.invalidate = mmu_rb_invalidate
@@ -1016,17 +1013,6 @@ static int mmu_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
 	return 0;
 }
 
-static int mmu_addr_cmp(struct mmu_rb_node *node, unsigned long addr,
-			unsigned long len)
-{
-	if ((addr + len) <= node->addr)
-		return -1;
-	else if (addr >= node->addr && addr < (node->addr + node->len))
-		return 0;
-	else
-		return 1;
-}
-
 static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct hfi1_filedata *fdata =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
