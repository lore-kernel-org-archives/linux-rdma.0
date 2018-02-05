From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 5/5] IB/cq: wire up adaptive moderation to workqueue based completion queues
Date: Tue,  6 Feb 2018 00:03:16 +0200
Message-ID: <20180205220316.30236-6-sagi@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205220316.30236-1-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Idan Burstein <idanb@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/core/cq.c | 25 ++++++++++++++++++++-----
 include/rdma/ib_verbs.h      |  9 +++++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 270801d28f9d..1d984fd77449 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/irq-am.h>
 #include <rdma/ib_verbs.h>
 
 /* # of WCs to poll for with a single call to ib_poll_cq */
@@ -70,6 +71,13 @@ static int ib_cq_irqpoll_am(struct irq_poll *iop, unsigned short level)
 	return ib_cq_am(cq, level);
 }
 
+static int ib_cq_workqueue_am(struct irq_am *am, unsigned short level)
+{
+	struct ib_cq *cq = container_of(am, struct ib_cq, wq.am);
+
+	return ib_cq_am(cq, level);
+}
+
 static int __ib_process_cq(struct ib_cq *cq, int budget)
 {
 	int i, n, completed = 0;
@@ -147,18 +155,21 @@ static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
 
 static void ib_cq_poll_work(struct work_struct *work)
 {
-	struct ib_cq *cq = container_of(work, struct ib_cq, work);
+	struct ib_cq *cq = container_of(work, struct ib_cq, wq.work);
 	int completed;
 
 	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
+	irq_am_add_comps(&cq->wq.am, completed);
 	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
 	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
-		queue_work(ib_comp_wq, &cq->work);
+		queue_work(ib_comp_wq, &cq->wq.work);
+	else
+		irq_am_add_event(&cq->wq.am);
 }
 
 static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 {
-	queue_work(ib_comp_wq, &cq->work);
+	queue_work(ib_comp_wq, &cq->wq.work);
 }
 
 /**
@@ -214,7 +225,10 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 		break;
 	case IB_POLL_WORKQUEUE:
 		cq->comp_handler = ib_cq_completion_workqueue;
-		INIT_WORK(&cq->work, ib_cq_poll_work);
+		INIT_WORK(&cq->wq.work, ib_cq_poll_work);
+		if (cq->device->modify_cq)
+			irq_am_init(&cq->wq.am, IB_CQ_AM_NR_EVENTS,
+				IB_CQ_AM_NR_LEVELS, 0, ib_cq_workqueue_am);
 		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	default:
@@ -250,7 +264,8 @@ void ib_free_cq(struct ib_cq *cq)
 		irq_poll_disable(&cq->iop);
 		break;
 	case IB_POLL_WORKQUEUE:
-		cancel_work_sync(&cq->work);
+		cancel_work_sync(&cq->wq.work);
+		irq_am_cleanup(&cq->wq.am);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd84cda5ed7c..14a93566adb6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1555,6 +1555,11 @@ enum ib_poll_context {
 	IB_POLL_WORKQUEUE,	/* poll from workqueue */
 };
 
+struct ib_cq_workqueue_poll {
+	struct irq_am		am;
+	struct work_struct	work;
+};
+
 struct ib_cq {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
@@ -1566,8 +1571,8 @@ struct ib_cq {
 	enum ib_poll_context	poll_ctx;
 	struct ib_wc		*wc;
 	union {
-		struct irq_poll		iop;
-		struct work_struct	work;
+		struct irq_poll			iop;
+		struct ib_cq_workqueue_poll	wq;
 	};
 };
 
-- 
2.14.1
