From: jglisse@redhat.com
Subject: [PATCH 06/13] IB/hfi1: update to new mmu_notifier semantic
Date: Thu, 31 Aug 2017 17:17:31 -0400
Message-ID: <20170831211738.17922-7-jglisse@redhat.com>
References: <20170831211738.17922-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170831211738.17922-1-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linux-rdma@vger.kernel.org, Dean Luick <dean.luick@intel.com>, Ira Weiny <ira.weiny@intel.com>, Doug Ledford <dledford@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>
List-Id: linux-rdma@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

Call to mmu_notifier_invalidate_page() are replaced by call to
mmu_notifier_invalidate_range() and thus call are bracketed by
call to mmu_notifier_invalidate_range_start()/end()

Remove now useless invalidate_page callback.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: Dean Luick <dean.luick@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index ccbf52c8ff6f..e4b56a0dd6d0 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -67,8 +67,6 @@ struct mmu_rb_handler {
 
 static unsigned long mmu_node_start(struct mmu_rb_node *);
 static unsigned long mmu_node_last(struct mmu_rb_node *);
-static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
-				     unsigned long);
 static inline void mmu_notifier_range_start(struct mmu_notifier *,
 					    struct mm_struct *,
 					    unsigned long, unsigned long);
@@ -82,7 +80,6 @@ static void do_remove(struct mmu_rb_handler *handler,
 static void handle_remove(struct work_struct *work);
 
 static const struct mmu_notifier_ops mn_opts = {
-	.invalidate_page = mmu_notifier_page,
 	.invalidate_range_start = mmu_notifier_range_start,
 };
 
@@ -285,12 +282,6 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 	handler->ops->remove(handler->ops_arg, node);
 }
 
-static inline void mmu_notifier_page(struct mmu_notifier *mn,
-				     struct mm_struct *mm, unsigned long addr)
-{
-	mmu_notifier_mem_invalidate(mn, mm, addr, addr + PAGE_SIZE);
-}
-
 static inline void mmu_notifier_range_start(struct mmu_notifier *mn,
 					    struct mm_struct *mm,
 					    unsigned long start,
-- 
2.13.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
