From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/16] IB/hfi1: Re-factor MMU notification code
Date: Tue, 08 Mar 2016 11:14:20 -0800
Message-ID: <20160308191419.30542.46215.stgit@scvm10.sc.intel.com>
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

The MMU notification code added to the
expected receive side has been re-factored and
split into it's own file. This was done in
order to make the code more general and, therefore,
usable by other parts of the driver.

The caching behavior remains the same. However,
the handling of the RB tree (insertion, deletions,
and searching) as well as the MMU invalidation
processing is now handled by functions in the
mmu_rb.[ch] files.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Makefile       |    2 
 drivers/infiniband/hw/hfi1/file_ops.c     |    1 
 drivers/infiniband/hw/hfi1/hfi.h          |   14 +
 drivers/infiniband/hw/hfi1/mmu_rb.c       |  304 ++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/mmu_rb.h       |   73 ++++++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  336 +++++++----------------------
 6 files changed, 471 insertions(+), 259 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/mmu_rb.c
 create mode 100644 drivers/infiniband/hw/hfi1/mmu_rb.h

diff --git a/drivers/infiniband/hw/hfi1/Makefile b/drivers/infiniband/hw/hfi1/Makefile
index 9b11706..8dc5938 100644
--- a/drivers/infiniband/hw/hfi1/Makefile
+++ b/drivers/infiniband/hw/hfi1/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
 hfi1-y := affinity.o chip.o device.o diag.o driver.o efivar.o \
 	eprom.o file_ops.o firmware.o \
-	init.o intr.o mad.o pcie.o pio.o pio_copy.o platform.o \
+	init.o intr.o mad.o mmu_rb.o pcie.o pio.o pio_copy.o platform.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o \
 	verbs_txreq.o
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index e4490ae..e460261 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -58,6 +58,7 @@
 #include "user_exp_rcv.h"
 #include "eprom.h"
 #include "aspm.h"
+#include "mmu_rb.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 5722883..78c8e24 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1179,6 +1179,7 @@ struct hfi1_devdata {
 #define PT_EAGER    1
 #define PT_INVALID  2
 
+struct tid_rb_node;
 struct mmu_rb_node;
 
 /* Private data for file operations */
