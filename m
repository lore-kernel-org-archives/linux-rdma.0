From: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] IB/ehca: Reduce number of spin_lock/spin_unlocks in
 ehca_poll_eqs
Date: Fri, 27 Nov 2009 14:13:20 +1100
Message-ID: <20091127031320.GV32182@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joachim
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


ftrace function_graph shows ehca_poll_eqs taking and dropping a spinlock
a lot:

 16)               |          .ehca_poll_eqs() {
 16)   0.492 us    |            ._spin_lock();
 16)   0.504 us    |            ._spin_lock_irqsave();
 16)   0.502 us    |            ._spin_unlock_irqrestore();
 16)   0.490 us    |            ._spin_lock_irqsave();
 16)   0.488 us    |            ._spin_unlock_irqrestore();
 16)   0.488 us    |            ._spin_lock_irqsave();
 16)   0.488 us    |            ._spin_unlock_irqrestore();
 16)   0.490 us    |            ._spin_lock_irqsave();
 16)   0.492 us    |            ._spin_unlock_irqrestore();

Since it's all the same spinlock, we can just take and drop it once.

Signed-off-by: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---

Index: linux.trees.git/drivers/infiniband/hw/ehca/ehca_main.c
===================================================================
--- linux.trees.git.orig/drivers/infiniband/hw/ehca/ehca_main.c	2009-11-27 10:17:29.000000000 +1100
+++ linux.trees.git/drivers/infiniband/hw/ehca/ehca_main.c	2009-11-27 10:19:08.000000000 +1100
@@ -957,15 +957,17 @@ void ehca_poll_eqs(unsigned long data)
 			int max = 3;
 			volatile u64 q_ofs, q_ofs2;
 			unsigned long flags;
+
 			spin_lock_irqsave(&eq->spinlock, flags);
+
 			q_ofs = eq->ipz_queue.current_q_offset;
-			spin_unlock_irqrestore(&eq->spinlock, flags);
 			do {
-				spin_lock_irqsave(&eq->spinlock, flags);
 				q_ofs2 = eq->ipz_queue.current_q_offset;
-				spin_unlock_irqrestore(&eq->spinlock, flags);
 				max--;
 			} while (q_ofs == q_ofs2 && max > 0);
+
+			spin_unlock_irqrestore(&eq->spinlock, flags);
+
 			if (q_ofs == q_ofs2)
 				ehca_process_eq(shca, 0);
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
