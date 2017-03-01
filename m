From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 18:46:14 +0200
Message-ID: <5f8f11de-e659-dbd8-a105-a32d7c239e37@grimberg.me>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
 <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
 <0786659a-da12-e8f7-329e-3caa8cc8791f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0786659a-da12-e8f7-329e-3caa8cc8791f-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hmm. I'm wandering if this is really the root-cause... Can it be the
> fact that ib_comp_wq is unbound causing the worker to migrate cpu cores
> in its lifetime?
>
> I wanted to change that a while ago and sent a patch for it [1].

[1]:
--
IB/device: Convert ib-comp-wq to be CPU-bound

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

diff --git a/drivers/infiniband/core/device.c 
b/drivers/infiniband/core/device.c
index 760ef603a468..15f4bdf89fe1 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -999,8 +999,7 @@ static int __init ib_core_init(void)
                 return -ENOMEM;

         ib_comp_wq = alloc_workqueue("ib-comp-wq",
-                       WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
-                       WQ_UNBOUND_MAX_ACTIVE);
+                       WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
         if (!ib_comp_wq) {
                 ret = -ENOMEM;
                 goto err;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