@@ -1189,20 +1190,17 @@ struct hfi1_filedata {
 	struct hfi1_user_sdma_pkt_q *pq;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
-	struct mmu_notifier mn;
 	struct rb_root tid_rb_root;
-	struct mmu_rb_node **entry_to_rb;
+	struct tid_rb_node **entry_to_rb;
 	spinlock_t tid_lock; /* protect tid_[limit,used] counters */
 	u32 tid_limit;
 	u32 tid_used;
-	spinlock_t rb_lock; /* protect tid_rb_root RB tree */
 	u32 *invalid_tids;
 	u32 invalid_tid_idx;
-	spinlock_t invalid_lock; /* protect the invalid_tids array */
-	int (*mmu_rb_insert)(struct hfi1_filedata *, struct rb_root *,
-			     struct mmu_rb_node *);
-	void (*mmu_rb_remove)(struct hfi1_filedata *, struct rb_root *,
-			      struct mmu_rb_node *);
+	/* protect invalid_tids array and invalid_tid_idx */
+	spinlock_t invalid_lock;
+	int (*mmu_rb_insert)(struct rb_root *, struct mmu_rb_node *);
+	void (*mmu_rb_remove)(struct rb_root *, struct mmu_rb_node *);
 };
 
 extern struct list_head hfi1_dev_list;
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
new file mode 100644
index 0000000..779ebaf
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -0,0 +1,304 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+#include <linux/list.h>
+#include <linux/mmu_notifier.h>
+#include <linux/rbtree.h>
+
+#include "mmu_rb.h"
+#include "trace.h"
+
+struct mmu_rb_handler {
+	struct list_head list;
+	struct mmu_notifier mn;
+	struct rb_root *root;
+	spinlock_t lock;        /* protect the RB tree */
+	struct mmu_rb_ops *ops;
+};
+
+static LIST_HEAD(mmu_rb_handlers);
+static DEFINE_SPINLOCK(mmu_rb_lock); /* protect mmu_rb_handlers list */
+
+static struct mmu_rb_handler *find_mmu_handler(struct rb_root *);
+static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
+				     unsigned long);
+static inline void mmu_notifier_range_start(struct mmu_notifier *,
+					    struct mm_struct *,
+					    unsigned long, unsigned long);
+static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
+					unsigned long, unsigned long);
+static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *,
+					   unsigned long, unsigned long);
+
+static struct mmu_notifier_ops mn_opts = {
+	.invalidate_page = mmu_notifier_page,
+	.invalidate_range_start = mmu_notifier_range_start,
+};
+
+int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
+{
+	struct mmu_rb_handler *handlr;
+
+	if (!ops->compare || !ops->invalidate)
+		return -EINVAL;
+
+	handlr = kmalloc(sizeof(*handlr), GFP_KERNEL);
+	if (!handlr)
+		return -ENOMEM;
+
+	handlr->root = root;
+	handlr->ops = ops;
+	INIT_HLIST_NODE(&handlr->mn.hlist);
+	spin_lock_init(&handlr->lock);
+	handlr->mn.ops = &mn_opts;
+	spin_lock(&mmu_rb_lock);
+	list_add_tail(&handlr->list, &mmu_rb_handlers);
+	spin_unlock(&mmu_rb_lock);
+
+	return mmu_notifier_register(&handlr->mn, current->mm);
+}
+
+void hfi1_mmu_rb_unregister(struct rb_root *root)
+{
+	struct mmu_rb_handler *handler = find_mmu_handler(root);
+
+	spin_lock(&mmu_rb_lock);
+	list_del(&handler->list);
+	spin_unlock(&mmu_rb_lock);
+
+	if (!RB_EMPTY_ROOT(root)) {
+		struct rb_node *node;
+		struct mmu_rb_node *rbnode;
+
+		while ((node = rb_first(root))) {
+			rbnode = rb_entry(node, struct mmu_rb_node, node);
+			if (handler->ops->remove)
+				handler->ops->remove(root, rbnode);
+			rb_erase(node, root);
+			kfree(rbnode);
+		}
+	}
+
+	if (current->mm)
+		mmu_notifier_unregister(&handler->mn, current->mm);
+	kfree(handler);
+}
+
+int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
+{
+	struct rb_node **new, *parent = NULL;
+	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	struct mmu_rb_node *this;
+	int res, ret = 0;
+
+	if (!handler)
+		return -EINVAL;
+
+	new = &handler->root->rb_node;
+	spin_lock(&handler->lock);
+	while (*new) {
+		this = container_of(*new, struct mmu_rb_node, node);
+		res = handler->ops->compare(this, mnode->addr, mnode->len);
+		parent = *new;
+
+		if (res < 0) {
+			new = &((*new)->rb_left);
+		} else if (res > 0) {
+			new = &((*new)->rb_right);
+		} else {
+			ret = 1;
+			goto unlock;
+		}
+	}
+
+	if (handler->ops->insert) {
+		ret = handler->ops->insert(root, mnode);
+		if (ret)
+			goto unlock;
+	}
+
+	rb_link_node(&mnode->node, parent, new);
+	rb_insert_color(&mnode->node, root);
+unlock:
+	spin_unlock(&handler->lock);
+	return ret;
+}
+
+/* Caller must host handler lock */
+static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
+					   unsigned long addr,
+					   unsigned long len)
+{
+	struct rb_node *node = handler->root->rb_node;
+	struct mmu_rb_node *mnode;
+	int res;
+
+	while (node) {
+		mnode = container_of(node, struct mmu_rb_node, node);
+		res = handler->ops->compare(mnode, addr, len);
+
+		if (res < 0)
+			node = node->rb_left;
+		else if (res > 0)
+			node = node->rb_right;
+		else
+			return mnode;
+	}
+	return NULL;
+}
+
+static void __mmu_rb_remove(struct mmu_rb_handler *handler,
+			    struct mmu_rb_node *node)
+{
+	/* Validity of handler and node pointers has been checked by caller. */
+	if (handler->ops->remove)
+		handler->ops->remove(handler->root, node);
+	rb_erase(&node->node, handler->root);
+}
+
+struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
+				       unsigned long len)
+{
+	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	struct mmu_rb_node *node;
+
+	if (!handler)
+		return ERR_PTR(-EINVAL);
+
+	spin_lock(&handler->lock);
+	node = __mmu_rb_search(handler, addr, len);
+	spin_unlock(&handler->lock);
+
+	return node;
+}
+
+void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
+{
+	struct mmu_rb_handler *handler = find_mmu_handler(root);
+
+	if (!handler || !node)
+		return;
+
+	spin_lock(&handler->lock);
+	__mmu_rb_remove(handler, node);
+	spin_unlock(&handler->lock);
+}
+
+static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
+{
+	struct mmu_rb_handler *handler;
+
+	spin_lock(&mmu_rb_lock);
+	list_for_each_entry(handler, &mmu_rb_handlers, list) {
+		if (handler->root == root)
+			goto unlock;
+	}
+	handler = NULL;
+unlock:
+	spin_unlock(&mmu_rb_lock);
+	return handler;
+}
+
+static inline void mmu_notifier_page(struct mmu_notifier *mn,
+				     struct mm_struct *mm, unsigned long addr)
+{
+	mmu_notifier_mem_invalidate(mn, addr, addr + PAGE_SIZE);
+}
+
+static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
+					    struct mm_struct *mm,
+					    unsigned long start,
+					    unsigned long end)
+{
+	mmu_notifier_mem_invalidate(mn, start, end);
+}
+
+static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
+					unsigned long start, unsigned long end)
+{
+	struct mmu_rb_handler *handler =
+		container_of(mn, struct mmu_rb_handler, mn);
+	struct rb_root *root = handler->root;
+	struct mmu_rb_node *node;
+	unsigned long addr = start;
+
+	spin_lock(&handler->lock);
+	while (addr < end) {
+		/*
+		 * There is no good way to provide a reasonable length to the
+		 * search function at this point. Using the remaining length in
+		 * the invalidation range is not the right thing to do.
+		 * We have to rely on the fact that the insertion algorithm
+		 * takes care of any overlap or length restrictions by using the
+		 * actual size of each node. Therefore, we can use a page as an
+		 * arbitrary, non-zero value.
+		 */
+		node = __mmu_rb_search(handler, addr, PAGE_SIZE);
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
+		if (handler->ops->invalidate(root, node))
+			__mmu_rb_remove(handler, node);
+
+		/*
+		 * The next address to be looked up is computed based
+		 * on the node's starting address. This is due to the
+		 * fact that the range where we start might be in the
+		 * middle of the node's buffer so simply incrementing
+		 * the address by the node's size would result is a
+		 * bad address.
+		 */
+		addr = node->addr + node->len;
+	}
+	spin_unlock(&handler->lock);
+}
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
new file mode 100644
index 0000000..9fe1076
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
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
+#ifndef _HFI1_MMU_RB_H
+#define _HFI1_MMU_RB_H
+
+#include "hfi.h"
+
+struct mmu_rb_node {
+	struct rb_node node;
+	unsigned long addr;
+	unsigned long len;
+};
+
+struct mmu_rb_ops {
+	int (*compare)(struct mmu_rb_node *, unsigned long,
+		       unsigned long);
+	int (*insert)(struct rb_root *, struct mmu_rb_node *);
+	void (*remove)(struct rb_root *, struct mmu_rb_node *);
+	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);
+};
+
+int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops);
+void hfi1_mmu_rb_unregister(struct rb_root *);
+int hfi1_mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
+void hfi1_mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
+struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *, unsigned long,
+				       unsigned long);
+
+#endif /* _HFI1_MMU_RB_H */
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index fccae50..c9e05dd 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -48,6 +48,7 @@
 
 #include "user_exp_rcv.h"
 #include "trace.h"
