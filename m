From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/12] IB/hfi1: Protect the interval RB tree when cleaning up
Date: Tue, 12 Apr 2016 10:46:35 -0700
Message-ID: <20160412174634.19295.587.stgit@scvm10.sc.intel.com>
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

The current implementation of the clean up function for
the interval RB trees has two flaws which may cause
problems in cases of concurrent executing of the function
and MMU notifier.

The flaws were due to the fact that deregistration of the
MMU callbacks was done after the tree was emptied and,
furthermore, the tree was not being locked.

This commit fixes both of these flaws by, first, switch the
order of operations, and, second, locking the tree while
traversing it to prevent any other operations.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index b3f0682..72b6d70 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -126,10 +126,15 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 	if (!handler)
 		return;
 
+	/* Unregister first so we don't get any more notifications. */
+	if (current->mm)
+		mmu_notifier_unregister(&handler->mn, current->mm);
+
 	spin_lock_irqsave(&mmu_rb_lock, flags);
 	list_del(&handler->list);
 	spin_unlock_irqrestore(&mmu_rb_lock, flags);
 
+	spin_lock_irqsave(&handler->lock, flags);
 	if (!RB_EMPTY_ROOT(root)) {
 		struct rb_node *node;
 		struct mmu_rb_node *rbnode;
@@ -141,9 +146,8 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 				handler->ops->remove(root, rbnode, NULL);
 		}
 	}
+	spin_unlock_irqrestore(&handler->lock, flags);
 
-	if (current->mm)
-		mmu_notifier_unregister(&handler->mn, current->mm);
 	kfree(handler);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
