From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/ehca: use kthread_create_on_node
Date: Fri, 29 Jul 2011 09:15:31 +0200
Message-ID: <1311923731.7845.25.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since create_comp_task() creates percpu kthread, it makes
sense to use kthread_create_on_node() to get proper NUMA affinity for
kthread stack.

Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
CC: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
CC: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index e571e60..5358900 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -786,7 +786,8 @@ static struct task_struct *create_comp_task(struct ehca_comp_pool *pool,
 	spin_lock_init(&cct->task_lock);
 	INIT_LIST_HEAD(&cct->cq_list);
 	init_waitqueue_head(&cct->wait_queue);
-	cct->task = kthread_create(comp_task, cct, "ehca_comp/%d", cpu);
+	cct->task = kthread_create_on_node(comp_task, cct, cpu_to_node(cpu),
+					   "ehca_comp/%d", cpu);
 
 	return cct->task;
 }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