+#include "mmu_rb.h"
 
 struct tid_group {
 	struct list_head list;
@@ -57,11 +58,9 @@ struct tid_group {
 	u8 map;
 };
 
-struct mmu_rb_node {
-	struct rb_node rbnode;
-	unsigned long virt;
+struct tid_rb_node {
+	struct mmu_rb_node mmu;
 	unsigned long phys;
-	unsigned long len;
 	struct tid_group *grp;
 	u32 rcventry;
 	dma_addr_t dma_addr;
@@ -70,16 +69,6 @@ struct mmu_rb_node {
 	struct page *pages[0];
 };
 
-enum mmu_call_types {
-	MMU_INVALIDATE_PAGE = 0,
-	MMU_INVALIDATE_RANGE = 1
-};
-
-static const char * const mmu_types[] = {
-	"PAGE",
-	"RANGE"
-};
-
 struct tid_pageset {
 	u16 idx;
 	u16 count;
@@ -99,28 +88,21 @@ static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
-static struct mmu_rb_node *mmu_rb_search(struct rb_root *, unsigned long);
-static int mmu_rb_insert_by_addr(struct hfi1_filedata *, struct rb_root *,
-				 struct mmu_rb_node *);
-static int mmu_rb_insert_by_entry(struct hfi1_filedata *, struct rb_root *,
-				  struct mmu_rb_node *);
-static void mmu_rb_remove_by_addr(struct hfi1_filedata *, struct rb_root *,
-				  struct mmu_rb_node *);
-static void mmu_rb_remove_by_entry(struct hfi1_filedata *, struct rb_root *,
-				   struct mmu_rb_node *);
-static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
-					unsigned long, unsigned long,
-					enum mmu_call_types);
-static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
-				     unsigned long);
-static inline void mmu_notifier_range_start(struct mmu_notifier *,
-					    struct mm_struct *,
-					    unsigned long, unsigned long);
+static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
+static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
+static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *);
 static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
-static void clear_tid_node(struct hfi1_filedata *, u16, struct mmu_rb_node *);
+static void clear_tid_node(struct hfi1_filedata *, u16, struct tid_rb_node *);
+
+static struct mmu_rb_ops tid_rb_ops = {
+	.compare = mmu_addr_cmp,
+	.insert = mmu_rb_insert,
+	.remove = mmu_rb_remove,
+	.invalidate = mmu_rb_invalidate
+};
 
 static inline u32 rcventry2tidinfo(u32 rcventry)
 {
@@ -167,11 +149,6 @@ static inline void tid_group_move(struct tid_group *group,
 	tid_group_add_tail(group, s2);
 }
 
-static struct mmu_notifier_ops mn_opts = {
-	.invalidate_page = mmu_notifier_page,
-	.invalidate_range_start = mmu_notifier_range_start,
-};
-
 /*
  * Initialize context and file private data needed for Expected
  * receive caching. This needs to be done after the context has
@@ -185,11 +162,8 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	unsigned tidbase;
 	int i, ret = 0;
 
-	INIT_HLIST_NODE(&fd->mn.hlist);
-	spin_lock_init(&fd->rb_lock);
 	spin_lock_init(&fd->tid_lock);
 	spin_lock_init(&fd->invalid_lock);
-	fd->mn.ops = &mn_opts;
 	fd->tid_rb_root = RB_ROOT;
 
 	if (!uctxt->subctxt_cnt || !fd->subctxt) {
@@ -239,7 +213,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		 * fails, continue but turn off the TID caching for
 		 * all user contexts.
 		 */
-		ret = mmu_notifier_register(&fd->mn, current->mm);
+		ret = hfi1_mmu_rb_register(&fd->tid_rb_root, &tid_rb_ops);
 		if (ret) {
 			dd_dev_info(dd,
 				    "Failed MMU notifier registration %d\n",
@@ -250,11 +224,11 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	}
 
 	if (HFI1_CAP_IS_USET(TID_UNMAP)) {
-		fd->mmu_rb_insert = mmu_rb_insert_by_entry;
-		fd->mmu_rb_remove = mmu_rb_remove_by_entry;
+		fd->mmu_rb_insert = mmu_rb_insert;
+		fd->mmu_rb_remove = mmu_rb_remove;
 	} else {
-		fd->mmu_rb_insert = mmu_rb_insert_by_addr;
-		fd->mmu_rb_remove = mmu_rb_remove_by_addr;
+		fd->mmu_rb_insert = hfi1_mmu_rb_insert;
+		fd->mmu_rb_remove = hfi1_mmu_rb_remove;
 	}
 
 	/*
@@ -295,8 +269,8 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 	 * The notifier would have been removed when the process'es mm
 	 * was freed.
 	 */
-	if (current->mm && !HFI1_CAP_IS_USET(TID_UNMAP))
-		mmu_notifier_unregister(&fd->mn, current->mm);
+	if (!HFI1_CAP_IS_USET(TID_UNMAP))
+		hfi1_mmu_rb_unregister(&fd->tid_rb_root);
 
 	kfree(fd->invalid_tids);
 
@@ -312,19 +286,6 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 			list_del_init(&grp->list);
 			kfree(grp);
 		}
-		spin_lock(&fd->rb_lock);
-		if (!RB_EMPTY_ROOT(&fd->tid_rb_root)) {
-			struct rb_node *node;
-			struct mmu_rb_node *rbnode;
-
-			while ((node = rb_first(&fd->tid_rb_root))) {
-				rbnode = rb_entry(node, struct mmu_rb_node,
-						  rbnode);
-				rb_erase(&rbnode->rbnode, &fd->tid_rb_root);
-				kfree(rbnode);
-			}
-		}
-		spin_unlock(&fd->rb_lock);
 		hfi1_clear_tids(uctxt);
 	}
 
@@ -866,7 +827,7 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	int ret;
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct mmu_rb_node *node;
+	struct tid_rb_node *node;
 	struct hfi1_devdata *dd = uctxt->dd;
 	struct rb_root *root = &fd->tid_rb_root;
 	dma_addr_t phys;
@@ -890,9 +851,9 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 		return -EFAULT;
 	}
 
