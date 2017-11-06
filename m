From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 03/11] IB/hfi1: Remove wrapper function in mmu_rb
Date: Mon, 06 Nov 2017 06:38:30 -0800
Message-ID: <20171106143828.27539.31875.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Wrapper functions were used to call the same function
mmu_notifier_mem_invalidate for 2 callbacks in
mmu_notifier.
The commit 7def96f0a973 ("IB/hfi1: update to new mmu_notifier semantic")
removed the invalidate_page callback.
Therefore, the wrapper function is no longer needed.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 175002c..e7b3ce1 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -67,12 +67,9 @@ struct mmu_rb_handler {
 
 static unsigned long mmu_node_start(struct mmu_rb_node *);
 static unsigned long mmu_node_last(struct mmu_rb_node *);
-static inline void mmu_notifier_range_start(struct mmu_notifier *,
-					    struct mm_struct *,
-					    unsigned long, unsigned long);
-static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
-					struct mm_struct *,
-					unsigned long, unsigned long);
+static void mmu_notifier_range_start(struct mmu_notifier *,
+				     struct mm_struct *,
+				     unsigned long, unsigned long);
 static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *,
 					   unsigned long, unsigned long);
 static void do_remove(struct mmu_rb_handler *handler,
@@ -286,17 +283,10 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 	handler->ops->remove(handler->ops_arg, node);
 }
 
-static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
-					    struct mm_struct *mm,
-					    unsigned long start,
-					    unsigned long end)
-{
-	mmu_notifier_mem_invalidate(mn, mm, start, end);
-}
-
-static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
-					struct mm_struct *mm,
-					unsigned long start, unsigned long end)
+static void mmu_notifier_range_start(struct mmu_notifier *mn,
+				     struct mm_struct *mm,
+				     unsigned long start,
+				     unsigned long end)
 {
 	struct mmu_rb_handler *handler =
 		container_of(mn, struct mmu_rb_handler, mn);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
