From: ira.weiny@intel.com
Subject: [RESUBMIT PATCH v2 01/14] staging/rdma/hfi1: Add function stubs for
 TID caching
Date: Mon, 11 Jan 2016 12:56:37 -0500
Message-ID: <1452535010-14087-2-git-send-email-ira.weiny@intel.com>
References: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: dledford@redhat.com, linux-rdma@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, Mitko Haralanov <mitko.haralanov@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

Add mmu notify helper functions and TID caching function
stubs in preparation for the TID caching implementation.

TID caching makes use of the MMU notifier to allow the driver
to respond to the user freeing memory which is allocated to
the HFI.

This patch implements the basic MMU notifier functions to insert,
find and remove buffer pages from memory based on the mmu_notifier
being invoked.

In addition it places stubs in place for the main entry points by
follow on code.

Follow up patches will complete the implementation of the interaction
with user space and makes use of these functions.

Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/Kconfig        |   1 +
 drivers/staging/rdma/hfi1/Makefile       |   2 +-
 drivers/staging/rdma/hfi1/hfi.h          |   4 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 264 +++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h |   8 +
 5 files changed, 278 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index fd25078ee923..bd0249bcf199 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
 	depends on X86_64
+	select MMU_NOTIFIER
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.
diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 68c5a315e557..e63251b9c56b 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 hfi1-y := chip.o cq.o device.o diag.o dma.o driver.o efivar.o eprom.o file_ops.o firmware.o \
 	init.o intr.o keys.o mad.o mmap.o mr.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
-	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
+	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
 
 CFLAGS_trace.o = -I$(src)
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index ee45a960752b..12760bb9e056 100644
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
@@ -1127,6 +1129,8 @@ struct hfi1_devdata {
 #define PT_EAGER    1
 #define PT_INVALID  2
 
+struct mmu_rb_node;
+
 /* Private data for file operations */
 struct hfi1_filedata {
 	struct hfi1_ctxtdata *uctxt;
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
new file mode 100644
index 000000000000..bafeddf67c8f
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -0,0 +1,264 @@
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
+static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
+			       unsigned long);
+static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
+						 unsigned long) __maybe_unused;
+static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *,
+							 u32);
+static int mmu_rb_insert_by_addr(struct rb_root *,
+				 struct mmu_rb_node *) __maybe_unused;
+static int mmu_rb_insert_by_entry(struct rb_root *,
+				  struct mmu_rb_node *) __maybe_unused;
+static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
+					unsigned long, unsigned long,
+					enum mmu_call_types);
+static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
+				     unsigned long);
+static inline void mmu_notifier_range_start(struct mmu_notifier *,
+					    struct mm_struct *,
+					    unsigned long, unsigned long);
+
+static struct mmu_notifier_ops __maybe_unused mn_opts = {
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
+	return -EINVAL;
+}
+
+int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
+{
+	return -EINVAL;
+}
+
+int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	return -EINVAL;
+}
+
+int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	return -EINVAL;
+}
+
+int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
+{
+	return -EINVAL;
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
+	/* Stub for now */
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
+	struct rb_node **new = &root->rb_node, *parent = NULL;
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
+	struct rb_node **new = &root->rb_node, *parent = NULL;
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
index 4f4876e1d353..28ef98a45a1e 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.h
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.h
@@ -50,6 +50,8 @@
  *
  */
 
+#include "hfi.h"
+
 #define EXP_TID_TIDLEN_MASK   0x7FFULL
 #define EXP_TID_TIDLEN_SHIFT  0
 #define EXP_TID_TIDCTRL_MASK  0x3ULL
@@ -71,4 +73,10 @@
 		(tid) |= EXP_TID_SET(field, (value));			\
 	} while (0)
 
+int hfi1_user_exp_rcv_init(struct file *);
+int hfi1_user_exp_rcv_free(struct hfi1_filedata *);
+int hfi1_user_exp_rcv_setup(struct file *, struct hfi1_tid_info *);
+int hfi1_user_exp_rcv_clear(struct file *, struct hfi1_tid_info *);
+int hfi1_user_exp_rcv_invalid(struct file *, struct hfi1_tid_info *);
+
 #endif /* _HFI1_USER_EXP_RCV_H */
-- 
1.8.2