-	node->virt = vaddr;
+	node->mmu.addr = vaddr;
+	node->mmu.len = npages * PAGE_SIZE;
 	node->phys = page_to_phys(pages[0]);
-	node->len = npages * PAGE_SIZE;
 	node->npages = npages;
 	node->rcventry = rcventry;
 	node->dma_addr = phys;
@@ -900,21 +861,19 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	node->freed = false;
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
-	spin_lock(&fd->rb_lock);
-	ret = fd->mmu_rb_insert(fd, root, node);
-	spin_unlock(&fd->rb_lock);
+	ret = fd->mmu_rb_insert(root, &node->mmu);
 
 	if (ret) {
 		hfi1_cdbg(TID, "Failed to insert RB node %u 0x%lx, 0x%lx %d",
-			  node->rcventry, node->virt, node->phys, ret);
+			  node->rcventry, node->mmu.addr, node->phys, ret);
 		pci_unmap_single(dd->pcidev, phys, npages * PAGE_SIZE,
 				 PCI_DMA_FROMDEVICE);
 		kfree(node);
 		return -EFAULT;
 	}
 	hfi1_put_tid(dd, rcventry, PT_EXPECTED, phys, ilog2(npages) + 1);
-	trace_hfi1_exp_tid_reg(uctxt->ctxt, fd->subctxt, rcventry,
-			       npages, node->virt, node->phys, phys);
+	trace_hfi1_exp_tid_reg(uctxt->ctxt, fd->subctxt, rcventry, npages,
+			       node->mmu.addr, node->phys, phys);
 	return 0;
 }
 
