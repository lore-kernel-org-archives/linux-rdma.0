From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/12] IB/hfi1: Fix deadlock caused by locking with wrong
 scope
Date: Tue, 12 Apr 2016 10:46:03 -0700
Message-ID: <20160412174602.19295.28126.stgit@scvm10.sc.intel.com>
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

The locking around the interval RB tree is designed to prevent
access to the tree while it's being modified. The locking in its
current form is too overzealous, which is causing a deadlock in
certain cases with the following backtrace:

    Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
    CPU: 0 PID: 5836 Comm: IMB-MPI1 Tainted: G           O 3.12.18-wfr+ #1
     0000000000000000 ffff88087f206c50 ffffffff814f1caa ffffffff817b53f0
     ffff88087f206cc8 ffffffff814ecd56 0000000000000010 ffff88087f206cd8
     ffff88087f206c78 0000000000000000 0000000000000000 0000000000001662
    Call Trace:
     <NMI>  [<ffffffff814f1caa>] dump_stack+0x45/0x56
     [<ffffffff814ecd56>] panic+0xc2/0x1cb
     [<ffffffff810d4370>] ? restart_watchdog_hrtimer+0x50/0x50
     [<ffffffff810d4432>] watchdog_overflow_callback+0xc2/0xd0
     [<ffffffff81109b4e>] __perf_event_overflow+0x8e/0x2b0
     [<ffffffff8110a714>] perf_event_overflow+0x14/0x20
     [<ffffffff8101c906>] intel_pmu_handle_irq+0x1b6/0x390
     [<ffffffff814f927b>] perf_event_nmi_handler+0x2b/0x50
     [<ffffffff814f8ad8>] nmi_handle.isra.3+0x88/0x180
     [<ffffffff814f8d39>] do_nmi+0x169/0x310
     [<ffffffff814f8177>] end_repeat_nmi+0x1e/0x2e
     [<ffffffff81272600>] ? unmap_single+0x30/0x30
     [<ffffffff814f780d>] ? _raw_spin_lock_irqsave+0x2d/0x40
     [<ffffffff814f780d>] ? _raw_spin_lock_irqsave+0x2d/0x40
     [<ffffffff814f780d>] ? _raw_spin_lock_irqsave+0x2d/0x40
     <<EOE>>  <IRQ>  [<ffffffffa056c4a8>] hfi1_mmu_rb_search+0x38/0x70 [hfi1]
     [<ffffffffa05919cb>] user_sdma_free_request+0xcb/0x120 [hfi1]
     [<ffffffffa0593393>] user_sdma_txreq_cb+0x263/0x350 [hfi1]
     [<ffffffffa057fad7>] ? sdma_txclean+0x27/0x1c0 [hfi1]
     [<ffffffffa0593130>] ? user_sdma_send_pkts+0x1710/0x1710 [hfi1]
     [<ffffffffa057fdd6>] sdma_make_progress+0x166/0x480 [hfi1]
     [<ffffffff810762c9>] ? ttwu_do_wakeup+0x19/0xd0
     [<ffffffffa0581c7e>] sdma_engine_interrupt+0x8e/0x100 [hfi1]
     [<ffffffffa0546bdd>] sdma_interrupt+0x5d/0xa0 [hfi1]
     [<ffffffff81097e57>] handle_irq_event_percpu+0x47/0x1d0
     [<ffffffff81098017>] handle_irq_event+0x37/0x60
     [<ffffffff8109aa5f>] handle_edge_irq+0x6f/0x120
     [<ffffffff810044af>] handle_irq+0xbf/0x150
     [<ffffffff8104c9b7>] ? irq_enter+0x17/0x80
     [<ffffffff8150168d>] do_IRQ+0x4d/0xc0
     [<ffffffff814f7c6a>] common_interrupt+0x6a/0x6a
     <EOI>  [<ffffffff81073524>] ? finish_task_switch+0x54/0xe0
     [<ffffffff814f56c6>] __schedule+0x3b6/0x7e0
     [<ffffffff810763a6>] __cond_resched+0x26/0x30
     [<ffffffff814f5eda>] _cond_resched+0x3a/0x50
     [<ffffffff814f4f82>] down_write+0x12/0x30
     [<ffffffffa0591619>] hfi1_release_user_pages+0x69/0x90 [hfi1]
     [<ffffffffa059173a>] sdma_rb_remove+0x9a/0xc0 [hfi1]
     [<ffffffffa056c00d>] __mmu_rb_remove.isra.5+0x5d/0x70 [hfi1]
     [<ffffffffa056c536>] hfi1_mmu_rb_remove+0x56/0x70 [hfi1]
     [<ffffffffa059427b>] hfi1_user_sdma_process_request+0x74b/0x1160 [hfi1]
     [<ffffffffa055c763>] hfi1_aio_write+0xc3/0x100 [hfi1]
     [<ffffffff8116a14c>] do_sync_readv_writev+0x4c/0x80
     [<ffffffff8116b58b>] do_readv_writev+0xbb/0x230
     [<ffffffff811a9da1>] ? fsnotify+0x241/0x320
     [<ffffffff81073524>] ? finish_task_switch+0x54/0xe0
     [<ffffffff8116b795>] vfs_writev+0x35/0x60
     [<ffffffff8116b8c9>] SyS_writev+0x49/0xc0
     [<ffffffff810cd876>] ? __audit_syscall_exit+0x1f6/0x2a0
     [<ffffffff814ff992>] system_call_fastpath+0x16/0x1b

As evident from the backtrace above, the process was being put to sleep
while holding the lock.

Limiting the scope of the lock only to the RB tree operation fixes the
above error allowing for proper locking and the process being put to
sleep when needed.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index eac4d04..b3f0682 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -177,7 +177,7 @@ unlock:
 	return ret;
 }
 
-/* Caller must host handler lock */
+/* Caller must hold handler lock */
 static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 					   unsigned long addr,
 					   unsigned long len)
@@ -201,13 +201,19 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 	return node;
 }
 
+/* Caller must *not* hold handler lock. */
 static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 			    struct mmu_rb_node *node, struct mm_struct *mm)
 {
+	unsigned long flags;
+
 	/* Validity of handler and node pointers has been checked by caller. */
 	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
 		  node->len);
+	spin_lock_irqsave(&handler->lock, flags);
 	__mmu_int_rb_remove(node, handler->root);
+	spin_unlock_irqrestore(&handler->lock, flags);
+
 	if (handler->ops->remove)
 		handler->ops->remove(handler->root, node, mm);
 }
@@ -232,14 +238,11 @@ struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
 void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
-	unsigned long flags;
 
 	if (!handler || !node)
 		return;
 
-	spin_lock_irqsave(&handler->lock, flags);
 	__mmu_rb_remove(handler, node, NULL);
-	spin_unlock_irqrestore(&handler->lock, flags);
 }
 
 static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
@@ -289,8 +292,11 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		ptr = __mmu_int_rb_iter_next(node, start, end - 1);
 		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
 			  node->addr, node->len);
-		if (handler->ops->invalidate(root, node))
+		if (handler->ops->invalidate(root, node)) {
+			spin_unlock_irqrestore(&handler->lock, flags);
 			__mmu_rb_remove(handler, node, mm);
+			spin_lock_irqsave(&handler->lock, flags);
+		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
