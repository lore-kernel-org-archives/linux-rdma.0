From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 1/2] ib/ehca: Do not turn off irqs in tasklet context
Date: Wed, 27 Jan 2010 18:01:56 +0100
Message-ID: <20100127180156.795056a5@alex-laptop>
References: <20100127180035.779b24d1@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100127180035.779b24d1@alex-laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Wilder <wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The irq_spinlock is only taken in tasklet context, so it is safe not to
disable hardware interrupts.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -548,11 +548,10 @@ void ehca_process_eq(struct ehca_shca *s
 	struct ehca_eq *eq = &shca->eq;
 	struct ehca_eqe_cache_entry *eqe_cache = eq->eqe_cache;
 	u64 eqe_value, ret;
-	unsigned long flags;
 	int eqe_cnt, i;
 	int eq_empty = 0;
 
-	spin_lock_irqsave(&eq->irq_spinlock, flags);
+	spin_lock(&eq->irq_spinlock);
 	if (is_irq) {
 		const int max_query_cnt = 100;
 		int query_cnt = 0;
@@ -643,7 +642,7 @@ void ehca_process_eq(struct ehca_shca *s
 	} while (1);
 
 unlock_irq_spinlock:
-	spin_unlock_irqrestore(&eq->irq_spinlock, flags);
+	spin_unlock(&eq->irq_spinlock);
 }
 
 void ehca_tasklet_eq(unsigned long data)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