@@ -924,7 +883,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	struct mmu_rb_node *node;
+	struct tid_rb_node *node;
 	u8 tidctrl = EXP_TID_GET(tidinfo, CTRL);
 	u32 tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
 
@@ -939,14 +898,11 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 
 	rcventry = tididx + (tidctrl - 1);
 
-	spin_lock(&fd->rb_lock);
 	node = fd->entry_to_rb[rcventry];
-	if (!node || node->rcventry != (uctxt->expected_base + rcventry)) {
-		spin_unlock(&fd->rb_lock);
+	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
-	}
-	fd->mmu_rb_remove(fd, &fd->tid_rb_root, node);
-	spin_unlock(&fd->rb_lock);
+	fd->mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
+
 	if (grp)
 		*grp = node->grp;
 	clear_tid_node(fd, fd->subctxt, node);
@@ -954,13 +910,13 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 }
 
 static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
-			   struct mmu_rb_node *node)
+			   struct tid_rb_node *node)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 
 	trace_hfi1_exp_tid_unreg(uctxt->ctxt, fd->subctxt, node->rcventry,
-				 node->npages, node->virt, node->phys,
+				 node->npages, node->mmu.addr, node->phys,
 				 node->dma_addr);
 
 	hfi1_put_tid(dd, node->rcventry, PT_INVALID, 0, 0);
