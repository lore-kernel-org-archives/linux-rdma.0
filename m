From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/16] IB/hfi1: Add MMU tracing
Date: Tue, 08 Mar 2016 11:14:59 -0800
Message-ID: <20160308191458.30542.7214.stgit@scvm10.sc.intel.com>
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

Add a new tracepoint type for the MMU functions and calls
to that tracepoint to allow tracing of MMU functionality.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |   10 ++++++++++
 drivers/infiniband/hw/hfi1/trace.c  |    1 +
 drivers/infiniband/hw/hfi1/trace.h  |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 540e267..c30373d 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -157,6 +157,8 @@ int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 		return -EINVAL;
 
 	spin_lock_irqsave(&handler->lock, flags);
+	hfi1_cdbg(MMU, "Inserting node addr 0x%llx, len %u", mnode->addr,
+		  mnode->len);
 	node = __mmu_rb_search(handler, mnode->addr, mnode->len);
 	if (node) {
 		ret = -EINVAL;
@@ -181,7 +183,11 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 {
 	struct mmu_rb_node *node;
 
+	hfi1_cdbg(MMU, "Searching for addr 0x%llx, len %u", addr, len);
 	node = __mmu_int_rb_iter_first(handler->root, addr, len);
+	if (node)
+		hfi1_cdbg(MMU, "Found node addr 0x%llx, len %u", node->addr,
+			  node->len);
 	return node;
 }
 
@@ -189,6 +195,8 @@ static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 			    struct mmu_rb_node *node, bool arg)
 {
 	/* Validity of handler and node pointers has been checked by caller. */
+	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
+		  node->len);
 	__mmu_int_rb_remove(node, handler->root);
 	if (handler->ops->remove)
 		handler->ops->remove(handler->root, node, arg);
@@ -266,6 +274,8 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 	spin_lock_irqsave(&handler->lock, flags);
 	for (node = __mmu_int_rb_iter_first(root, start, end); node;
 	     node = __mmu_int_rb_iter_next(node, start, end)) {
+		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
+			  node->addr, node->len);
 		if (handler->ops->invalidate(root, node))
 			__mmu_rb_remove(handler, node, true);
 	}
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 6821d7c..8b62fef 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -232,3 +232,4 @@ __hfi1_trace_fn(DC8051);
 __hfi1_trace_fn(FIRMWARE);
 __hfi1_trace_fn(RCVCTRL);
 __hfi1_trace_fn(TID);
+__hfi1_trace_fn(MMU);
diff --git a/drivers/infiniband/hw/hfi1/trace.h b/drivers/infiniband/hw/hfi1/trace.h
index 4d91c18..963dc94 100644
--- a/drivers/infiniband/hw/hfi1/trace.h
+++ b/drivers/infiniband/hw/hfi1/trace.h
@@ -1340,6 +1340,7 @@ __hfi1_trace_def(DC8051);
 __hfi1_trace_def(FIRMWARE);
 __hfi1_trace_def(RCVCTRL);
 __hfi1_trace_def(TID);
+__hfi1_trace_def(MMU);
 
 #define hfi1_cdbg(which, fmt, ...) \
 	__hfi1_trace_##which(__func__, fmt, ##__VA_ARGS__)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
