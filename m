From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] ib/ehca: init irq tasklet before irq can happen
Date: Mon, 5 Jul 2010 13:41:56 +0200
Message-ID: <20100705134156.36803536@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize tasklet before interrupts are requested to prevent scheduling of
uninitialized tasklet.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
Hi Roland, please queue this fix for 2.6.36, thanks!

 drivers/infiniband/hw/ehca/ehca_eq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_eq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -122,21 +122,21 @@ int ehca_create_eq(struct ehca_shca *shc
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
+		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
+
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
+		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
+
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
-
-		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
 	}
 
 	eq->is_initialized = 1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