@@ -970,7 +926,7 @@ static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
 	 */
 	flush_wc();
 
-	pci_unmap_single(dd->pcidev, node->dma_addr, node->len,
+	pci_unmap_single(dd->pcidev, node->dma_addr, node->mmu.len,
 			 PCI_DMA_FROMDEVICE);
 	hfi1_release_user_pages(node->pages, node->npages, true);
 
@@ -997,216 +953,96 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 	list_for_each_entry_safe(grp, ptr, &set->list, list) {
 		list_del_init(&grp->list);
 
-		spin_lock(&fd->rb_lock);
 		for (i = 0; i < grp->size; i++) {
 			if (grp->map & (1 << i)) {
 				u16 rcventry = grp->base + i;
-				struct mmu_rb_node *node;
+				struct tid_rb_node *node;
 
 				node = fd->entry_to_rb[rcventry -
 							  uctxt->expected_base];
 				if (!node || node->rcventry != rcventry)
 					continue;
-				fd->mmu_rb_remove(fd, root, node);
+				fd->mmu_rb_remove(root, &node->mmu);
 				clear_tid_node(fd, -1, node);
 			}
 		}
-		spin_unlock(&fd->rb_lock);
 	}
 }
 
-static inline void mmu_notifier_page(struct mmu_notifier *mn,
-				     struct mm_struct *mm, unsigned long addr)
-{
-	mmu_notifier_mem_invalidate(mn, addr, addr + PAGE_SIZE,
-				    MMU_INVALIDATE_PAGE);
-}
-
-static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
-					    struct mm_struct *mm,
-					    unsigned long start,
-					    unsigned long end)
+static int mmu_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
 {
-	mmu_notifier_mem_invalidate(mn, start, end, MMU_INVALIDATE_RANGE);
-}
+	struct hfi1_filedata *fdata =
+		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct hfi1_ctxtdata *uctxt = fdata->uctxt;
+	struct tid_rb_node *node =
+		container_of(mnode, struct tid_rb_node, mmu);
 
