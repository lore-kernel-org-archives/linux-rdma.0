From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH RESEND] IB/device: Convert ib-comp-wq to be CPU-bound
Date: Wed,  8 Mar 2017 22:03:17 +0200
Message-ID: <1489003397-2321-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This workqueue is used by our storage target mode ULPs
via the new CQ API. Recent observations when working
with very high-end flash storage devices reveal that
UNBOUND workqueue threads can migrate between cpu cores
and even numa nodes (although some numa locality is accounted
for).

While this attribute can be useful in some workloads,
it does not fit in very nicely with the normal
run-to-completion model we usually use in our target-mode
ULPs and the block-mq irq<->cpu affinity facilities.

The whole block-mq concept is that the completion will
land on the same cpu where the submission was performed.
The fact that our submitter thread is migrating cpus
can break this locality.

We assume that as a target mode ULP, we will serve multiple
initiators/clients and we can spread the load enough without
having to use unbound kworkers.

Also, while we're at it, expose this workqueue via sysfs which
is harmless and can be useful for debug.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 593d2ce6ec7c..fb5ae9564e80 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1015,8 +1015,7 @@ static int __init ib_core_init(void)
 		return -ENOMEM;
 
 	ib_comp_wq = alloc_workqueue("ib-comp-wq",
-			WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
-			WQ_UNBOUND_MAX_ACTIVE);
+			WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
 	if (!ib_comp_wq) {
 		ret = -ENOMEM;
 		goto err;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
