From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/3] irq_poll: Fix irq_poll_sched()
Date: Thu, 31 Dec 2015 09:56:03 +0100
Message-ID: <5684EDA3.60802@sandisk.com>
References: <5684ED4B.2010303@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5684ED4B.2010303-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The IRQ_POLL_F_SCHED bit is set as long as polling is ongoing.
This means that irq_poll_sched() must proceed if this bit has
not yet been set.

Fixes: commit ea51190c0315 ("irq_poll: fold irq_poll_sched_prep into irq_poll_sched").
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 lib/irq_poll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 2836620..836f7db 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -29,7 +29,7 @@ void irq_poll_sched(struct irq_poll *iop)
 
 	if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
 		return;
-	if (!test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
+	if (test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
 		return;
 
 	local_irq_save(flags);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