-static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
-					unsigned long start, unsigned long end,
-					enum mmu_call_types type)
-{
-	struct hfi1_filedata *fd = container_of(mn, struct hfi1_filedata, mn);
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct rb_root *root = &fd->tid_rb_root;
-	struct mmu_rb_node *node;
-	unsigned long addr = start;
+	if (node->freed)
+		return 0;
 
-	trace_hfi1_mmu_invalidate(uctxt->ctxt, fd->subctxt, mmu_types[type],
-				  start, end);
+	trace_hfi1_exp_tid_inval(uctxt->ctxt, fdata->subctxt, node->mmu.addr,
+				 node->rcventry, node->npages, node->dma_addr);
+	node->freed = true;
 
-	spin_lock(&fd->rb_lock);
-	while (addr < end) {
-		node = mmu_rb_search(root, addr);
+	spin_lock(&fdata->invalid_lock);
+	if (fdata->invalid_tid_idx < uctxt->expected_count) {
+		fdata->invalid_tids[fdata->invalid_tid_idx] =
+			rcventry2tidinfo(node->rcventry - uctxt->expected_base);
+		fdata->invalid_tids[fdata->invalid_tid_idx] |=
+			EXP_TID_SET(LEN, node->npages);
+		if (!fdata->invalid_tid_idx) {
+			unsigned long *ev;
 
-		if (!node) {
 			/*
-			 * Didn't find a node at this address. However, the
-			 * range could be bigger than what we have registered
-			 * so we have to keep looking.
+			 * hfi1_set_uevent_bits() sets a user event flag
+			 * for all processes. Because calling into the
+			 * driver to process TID cache invalidations is
+			 * expensive and TID cache invalidations are
+			 * handled on a per-process basis, we can
+			 * optimize this to set the flag only for the
+			 * process in question.
 			 */
-			addr += PAGE_SIZE;
-			continue;
-		}
-
-		/*
-		 * The next address to be looked up is computed based
-		 * on the node's starting address. This is due to the
-		 * fact that the range where we start might be in the
-		 * middle of the node's buffer so simply incrementing
-		 * the address by the node's size would result is a
-		 * bad address.
-		 */
-		addr = node->virt + (node->npages * PAGE_SIZE);
-		if (node->freed)
-			continue;
-
-		trace_hfi1_exp_tid_inval(uctxt->ctxt, fd->subctxt, node->virt,
-					 node->rcventry, node->npages,
-					 node->dma_addr);
-		node->freed = true;
-
-		spin_lock(&fd->invalid_lock);
-		if (fd->invalid_tid_idx < uctxt->expected_count) {
-			fd->invalid_tids[fd->invalid_tid_idx] =
-				rcventry2tidinfo(node->rcventry -
-						 uctxt->expected_base);
-			fd->invalid_tids[fd->invalid_tid_idx] |=
-				EXP_TID_SET(LEN, node->npages);
-			if (!fd->invalid_tid_idx) {
-				unsigned long *ev;
-
-				/*
-				 * hfi1_set_uevent_bits() sets a user event flag
-				 * for all processes. Because calling into the
-				 * driver to process TID cache invalidations is
-				 * expensive and TID cache invalidations are
-				 * handled on a per-process basis, we can
-				 * optimize this to set the flag only for the
-				 * process in question.
-				 */
-				ev = uctxt->dd->events +
-					(((uctxt->ctxt -
-					   uctxt->dd->first_user_ctxt) *
-					  HFI1_MAX_SHARED_CTXTS) + fd->subctxt);
-				set_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
-			}
-			fd->invalid_tid_idx++;
+			ev = uctxt->dd->events +
+				(((uctxt->ctxt - uctxt->dd->first_user_ctxt) *
+				  HFI1_MAX_SHARED_CTXTS) + fdata->subctxt);
+			set_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
 		}
-		spin_unlock(&fd->invalid_lock);
+		fdata->invalid_tid_idx++;
 	}
-	spin_unlock(&fd->rb_lock);
+	spin_unlock(&fdata->invalid_lock);
+	return 0;
 }
 
-static inline int mmu_addr_cmp(struct mmu_rb_node *node, unsigned long addr,
-			       unsigned long len)
+static int mmu_addr_cmp(struct mmu_rb_node *node, unsigned long addr,
+			unsigned long len)
 {
-	if ((addr + len) <= node->virt)
+	if ((addr + len) <= node->addr)
 		return -1;
-	else if (addr >= node->virt && addr < (node->virt + node->len))
+	else if (addr >= node->addr && addr < (node->addr + node->len))
 		return 0;
 	else
 		return 1;
 }
 
-static inline int mmu_entry_cmp(struct mmu_rb_node *node, u32 entry)
-{
-	if (entry < node->rcventry)
-		return -1;
-	else if (entry > node->rcventry)
-		return 1;
-	else
-		return 0;
-}
-
-static struct mmu_rb_node *mmu_rb_search(struct rb_root *root,
-					 unsigned long addr)
-{
-	struct rb_node *node = root->rb_node;
-
-	while (node) {
-		struct mmu_rb_node *mnode =
-			container_of(node, struct mmu_rb_node, rbnode);
-		/*
-		 * When searching, use at least one page length for size. The
-		 * MMU notifier will not give us anything less than that. We
-		 * also don't need anything more than a page because we are
-		 * guaranteed to have non-overlapping buffers in the tree.
-		 */
-		int result = mmu_addr_cmp(mnode, addr, PAGE_SIZE);
-
-		if (result < 0)
-			node = node->rb_left;
-		else if (result > 0)
-			node = node->rb_right;
-		else
-			return mnode;
-	}
-	return NULL;
-}
-
-static int mmu_rb_insert_by_entry(struct hfi1_filedata *fdata,
-				  struct rb_root *root,
-				  struct mmu_rb_node *node)
+static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 {
+	struct hfi1_filedata *fdata =
+		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct tid_rb_node *tnode =
+		container_of(node, struct tid_rb_node, mmu);
 	u32 base = fdata->uctxt->expected_base;
 
-	fdata->entry_to_rb[node->rcventry - base] = node;
+	fdata->entry_to_rb[tnode->rcventry - base] = tnode;
 	return 0;
 }
 
-static int mmu_rb_insert_by_addr(struct hfi1_filedata *fdata,
-				 struct rb_root *root, struct mmu_rb_node *node)
-{
-	struct rb_node **new = &root->rb_node, *parent = NULL;
-	u32 base = fdata->uctxt->expected_base;
-
-	/* Figure out where to put new node */
-	while (*new) {
-		struct mmu_rb_node *this =
-			container_of(*new, struct mmu_rb_node, rbnode);
-		int result = mmu_addr_cmp(this, node->virt, node->len);
-
-		parent = *new;
-		if (result < 0)
-			new = &((*new)->rb_left);
-		else if (result > 0)
-			new = &((*new)->rb_right);
-		else
-			return 1;
-	}
-
-	/* Add new node and rebalance tree. */
-	rb_link_node(&node->rbnode, parent, new);
-	rb_insert_color(&node->rbnode, root);
-
-	fdata->entry_to_rb[node->rcventry - base] = node;
-	return 0;
-}
-
-static void mmu_rb_remove_by_entry(struct hfi1_filedata *fdata,
-				   struct rb_root *root,
-				   struct mmu_rb_node *node)
-{
-	u32 base = fdata->uctxt->expected_base;
-
-	fdata->entry_to_rb[node->rcventry - base] = NULL;
-}
-
-static void mmu_rb_remove_by_addr(struct hfi1_filedata *fdata,
-				  struct rb_root *root,
-				  struct mmu_rb_node *node)
+static void mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 {
+	struct hfi1_filedata *fdata =
+		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct tid_rb_node *tnode =
+		container_of(node, struct tid_rb_node, mmu);
 	u32 base = fdata->uctxt->expected_base;
 
-	fdata->entry_to_rb[node->rcventry - base] = NULL;
-	rb_erase(&node->rbnode, root);
+	fdata->entry_to_rb[tnode->rcventry - base] = NULL;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
