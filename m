From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] IB/core: allocate wc array statically
Date: Sun, 14 Jan 2018 17:07:49 +0200
Message-ID: <1515942470-11461-2-git-send-email-maxg@mellanox.com>
References: <1515942470-11461-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515942470-11461-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The poll batch is small and known at pre-proccessing time.
No need to allocate it dynamically.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cq.c | 12 +-----------
 include/rdma/ib_verbs.h      |  5 ++++-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index f2ae75f..637c999 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -15,9 +15,6 @@
 #include <linux/slab.h>
 #include <rdma/ib_verbs.h>
 
-/* # of WCs to poll for with a single call to ib_poll_cq */
-#define IB_POLL_BATCH			16
-
 /* # of WCs to iterate over before yielding */
 #define IB_POLL_BUDGET_IRQ		256
 #define IB_POLL_BUDGET_WORKQUEUE	65536
@@ -150,10 +147,6 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->poll_ctx = poll_ctx;
 	atomic_set(&cq->usecnt, 0);
 
-	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
-	if (!cq->wc)
-		goto out_destroy_cq;
-
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
 		cq->comp_handler = ib_cq_completion_direct;
@@ -171,13 +164,11 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_free_wc;
+		goto out_destroy_cq;
 	}
 
 	return cq;
 
-out_free_wc:
-	kfree(cq->wc);
 out_destroy_cq:
 	cq->device->destroy_cq(cq);
 	return ERR_PTR(ret);
@@ -208,7 +199,6 @@ void ib_free_cq(struct ib_cq *cq)
 		WARN_ON_ONCE(1);
 	}
 
-	kfree(cq->wc);
 	ret = cq->device->destroy_cq(cq);
 	WARN_ON_ONCE(ret);
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd84cda..3538add 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1549,6 +1549,9 @@ struct ib_ah {
 
 typedef void (*ib_comp_handler)(struct ib_cq *cq, void *cq_context);
 
+/* # of WCs to poll for with a single call to ib_poll_cq */
+#define IB_POLL_BATCH			16
+
 enum ib_poll_context {
 	IB_POLL_DIRECT,		/* caller context, no hw completions */
 	IB_POLL_SOFTIRQ,	/* poll from softirq context */
@@ -1564,7 +1567,7 @@ struct ib_cq {
 	int               	cqe;
 	atomic_t          	usecnt; /* count number of work queues */
 	enum ib_poll_context	poll_ctx;
-	struct ib_wc		*wc;
+	struct ib_wc		wc[IB_POLL_BATCH];
 	union {
 		struct irq_poll		iop;
 		struct work_struct	work;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
